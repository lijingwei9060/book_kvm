/api/v1/applications/myapp/logs?appNamespace=argocd&container=myapp&namespace=devops&follow=true&podName=myapp-7dfb7d78d5-fbtpd&tailLines=1000&sinceSeconds=0
```json
[
    {
    "result": {
        "content": "/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.244724888Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.247733414Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.247829394Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.258576718Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.267769178Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.268037198Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.272723679Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "/docker-entrypoint.sh: Configuration complete; ready for start up",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.275266805Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: using the \"epoll\" event method",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.282524451Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: nginx/1.21.1",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.28256868Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: built by gcc 8.3.0 (Debian 8.3.0-6)",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.282574551Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: OS: Linux 5.15.0-119-generic",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.282578871Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.28258308Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: start worker processes",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.28259558Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: start worker process 31",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.282842422Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: start worker process 32",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.283077582Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: start worker process 33",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.283367393Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 07:55:07 [notice] 1#1: start worker process 34",
        "timeStamp": "2025-08-13T07:55:07Z",
        "last": false,
        "timeStampStr": "2025-08-13T07:55:07.283666183Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "10.233.78.0 - - [13/Aug/2025:08:03:04 +0000] \"GET / HTTP/1.1\" 200 15 \"-\" \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/4.2.7.457\" \"-\"",
        "timeStamp": "2025-08-13T08:03:04Z",
        "last": false,
        "timeStampStr": "2025-08-13T08:03:04.121651465Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "2025/08/13 08:03:04 [error] 32#32: *2 open() \"/usr/share/nginx/html/favicon.ico\" failed (2: No such file or directory), client: 10.233.78.0, server: localhost, request: \"GET /favicon.ico HTTP/1.1\", host: \"10.203.162.5:32060\", referrer: \"http://10.203.162.5:32060/\"",
        "timeStamp": "2025-08-13T08:03:04Z",
        "last": false,
        "timeStampStr": "2025-08-13T08:03:04.182137308Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}{
    "result": {
        "content": "10.233.78.0 - - [13/Aug/2025:08:03:04 +0000] \"GET /favicon.ico HTTP/1.1\" 404 555 \"http://10.203.162.5:32060/\" \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/4.2.7.457\" \"-\"",
        "timeStamp": "2025-08-13T08:03:04Z",
        "last": false,
        "timeStampStr": "2025-08-13T08:03:04.182198457Z",
        "podName": "myapp-7dfb7d78d5-fbtpd"
    }
}
]
```