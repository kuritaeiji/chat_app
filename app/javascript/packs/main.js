import './plugins/bootstrap-vue.js'
import './plugins/turbolinks'
import Vue from 'vue'
import App from './App.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(App)
  }).$mount('#index')
})