import { shallowMount, createLocalVue } from '@vue/test-utils'
import BootstrapVue from 'bootstrap-vue'
import flushPromises from 'flush-promises'
import { client } from '../packs/plugins/client.js'
import Vuex from 'vuex'
import MockAdapter from 'axios-mock-adapter'
const mockAxios = new MockAdapter(client)

const localVue = createLocalVue()
localVue.use(BootstrapVue)
localVue.use(Vuex)
import Home from '../packs/views/Home.vue'

describe('Home.vue', () => {
  let store
  let CurrentUser
  let getCookie
  let currentUser
  let friends
  let usersApplyingForFriends

  beforeEach(() => {
    currentUser = { user: { name: 'example', id: '1', description: 'example', avatar: null } }
    friends = [{ name: 'example_friend', id: '2', description: 'example_friend', avatar: null }]
    usersApplyingForFriends = [{ name: 'example_users', id: '3', description: 'example_users', avatar: null }]
    CurrentUser = {
      namespaced: true,
      actions: {
        logIn: jest.fn()
      },
      getters: {
        getIsLoggedIn: jest.fn(),
        getCurrentUser: jest.fn()
      }
    }
    CurrentUser.getters.getIsLoggedIn.mockReturnValue(false)
    CurrentUser.getters.getCurrentUser.mockReturnValue(currentUser.user)

    store = new Vuex.Store({
      modules: {
        CurrentUser: CurrentUser
      }
    })

    getCookie = jest.fn()
    getCookie.mockReturnValue('1')
  })

  it('マウント後にユーザー情報を取得', async () => {
    mockAxios.onGet(`/api/users/${getCookie()}`).reply('200', { user: currentUser } )
    let wrapper = shallowMount(Home, {
      localVue, store,  methods: { getCookie } 
    })
    await flushPromises()
    expect(CurrentUser.actions.logIn).toHaveBeenCalled()
  })

  it('マウント後にフレンド取得', async () => {
    mockAxios.onGet(`/api/users/${CurrentUser.getters.getCurrentUser().id}/friendships`).reply('200', friends)
    let wrapper = shallowMount(Home, {
      localVue, store, methods: { getCookie }
    })
    await flushPromises()
    expect(wrapper.vm.friends).toStrictEqual(friends)
    expect(wrapper.vm.showFriends).toStrictEqual([false])
  })

  it('マウント後にフレンド申請してきているユーザーを取得', async () => {
    mockAxios.onGet(`/api/users/${CurrentUser.getters.getCurrentUser().id}/friendships/users_applying_for_friends_to_me`).reply('200', usersApplyingForFriends)
    let wrapper = shallowMount(Home, {
      localVue, store, methods: { getCookie }
    })
    await flushPromises()
    expect(wrapper.vm.usersApplyingForFriends).toStrictEqual(usersApplyingForFriends)
    expect(wrapper.vm.showUsers).toStrictEqual([false])
  })
})