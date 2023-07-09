#!/bin/zsh

CONFIG_DIR="$HOME/Library/Application Support/shurl"
CONFIG_FILE="$CONFIG_DIR/config.json"

# 方法 - 执行curl操作 
curlFunc() {
  curl -s -L "https://$1/yourls-api.php?signature=$2&action=shorturl&format=simple&url=$3"
}

# 获取剪贴板 url
url=$(pbpaste)

readConfig() {
  jq -r ".$1" "$CONFIG_FILE"
}

# 判断是否需重新配置
if [ "$1" == "-r" ] || [ ! -f "$CONFIG_FILE" ]; then
  if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
  fi

  echo -n "输入你的域名，不包含 https:// （如：example.com）："
  read domain
  until [[ $domain == *"."* ]]; do
    read "domain?请输入正确的域名，不包含 https:// （如：example.com）："
  done

  echo -n "输入 signature ，可从 https://$domain/admin/tools.php 获取："
  read signature
  until [[ $signature =~ ^[0-9a-zA-Z]{10}$ ]]; do
    read "signature?无效输入，请重新输入："
  done

  # 写入配置文件
  echo "初始化成功，再次运行 shurl 即可正常使用，详细用法请访问 https://github.com/Mrered/yourlsh "
  url="https://images.unsplash.com/photo-1580855014124-d1e9d454c6b1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZXZlcnl0aGluZyUyMGlzJTIwZ29pbmclMjB0byUyMGJlJTIwYWxyaWdodHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60"
  url=$(curlFunc $domain $signature $url)
  if [[ $url == "http"* ]]; then
    echo "{ \"domain\": \"$domain\", \"signature\": \"$signature\" }" > $CONFIG_FILE
    open "$url"
  else
    echo "你的配置有误，请重新配置"
  fi
else
  domain=$(readConfig domain)
  signature=$(readConfig signature)
  echo -n $(curlFunc $domain $signature $url) | pbcopy
fi