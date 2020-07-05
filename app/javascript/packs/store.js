import Vuex from 'vuex'
import Vue from 'vue'
import CurrentUser from './store_modules/current-user'
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    CurrentUser: CurrentUser
  },
  plugins: [createPersistedState({
    key: 'chat-app',
    storage: localStorage
  })]
})