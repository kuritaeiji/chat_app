<template>
  <div id="home">
    <h1>Home</h1>
    <p>{{ getCurrentUser.name }}</p>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { client } from '../plugins/client'
export default {
  name: 'Home',
  computed: mapGetters('CurrentUser', ['getIsLoggedIn', 'getCurrentUser']),
  mounted() {
    this.fetchCurrentUser()
  },
  methods: {
    ...mapActions('CurrentUser', ['logIn']),
    async fetchCurrentUser() {
      if (!this.getIsLoggedIn) {
        try {
          const response = await client.get(`/api/users/${this.getCookie()}`)
          this.logIn(response.data.user)
        } catch (error) {
          console.log(error)
        }
      }
    },
    getCookie() {
      return document.cookie.split(';').find((cookie) => cookie.startsWith('user_id')).split('=')[1]
    }
  }
}
</script>