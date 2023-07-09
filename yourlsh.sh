#!/bin/zsh

CONFIG_DIR="$HOME/Library/Application Support/shurl"
CONFIG_FILE="$CONFIG_DIR/config.json"

# 判断是否需重新配置
if [ "$1" == "-r" ] || [ ! -f "$CONFIG_FILE" ]; then
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
    fi
    echo -n "输入 domain (至少含有一个'.')："
    read domain
    until [[ $domain == *"."* ]]; do
        echo "无效输入，请重新输入："
        read domain
    done

    echo -n "输入 signature (数字/字母，10位)："
    read signature
    until [[ $signature =~ ^[0-9a-zA-Z]{10}$ ]]; do
        echo "无效输入，请重新输入："
        read signature
    done

    # 写入配置文件
    echo "{ \"domain\": \"$domain\", \"signature\": \"$signature\" }" > $CONFIG_FILE
    echo "设置成功！"
else
    domain=$(cat "$CONFIG_FILE" | awk -F":" '{print $2}' | awk -F"," '{print $1}'| sed 's/\"//g' | sed 's/ //g')
    signature=$(cat "$CONFIG_FILE" | awk -F":" '{print $3}' | sed 's/\"//g' | sed 's/}//g' | sed 's/ //g')
fi

# 获取剪贴板 url
url=$(pbpaste)

# 执行 curl 操作
echo -n $(curl -s -L "https://$domain/yourls-api.php?signature=$signature&action=shorturl&format=simple&url=$url") | pbcopy
