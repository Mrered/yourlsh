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

去自己的后台 `https://<你的域名>/admin/tools.php` 获取 `Signature token` 备用。

- 初次运行 shurl 时会自动判断并进行初始化；
- 若配置内容有误，运行 shurl 会重新初始化；
- 将要缩短链接拷贝到剪贴板后运行 shurl ，返回的短链会直接拷贝到剪贴板。

## 使用方法

1. 将要缩短的链接复制到剪贴板中，程序将从剪贴板里直接获取内容；
2. 运行下面命令后，生成的短链会自动复制到你的剪贴板。

```sh
shurl
```

## 帮助

```sh
shurl -h #打印帮助内容
shurl -r #删除配置文件并重新初始化
```

## 更新

```sh
brew update
brew upgrade shurl
```

## 构建

```sh
shc -r -f yourlsh.sh -o shurl
```

## 其他

`config.json` 存放位置：`~/Library/Application Support/shurl/config.json` 。

|    参数     |                 说明                  |  类型  |
| :---------: | :-----------------------------------: | :----: |
|  `domain`   | 你的域名，必须套 TLS ，不包含 `https` | 字符串 |
| `signature` |         你的 Signature token          | 字符串 |
|   `check`   |         检测配置文件是否可用          |  布尔  |
