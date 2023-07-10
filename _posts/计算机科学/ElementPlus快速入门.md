---
title: ElementPlus快速入门
date: 2023-07-10 01:13:15
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

# 快速开始[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B)

本节将介绍如何在项目中使用 Element Plus。

## 用法[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E7%94%A8%E6%B3%95)

### 完整引入[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E5%AE%8C%E6%95%B4%E5%BC%95%E5%85%A5)

如果你对打包后的文件大小不是很在乎，那么使用完整导入会更方便。

```
// main.ts
import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue'

const app = createApp(App)

app.use(ElementPlus)
app.mount('#app')
```

#### Volar 支持[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#volar-%E6%94%AF%E6%8C%81)

如果您使用 Volar，请在 `tsconfig.json` 中通过 `compilerOptions.type` 指定全局组件类型。

```
// tsconfig.json
{
  "compilerOptions": {
    // ...
    "types": ["element-plus/global"]
  }
}
```

### 按需导入[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E6%8C%89%E9%9C%80%E5%AF%BC%E5%85%A5)

您需要使用额外的插件来导入要使用的组件。

#### 自动导入推荐[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E8%87%AA%E5%8A%A8%E5%AF%BC%E5%85%A5-%E6%8E%A8%E8%8D%90)

首先你需要安装`unplugin-vue-components` 和 `unplugin-auto-import`这两款插件

```
npm install -D unplugin-vue-components unplugin-auto-import
```

然后把下列代码插入到你的 `Vite` 或 `Webpack` 的配置文件中

##### Vite[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#vite)

```
// vite.config.ts
import { defineConfig } from 'vite'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

export default defineConfig({
  // ...
  plugins: [
    // ...
    AutoImport({
      resolvers: [ElementPlusResolver()],
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    }),
  ],
})
```

##### Webpack[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#webpack)

```
// webpack.config.js
const AutoImport = require('unplugin-auto-import/webpack')
const Components = require('unplugin-vue-components/webpack')
const { ElementPlusResolver } = require('unplugin-vue-components/resolvers')

module.exports = {
  // ...
  plugins: [
    AutoImport({
      resolvers: [ElementPlusResolver()],
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    }),
  ],
}
```

想了解更多打包 ([Rollup](https://rollupjs.org/), [Vue CLI](https://cli.vuejs.org/)) 和配置工具，请参考 [unplugin-vue-components](https://github.com/antfu/unplugin-vue-components#installation) 和 [unplugin-auto-import](https://github.com/antfu/unplugin-auto-import#install)。

#### Nuxt[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#nuxt)

关于 Nuxt 用户, 你只需要安装 `@element-plus/nuxt` 即可.

```
npm install -D @element-plus/nuxt
```

然后将下面的代码写入你的配置文件.

```
// nuxt.config.ts
export default defineNuxtConfig({
  modules: ['@element-plus/nuxt'],
})
```

配置文档参考 [docs](https://github.com/element-plus/element-plus-nuxt#readme).

### 手动导入[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E6%89%8B%E5%8A%A8%E5%AF%BC%E5%85%A5)

Element Plus 提供了基于 ES Module 的开箱即用的 [Tree Shaking](https://webpack.js.org/guides/tree-shaking/) 功能。

但你需要安装 [unplugin-element-plus](https://github.com/element-plus/unplugin-element-plus) 来导入样式。 配置文档参考 [docs](https://github.com/element-plus/unplugin-element-plus#readme).

> App.vue

```
<template>
  <el-button>我是 ElButton</el-button>
</template>
<script>
  import { ElButton } from 'element-plus'
  export default {
    components: { ElButton },
  }
</script>
```

```
// vite.config.ts
import { defineConfig } from 'vite'
import ElementPlus from 'unplugin-element-plus/vite'

export default defineConfig({
  // ...
  plugins: [ElementPlus()],
})
```

WARNING

如果使用 `unplugin-element-plus` 并且只使用组件 API，你需要手动导入样式。

Example:

```
import 'element-plus/es/components/message/style/css'
import { ElMessage } from 'element-plus'
```

## 快捷搭建项目模板[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E5%BF%AB%E6%8D%B7%E6%90%AD%E5%BB%BA%E9%A1%B9%E7%9B%AE%E6%A8%A1%E6%9D%BF)

我们提供了 [Vite 模板](https://github.com/element-plus/element-plus-vite-starter)。

对于Nuxt 用户，我们有一个 [Nuxt 模板](https://github.com/element-plus/element-plus-nuxt-starter)。

对于 Laravel 用户，我们也准备了[Laravel 模板](https://github.com/element-plus/element-plus-in-laravel-starter)。

## 全局配置[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E5%85%A8%E5%B1%80%E9%85%8D%E7%BD%AE)

在引入 ElementPlus 时，可以传入一个包含 `size` 和 `zIndex` 属性的全局配置对象。 `size` 用于设置表单组件的默认尺寸，`zIndex` 用于设置弹出组件的层级，`zIndex` 的默认值为 `2000`。

完整引入：

```
import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import App from './App.vue'

const app = createApp(App)
app.use(ElementPlus, { size: 'small', zIndex: 3000 })
```

按需引入:

```
<template>
  <el-config-provider :size="size" :z-index="zIndex">
    <app />
  </el-config-provider>
</template>

<script>
import { defineComponent } from 'vue'
import { ElConfigProvider } from 'element-plus'

export default defineComponent({
  components: {
    ElConfigProvider,
  },
  setup() {
    return {
      zIndex: 3000,
      size: 'small',
    }
  },
})
</script>
```

## 使用 Nuxt.js[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E4%BD%BF%E7%94%A8-nuxt-js)

我们也可以使用 [Nuxt.js](https://v3.nuxtjs.org/)：

## 开始使用[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#%E5%BC%80%E5%A7%8B%E4%BD%BF%E7%94%A8)

现在你可以启动项目了。 具体每个组件的使用方法, 请查阅 [每个组件的独立文档](https://element-plus.org/en-US/component/button.html).