---
title: nginx+vue项目部署后无法加载资源
date: 2025-03-02 19:40:46
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---
项目使用的`nginx.conf`如下：

```nginx
events {
    worker_connections  1024;
}

http {
    server {
        listen 80;

        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            try_files $uri $uri/ /index.html;
        }

        location /api/ {
            proxy_pass http://backend:8010/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_read_timeout 300s;
        }
		...
    }
}
```

前端在加载时会出现如下报错：

```txt
Failed to load module script: Expected a JavaScript module script but the server responded with a MIME type of "text/plain". Strict MIME type checking is enforced for module scripts per HTML spec.
```

解读下大概是服务端对于请求的资源的MIME类型返回错误，导致浏览器能接收到文件，但是因为MIME类型错误所以拒绝加载。

nginx对于任意请求的资源的响应类型都是text/plain，而前端要求MIME和文件后缀匹配，因此才会出现这个问题。

nginx安装后会有mime.types文件，其中存储了大部分常见的后缀-MIME类型对应关系。所以我们作如下修改：

```diff
events {
    worker_connections  1024;
}

http {
+    include mime.types;
+    default_type application/octet-stream;
    
    server {
		...
    }
}
```

这样nginx就能返回正确的类型了。