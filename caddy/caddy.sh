#!/bin/bash                                                                                               

# Root
[[ $(id -u) != 0 ]] && blue "哎呀……请使用 root 用户运行 ~(^_^)" && exit 1

file="/usr/local/caddy/"
caddy_file="/usr/local/caddy/caddy"
caddy_conf_file="/usr/local/caddy/Caddyfile"

# 检测caddye是否已安装
check_installed_status(){
	[[ ! -e ${caddy_file} ]] && redbg "错误！ Caddy 没有安装，请检查 !" && exit 1
}

# 检测系统
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
}

# 开始安装caddy
install_caddy(){
    bash <(curl -L -s https://raw.githubusercontent.com/plmxs2017/codes/main/caddy/caddy_install.sh)
}

# 该配置会自动部署ssl证书，前提是域名已解析成功
caddy_set(){
    green "请输入域名：示例baidu.one或www.baidu.one"
    redbg "注意：域名必须已解析生效，否则会导致申请证书失败"
    read -p "请输入域名：" domain
    greenbg "代理端口；示例888"
    read -p "请输入代理端口：" port
    greenbg "填写邮箱，用于自动申请证书"
    read -p "邮箱地址" email
    echo "$domain {
    gzip
    tls $email
    proxy / 127.0.0.1:$port
    }" > /usr/local/caddy/Caddyfile
    echo
    sleep 6s 
    green "=================================================="
    green "恭喜您，已完成域名反代设置，现在可以通过域名直接访问了"
    green ""
    white "https://$domain"
    green "被代理端口：$port"
    green "备注：域名由caddy反代，自动申请ssl证书，到期自动续期"
    green "=================================================="
}


uninstall_caddy(){
    check_sys
	check_installed_status
	echo && redbg "确定要卸载 Caddy ? [y/N]"
	read -e -p "(默认: n):" unyn
	[[ -z ${unyn} ]] && unyn="n"
	if [[ ${unyn} == [Yy] ]]; then
		PID=`ps -ef |grep "caddy" |grep -v "grep" |grep -v "init.d" |grep -v "service" |grep -v "caddy_install" |awk '{print $2}'`
		[[ ! -z ${PID} ]] && kill -9 ${PID}
		if [[ ${release} = "centos" ]]; then
			chkconfig --del caddy
		else
			update-rc.d -f caddy remove
		fi
		[[ -s /tmp/caddy.log ]] && rm -rf /tmp/caddy.log
		rm -rf ${caddy_file}
		rm -rf ${caddy_conf_file}
		rm -rf /etc/init.d/caddy
		[[ ! -e ${caddy_file} ]] && echo && green " 【信息】Caddy 卸载完成 !" && echo && exit 1
		echo && red "[错误] Caddy 卸载失败 !" && echo
	else
		echo && echo "卸载已取消..." && echo
	fi
}


#开始菜单
start_menu(){
    clear

    echo
    yellow "使用前提：域名必须已解析生效，否则自动配置会失效"
    blue "备注：域名由caddy反代，自动申请ssl证书，到期自动续期"
    echo
    white "1.开始安装"
    white "2.卸载"
    white "3.退出脚本"
    read -p "请输入数字:" num
    case "$num" in
    1)
    install_caddy
    caddy_set
	;;
    2)
    uninstall_caddy
	;;
    3)
	exit 1
	;;
	*)
	clear
	echo "请输入正确数字"
	sleep 5s
	start_menu
	;;
    esac
}

start_menu
