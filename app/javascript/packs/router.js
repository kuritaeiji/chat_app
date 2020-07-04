import Vue from 'vue'
import VueRouter from 'vue-router'
import UsersNew from './views/UsersNew.vue'
import Login from './views/Login.vue'

Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/users/new', component: UsersNew, name: 'UsersNew' },
    { path: '/login', component: Login, name: 'Login'}
  ]
})