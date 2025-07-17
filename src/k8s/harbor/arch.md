# 组件

Proxy (Nginx)​​	独立容器	作为统一入口，转发请求至后端服务（如 UI、Registry、Token Service）。
​Registry​	独立容器	存储和分发 Docker/OCI 镜像，处理 push/pull 请求，依赖 Token 验证权限。
Storage： registry对应的存储组件，可以是分布式文件系统也可以是对象存储。
​Core Service​	独立容器 (harbor-core)	提供核心 API，管理用户认证、RBAC、项目与镜像生命周期。所有api请求都会流转到core处理，包括login、pull、push以及管理后台相关。
​Token Service​	Core 内置模块	签发 JWT 令牌，验证 Docker 客户端操作权限。
​Job Service​	独立容器	异步处理任务（镜像复制、漏洞扫描、垃圾回收），通过 Redis 调度任务。
​Log Collector​	独立容器 (Fluentd)	聚合各组件日志，支持 ELK 集成。
​Notary​	可选容器	提供镜像签名与验签功能，确保镜像完整性。
​Clair/Trivy​	可选容器	扫描镜像漏洞（CVE），阻断高风险镜像推送。


## 概念：

[manifest](https://pkg.go.dev/github.com/opencontainers/image-spec@v1.1.0/specs-go/v1#Manifest) 主要包含了镜像的元信息配置和文件层对象的摘要，现在基本都是v2版本格式，相对v1来说更通用，还可以塞入一些拓展的信息。

The following media types are used by the manifest formats described here, and the resources they [reference](https://distribution.github.io/distribution/spec/manifest-v2-2/):

- application/vnd.docker.distribution.manifest.v2+json: New image manifest format (schemaVersion = 2)
- application/vnd.docker.distribution.manifest.list.v2+json: Manifest list, aka “fat manifest”
- application/vnd.docker.container.image.v1+json: Container config JSON
- application/vnd.docker.image.rootfs.diff.tar.gzip: “Layer”, as a gzipped tar
- application/vnd.docker.image.rootfs.foreign.diff.tar.gzip: “Layer”, as a gzipped tar that should never be pushed
- application/vnd.docker.plugin.v1+json: Plugin config JSON

[OCI Image Media Types](https://specs.opencontainers.org/image-spec/media-types/): The following media types identify the formats described here and their referenced resources:

- application/vnd.oci.descriptor.v1+json: Content Descriptor
- application/vnd.oci.layout.header.v1+json: OCI Layout
- application/vnd.oci.image.index.v1+json: Image Index
- application/vnd.oci.image.manifest.v1+json: Image manifest
- application/vnd.oci.image.config.v1+json: Image config
- application/vnd.oci.image.layer.v1.tar: "Layer", as a tar archive
- application/vnd.oci.image.layer.v1.tar+gzip: "Layer", as a tar archive compressed with gzip
- application/vnd.oci.image.layer.nondistributable.v1.tar: "Layer", as a tar archive with distribution restrictions
- application/vnd.oci.image.layer.nondistributable.v1.tar+gzip: "Layer", as a tar archive with distribution restrictions compressed with gzip


```json
{
	"schemaVersion": 2,
	"mediaType": "application/vnd.docker.distribution.manifest.v2+json",
	"config": {  	  
		"mediaType": "application/vnd.docker.container.image.v1+json",		
        "size": 8881,    	
		"digest": "sha256:7d899ed163ee9e7979519c4c00be7e38a2cd4b8b8936524f1a8e29c1cd3a0c7a" 
	},

	"layers": [
    {
		"mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip", 
		"size": 2830948, 
		"digest": "sha256:5420e0d28c84ecb16748cb90cc6acf8e2a81dab10cb1f674f3eee8533e53c62a"
	}, {
		"mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
		"size": 7702134,
		"digest": "sha256:74b3565ce580d6e680e17fead073137d59b59694df894b9690f3f9b75dfe60d7"
	}, {
		"mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
		"size": 599,
		"digest": "sha256:dd5b8f6431c1707d7ddc8fd895e7e5619d16e83967e03eaa4aa9c06abcbbc10f"
	}, {
		"mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
		"size": 894,
		"digest": "sha256:bed80a240c44c78e884ae1d21f37232ef15c023250092c116ffa5076ec4fefe1"
	}, {
		"mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
		"size": 667,
		"digest": "sha256:1852ff466a070dd053cd338926ac82d0def499381ced74e6ac671d284a8a394b"
	}, {
		"mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
		"size": 1393,
		"digest": "sha256:a2ca5eee54a63f8128554d3b810ce1aebba37db5c311e7093a18bf7bd93f5575"
	}]
}
```
## pull实现原理

harbor 这边对于请求的处理的链路大概是这样的：
1. 流量从 nginx 代理进来匹配规则后转发到 core服务（还有一部分前端页面流量会被转发到portal服务），
2. 然后core会从 redis 和 pg 中查询它所想要的数据
3. 同时有可能会将流量再进一步转发给 registry
4. registry则会再继续调用s3和redis完成整个请求的处理逻辑。


## /v2 接口

/v2/ ： harbor并不会做任何的处理，会直接透传给registry，而registry这一侧也没有什么特殊的逻辑，铁定会返回 401
/service/token： docker客户端就会向镜像中心发起登录请求，根据约定，客户端传入自己的账号和密码调用/service/token接口，返回JWT token用于后续的访问。对于匿名用户也会签发token，用于访问public
/v2/{{REPOSITORY}}/manifests/{{TAG | DIGEST}}
/v2/{{REPOSITORY}}/blobs/{{DIGEST}}


## 认证

harbor 系统里面是分为两层认证的：
1. harbor 自己有一套账号系统，存在数据库中，
2. registry是一套独立的组件，也有一套自己的认证
3. 用户只会感知到第一层harbor的账号，然后habor初始化的时候会和registry一起配置一个固定密码的用户进行它到registry的认证。


## 授权

harbor 里面有一个 middleware：[/src/server/middleware/v2auth/auth.go](https://github.com/goharbor/harbor/blob/main/src/server/middleware/v2auth/auth.go)，会根据 JWT Token 中的用户，以及要访问的项目，进行 rbac 权限校验，如果权限校验失败，就不会有下面的流程了


## 表结构 

先根据仓库名称查到仓库ID
SELECT id FROM "repository"  WHERE name = 'test/nginx';
根据仓库ID和TAG名称查询TAG表中存储的artifact_id
SELECT artifact_id FROM "tag" WHERE "repository_id" = ${repository.id} AND "name" = '1.20.2-alpine';
根据ID查询artifact信息
SELECT * FROM "artifact" WHERE "id" = ${artifact_id};
根据digest查询artifact 信息
SELECT * FROM "artifact" WHERE "digest" = ${digest} AND "repository_name" = 'test/nginx';