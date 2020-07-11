<template>
  <div id="users-search">
    <b-container fluid class="p-0">
      <Links></Links>
    </b-container>

    <b-container class="my-5">
      <h2 class="mb-5">ユーザー検索</h2>

      <form @submit.prevent="searchUser" class="mb-5">
        <Error :errorMessages="errorMessages"></Error>
        <ValidationProvider ref="provider" rules="required|max: 20|alpha_num" v-slot="{ errors }" name="ユーザーID">
          <div class="input-group">
            <input type="text" class="form-control" placeholder="ユーザーID" v-model="identifierId">
            <p v-show="errors[0]">{{ errors[0] }}</p>
            <div class="input-group-append">
              <b-button type="submit" variant="primary">検索</b-button>
            </div>
          </div>
        </ValidationProvider>
      </form>

      <b-row class="justify-content-center no-gutters user" v-if="searchedUser.name" @click="openModal" id="open-button">
        <b-col md="3" class="underline no-gutters py-2">
          <img v-if="searchedUser.avatar" :src="searchedUser.avatar">
          <img v-else :src="defaultAvatar" width="100px" height="100px">
        </b-col>
        <b-col md="5" class="text-center name underline py-2">
          {{ searchedUser.name }}
        </b-col>
      </b-row>
    </b-container>

    <SearchedUserModal :showModal="showModal" :user="searchedUser" :defaultAvatar="defaultAvatar" @closeModal="closeModal"></SearchedUserModal>
  </div>
</template>

<script>
import Links from '../components/Links.vue'
import Error from '../components/Error.vue'
import SearchedUserModal from '../components/SearchedUserModal.vue'
import { client } from '../plugins/client'
import defaultAvatar from '../images/default.jpg'

export default {
  name: 'UsersSearch',
  components: {
    Links, Error, SearchedUserModal
  },
  data() {
    return {
      identifierId: '',
      searchedUser: {},
      errorMessages: [],
      defaultAvatar: defaultAvatar,
      showModal: false
    }
  },
  methods: {
    async searchUser() {
      try {
        let valid = await this.$refs.provider.validate()
        if (valid) {
          const response = await client.get(`/api/users/search.json`, { params: { identifier_id: this.identifierId } })
          if (response.data.user) {
            this.errorMessages = []
            Object.assign(this.searchedUser, response.data.user)
          } else {
            Object.assign(this.searchedUser, {})
            this.errorMessages = []
            this.errorMessages.push(response.data.message)
          }
        }
      } catch (error) {
        console.log(error)
      }
    },
    openModal() {
      this.showModal = true
    },
    closeModal() {
      this.showModal = false
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