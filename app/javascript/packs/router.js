import Vue from 'vue'
import VueRouter from 'vue-router'
import UsersNew from './views/UsersNew.vue'
import Login from './views/Login.vue'
import Home from './views/Home.vue'
import Settings from './views/Settings.vue'
import UsersSearch from  './views/UsersSearch.vue'
import UsersEdit from './views/UsersEdit.vue'

Vue.use(VueRouter)

const router =  new VueRouter({
  mode: 'history',
  routes: [
    { path: '/',                  component: Home,          name: 'Home',        meta: { isAuthLogIn: true }},
    { path: '/users/new',         component: UsersNew,      name: 'UsersNew' },
    { path: '/login',             component: Login,         name: 'Login'    },
    { path: '/settings',          component: Settings,      name: 'Settings',    meta: { isAuthLogIn: true }},
    { path: '/users/search',      component: UsersSearch,   name: 'UsersSearch', meta: { isAuthLogIn: true }},
    { path: '/users/edit',        component: UsersEdit,     name: 'UsersEdit',   meta: { isAuthLogIn: true }}
  ]
})

router.beforeEach((to, from ,next) => {
  let cookies = document.cookie
  if (to.matched.some((route) => route.meta.isAuthLogIn) && !cookies.match('user_id')) {
    next({ path: '/login' })
  } else {
    next()
  }
})

export default router