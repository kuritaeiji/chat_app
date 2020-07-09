<template>
  <div id="home">
    <h1>Home</h1>
    <p>{{ getCurrentUser.name }}</p>
    <img :src="defaultAvatar">
    <img :src="getCurrentUser.avatar">
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { client } from '../plugins/client'
import defaultAvatar from '../images/default.jpg'

export default {
  name: 'Home',
  data() {
    return {
      defaultAvatar: defaultAvatar
    }
  },
  computed: mapGetters('CurrentUser', ['getIsLoggedIn', 'getCurrentUser']),
  mounted() {
    this.fetchCurrentUser()
  },
  created() {
    this.getCurrentUser
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