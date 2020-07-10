import { mount, createLocalVue } from '@vue/test-utils'
import Settings from '../packs/views/Settings.vue'
import Stub from './Stub.vue'
import BootstrapVue from 'bootstrap-vue'
import { client } from '../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'
import Vuex from 'vuex'
import flushPromises from 'flush-promises'

let localVue = createLocalVue()
localVue.use(BootstrapVue)
localVue.use(Vuex)
let mockAxios = new MockAdapter(client)

describe('Settings.vue', () => {
  let CurrentUser
  let store

  beforeEach(() => {
    CurrentUser = {
      namespaced: true,
      getters: {
        getCurrentUser: jest.fn(() => {
          return { id: 1 }
        })
      },
      actions: {
        logOut: jest.fn()
      }
    }

    store = new Vuex.Store({
      modules: {
        CurrentUser
      }
    })
  })

  it('ログアウトする', async () => {
    mockAxios.onDelete(`/api/cookies/${CurrentUser.getters.getCurrentUser().id}`).reply('200', { message: 'success' })
    let router = {
      push: jest.fn()
    }
    let wrapper = mount(Settings, {
      localVue, store,
      mocks: {
        $router: router
      },
      stubs: {
        Links: Stub
      }
    })
    console.log(wrapper.find('#log-out'))
    wrapper.find('#log-out').trigger('click')
    await flushPromises()

    expect(CurrentUser.actions.logOut).toHaveBeenCalled()
    expect(router.push).toHaveBeenCalled()
  })
})