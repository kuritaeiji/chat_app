import { createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import CurrentUser from '../../packs/store_modules/current-user'

describe('CurrentUser', () => {
  let localVue
  let store
  let user
  let updatedUser

  beforeEach(() => {
    localVue = createLocalVue()
    localVue.use(Vuex)
    
    store = new Vuex.Store({
      modules: {
        CurrentUser: CurrentUser
      }
    })

    user = {
      name: 'example',
      email: 'example@example.com',
      description: 'example',
      password: 'example',
      password_confirmation: 'example',
      identifier_id: 'example'
    }

    updatedUser = {
      name: 'example_updated',
      email: 'example@example.com',
      description: 'example',
      password: 'example',
      password_confirmation: 'example',
      identifier_id: 'example'
    }
  })

  it('dispatch logIn', () => {
    store.dispatch('CurrentUser/logIn', user)
    expect(store.state.CurrentUser.currentUser).toStrictEqual(user)
    expect(store.state.CurrentUser.isLoggedIn).toBe(true)
  })

  it('dispatch logOut', () => {
    store.dispatch('CurrentUser/logIn', user)
    expect(store.state.CurrentUser.currentUser).toStrictEqual(user)
    expect(store.state.CurrentUser.isLoggedIn).toBe(true)

    store.dispatch('CurrentUser/logOut')
    expect(store.state.CurrentUser.currentUser).toStrictEqual({})
    expect(store.state.CurrentUser.isLoggedIn).toBe(false)
  })

  it('dispatch updateCurrentUser', () => {
    store.dispatch('CurrentUser/logIn', user)
    expect(store.state.CurrentUser.currentUser).toStrictEqual(user)
    expect(store.state.CurrentUser.isLoggedIn).toBe(true)

    store.dispatch('CurrentUser/updateCurrentUser', updatedUser)
    expect(store.state.CurrentUser.currentUser).toStrictEqual(updatedUser)
  })
})