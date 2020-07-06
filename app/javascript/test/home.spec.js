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
  it('マウント後にユーザー情報を取得', async () => {
    let user = { user: { name: 'example', id: '1', description: 'example' } }
    let CurrentUser = {
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
    CurrentUser.getters.getCurrentUser.mockReturnValue(user)

    let store = new Vuex.Store({
      modules: {
        CurrentUser: CurrentUser
      }
    })

    let getCookie = jest.fn()
    getCookie.mockReturnValue('1')

    mockAxios.onGet(`/api/users/${getCookie()}`).reply('200', user )

    let wrapper = shallowMount(Home, {
      localVue, store,  methods: { getCookie } 
    })
    
    await flushPromises()
    expect(CurrentUser.actions.logIn).toHaveBeenCalled()
  })
})