# intro

- Release: 

## 文件结构

1. Chart.yaml： chart描述文件
2. values.yaml： chart的默认值，templates会使用到，也可以在命令行中覆盖。
3. charts/： 子chart
4. templates/: helm通过模板引擎把这个发送给k8s
   1. NOTES.txt: 帮助文档，helm install的时候会显示
   2. deployment.yaml: 创建k8s的deployment
   3. service.yaml: 创建service endpoint
   4. _helpers.tpl: 
   5. configmap.yaml: CopnfigMap


模板指令： 使用 {{ }}
1. Release: This object describes the release itself. It has several objects inside of it:
   1. Release.Name: The release name
   2. Release.Namespace: The namespace to be released into (if the manifest doesn’t override)
   3. Release.IsUpgrade: This is set to true if the current operation is an upgrade or rollback.
   4. Release.IsInstall: This is set to true if the current operation is an install.
   5. Release.Revision: The revision number for this release. On install, this is 1, and it is incremented with each upgrade and rollback.
   6. Release.Service: The service that is rendering the present template. On Helm, this is always Helm.
2. Values: Values passed into the template from the values.yaml file and from user-supplied files. By default, Values is empty.
3. Chart: The contents of the Chart.yaml file. Any data in Chart.yaml will be accessible here. For example {{ .Chart.Name }}-{{ .Chart.Version }} will print out the mychart-0.1.0.
4. Files: This provides access to all non-special files in a chart. While you cannot use it to access templates, you can use it to access other files in the chart. See the section Accessing Files for more.
   1. Files.Get is a function for getting a file by name (.Files.Get config.ini)
   2. Files.GetBytes is a function for getting the contents of a file as an array of bytes instead of as a string. This is useful for things like images.
   3. Files.Glob is a function that returns a list of files whose names match the given shell glob pattern.
   4. Files.Lines is a function that reads a file line-by-line. This is useful for iterating over each line in a file.
   5. Files.AsSecrets is a function that returns the file bodies as Base 64 encoded strings.
   6. Files.AsConfig is a function that returns file bodies as a YAML map.
5. Capabilities: This provides information about what capabilities the Kubernetes cluster supports.
   1. Capabilities.APIVersions is a set of versions.
   2. Capabilities.APIVersions.Has $version indicates whether a version (e.g., batch/v1) or resource (e.g., apps/v1/Deployment) is available on the cluster.
   3. Capabilities.KubeVersion and Capabilities.KubeVersion.Version is the Kubernetes version.
   4. Capabilities.KubeVersion.Major is the Kubernetes major version.
   5. Capabilities.KubeVersion.Minor is the Kubernetes minor version.
   6. Capabilities.HelmVersion is the object containing the Helm Version details, it is the same output of helm version.
   7. Capabilities.HelmVersion.Version is the current Helm version in semver format.
   8. Capabilities.HelmVersion.GitCommit is the Helm git sha1.
   9. Capabilities.HelmVersion.GitTreeState is the state of the Helm git tree.
   10. Capabilities.HelmVersion.GoVersion is the version of the Go compiler used.
6.  Template: Contains information about the current template that is being executed
    1.  Template.Name: A namespaced file path to the current template (e.g. mychart/templates/mytemplate.yaml)
    2.  Template.BasePath: The namespaced path to the templates directory of the current chart (e.g. mychart/templates).

模板函数和pipeline(|)，有60个go template language
1. quote：
2. upper
3. repeat n
4. default xxx : .Values.favorite.drink | default (printf "%s-tea" (include "fullname" .))
5. lookup 

(lookup "v1" "Namespace" "" "mynamespace").metadata.annotations

{{ range $index, $service := (lookup "v1" "Service" "mynamespace" "").items }}
    {{/* do something with each service */}}
{{ end }}

operator: 

## helm命令

helm get manifest full-cora1
helm install full-cora1 ./mychart
helm install --debug --dry-run goodly-guppy ./mychart
helm uninstall full-cora1