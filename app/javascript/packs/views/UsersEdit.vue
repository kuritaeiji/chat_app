<template>
  <div id="users-edit">
    <b-container fluid class="p-0">
      <Links></Links>
    </b-container>
    <b-container class="my-5">
      <h2 class="mb-5">プロフィール編集</h2>
      <ValidationObserver ref="observer">
        <form @submit.prevent="updateUser">
          <Error :errorMessages="errorMessages"></Error>

          <ValidationProvider rules="required|max: 20" v-slot="{ errors }" name="名前">
            <b-form-group label="名前" label-for="name" label-cols-md="3">
              <b-form-input id="name" v-model="user.name"></b-form-input>
              <p v-show="errors[0]">{{ errors[0] }}</p>
            </b-form-group>
          </ValidationProvider>

          <ValidationProvider rules="max: 100" v-slot="{ errors }" name="自己紹介">
            <b-form-group label="自己紹介" label-for="description" label-cols-md="3">
              <b-form-textarea id="description" v-model="user.description"></b-form-textarea>
              <p v-show="errors[0]">{{ errors[0] }}</p>
            </b-form-group>
          </ValidationProvider>

          <ValidationProvider rules="image" v-slot="{ errors }" name="プロフィール画像">
            <b-form-group label="プロフィール画像" label-for="avatar" label-cols-md="3">
              <b-form-file id="avatar" @change="encodeBase64"></b-form-file>
              <p v-show="errors[0]">{{ errors[0] }}</p>
            </b-form-group>
          </ValidationProvider>

          <div class="text-center">
            <b-button type="submit" variant="primary">更新する</b-button>
          </div>
        </form>
      </ValidationObserver>
    </b-container>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Error from '../components/Error.vue'
import Links from '../components/Links.vue'
import { client } from '../plugins/client'

export default {
  name: 'UsersEdit',
  data() {
    return {
      user: {
        name: '',
        description: '',
        avatar: ''
      },
      errorMessages: []
    }
  },
  components: {
    Error, Links
  },
  computed: mapGetters('CurrentUser', ['getCurrentUser']),
  methods: {
    ...mapActions('CurrentUser', ['updateCurrentUser']),
    setUser() {
      this.user.name = this.getCurrentUser.name
      this.user.description = this.getCurrentUser.description
      this.user.avatar = this.getCurrentUser.avatar
    },
    encodeBase64() {
      let file = event.target.files[0]
      let reader = new FileReader()
      reader.readAsDataURL(file)
      reader.onload = () => {
        this.user.avatar = event.target.result
      }
    },
    // 画像は初期値と変化した場合のみ送信
    async updateUser() {
      try {
        let valid = await this.$refs.observer.validate()
        if (valid) {
          this.user.avatar = this.user.avatar == this.getCurrentUser.avatar ? null : this.user.avatar
          const response = await client.put(`/api/users/${this.getCurrentUser.id}.json`, { user: this.user })
          if (response.data.user) {
            this.updateCurrentUser(response.data.user)
            this.$toasted.show("プロフィールを更新しました。", { 
              theme: "bubble", 
              position: "top-right", 
              duration : 5000
            })
            this.$router.push('/')
          } else {
            this.errorMessages = []
            response.data.error_messages.forEach((error) => {
              this.errorMessages.push(error.message)
            })
          }
        }
      } catch (error) {
        console.log(error)
      }
    }
  },
  mounted() {
    this.setUser()
  }
}
</script>