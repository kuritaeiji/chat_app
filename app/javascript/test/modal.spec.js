import Modal from '../packs/components/Modal.vue'
import { shallowMount, mount, createLocalVue } from '@vue/test-utils'
import { client } from '../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'
let mockAxios = new MockAdapter(client)
import Vuex from 'vuex'
let localVue = createLocalVue()
localVue.use(Vuex)
import flushPromises from 'flush-promises'
import BootstrapVue from 'bootstrap-vue'
localVue.use(BootstrapVue)

let propsMock = {
  showUser: false,
  user: {
    id: 2,
    name: 'example',
    description: 'example',
    avatar: null
  },
  defaultAvatar: ''
}

describe('Modal.vue', () => {
  let store
  let CurrentUser

  beforeEach(() => {
    CurrentUser = {
      namespaced: true,
      getters: {
        getCurrentUser: jest.fn()
      }
    }
    CurrentUser.getters.getCurrentUser.mockReturnValue({id: 1})

    store = new Vuex.Store({
      modules: {
        CurrentUser: CurrentUser
      }
    })
  })

  it('モーダルを閉じる', () => {
    let wrapper = shallowMount(Modal, {
      localVue, propsData: propsMock
    })
    wrapper.find('#modal').trigger('click.self')
    expect(wrapper.emitted().closeUserModal.length).toBe(1)
  })

  it('承認ボタンを押すと承認する', async () => {
    let router = {
      go: jest.fn()
    }

    let toasted = {
      show: jest.fn()
    }

    let wrapper = shallowMount(Modal, {
      localVue, propsData: propsMock, store,
      mocks: {
        $router: router,
        $toasted: toasted
      }
    })
    mockAxios.onPut(`/api/users/1/friendships/approve.json`).reply('200')
    wrapper.find('#approve-button').trigger('click.stop')
    await flushPromises()

    expect(router.go).toHaveBeenCalled()
    expect(toasted.show).toHaveBeenCalled()
  })
})