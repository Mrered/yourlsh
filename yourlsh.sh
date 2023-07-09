#!/bin/zsh

CONFIG_DIR="$HOME/Library/Application Support/shurl"
CONFIG_FILE="$CONFIG_DIR/config.json"
result=""

# 方法 - 执行curl操作 
curlFunc() {
  curl -s -L "https://$1/yourls-api.php?signature=$2&action=shorturl&format=simple&url=$3"
}

# 获取剪贴板 url
url=$(pbpaste)

isCheck() {
  jq -r ".${1}" "$CONFIG_FILE"
}

writeConfig() {
  jq ". + {\"$1\": \"$2\"}" "$CONFIG_FILE" > tmp.$$.json && mv tmp.$$.json "$CONFIG_FILE"
}

# 在初始化之前检查是否需要重新配置
needInitialization() {
  if [ "$1" == "-r" ]; then
    return 0
  elif [ ! -f "$CONFIG_FILE" ]; then
    return 0
  elif ! jq -e '.domain and .signature and .check' "$CONFIG_FILE" >/dev/null 2>&1; then
    return 0
  elif [ "$(isCheck check)" == "false" ]; then
    return 0
  else
    return 1
  fi
}

initialization() {
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
  echo "{ \"domain\": \"$domain\", \"signature\": \"$signature\", \"check\": false }" > "$CONFIG_FILE"
  echo "正在检测配置是否正确"
  url="https://images.unsplash.com/photo-1580855014124-d1e9d454c6b1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZXZlcnl0aGluZyUyMGlzJTIwZ29pbmclMjB0byUyMGJlJTIwYWxyaWdodHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60"
  result=$(curlFunc $domain $signature $url)
  if [[ $result == "http"* ]]; then
    writeConfig "check" "true"
    open "$result"
    echo "配置正确，初始化成功，详细用法请访问 https://github.com/Mrered/yourlsh "
  else
    writeConfig "check" "false"
    echo "你的配置有误，请重新配置"
  fi
}

printHelp() {
  echo "  帮助："
  echo ""
  echo "        初次运行 shurl 时会自动判断并进行初始化"
  echo "        若配置内容有误，运行 shurl 会重新初始化"
  echo "        将要缩短链接拷贝到剪贴板后运行 shurl，返回的短链会直接拷贝到剪贴板"
  echo ""
  echo "  参数："
  echo ""
  echo "  -h    打印帮助内容"
  echo "  -r    删除配置文件并重新初始化"
  echo ""
  echo "  更新："
  echo ""
  echo "        brew update"
  echo "        brew upgrade shurl"
}

# 判断是否需重新配置或打印帮助内容
if [ "$1" == "-h" ]; then
  printHelp
elif needInitialization "$1"; then
  initialization
else
  # 执行 curl 操作
  domain=$(jq -r .domain "$CONFIG_FILE")
  signature=$(jq -r .signature "$CONFIG_FILE")
  echo -n $(curlFunc $domain $signature $url) | pbcopy 
fi
