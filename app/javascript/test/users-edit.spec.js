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
import UsersEdit from '../packs/views/UsersEdit.vue'
import Stub from './Stub.vue'

describe('UsersEdit.vue', () => {
  let user
  let updatedUser
  let CurrentUser
  let store

  beforeEach(() => {
    user = {
      id: 1,
      name: 'example',
      description: 'example',
      avatar: null
    }

    updatedUser = {
      id: 1,
      name: 'example_updated',
      description: 'example_updated',
      avatar: null
    }

    CurrentUser = {
      namespaced: true,
      getters: {
        getCurrentUser: jest.fn(() => {
          return user
        })
      },
      actions: {
        updateCurrentUser: jest.fn()
      }
    }

    store = new Vuex.Store({
      modules: {
        CurrentUser
      }
    })
  })

  it('マウント時にユーザー情報をセット', () => {
    let wrapper = mount(UsersEdit, {
      localVue, store,
      stubs: {
        Links: Stub,
        Error: Stub
      }
    })
    expect(wrapper.vm.user.name).toBe(user.name)
    expect(wrapper.vm.user.description).toBe(user.description)
    expect(wrapper.vm.user.avatar).toBe(user.avatar)
  })

  // it('画像が添付された時base64エンコードする', () => {
  //   let file = new File(['../packs/images/default.jpg'], 'default.jpg', { type: 'image/jpg' })
  //   let wrapper = mount(UsersEdit, {
  //     localVue, store,
  //     stubs: {
  //       Links: Stub,
  //       Error: Stub
  //     }
  //   })
  //   wrapper.find('#avatar').files[0] = file
  //   wrapper.find('#avatar').trigger('change')
  //   expect(wrapper.vm.user.avatar).toMatch('data:image/jpg;base64')
  // })

  it('プロフィールを更新する', async () => {
    mockAxios.onPut(`/api/users/${CurrentUser.getters.getCurrentUser().id}.json`).reply('200', { user: updatedUser })
    let router = {
      push: jest.fn()
    }
    let toasted = {
      show: jest.fn()
    }
    let wrapper = mount(UsersEdit, {
      localVue, store,
      mocks: {
        $toasted: toasted,
        $router: router
      },
      stubs: {
        Error: Stub,
        Links: Stub
      }
    })
    wrapper.vm.$refs.observer.validate = () => Promise.resolve(true)
    wrapper.find('form').trigger('submit.prevent')
    await flushPromises()

    expect(CurrentUser.actions.updateCurrentUser).toHaveBeenCalled()
    expect(toasted.show).toHaveBeenCalled()
    expect(router.push).toHaveBeenCalled()
  })
})