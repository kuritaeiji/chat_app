import Vue from 'vue'
import VueRouter from 'vue-router'
import UsersNew from './views/UsersNew.vue'
import Login from './views/Login.vue'
import Home from './views/Home.vue'
import Settings from './views/Settings.vue'
import UsersSearch from  './views/UsersSearch.vue'
import UsersEdit from './views/UsersEdit.vue'
import UsersShow from './views/UsersShow.vue'
import Groups from './views/Groups.vue'
import Group from './views/Group.vue'
import GroupsNew from './views/GroupsNew.vue'
import GroupsEdit from './views/GroupsEdit.vue'

Vue.use(VueRouter)

const router =  new VueRouter({
  mode: 'history',
  routes: [
    { path: '/',                          component: Home,          name: 'Home',        meta: { isAuthLogIn:  true }},
    { path: '/users/new',                 component: UsersNew,      name: 'UsersNew',    meta: { isAuthLogOut: true }},
    { path: '/login',                     component: Login,         name: 'Login',       meta: { isAuthLogOut: true }},
    { path: '/settings',                  component: Settings,      name: 'Settings',    meta: { isAuthLogIn:  true }},
    { path: '/settings/users/search',     component: UsersSearch,   name: 'UsersSearch', meta: { isAuthLogIn:  true }},
    { path: '/settings/users/edit',       component: UsersEdit,     name: 'UsersEdit',   meta: { isAuthLogIn:  true }},
    { path: '/settings/users/show',       component: UsersShow,     name: 'UsersShow',   meta: { isAuthLogIn:  true }},
    { path: '/settings/groups/new',       component: GroupsNew,     name: 'GroupsNew',   meta: { isAuthLogIn:  true }},
    { path: '/settings/groups/edit',      component: GroupsEdit,    name: 'GroupsEdit',  meta: { isAuthLogIn:  true }},
    {
      path: '/groups',
      component: Groups,
      meta: { isAuthLogIn: true },
      children: [
        {
          path: ':groupId',
          component: Group,
          name: 'Group',
          props: true,
          meta: { isAuthLogIn: true }
        }
      ]
    }
  ]
})

router.beforeEach((to, from ,next) => {
  let cookies = document.cookie
  if (to.matched.some((route) => route.meta.isAuthLogIn) && !cookies.match('user_id')) {
    next({ path: '/login' })
  } else if (to.matched.some((route) => route.meta.isAuthLogOut) && cookies.match('user_id')) {
    next({ path: '/' })
  } else {
    next()
  }
})

export default router