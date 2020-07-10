<template>
  <div id="home">
    <b-container fluid class="p-0">
      <Links></Links>
    </b-container>
    <b-container>
      <div v-if="usersApplyingForFriends.length > 0">
        <b-row class="justify-content-center no-gutters">
          <b-col md="3" class="underline py-2">
            <h3>フレンド申請（{{ usersApplyingForFriends.length }}）</h3>
          </b-col>
          <b-col md="5" class="underline py-2"></b-col>
        </b-row>
        
        <b-row v-for="(user, index) in usersApplyingForFriends" :key="index" class="justify-content-center no-gutters user" @click="openUserModal(index)">
          <b-col md="3" class="underline py-2">
            <img v-if="user.avatar" :src="user.avatar" :alt="user.name">
            <img v-else :src="defaultAvatar" width="100px" height="100px" alt="default avatar">
          </b-col>
          <b-col md="5" class="text-center name underline py-2">
            {{ user.name }}
          </b-col>
        </b-row>
      </div>

      <div v-if="friends.length > 0">
        <b-row class="justify-content-center no-gutters">
          <b-col md="3" class="underline py-2">
            <h3>フレンド（{{ friends.length }}）</h3>
          </b-col>
          <b-col md="5" class="underline py-2"></b-col>
        </b-row>
        
        <b-row v-for="(friend, index) in friends" :key="index" class="justify-content-center no-gutters user">
          <b-col md="3" class="underline no-gutters py-2">
            <img v-if="friend.avatar" :src="friend.avatar" :alt="friend.name">
            <img v-else :src="defaultAvatar" width="100px" height="100px" alt="default avatar">
          </b-col>
          <b-col md="5" class="text-center name underline py-2">
            {{ friend.name }}
          </b-col>
        </b-row>
      </div>

      <div v-if="friends.length == 0 && usersApplyingForFriends.length == 0" class="mt-5">
        <h3 class="text-center">フレンドを追加しよう</h3>
      </div>
    </b-container>

    <!-- モーダル -->
    <div v-for="(user, index) in usersApplyingForFriends" :key="index">
      <Modal :showUser="showUsers[index]" @closeUserModal="closeUserModal(index)" :user="user" :defaultAvatar="defaultAvatar"></Modal>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { client } from '../plugins/client'
import defaultAvatar from '../images/default.jpg'
import Links from '../components/Links.vue'
import Modal from '../components/Modal.vue'

export default {
  name: 'Home',
  components: {
    Links, Modal
  },
  data() {
    return {
      defaultAvatar: defaultAvatar,
      usersApplyingForFriends: [],
      friends: [],
      showUsers: [],
      showFriends: []
    }
  },
  computed: { 
    ...mapGetters('CurrentUser', ['getIsLoggedIn', 'getCurrentUser'])
  },
  mounted() {
    this.fetchCurrentUser()
    this.fetchUsersApplyingForFriends()
    this.fetchFriends()
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
    },
    async fetchFriends() {
      try {
        const response = await client.get(`/api/users/${this.getCurrentUser.id}/friendships`)
        if (Array.isArray(response.data)) {
          let friends = response.data
          friends.forEach((friend) => {
            this.friends.push(friend)
            this.showFriends.push(false)
          })
        }
      } catch (error) {
        console.log(error)
      }
    },
    async fetchUsersApplyingForFriends() {
      try {
        const response = await client.get(`/api/users/${this.getCurrentUser.id}/friendships/users_applying_for_friends_to_me`)
        if (Array.isArray(response.data)) {
          let users = response.data
          users.forEach((user) => {
            this.usersApplyingForFriends.push(user)
            this.showUsers.push(false)
          })
        }
      } catch (error) {
        console.log(error)
      }
    },
    openUserModal(index) {
      this.showUsers.splice(index, 1, true)
    },
    closeUserModal(index) {
      this.showUsers.splice(index, 1, false)
    }
  }
}
</script>

<style scoped>
.name {
  line-height: 100px;
}

.underline {
  border-bottom: 1px solid #e6ecf0;
  font-size: 25px;
  font-weight: bold;
}

.user:hover {
  background-color: #f5f8fa;
  cursor: pointer;
}
</style>