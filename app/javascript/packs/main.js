import './plugins/turbolinks'
import './plugins/vee-validate'
import './plugins/toast'
import './plugins/bootstrap-vue.js'
import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

Vue.config.devtools = true

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    store,
    render: h => h(App)
  }).$mount('#index')
})