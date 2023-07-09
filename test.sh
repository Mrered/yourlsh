#!/bin/zsh

url="http"

if [[ $url == "http"* ]]; then
  echo "变量的前端包含'http'"
else
  echo "变量的前端不包含'https://'"
fi
