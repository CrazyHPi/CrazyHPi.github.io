# Overleaf

## 环境

前置需求:
- git
- docker desktop

安装在wsl中，使用gost+nginx反代实现多人共享，外网访问

安装wsl ubuntu
```sh
# 查看线上版本
wsl --list --online
# 安装 wsl Ubuntu
wsl --install Ubuntu
```

windows内查看wsl文件位置：`\\wsl.localhost\Ubuntu`

安装 docker desktop:
https://docs.docker.com/desktop/setup/install/windows-install/

更改 docker Disk Image 位置:
Settings - Resources - Disk image location

打开wsl docker 集成，免去wsl中再安装：
Settings - Resources - WSL intergration，打开对应wsl版本


## 安装

使用 overleaf toolkit安装
```sh
git clone https://github.com/overleaf/toolkit.git ./overleaf
cd overleaf-toolkit/
```

生成、编辑配置
```sh
bin/init
```

主要编辑这两个
- overleaf.rc : the main top-level configuration file
- variables.env : environment variables loaded into the docker container

更改ip/端口
```sh
vim config/overleaf.rc

# overleaf里面项目文件储存位置
OVERLEAF_DATA_PATH=data/overleaf
# 更改端口
# 实际上要反代，端口无所谓，能用就行
OVERLEAF_LISTEN_IP=127.0.0.1
OVERLEAF_PORT=8888
```

启动
```sh
# 第一次启动，拉取docker
bin/up

# 启停
# 好像在 docker desktop里也行
bin/start
bin/stop
```

下载完整texlive，需要很多空间

在overleaf能跑起来之后
```sh
# 进入docker shell
bin/shell

# 更换 texlive 源
# tuna源
tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
# ustc源
tlmgr option repository http://mirrors.ustc.edu.cn/CTAN/systems/texlive/tlnet

# 下载全部宏包
tlmgr install scheme-full
```


「TeXLive源」
- 清华: https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/
- 兰大: https://mirror.lzu.edu.cn/CTAN/systems/texlive/
- 阿里: https://mirrors.aliyun.com/CTAN/systems/texlive/
- 科大: http://mirrors.ustc.edu.cn/CTAN/systems/texlive/

## 反代

### 使用gost反代

[gost Github](https://github.com/go-gost/gost)，[文档](https://latest.gost.run/)

本地gost
```
gost.exe -L rtcp://:8888/:8888 -F socks5://username:password@example.com:18888
```

远程gost，允许bind port
```
./gost -L socks5://username:password@:18888?bind=true
```

### 域名访问

需要服务器，nginx，域名，证书，配置略

nginx vhost配置文件目录: `/usr/local/nginx/conf/vhost/`

编辑对应的 `example.com.conf`

```conf
server
{
    listen 80;
    #listen [::]:80;
    server_name example.com;
    return 301 https://$host$request_uri;
    # 80 http 重定向到 443 https
}

server
{
    listen 443 ssl;
    server_name example.com;
    
    # 证书
	ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    location /
    {
        # 反代到本机反代的端口
        proxy_pass http://127.0.0.1:8888;
     	proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_read_timeout 3m;
        proxy_send_timeout 3m;
    }

    access_log  /home/wwwlogs/example.com.log;
}
```


## Ref

https://docs.docker.com/desktop/setup/install/windows-install/

https://learn.microsoft.com/zh-cn/windows/wsl/install#install-wsl-command

https://github.com/overleaf/toolkit/blob/master/doc/quick-start-guide.md

overleaf

https://tnnidm.com/build-and-use-overleaf-server/index.html

https://blog.xial.moe/index.php/2023/07/15/windows-bendibushu-overleaf-fuwu/

https://ziuch.com/article/self-hosted-overleaf

