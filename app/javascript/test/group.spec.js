import { mount, createLocalVue } from '@vue/test-utils'
import BootstrapVue from 'bootstrap-vue'
import flushPromises from 'flush-promises'
import { client } from '../packs/plugins/client'
import MockAdapter from 'axios-mock-adapter'
import VueRouter from 'vue-router'

let localVue = createLocalVue()
localVue.use(BootstrapVue)
localVue.use(VueRouter)
let mockAxios = new MockAdapter(client)
import Group from '../packs/views/Group.vue'
import Stub from './Stub.vue'
import Groups from '../packs/views/Groups.vue'

describe('Group.vue', () => {
  let group
  let propsData
  let router
  beforeEach(() => {
    group = {
      id: 1,
      name: 'example1'
    }
    propsData = {
      groupId: '1'
    }
    mockAxios.onGet(`/api/groups/${propsData.groupId}`).reply('200', { group: group })
    router = new VueRouter({
      routes: [
        { 
          path: '/groups',
          component: Groups,
          children: [
            {
              path: ':groupId',
              component: Group,
              props: true
            }
          ]
        }
      ]
    })
  })

  it('マウント時にグループを取得', async () => {
    let wrapper = mount(Group, {
      localVue, propsData, router,
      stubs: {
        Groups: Stub,
        FontAwesomeIcon: Stub
      }
    })
    await flushPromises()

    expect(wrapper.vm.group).toStrictEqual(group)
  })

  
})