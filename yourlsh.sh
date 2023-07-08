#!/bin/zsh
config_file=~/.shurl/config.json
url=$(pbpaste)

if [[ ! -f $config_file ]]; then
  echo "配置文件 $config_file 不存在，请输入以下参数："
  read "domain?请输入域名，不包含 https:// （例如：example.com）: "
  read "signature?请输入 signature token: "

  mkdir -p "$(dirname "$config_file")"
  printf '{"domain":"%s","signature":"%s"}' "$domain" "$signature" > "$config_file"
  echo "初始化成功，若要更改配置，请删除 $config_file"
  exit 0
else
  config_data=$(cat "$config_file")
  domain=$(echo "$config_data" | jq -r '.domain')
  signature=$(echo "$config_data" | jq -r '.signature')
fi

if [[ -z $url ]]; then
  echo "剪贴板中未找到URL，请复制URL然后再次执行脚本。"
  exit 1
fi

# 执行 curl 请求并将结果复制到剪贴板
echo -n $(curl -s -L "https://$domain/yourls-api.php?signature=$signature&action=shorturl&format=simple&url=$url") | pbcopy
