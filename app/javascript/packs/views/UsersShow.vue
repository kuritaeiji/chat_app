<template>
  <div id="users-show">
    <b-container fluid class="p-0">
      <Links></Links>
    </b-container>

    <b-container>
      <h2 class="my-4">プロフィール</h2>
      <b-row>
        <b-col md="3" class="p-4">
          <img v-if="getCurrentUser.avatar" :src="getCurrentUser.avatar" class="img-fluid">
          <img v-else :src="defaultAvatar" class="img-fluid">
        </b-col>
        <b-col md="9">
          <table class="table table-hover">
            <tbody>
              <tr>
                <th>名前</th>
                <td>{{ this.getCurrentUser.name }}</td>
              </tr>
              <tr>
                <th>自己紹介</th>
                <td>{{ this.getCurrentUser.description }}</td>
              </tr>
              <tr>
                <th>ユーザーID</th>
                <td>{{ this.getCurrentUser.identifier_id }}</td>
              </tr>
            </tbody>
          </table>
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Links from '../components/Links.vue'
import defaultAvatar from '../images/default.jpg'

export default {
  name: 'UsersShow',
  computed: mapGetters('CurrentUser', ['getCurrentUser']),
  components: {
    Links
  },
  data() {
    return {
      defaultAvatar: defaultAvatar
    }
  }
}
</script>