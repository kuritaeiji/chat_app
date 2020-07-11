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
      Object.assign(state.currentUser, payload)
      state.isLoggedIn = true
    },
    logOut(state) {
      state.currentUser = {},
      state.isLoggedIn = false
    },
    updateCurrentUser(state, payload) {
      Object.assign(state.currentUser, payload)
    }
  },
  actions: {
    logIn(context, payload) {
      context.commit('logIn', payload)
    },
    logOut(context) {
      context.commit('logOut')
    },
    updateCurrentUser(context, payload) {
      context.commit('updateCurrentUser', payload)
    }
  }
}