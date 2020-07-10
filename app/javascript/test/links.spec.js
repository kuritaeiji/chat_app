import Links from '../packs/components/Links.vue'
import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
let localVue = createLocalVue()
localVue.use(Vuex)

describe('Links.vue', () => {
  let Count
  let CurrentUser
  let store

  beforeEach(() => {
    Count = {
      namespaced: true,
      actions: {
        fetchUsersCountApplyingForFriends: jest.fn()
      }
    }

    CurrentUser = {
      namespaced: true,
      getters: {
        getCurrentUser() {
          return { id: 1 }
        }
      }
    }

    store = new Vuex.Store({
      modules: {
        Count: Count,
        CurrentUser: CurrentUser
      }
    })
  })

  it('マウント時にフレンド申請しているユーザー数を取得', async () => {
    let wrapper = shallowMount(Links, {
      localVue, store
    })
    expect(Count.actions.fetchUsersCountApplyingForFriends).toHaveBeenCalled()
  })
})