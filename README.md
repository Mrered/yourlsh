# shurl

## 这是什么？

这是一个基于 [YOURLS](https://yourls.org/) 自建的短链快捷方式；

## 安装

```sh
brew tap ivaquero/chinese
brew update
brew install shurl
```

## 使用方法

1. 去自己的后台 `https://<你的域名>/admin/tools.php` 获取 `Signature token` ；
2. 将要缩短的链接复制到剪贴板中，程序将从剪贴板里直接获取内容；
3. 运行下面命令后，生成的短链会自动复制到你的剪贴板。

```sh
shurl -d <你的域名> -s <你的signature>
```

参数说明

|    参数     |            值            |     用法示例     |
| :---------: | :----------------------: | :--------------: |
|  `domain`   | 你的域名，不包含 `https` | `-d example.com` |
| `signature` |   你的 Signature token   | `-s a1b2c3d4e5`  |
