import Vuex from 'vuex'
import Vue from 'vue'
import CurrentUser from './store_modules/current-user'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    CurrentUser: CurrentUser
  }
})