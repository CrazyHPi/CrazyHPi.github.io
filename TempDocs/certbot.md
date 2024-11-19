# 使用 CertBot 获取LE证书

已有nginx环境，域名更换/证书过期重新申请

## 安装 CertBot
需要sudo

```bash
# 依赖
apt update
apt install python3 python3-venv libaugeas0

# 直接pip install 不隔离环境了
pip install certbot certbot-nginx
# 查看安装情况
certbot -h 
```

## 申请证书

已经有nginx的静态网站目录，没有的话，随便找个地方临时放一下

需要域名 `example.com` 已经解析到对应服务器

Lets' Encrypt 证书目录: `/etc/letsencrypt/live/`

申请到的证书会放在LE证书目录下的 example.com 里面

```bash
# --webroot -w 网站目录 用于验证
# -d 域名 可以一次申请多个
 certbot certonly --webroot -w /home/wwwroot/example.com -d example.com
```

## 配置网站

nginx vhost配置文件目录: `/usr/local/nginx/conf/vhost/`

```conf
server
{
    listen 80;
    #listen [::]:80;
    server_name example.com ;
    return 301 https://$host$request_uri;
    # 80 http重定向到443 https
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
        # ...
    }
}
```

## Ref

https://certbot.eff.org/instructions?ws=nginx&os=pip
