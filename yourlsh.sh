#!/bin/zsh
config_file=~/.shurl/config.json
url=$(pbpaste)

if [[ $1 == "-r" ]]; then
  rm -f "$config_file"
  echo "已删除配置文件 $config_file。"
  echo "请输入以下参数："
else
  if [[ -f $config_file ]]; then
    config_data=$(cat "$config_file")
    domain=$(echo "$config_data" | jq -r '.domain')
    signature=$(echo "$config_data" | jq -r '.signature')
  fi

  if [[ -z $domain || -z $signature ]]; then
    echo "配置文件 $config_file 不存在或内容不完整，请输入以下参数："
  else
    echo "配置文件 $config_file 已存在，并包含以下配置："
    echo "域名: $domain"
    echo "签名: $signature"
    echo
    read -p "若要重新配置，请使用 shurl -r 命令。"
    exit 0
  fi
fi

while true; do
  read -p "请输入域名，不包含 https:// （例如：example.com）: " domain
  if [[ ! $domain =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "无效的域名，请重新输入正确的域名。"
  else
    break
  fi
done

while true; do
  read -p "请输入 signature token（十位数字字母组合）: " signature
  if [[ ! $signature =~ ^[a-zA-Z0-9]{10}$ ]]; then
    echo "无效的 signature token，请重新输入正确的值。"
  else
    break
  fi
done

mkdir -p "$(dirname "$config_file")"
printf '{"domain":"%s","signature":"%s"}' "$domain" "$signature" > "$config_file"
echo "初始化成功，若要更改配置，请使用 shurl -r 命令。"

if [[ -z $url ]]; then
  echo "剪贴板中未找到URL，请复制URL然后再次执行脚本。"
  exit 1
fi

# 执行 curl 请求并将结果保存到变量中
result=$(curl -s -L "https://$domain/yourls-api.php?signature=$signature&action=shorturl&url=$url" | grep -o '<shorturl>[^<]*</shorturl>' | sed -e 's/<shorturl>\(.*\)<\/shorturl>/\1/')

# 将结果复制到剪贴板
echo "$result" | pbcopy