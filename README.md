# Caddy

## 一键脚本
- bash <(curl -L -s https://git.io/JkfJl)

Caddy是一个使用 Go语言写的 HTTP Server，开发时间并不长，在性能上或许比不上 Nginx，但是在 上手难度/配置难度 上面简单的不行不行的。

并且 Caddy支持 自动签订Let’s Encrypt SSL证书，什么都不需要你管，只需要提供一个邮箱，剩下的他会自己申请、配置和续约 SSL证书！

官网地址
https://caddyserver.com

echo "127.0.0.1:端口 {
 gzip
 tls xxx@xxx.xxx
 proxy / baidu.com
}" > /usr/local/caddy/Caddyfile


## 使用说明

- 启动：/etc/init.d/caddy start
- 停止：/etc/init.d/caddy stop
- 重启：/etc/init.d/caddy restart
- 查看状态：/etc/init.d/caddy status
- 查看Caddy启动日志：tail -f /tmp/caddy.log
- 安装目录：/usr/local/caddy
- Caddy配置文件位置：/usr/local/caddy/Caddyfile
- Caddy自动申请SSL证书位置：/.caddy/acme/acme-v01.api.letsencrypt.org/sites/xxx.xxx(域名)/

## 单网站/多网站

- 当然，上面的几个示例，实际上都算是单网站。

- 最后一句代码都是 }" > /usr/local/caddy/Caddyfile ，也就是清空了 Caddy配置文件，然后再写入了配置信息。

- 如果你要设置多个网站，那么把最后一句代码改成 }" >> /usr/local/caddy/Caddyfile 即可，注意是把 > 改成 >> ，这样就不会清空原来的配置信息了，而是会把要添加的配置信息加到配置文件最后！
