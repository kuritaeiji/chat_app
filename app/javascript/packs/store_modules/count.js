import { client } from '../plugins/client'

export default {
  namespaced: true,
  state: {
    usersCountApplyingForFriends: 0,
    notReadMessagesCount: 0
  },
  getters: {
    getUsersCountApplyingForFriends(state) {
      return state.usersCountApplyingForFriends
    },
    getNotReadMessagesCount(state) {
      return state.notReadMessagesCount
    }
  },
  mutations: {
    setUsersCountApplyingForFriends(state, payload) {
      state.usersCountApplyingForFriends = payload
    },
    setnotReadMessagesCount(state, payload) {
      state.notReadMessagesCount = payload
    }
  },
  actions: {
    async fetchUsersCountApplyingForFriends(context, payload) {
      try {
        const response = await client.get(`/api/users/${payload}/friendships/users_count_applying_for_friends_to_me`)
        context.commit('setUsersCountApplyingForFriends', response.data.count)
      } catch (error) {
        console.log(error)
      }
    },
    async fetchNotReadMessagesCount(context, payload) {
      try {

      } catch (error) {
        
      }
    }
  }
}