---
title: Web开发日志
date: 2023-07-10 01:13:15
author: xeonds
toc: true
excerpt: 前端就是不停地造轮子
tags:
  - Vue
  - ElementPlus
  - Vite
---

## Vue篇

### 关于Slot

Slot，即“插槽”，是Vue的一个很重要的功能。通过插槽，可以将其他的组件“插入”到当前组件的某个槽位。这个机制的优点，就是在保留了子组件的控制的同时，也给父组件保留了一定的内容控制权。比如elementUI，它的很多功能都提供了slot来让我们插入自定义的内容。

#### 用法

它的用法很简单，分两部分。

1. 组件

```vue
...
<slot name="component-a" :param1="123"></slot>
...
```

2. 父组件

```vue
<Component>
	<template #component-a="{ param_1 }">
		{{ param_1 }}
	</template>
</Component>
```

上面是完整示例，一个**具名**的**作用域**插槽。它将子组件的一个参数`param1`通过解构赋值，回传到了父组件的形参`param_1`中，并在其中渲染出了它的值。同时，父组件将这部分template中的内容传入了子组件中，和子组件的其他部分内容一同渲染。

## Vue-router

### 历史模式的问题

`Vue-router`支持多种历史模式。现在较为常用的一种就是`HTML5`模式。该模式下，浏览器显示的链接和正常的url一致，非常漂亮。但是需要后端路由的配置，否则会出现刷新页面出现404的问题。

除了`HTML5`模式，还有一种历史模式，叫做`hash`模式。它会在url中添加一个`#`来解决这个问题：`#`后面的部分在刷新时不会被后端认为是任何后端路由，因此也就不存在刷新后出现404的问题。

这一部分的配置在`createRouter()`的参数中进行配置：

```js
import { createRouter, createWebHashHistory, createWebHistory } from "vue-router";

export default createRouter({
  // hash模式，无需后端配置
  history: createWebHashHistory(),
  // html5模式，需要后端配置
  history: createWebHistory(),
  routes: [ ... ]
});
```

## Vuex

这是Vue官方出的状态管理插件。它用来管理整个单页程序的所有数据。

### 项目架构

使用Vuex时，最佳实践一般是使用模块来组织各个部分的数据。假设我们的项目的store目录结构如下：

```bash
- store
  - modules
    - module1.js
    - module2.js
    - module3.js
  - index.js
```

那么，我们可以在每个模块中这么定义数据：

```js
const auth = {
  state: {
    token: null
  },
  mutations: {
    SET_TOKEN(state, token) {
      state.token = token;
    }
  },
  actions: {
    setToken({ commit }, token) {
      commit("SET_TOKEN", token);
    }
  },
  getters: {
    getToken(state) {
      return state.token;
    }
  }
};

export default auth;
```

然后在index.js中这么导入模块：

```js
import Vue from 'vue';
import Vuex from 'vuex';
import modules from './modules';

Vue.use(Vuex);

const store = new Vuex.Store({
  modules,
  plugins: [localStoragePlugin]
});

export default store;
```

这种结构便于我们维护前端的数据模型。

## Vite

### pathResolve

```vite
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import path from "path";
import AutoImport from "unplugin-auto-import/vite";
import Components from "unplugin-vue-components/vite";
import { ElementPlusResolver } from "unplugin-vue-components/resolvers";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    AutoImport({
      resolvers: [ElementPlusResolver()],
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    }),
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
```

## ElementUI篇

### 完整引入
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

- Volar 支持[#](https://element-plus.gitee.io/zh-CN/guide/quickstart.html#volar-%E6%94%AF%E6%8C%81)

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

### 自动导入

首先你需要安装`unplugin-vue-components` 和 `unplugin-auto-import`这两款插件

```
npm install -D unplugin-vue-components unplugin-auto-import
```

然后把下列代码插入到你的 `Vite` 或 `Webpack` 的配置文件中

#### Vite

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

#### Webpack

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

#### Nuxt
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

### 手动导入

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

### 全局配置

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

### `el-input`的输入问题

遇到过一次输入框无法输入的问题。查看了下[官方文档](https://element-plus.gitee.io/zh-CN/component/input.html#input-%E8%BE%93%E5%85%A5%E6%A1%86)发现是设计特性。正常来说，Input总是会响应输入事件，但是**el-input是受控组件，所以它总是会更优先保证显示v-model绑定的数据值**。这也就是为什么输入不会被正常响应的原因：没有给它加`v-model`，或者绑定了不存在/错误的对象。

>不过我绑定不存在元素的时候居然没有报错，神奇......

## vue3+vite相对路径打包

```vite
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  base: './'
})
```


