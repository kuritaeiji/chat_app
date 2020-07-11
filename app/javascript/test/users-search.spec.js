import UsersSearch from '../packs/views/UsersSearch.vue'
import { mount, createLocalVue } from '@vue/test-utils'
import { client } from '../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'
let mockAxios = new MockAdapter(client)
let localVue = createLocalVue()
import flushPromises from 'flush-promises'
import BootstrapVue from 'bootstrap-vue'
localVue.use(BootstrapVue)
import { ValidationProvider, ValidationObserver, extend
 } from 'vee-validate'
import Stub from './Stub.vue'
import * as rules from 'vee-validate/dist/rules'
for (let rule in rules) {
  extend(rule, rules[rule]);
}
localVue.component('ValidationProvider', ValidationProvider)
localVue.component('ValidationObserver', ValidationObserver)

describe('UsersSearch.vue', () => {
  it('ユーザーを検索する', async () => {
    let user = {
      id: 2,
      name: 'example',
      description: 'example',
      avatar: null
    }
    mockAxios.onGet(`/api/users/search.json`).reply('200', { user: user })
    let wrapper = mount(UsersSearch, {
      localVue,
      stubs: {
        Error: Stub,
        Links: Stub,
        SearchedUserModal: Stub
      }
    })
    wrapper.vm.$refs.provider.validate = () => Promise.resolve(true)
    wrapper.find('form').trigger('submit.prevent')
    await flushPromises()

    expect(wrapper.vm.searchedUser).toStrictEqual(user)
    expect(wrapper.vm.errorMessages).toStrictEqual([])
  })

  it('ユーザーがいない場合エラ〜メッセージを返す', async () => {
    mockAxios.onGet(`/api/users/search.json`).reply('200', { message: 'ユーザーが見つかりませんでした。' })
    let wrapper = mount(UsersSearch, {
      localVue,
      stubs: {
        Error: Stub,
        Links: Stub,
        SearchedUserModal: Stub
      }
    })
    wrapper.vm.$refs.provider.validate = () => Promise.resolve(true)
    wrapper.find('form').trigger('submit.prevent')
    await flushPromises()

    expect(wrapper.vm.errorMessages).toStrictEqual(['ユーザーが見つかりませんでした。'])
  })
})