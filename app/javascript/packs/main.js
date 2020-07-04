import './plugins/bootstrap-vue.js'
import './plugins/turbolinks'
import './plugins/vee-validate'
import Vue from 'vue'
import App from './App.vue'
import router from './router'

import VueAxiosPlugin from './plugins/vue-axios'
import axios from 'axios'
Vue.use(VueAxiosPlugin, { axios: axios })

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