<template>
  <div id="app">
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