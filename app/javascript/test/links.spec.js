import Links from '../packs/components/Links.vue'
import BootstrapVue from 'bootstrap-vue'
import { mount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
let localVue = createLocalVue()
localVue.use(Vuex)
localVue.use(BootstrapVue)

describe('Links.vue', () => {
  let Count
  let CurrentUser
  let store
  let getCookie

  beforeEach(() => {
    Count = {
      namespaced: true,
      actions: {
        fetchUsersCountApplyingForFriends: jest.fn(),
        fetchUnreadMessagesCount: jest.fn()
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

    getCookie = jest.fn(() => {
      return '1'
    })
  })

  it('マウント時にフレンド申請しているユーザー数を取得', async () => {
    let wrapper = mount(Links, {
      localVue, store, methods: { getCookie }
    })
    expect(Count.actions.fetchUsersCountApplyingForFriends).toHaveBeenCalled()
  })

  it('マウント時に未読数を取得', async () => {
    let wrapper = mount(Links, {
      localVue, store, methods: { getCookie }
    })
    expect(Count.actions.fetchUnreadMessagesCount).toHaveBeenCalled()
  })

  it('5秒ごとにfetchUnreadMessagesCountが呼び出される', async () => {
    let wrapper = mount(Links, {
      localVue, store, methods: { getCookie }
    })
    jest.advanceTimersByTime(10000)
    await expect(Count.actions.fetchUnreadMessagesCount).toHaveBeenCalledTimes(3)
  })
})