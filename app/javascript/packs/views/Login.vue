<template>
  <b-container id="Login" class="my-3">
    <h2 class="text-center">ログイン<span class="test-user">（既にテストユーザーのログイン情報が入力されています）</span></h2>
    <ValidationObserver ref="observer">
      <form @submit.prevent="login">
        <Error :errorMessages="errorMessages"></Error>

        <ValidationProvider rules="required|email" v-slot="{ errors }" name="メールアドレス">
          <b-form-group label="メールアドレス" label-for="email" label-cols-md="3">
            <b-form-input type="email" id="email" v-model="cookie.email"></b-form-input>
            <p v-show="errors[0]">{{ errors[0] }}</p>
          </b-form-group>
          
        </ValidationProvider>
        
        <ValidationProvider rules="required|min: 6" v-slot="{ errors }" name="パスワード">
          <b-form-group label="パスワード" label-for="password" label-cols-md="3">
            <b-form-input type="password" id="password" v-model="cookie.password"></b-form-input>
            <p v-show="errors[0]">{{ errors[0] }}</p>
          </b-form-group>
        </ValidationProvider>

        <div class="d-flex justify-content-center">
          <b-button type="submit" variant="primary">ログイン</b-button>
          <router-link to="/users/new" class="pl-3">新規登録</router-link>
        </div>
      </form>
    </ValidationObserver>
  </b-container>
</template>

<script>
import { client } from '../plugins/client.js'
import Error from '../components/Error.vue'
import { mapActions, mapGetters } from 'vuex'

export default({
  name: 'Login',
  components: {
    Error
  },
  data() {
    return {
      cookie: {
        email: 'example@example.com',
        password: 'example'
      },
      errorMessages: []
    }
  },
  methods: {
    ...mapActions('CurrentUser', ['logIn']),
    async login() {
      let valid = await this.$refs.observer.validate()
      if (valid) {
        const response = await client.post('/api/cookies.json', { cookie: this.cookie })
        if (response.data.message == 'success') {
          this.$router.push('/')
        } else {
          this.errorMessages.push(response.data.error_message)
        }
      } 
    }
  }
})
</script>

<style scoped>
.test-user {
  font-size: 16px;
  font-weight: normal;
}
</style>