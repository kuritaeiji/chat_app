<template>
  <div id="app">
    <b-container>
      <div v-if="!getIsLoggedIn">
        <router-link to="/users/new">登録</router-link>
        <router-link to="/login">ログイン</router-link>
      </div>
    </b-container>
    <router-view />
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { client } from './plugins/client'
export default {
  name: 'App',
  computed: mapGetters('CurrentUser', ['getIsLoggedIn', 'getCurrentUser'])
}

</script>