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

  validate_domain "$domain" || return 1
  validate_signature "$signature" || return 1
}

if [[ $1 == "-r" ]]; then
  rm -f "$config_file"
  echo "已删除配置文件 $config_file。"
  echo "请输入以下参数："
elif [[ -f $config_file ]]; then
  read_configuration
  if [[ $? -eq 0 ]]; then
    echo "配置文件 $config_file 已存在，将使用其中的配置信息。"
  else
    echo "配置文件 $config_file 不完整或包含无效配置信息，请重新配置。"
    exit 1
  fi
else
  echo "配置文件 $config_file 不存在，请输入以下参数："
  while true; do
    read "domain?请输入域名，不包含 https:// （例如：example.com）: "
    validate_domain "$domain" && break
  done

  while true; do
    read "signature?请输入 signature token（十位数字字母组合）: "
    validate_signature "$signature" && break
  done

  mkdir -p "$(dirname "$config_file")"  # 创建目录（如果不存在）
  printf '{"domain":"%s","signature":"%s"}' "$domain" "$signature" > "$config_file"
  echo "配置已保存到 $config_file。"
fi

if [[ -z $url ]]; then
  echo "剪贴板中未找到URL，请复制URL然后再次执行脚本。"
  exit 1
fi

# 执行 curl 请求并将结果保存到变量中
result=$(curl -s -L "https://$domain/yourls-api.php?signature=$signature&action=shorturl&url=$url" | grep -o '<shorturl>[^<]*</shorturl>' | sed -e 's/<shorturl>\(.*\)<\/shorturl>/\1/')

# 将结果复制到剪贴板
echo "$result" | pbcopy
