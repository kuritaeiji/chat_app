import { mount, createLocalVue } from '@vue/test-utils'
import BootstrapVue from 'bootstrap-vue'
import flushPromises from 'flush-promises'
import { client } from '../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'
import Vuex from 'vuex'
import { ValidationProvider, ValidationObserver, extend } from 'vee-validate'
import * as rules from 'vee-validate/dist/rules'
for (let rule in rules) {
  extend(rule, rules[rule]);
}

let localVue = createLocalVue()
localVue.component('ValidationProvider', ValidationProvider)
localVue.component('ValidationObserver', ValidationObserver)
localVue.use(Vuex)
localVue.use(BootstrapVue)
let mockAxios = new MockAdapter(client)
import defaultAvatar from '../packs/images/default.jpg'
import GroupsEdit from '../packs/views/GroupsEdit.vue'
import Stub from './Stub.vue'

describe('GroupsEdit.vue', () => {
  let propsData
  let user
  let group
  let friendA
  let friendB
  let CurrentUser
  let store
  beforeEach(() => {
    propsData = {
      groupId: '1'
    }

    user = {
      id: 1,
      name: 'example',
      description: 'example',
      avatar: null
    }

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

    CurrentUser = {
      namespaced: true,
      getters: {
        getCurrentUser: jest.fn(() => {
          return user
        })
      }
    }

    group = {
      id: 1,
      name: 'example',
      avatar: null,
      user_ids: [CurrentUser.getters.getCurrentUser().id ,friendA.id, friendB.id]
    }


    store = new Vuex.Store({
      modules: { CurrentUser }
    })
    
    mockAxios.onGet(`/api/groups/${propsData.groupId}`).reply('200', { group: group })
    mockAxios.onGet(`/api/groups/${propsData.groupId}/friends_and_members`).reply('200', [friendA, friendB])
  })

  it('マウント時にフレンドとグループを取得', async () => {
    let wrapper = mount(GroupsEdit, {
      localVue, store, propsData,
      stubs: {
        Error: Stub,
        Links: Stub
      }
    })

    await flushPromises()
    expect(wrapper.vm.friends).toStrictEqual([friendA, friendB])
    expect(wrapper.vm.group).toStrictEqual(group)
  })

  it('グループをアップデートする', async () => {
    let router = {
      push: jest.fn()
    }

    let toasted = {
      show: jest.fn()
    }

    let wrapper = mount(GroupsEdit, {
      localVue, store, propsData,
      mocks: {
        $router: router,
        $toasted: toasted
      },
      stubs: {
        Error: Stub,
        Links: Stub
      }
    })
    await flushPromises()

    mockAxios.onPut(`/api/groups/${propsData.groupId}.json`).reply('200', { group_id: propsData.groupId })
    wrapper.vm.$refs.observer.validate = () => Promise.resolve(true)
    wrapper.find('form').trigger('submit.prevent')
    await flushPromises()

    expect(router.push).toHaveBeenCalled()
    expect(toasted.show).toHaveBeenCalled()
  })

  it('グループのメンバーが二人以下の時エラーメッセージを表示', async () => {
    let wrapper = mount(GroupsEdit, {
      localVue, store, propsData,
      stubs: {
        Error: Stub,
        Links: Stub
      }
    })
    await flushPromises()

    wrapper.setData({ group: {
      id: 1,
      name: 'example',
      avatar: null,
      user_ids: [CurrentUser.getters.getCurrentUser().id ,friendA.id]
    }})
    expect(wrapper.vm.group.user_ids.length).toBe(2)
    wrapper.vm.$refs.observer.validate = () => Promise.resolve(true)
    wrapper.find('form').trigger('submit.prevent')
    await flushPromises()
    expect(wrapper.vm.errorMessages).toStrictEqual(['二人以上のグループメンバーを選んでください'])
  })
})