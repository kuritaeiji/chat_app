import { mount, createLocalVue } from '@vue/test-utils'
import BootstrapVue from 'bootstrap-vue'
import flushPromises from 'flush-promises'
import { client } from '../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'

let localVue = createLocalVue()
localVue.use(BootstrapVue)
let mockAxios = new MockAdapter(client)

import Groups from '../packs/views/Groups.vue'
import Stub from './Stub.vue'

describe('Groups.vue', () => {
  let groups

  beforeEach(() => {
    groups = [
      { id: 1, name: 'example', avatar: null, unread_messages_count_by_groups: 1 },
      { id: 2, name: 'example2', avatar: null, unread_messages_count_by_groups: 1 }
    ]
    mockAxios.onGet('/api/groups').reply('200', groups)
  })

  it('マウント時にグループを取得', async () => {
    let wrapper = mount(Groups, {
      localVue,
      stubs: {
        Links: Stub
      }
    })
    await flushPromises()

    expect(wrapper.vm.groups).toStrictEqual(groups)
  })
})