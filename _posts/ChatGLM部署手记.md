---
title: ChatGLM部署手记
excerpt: 这卡总算是用起来了
toc: true
author: xeonds
date: 2023.08.23 01:20:56
---

这次部署了一次量化后的模型，大概记录一下部署过程和遇到的问题。

因为显卡显存只有8G，所以部署的是6b的int4量化模型。

## 部署

一般是直接从Hugging Face克隆仓库下来。我当时担心速度不够从清华云盘下载的，不过后来克隆发现速度很快，一般应该是不用担心下载速度的。

首先克隆6b的仓库，然后进入仓库安装依赖：

```bash
git clone https://github.com/THUDM/ChatGLM-6B && cd ChatGLM-6B
pip install -r requirements.txt
```

然后下载ChatGLM-6B的模型的量化版本。注意，**一定要下载所有的文件**。如果clone不下来，就先把其他小文件下下来，然后在清华网盘下载模型本体：

```bash
git clone https://huggingface.co/THUDM/chatglm-6b-int4
# 量化版本地址：https://cloud.tsinghua.edu.cn/d/674208019e314311ab5c/
```

完成后，更改cli-demo.py和webui-demo.py中的`THUDM/chatglm-6b-int4`为你本地的路径：`/path/to/chatglm-6b-int4`即可。

最后，使用python运行即可：

```bash
python3 webui-demo.py
```

## 问题

如果报错的话，可能是缺少 tokenizer 的相关文件：tokenizer_config.json、special_tokens_map.json、tokenization_chatglm.py 和 ice_text.model。将这些文件（位于你下载的模型的目录中）补全即可解决。
