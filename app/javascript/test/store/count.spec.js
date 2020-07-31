import Count from '../../packs/store_modules/count'
import { createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import flushPromises from 'flush-promises'
import { client } from '../../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'
let mockAxios = new MockAdapter(client)

describe('Count', () => {
  let localVue
  let store

  beforeEach(() => {
    localVue = createLocalVue()
    localVue.use(Vuex)

    store = new Vuex.Store({
      modules: {
        Count
      }
    })
  })

  it('dispatch fetchUsersCountApplyingForFriends', async () => {
    mockAxios.onGet('/api/users/1/friendships/users_count_applying_for_friends_to_me').reply('200', { count: 10 })
    store.dispatch('Count/fetchUsersCountApplyingForFriends', 1)
    await flushPromises()
    expect(store.state.Count.usersCountApplyingForFriends).toBe(10)
  })

  it('dispatch fetchUnreadMessagesCount', async () => {
    mockAxios.onGet('/api/messages/return_unread_messages_count').reply('200', { unread_messages_count: 10 })
    store.dispatch('Count/fetchUnreadMessagesCount')
    await flushPromises()
    expect(store.state.Count.unreadMessagesCount).toBe(10)
  })
})