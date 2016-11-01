PP匠开发者接入指南
===============

## 安装api client工具
本工具使用ruby开发，需先安装 ruby, gem bundler
使用rvm安装ruby [rvm](https://rvm.io/rvm/install)
安装Bundler
```
$ gem install bundler
```

在demo目录下面，使用Bundler安装需要的dependencies
```
bundle install
```

## 使用
命令行工具: bin/ppninja

首次使用需要配置ppninja的账号
当前测试的Host为 114.55.92.44
appid 和 appsecret 应从测试网站获取

```
bin/ppninja config -h 114.55.92.44 -i <appid> -k <appsecret>
```

上传为
```
bin/ppninja upload <file_path>
```
得到对应的token在Response中

查看状态
```
bin/ppninja status <token>
```

下载为
```
bin/ppninja download <token>
```
