import { mount, createLocalVue } from '@vue/test-utils'
import BootstrapVue from 'bootstrap-vue'
import flushPromises from 'flush-promises'
import { client } from '../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'
import Vuex from 'vuex'
import { ValidationProvider, ValidationObserver } from 'vee-validate'

let localVue = createLocalVue()
localVue.component('ValidationProvider', ValidationProvider)
localVue.component('ValidationObserver', ValidationObserver)
localVue.use(Vuex)
localVue.use(BootstrapVue)
let mockAxios = new MockAdapter(client)
import UsersEdit from '../packs/views/GroupsNew.vue'
import Stub from './Stub.vue'

describe('GroupsNew.vue', () => {
  let store
  let CurrentUser
  let fetchFriends
  let friendA
  let friendB

  beforeEach(() => {
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

    friendA = {
      id: 2,
      name: 'friendA',
      avatar: null
    }

    friendB = {
      id: 3,
      name: 'friendB',
      avatar: null
    }

    fetchFriends = jest.fn(() => {
      return [friendA, friendB]
    })
  })

  it('マウント時にフレンド取得', async () => {
    mockAxios.onGet(`/api/users/${CurrentUser.getters.getCurrentUser().id}/friendships`).reply('200', [friendA, friendB])
    let wrapper = mount(UsersEdit, {
      localVue, store,
      stubs: {
        Links: Stub,
        Error: Stub
      }
    })
    await flushPromises()

    expect(wrapper.vm.friends).toStrictEqual([friendA, friendB])
    expect(wrapper.vm.group.user_ids).toStrictEqual([CurrentUser.getters.getCurrentUser().id])
  })

  it('グループの作成ができる', async () => {
    mockAxios.onPost('/api/groups.json').reply('200', { group_id: 1 })
    let router = {
      push: jest.fn()
    }
    let toasted = {
      show: jest.fn()
    }
    let wrapper = mount(UsersEdit, {
      localVue, store,
      methods: {
        fetchFriends
      },
      stubs: {
        Links: Stub,
        Error: Stub
      },
      mocks: {
        $router: router,
        $toasted: toasted
      }
    })
    wrapper.setData({ group: { name: '', avatar: '', user_ids: [1, 2, 3] }})
    wrapper.find('form').trigger('submit.prevent')
    await flushPromises()

    expect(router.push).toHaveBeenCalled()
  })
})