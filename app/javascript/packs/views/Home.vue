<template>
  <div id="home">
    <h1>Home</h1>
    <p>{{ getCurrentUser.name }}</p>
  </div>
</template>

<script>
import { logInGuard } from '../navigation-guards'
import { mapGetters } from 'vuex'
export default {
  name: 'Home',
  computed: mapGetters('CurrentUser', ['getIsLoggedIn', 'getCurrentUser']),
  beforeRouteEnter: logInGuard
}
</script>