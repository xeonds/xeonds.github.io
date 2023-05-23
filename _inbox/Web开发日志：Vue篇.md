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

## ElementUI

### el-input的输入问题

遇到过一次输入框无法输入的问题。查看了下[官方文档](https://element-plus.gitee.io/zh-CN/component/input.html#input-%E8%BE%93%E5%85%A5%E6%A1%86)发现是设计特性。正常来说，Input总是会响应输入事件，但是**el-input是受控组件，所以它总是会更优先保证显示v-model绑定的数据值**。这也就是为什么输入不会被正常响应的原因：没有给它加`v-model`，或者绑定了不存在/错误的对象。

>不过我绑定不存在元素的时候居然没有报错，神奇......

