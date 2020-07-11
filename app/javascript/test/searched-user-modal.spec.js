import SearchedUserModal from '../packs/components/SearchedUserModal.vue'
import { mount, createLocalVue } from '@vue/test-utils'
import { client } from '../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'
let mockAxios = new MockAdapter(client)
import Vuex from 'vuex'
let localVue = createLocalVue()
localVue.use(Vuex)
import flushPromises from 'flush-promises'
import BootstrapVue from 'bootstrap-vue'
localVue.use(BootstrapVue)

describe('SearchedUserModal', () => {
  let propsMock
  let CurrentUser
  let store

  beforeEach(() => {
    propsMock = {
      showModal: false,
      user: {
        id: 2,
        name: 'example',
        description: 'example',
        avatar: null
      },
      defaultAvatar: ''
    }

    CurrentUser = {
      namespaced: true,
      getters: {
        getCurrentUser: jest.fn(() => {
          return { id: 1 }
        })
      }
    }

    store = new Vuex.Store({
      modules: {
        CurrentUser
      }
    })
  })

  it('モーダルを閉じる', () => {
    let wrapper = mount(SearchedUserModal, {
      localVue, store, propsData: propsMock
    })
    wrapper.find('#modal').trigger('click')
    expect(wrapper.emitted().closeModal).toBeTruthy()
  })

  it('フレンド申請する', async () => {
    mockAxios.onPost(`/api/users/${CurrentUser.getters.getCurrentUser().id}/friendships.json`).reply('200', { message: 'success' } )
    let router = {
      push: jest.fn()
    }
    let toasted = {
      show: jest.fn()
    }
    let wrapper = mount(SearchedUserModal, {
      localVue, store, propsData: propsMock,
      mocks: {
        $router: router,
        $toasted: toasted
      }
    })
    wrapper.find('#apply-button').trigger('click')
    await flushPromises()

    expect(router.push).toHaveBeenCalled()
    expect(toasted.show).toHaveBeenCalled()
  })
})