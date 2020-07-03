<template>
  <b-container id="users-new">
    <h2 class="text-center">新規登録</h2>
    <form @submit.prevent="createUser">
      <b-form-group label="名前" label-for="name" label-cols-md="3">
        <b-form-input id="name" v-model="user.name"></b-form-input>
      </b-form-group>

      <b-form-group label="ユーザーID" label-for="identifier_id" label-cols-md="3">
        <b-form-input id="identifier_id" v-model="user.identifier_id"></b-form-input>
      </b-form-group>

      <b-form-group label="メールアドレス" label-for="email" label-cols-md="3">
        <b-form-input id="email type-email" v-model="user.email"></b-form-input>
      </b-form-group>

      <b-form-group label="パスワード" label-for="password" label-cols-md="3">
        <b-form-input id="password type-password" v-model="user.password"></b-form-input>
      </b-form-group>

      <b-form-group label="パスワード（確認）" label-for="password" label-cols-md="3">
        <b-form-input id="password type-password" v-model="user.password_confirmation"></b-form-input>
      </b-form-group>

      <b-form-group label="プロフィール画像" label-for="avatar" label-cols-md="3">
        <b-form-file id="avatar" ref="upfile" @change="onChange"></b-form-file>
      </b-form-group>
      
      <div class="text-center">
        <b-button type="submit" variant="primary">登録</b-button>
      </div>
    </form>
  </b-container>
</template>

<script>
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
        avatar: new FormData()
      }
    }
  },
  methods: {
    onChange() {
      let fl = this.$refs.upfile.files[0]
      this.avatar.append('upfile', fl, fl.name)
    },
    createUser() {
      
    }
  }
}
</script>