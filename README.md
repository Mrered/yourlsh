# shurl

## 这是什么？

这是一个基于 [YOURLS](https://yourls.org/) 自建的短链快捷方式；

## 使用方法

1. 去自己的后台 `https://<你的域名>/admin/tools.php` 获取 `Signature token` ；
2. 将要缩短的链接复制到剪贴板中，程序将从剪贴板里直接获取内容；
3. 运行

```sh
./shurl -s <你的signature>
```
