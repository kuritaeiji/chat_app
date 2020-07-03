import './plugins/bootstrap-vue.js'
import './plugins/turbolinks'
import './plugins/axios'
import './plugins/vee-validate'
import Vue from 'vue'
import App from './App.vue'
import router from './router'

import { ValidationObserver, ValidationProvider } from 'vee-validate'
Vue.component('ValidationProvider', ValidationProvider)
Vue.component('ValidationObserver', ValidationObserver)

Vue.config.devtools = true

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    render: h => h(App)
  }).$mount('#index')
})