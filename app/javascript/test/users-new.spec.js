import { mount, createLocalVue } from '@vue/test-utils'
import UsersNew from '../packs/views/UsersNew.vue'
import BootstrapVue from 'bootstrap-vue'
import flushPromises from 'flush-promises'
import { ValidationProvider, ValidationObserver } from 'vee-validate'
import { client } from '../packs/plugins/client.js'
import MockAdapter from 'axios-mock-adapter'
const mockAxios = new MockAdapter(client)

const localVue = createLocalVue()
localVue.use(BootstrapVue)
localVue.component('ValidationProvider', ValidationProvider)
localVue.component('ValidationObserver', ValidationObserver)




describe('UsersNew.vue', () => {
  it('正しくない値の時エラーメッセージを受け取る', async () => {
    const wrapper = mount(UsersNew, {
      localVue,
    })
    mockAxios.onPost('/api/users.json').reply('200', { error_messages: [ { message: 'message' } ] })

    wrapper.vm.$refs.observer.validate = () => Promise.resolve(true)
    wrapper.find('form').trigger('submit.prevent')
    await flushPromises()
    expect(wrapper.vm.errorMessages[0]).toBe('message')
  })
})