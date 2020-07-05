import Vue from 'vue'
import VueRouter from 'vue-router'
import UsersNew from './views/UsersNew.vue'
import Login from './views/Login.vue'
import Home from './views/Home.vue'

Vue.use(VueRouter)

const router =  new VueRouter({
  mode: 'history',
  routes: [
    { path: '/',          component: Home,     name: 'Home'     , meta: { isAuthLogIn: true }},
    { path: '/users/new', component: UsersNew, name: 'UsersNew' },
    { path: '/login',     component: Login,    name: 'Login'    , meta: { isAuthLogout: true}}
  ]
})

let cookies = document.cookie

router.beforeEach((to, from ,next) => {
  if (to.matched.some((route) => route.meta.isAuthLogIn) && !cookies.match('user_id')) {
    next({ path: '/login' })
  } else if (to.matched.some((route) => route.meta.isAuthLogOut) && !!cookies.match('user_id')) {
      next({ path: '/' })
  } else {
    next()
  }
})

export default router