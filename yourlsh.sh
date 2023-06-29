#!/bin/zsh
config_file=~/.shurl/config.json
url=$(pbpaste)

function validate_domain {
  local domain=$1
  if [[ ! $domain =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "无效的域名，请重新输入正确的域名。"
    return 1
  fi
}

function validate_signature {
  local signature=$1
  if [[ ! $signature =~ ^[a-zA-Z0-9]{10}$ ]]; then
    echo "无效的 signature token，请重新输入正确的值。"
    return 1
  fi
}

function read_configuration {
  local data=$(cat "$config_file")
  domain=$(echo "$data" | jq -r '.domain')
  signature=$(echo "$data" | jq -r '.signature')

  validate_domain "$domain" || exit 1
  validate_signature "$signature" || exit 1
}

if [[ $1 == "-r" ]]; then
  rm -f "$config_file"
  echo "已删除配置文件 $config_file。"
  echo "请输入以下参数："
else
  if [[ -f $config_file ]]; then
    read_configuration
    if [[ $? -eq 0 ]]; then
      read -p "若要重新配置，请使用 shurl -r 命令。"
      exit 0
    fi
  fi

  echo "配置文件 $config_file 不存在或内容不完整，请输入以下参数："
fi

while true; do
  read -p "请输入域名，不包含 https:// （例如：example.com）: " domain
  validate_domain "$domain" && break
done

while true; do
  read -p "请输入 signature token（十位数字字母组合）: " signature
  validate_signature "$signature" && break
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