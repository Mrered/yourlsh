# shurl

## 这是什么？

这是一个基于 [YOURLS](https://yourls.org/) 自建的短链快捷方式；

## 安装

```sh
brew tap ivaquero/chinese
brew update
brew install shurl
```

## 初始化

去自己的后台 `https://<你的域名>/admin/tools.php` 获取 `Signature token` ，安装后首次执行会提示

```sh
配置文件 ~/.shurl/config.json 不存在，请输入以下参数：
请输入域名，不包含 https:// （例如：example.com）: 
请输入 signature token: 
```

依次填写 域名 和 signature token ，回车完成初始化，会提示

```sh
初始化成功，若要更改配置，请删除 ~/.shurl/config.json
```

## 使用方法

1. 将要缩短的链接复制到剪贴板中，程序将从剪贴板里直接获取内容；
2. 运行下面命令后，生成的短链会自动复制到你的剪贴板。

```sh
shurl
```

`config.json` 参数说明

|    参数     |                 说明                  |
| :---------: | :-----------------------------------: |
|  `domain`   | 你的域名，必须套 TLS ，不包含 `https` |
| `signature` |         你的 Signature token          |
