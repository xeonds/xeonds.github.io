---
title: Golang配置文件最佳实践
date: 2023-09-25 22:30:22
author: xeonds
toc: true
excerpt: 最佳实践是软件开发行业的积淀。遵守它们或许不能让你写出好的程序，但是能保住你代码质量的下限
tags:
  - 开发
  - Golang
cover: /img/Pasted%20image%2020230925224032.png
---
>关于软件开发的最佳实践，可以看看[The Twevle-Factor App](https://12factor.net/)的介绍，这里就不展开了。

跟配置文件相关的就是软件的设置项。现代的软件保存配置的方式一般有这么几种：**单个配置文件、命令行参数、环境变量**等等。它们有各自的优缺点：对于单文件配置，它结构清晰易于修改。但是对于多个实例，管理它们的配置需要使用多份配置，很难集中管理；对于命令行参数，干净是干净，就是对用户不太友好；另外就是环境变量，这东西就不是给用户用的吧......调试都没法调）


所以呢？

## 配置文件

首先还是得用配置文件。因为它清晰展示了配置的结构。

```go
package model

import (
	"gopkg.in/yaml.v3"
	"log"
	"os"
)

type Config struct {
	Server struct {
		AppMode string `yaml:"app-mode", envconfig:"SERVER_MODE"`
		Port    string `yaml:"port", envconfig:"SERVER_PORT"`
		JwtKey  string `yaml:"jwt-key", envconfig:"SERVER_JWTKEY"`
	} `yaml:"server"`
	Database struct {
		DbType   string `yaml:"db-type", envconfig:"DB_TYPE"`
		Host     string `yaml:"host", envconfig:"DB_HOST"`
		Port     string `yaml:"port", envconfig:"DB_PORT"`
		Name     string `yaml:"name", envconfig:"DB_NAME"`
		User     string `yaml:"user", envconfig:"DB_USER"`
		Password string `yaml:"password", envconfig:"DB_PASSWORD"`
	} `yaml:"database"`
}

func LoadConfig() {
	var config Config
	readFile(&config)
	readEnv(&config)
}

func readFile(cfg *Config) {
	f, err := os.Open("config.yml")
	if err != nil {
		log.Println(err)
	}
	defer f.Close()

	decoder := yaml.NewDecoder(f)
	err = decoder.Decode(cfg)
	if err != nil {
		log.Println(err)
	}
}

func readEnv(cfg *Config) {
	err := envconfig.Process("", cfg)
	if err != nil {
		log.Println(err)
	}
}

func GetConfig() (Config, int) {
	var config Config
	if err != nil {
		return config, errmsg.ERROR
	}
	return config, errmsg.SUCCSE
}

func UpdateConfig(data *Config) int {

	return errmsg.SUCCSE
}
```
