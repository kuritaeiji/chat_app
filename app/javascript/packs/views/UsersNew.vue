<template>
  <b-container id="users-new" class="my-3">
    <h2 class="text-center">新規登録</h2>

    <ValidationObserver ref="observer">
      <form @submit.prevent="createUser">
        <div class="alert alert-danger" v-if="errorMessages.length">
          <ul class="list-unstyled">
            <li v-for="(message, index) in errorMessages" :key="index">
              {{ index + 1 }}： {{ message }}
            </li>
          </ul>
        </div>

        <ValidationProvider rules="required|max: 20" v-slot="{ errors }" name="名前">
          <b-form-group label="名前" label-for="name" label-cols-md="3">
            <b-form-input id="name" v-model="user.name"></b-form-input>
            <p v-show="errors[0]">{{ errors[0] }}</p>
          </b-form-group>
        </ValidationProvider>

        <ValidationProvider rules="required|max: 20|alpha_num" v-slot="{ errors }" name="ユーザーID">
          <b-form-group label="ユーザーID" label-for="identifier_id" label-cols-md="3">
            <b-form-input id="identifier_id" v-model="user.identifier_id"></b-form-input>
            <p v-show="errors[0]">{{ errors[0] }}</p>
          </b-form-group>
        </ValidationProvider>

        <ValidationProvider rules="max: 100" v-slot="{ errors }" name="自己紹介">
          <b-form-group label="自己紹介" label-for="description" label-cols-md="3">
            <b-form-textarea id="description" v-model="user.description"></b-form-textarea>
            <p v-show="errors[0]">{{ errors[0] }}</p>
          </b-form-group>
        </ValidationProvider>

        <ValidationProvider rules="required|email" v-slot="{ errors }" name="メールアドレス">
          <b-form-group label="メールアドレス" label-for="email" label-cols-md="3">
            <b-form-input id="email" type="email" v-model="user.email"></b-form-input>
          </b-form-group>
          <p v-show="errors[0]">{{ errors[0] }}</p>
        </ValidationProvider>
        
        <ValidationProvider rules="required|min: 6" v-slot="{ errors }" name="パスワード">
          <b-form-group label="パスワード" label-for="password" label-cols-md="3">
            <b-form-input id="password" type="password" v-model="user.password"></b-form-input>
            <p v-show="errors[0]">{{ errors[0] }}</p>
          </b-form-group>
        </ValidationProvider>

        <ValidationProvider rules="required|min: 6" v-slot="{ errors }" name="パスワード（確認）">
          <b-form-group label="パスワード（確認）" label-for="password_confirmation" label-cols-md="3">
            <b-form-input id="password_confirmation" type="password" v-model="user.password_confirmation"></b-form-input>
            <p v-show="errors[0]">{{ errors[0] }}</p>
          </b-form-group>
        </ValidationProvider>
        
        <b-form-group label="プロフィール画像" label-for="avatar" label-cols-md="3">
          <b-form-file id="avatar" @change="onChange"></b-form-file>
        </b-form-group>
        
        <div class="text-center">
          <b-button type="submit" variant="primary">登録</b-button>
        </div>
      </form>
    </ValidationObserver>
  </b-container>
</template>

<script>
import { client } from '../plugins/client.js'

export default {
  name: 'UsersNew',
  data() {
    return {
      user: {
        name: '',
        identifier_id: '',
        email: '',
        password: '',
        password_confirmation: '',
        description: '',
        avatar: ''
      },
      errorMessages: [],
      image: ''
    }
  },
  methods: {
    onChange() {
      // base64エンコードする
      let file = event.target.files[0] || event.dataTransfer.files
      let reader = new FileReader()
      reader.readAsDataURL(file) //reader.readAsDataURL(file)の処理が終わったらreader.onloadが発火
      reader.onload = () => {
        this.image = event.target.result
        this.user.avatar = this.image
      }
    },
    async createUser() {
      try {
        let valid = await this.$refs.observer.validate()
        if (valid) {
          const response = await client.post('/api/users.json', { user: this.user })
          if (response.data.message && response.data.message == 'success') {
            this.$toasted.show("アカウウント有効化メールを送信しました。", { 
              theme: "bubble", 
              position: "top-right", 
              duration : 5000
            })
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
  }
}
</script>