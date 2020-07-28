<template>
  <div id="groups-new">
    <b-container fluid class="p-0">
      <Links></Links>
    </b-container>

    <b-container>
      <h2 class="my-4">グループの作成</h2>
      <ValidationObserver ref="observer">
        <form @submit.prevent="createGroup">
          <Error :errorMessages="errorMessages"></Error>
          <ValidationProvider rules="required|max: 20" v-slot="{ errors }" name="グループ名">
            <b-form-group label="グループ名" label-for="name" label-cols-md="3">
              <b-form-input id="name" v-model="group.name"></b-form-input>
              <p v-show="errors[0]">{{ errors[0] }}</p>
            </b-form-group>
          </ValidationProvider>

          <ValidationProvider rules="image" v-slot="{ errors }" name="アイコン画像" class="mb-3">
            <b-form-group label="プロフィール画像" label-for="avatar" label-cols-md="3">
              <b-form-file id="avatar" @change="onChange"></b-form-file>
              <p v-show="errors[0]">{{ errors[0] }}</p>
            </b-form-group>
          </ValidationProvider>

          <b-row v-for="(friend, index) in friends" :key="index" class="justify-content-center no-gutters user">
            <b-col md="3" class="underline no-gutters py-2">
              <img v-if="friend.avatar" :src="friend.avatar" :alt="friend.name">
              <img v-else :src="defaultAvatar" width="100px" height="100px">
            </b-col>
            <b-col md="5" class="text-center name underline py-2">
              {{ friend.name }}
            </b-col>
            <b-col md="2" class="underline text-center name">
              <b-button variant="primary" v-show="!friendIsAdded(friend)" @click="addFriendToGroup(friend)">追加</b-button>
              <b-button variant="danger" v-show="friendIsAdded(friend)" @click="deleteFriendFromGroup(friend)">削除</b-button>
            </b-col>
          </b-row>

          <div class="text-center my-3">
            <b-button variant="primary" size="lg" type="submit">作成</b-button>
          </div>
        </form>
      </ValidationObserver>
    </b-container>
  </div>
</template>

<script>
import Links from '../components/Links.vue'
import { mapGetters } from 'vuex'
import { client } from '../plugins/client'
import defaultAvatar from '../images/default.jpg'
import Error from '../components/Error.vue'

export default {
  name: 'GroupsNew',
  components: {
    Links, Error
  },
  data() {
    return {
      group: {
        name: '',
        avatar: '',
        user_ids: []
      },
      friends: [],
      defaultAvatar: defaultAvatar,
      errorMessages: []
    }
  },
  computed: {
    ...mapGetters('CurrentUser', ['getCurrentUser']),
  },
  methods: {
    onChange() {
      let file = event.target.files[0]
      let fileReader = new FileReader()
      fileReader.readAsDataURL(file)
      fileReader.onload = () => {
        this.group.avatar = event.target.result
      }
    },
    async fetchFriends() {
      try {
        const response = await client.get(`/api/users/${this.getCurrentUser.id}/friendships`)
        if (Array.isArray(response.data)) {
          response.data.forEach((friend) => {
            this.friends.push(friend)
          })
        }
      } catch (error) {
        console.log(error)
      }
    },
    friendIsAdded(friend) {
      if (this.group.user_ids.some((user_id) => user_id == friend.id)) {
        return true
      } else {
        return false
      }
    },
    addFriendToGroup(friend) {
      this.group.user_ids.push(friend.id)
    },
    deleteFriendFromGroup(friend) {
      this.group.user_ids = this.group.user_ids.filter((userId) => userId != friend.id)
    },
    async createGroup() {
      try {
        let valid = await this.$refs.observer.validate()
        // 三人以上メンバーを選ばなければならない
        if (valid && this.group.user_ids.length >= 3) {
          const response = await client.post('/api/groups.json', { group: this.group })
          if (response.data.group_id) {
            this.$toasted.show("グループを作成しました。", { 
              theme: "bubble", 
              position: "top-right", 
              duration : 5000
            })
            this.$router.push(`/groups/${response.data.group_id}`)
          } else {
            this.errorMessages = []
            response.data.errorMessages.forEach((error) => {
              this.errorMessages.push(error.message)
            })
          }
        } else {
          this.errorMessages = []
          this.errorMessages.push('二人以上のグループメンバーを選んでください')
        }
      } catch (error) {
        console.log(error)
      }
    }
  },
  async mounted() {
    this.fetchFriends()
    this.group.user_ids.push(this.getCurrentUser.id)
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
</style>