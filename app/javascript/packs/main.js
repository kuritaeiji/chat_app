import './plugins/bootstrap-vue.js'
import './plugins/turbolinks'
import './plugins/vee-validate'
import Vue from 'vue'
import App from './App.vue'
import router from './router'

Vue.config.devtools = true

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    render: h => h(App)
  }).$mount('#index')
})