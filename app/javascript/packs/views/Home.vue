<template>
  <div id="home">
    <h1>Home</h1>
    <p>{{ getCurrentUser.name }}</p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  name: 'Home',
  computed: mapGetters('CurrentUser', ['getIsLoggedIn', 'getCurrentUser']),
  created() {
    let cookies = document.cookie
    console.log(cookies)
    console.log(cookies.match('user_id'))
  }
}
</script>