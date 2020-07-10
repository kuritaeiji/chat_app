export default {
  namespaced: true,
  state: {
    currentUser: {},
    isLoggedIn: false
  },
  getters: {
    getCurrentUser(state) {
      return state.currentUser
    },
    getIsLoggedIn(state) {
      return state.isLoggedIn
    }
  },
  mutations: {
    logIn(state, payload) {
      state.currentUser = payload
      Object.assign({}, payload)
      state.isLoggedIn = true
    },
    logOut(state) {
      state.currentUser = {},
      state.isLoggedIn = false
    }
  },
  actions: {
    logIn(context, payload) {
      context.commit('logIn', payload)
    },
    logOut(context) {
      context.commit('logOut')
    }
  }
}