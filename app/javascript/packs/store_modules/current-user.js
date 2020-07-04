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
      state.isLoggedIn = true
    },
    logOut(state) {
      state.currentUser = {},
      state.isLoggedIn = false
    }
  }
}