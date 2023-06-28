#!/bin/zsh
domain=""
signature=""
url=$(pbpaste)

while getopts "s:" opt; do
  case $opt in
    s) signature="$OPTARG";;
    d) domain="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1;;
  esac
done

if [[ -z $signature ]]; then
  echo "Missing signature. Usage: ./shurl.sh -s <signature> -d <domain>"
  exit 1
fi


if [[ -z $domain ]]; then
  echo "Missing domain. Usage: ./shurl.sh -s <signature> -d <domain>"
  exit 1
fi

if [[ -z $url ]]; then
  echo "No URL found in the clipboard. Please copy a URL and try again."
  exit 1
fi

# 执行 curl 请求并将结果保存到变量中
result=$(curl -s -L "https://$domain/yourls-api.php?signature=$signature&action=shorturl&url=$url" | grep -o '<shorturl>[^<]*</shorturl>' | sed -e 's/<shorturl>\(.*\)<\/shorturl>/\1/')

# 将结果复制到剪贴板
echo "$result" | pbcopy
