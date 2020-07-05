import { mount, createLocalVue } from '@vue/test-utils'
import BootstrapVue from 'bootstrap-vue'
import flushPromises from 'flush-promises'
import { ValidationProvider, ValidationObserver } from 'vee-validate'
import { client } from '../packs/plugins/client.js'
import MockAdapter from 'axios-mock-adapter'
const mockAxios = new MockAdapter(client)
import Vuex from 'vuex'


const localVue = createLocalVue()
localVue.use(BootstrapVue)
localVue.use(Vuex)
localVue.component('ValidationProvider', ValidationProvider)
localVue.component('ValidationObserver', ValidationObserver)
import Login from '../packs/views/Login.vue'
import Error from '../packs/components/Error.vue'

describe('Login.vue', () => {
  it('正しいパスワードとメールアドレスが入力されるとログインする', async () => {
    const router = {
      push: jest.fn()
    }

    const CurrentUser = {
      namespaced: true,
      mutations: {
        logIn: jest.fn()
      }
    }

    const store = new Vuex.Store({
      modules: {
        CurrentUser: CurrentUser
      }
    })
    
    const wrapper = mount(Login, {
      localVue, store,
      mocks: {
        $router: router
      }
    })
    mockAxios.onPost('/api/cookies.json').reply('200', { user: { name: 'example', identifier_id: 'example' } })
    wrapper.vm.$refs.observer.validate = () => Promise.resolve(true)
    wrapper.find('form').trigger('submit.prevent')
    await flushPromises()

    expect(CurrentUser.mutations.logIn).toHaveBeenCalled()
    expect(router.push).toHaveBeenCalled()
  })

  it('正しくない値を入力するとエラーメッセージが追加', async () => {
    const wrapper = mount(Login, {
      localVue
    })
    const errorMessage = 'メールアドレスもしくはパスワードが間違っています。'
    mockAxios.onPost('/api/cookies.json').reply('200', { error_message: errorMessage } )
    wrapper.vm.$refs.observer.validate = () => Promise.resolve(true)
    wrapper.find('form').trigger('submit.prevent')
    await flushPromises()

    expect(wrapper.vm.errorMessages[0]).toBe(errorMessage)
  })
})