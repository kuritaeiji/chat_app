<template>
  <div id="settings">
    <b-container fluid class="p-0">
      <Links></Links>
    </b-container>
    <b-container class="mt-5">
      <b-row>
        <b-col class="d-none d-md-block" md="3"></b-col>
        <b-col class="setting p-3">
          <router-link to="/settings/users/search" tag="div">ユーザー検索</router-link>
        </b-col>
        <b-col class="d-none d-md-block" md="3"></b-col>
      </b-row>
      <b-row>
        <b-col class="d-none d-md-block" md="3"></b-col>
        <b-col class="setting p-3">
          <router-link to="/settings/users/edit" tag="div">プロフィール編集</router-link>
        </b-col>
        <b-col class="d-none d-md-block" md="3"></b-col>
      </b-row>
      <b-row>
        <b-col class="d-none d-md-block" md="3"></b-col>
        <b-col class="setting p-3">
          <router-link to="/settings/users/show" tag="div">プロフィール</router-link>
        </b-col>
        <b-col class="d-none d-md-block" md="3"></b-col>
      </b-row>
      <b-row>
        <b-col class="d-none d-md-block" md="3"></b-col>
        <b-col @click="signOut" class="setting p-3" id="log-out">ログアウト</b-col>
        <b-col class="d-none d-md-block" md="3"></b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { client } from '../plugins/client'
import Links from '../components/Links.vue'

export default {
  name: 'Settings',
  components: {
    Links
  },
  computed: mapGetters('CurrentUser', ['getCurrentUser']),
  methods: {
    ...mapActions('CurrentUser', ['logOut']),
    async signOut() {
      try {
        const response = await client.delete(`/api/cookies/${this.getCurrentUser.id}`)
        if (response.data.message == 'success') {
          this.logOut()
          this.$router.push('/login')
        }
      } catch (error) {
        coneole.log(error)
      }
    }
  }
}
</script>

<style scoped>
.setting {
  border-bottom: 1px solid #e6ecf0;
  font-size: 25px;
  font-weight: bold;
  color: #14141a;
}

.setting:hover {
  cursor: pointer;
  background-color: #e6ecf0;
}
</style>