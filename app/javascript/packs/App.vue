<template>
  <div id="app">
    <b-container>
      <div v-if="getIsLoggedIn">
        <a @click="signOut">ログアウト</a>
      </div>
      <div v-else>
        <router-link to="/users/new">登録</router-link>
        <router-link to="/login">ログイン</router-link>
      </div>
    </b-container>
    <router-view />
  </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'
import { client } from './plugins/client'
export default {
  name: 'App',
  computed: mapGetters('CurrentUser', ['getIsLoggedIn', 'getCurrentUser']),
  methods: {
    ...mapMutations('CurrentUser', ['logOut']),
    async signOut() {
      try {
        const response = await client.delete(`/api/cookies/${this.getCurrentUser.id}.json`)
        if (response.data.message == 'success') {
          this.logOut()
          console.log(this.getCurrentUser)
          this.$router.push('/login')
        }
      } catch (error) {
        console.log(error)
      }
    }
  }
}
</script>