import { client } from '../plugins/client'

export default {
  namespaced: true,
  state: {
    usersCountApplyingForFriends: 0,
    unreadMessagesCount: 0
  },
  getters: {
    getUsersCountApplyingForFriends(state) {
      return state.usersCountApplyingForFriends
    },
    getUnreadMessagesCount(state) {
      return state.unreadMessagesCount
    }
  },
  mutations: {
    setUsersCountApplyingForFriends(state, payload) {
      state.usersCountApplyingForFriends = payload
    },
    setUnreadMessagesCount(state, payload) {
      state.unreadMessagesCount = payload
    },
    updateUnreadMessagesCount(state, payload) {
      state.unreadMessagesCount -= payload
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
    async fetchUnreadMessagesCount(context) {
      try {
        const response = await client.get('/api/messages/return_unread_messages_count')
        context.commit('setUnreadMessagesCount', response.data.unread_messages_count)
      } catch (error) {
        console.log(error)
      }
    },
    updateUnreadMessagesCount(context, payload) {
      context.commit('updateUnreadMessagesCount', payload)
    }
  }
}