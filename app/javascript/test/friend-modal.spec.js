import { mount, createLocalVue } from '@vue/test-utils'
import BootstrapVue from 'bootstrap-vue'
import flushPromises from 'flush-promises'
import { client } from '../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'
import Vuex from 'vuex'

let localVue = createLocalVue()
localVue.use(Vuex)
localVue.use(BootstrapVue)
let mockAxios = new MockAdapter(client)

import FriendModal from '../packs/components/FriendModal.vue'
import defaultAvatar from '../packs/images/default.jpg'

describe('FriendModal.vue', () => {
  let CurrentUser
  let store
  let propsMocks

  beforeEach(() => {
    CurrentUser = {
      namespaced: true,
      getters: {
        getCurrentUser: jest.fn(() => {
          return {
            id: 1
          }
        })
      }
    }

    store = new Vuex.Store({
      modules: {
        CurrentUser
      }
    })

    propsMocks = {
      showModal: true,
      friend: {
        id: 2,
        name: 'example',
        description: 'example',
        avatar: null
      },
      defaultAvatar: defaultAvatar
    }
  })

  it('モーダルを閉じる', () => {
    let wrapper = mount(FriendModal, {
      localVue, store, propsData: propsMocks
    })
    wrapper.find('#modal').trigger('click.self')
    expect(wrapper.emitted().closeFriendModal).toBeTruthy()
  })

  it('トークボタンを押すとトーク画面に遷移', async () => {
    let router = {
      push: jest.fn()
    }
    mockAxios.onPost('/api/groups.json').reply('200', { group_id: 1 })
    let wrapper = mount(FriendModal, {
      localVue, store, propsData: propsMocks,
      mocks: {
        $router: router
      }
    })
    wrapper.find('#talk-button').trigger('click.stop')
    await flushPromises()

    expect(router.push).toHaveBeenCalled()
  })
})