<template>
  <div id="group">
    <div class="d-flex justify-content-between p-3 underline">
      <div class="font-weight-bold group-name">{{ group.name }}</div>
      <div class="dropdown dropleft">
        <font-awesome-icon icon="cog" size="3x" class="cog dropdown-toggle" data-toggle="dropdown" />
        <div class="dropdown-menu" aria-labelledby="dropdown1">
          <router-link tag="a" class="dropdown-item" :to="`/settings/groups/edit/${groupId}`">グループの編集</router-link>
          <div id="delete-button" class="dropdown-item" @click="deleteGroup">グループの削除</div>
        </div>
      </div>
    </div>

    <div v-if="messagesAndUsers.length > 0" class="p-3 messages">
      <div v-for="(messageAndUser, index) in messagesAndUsers" :key="index">
        <div v-if="index == 0 && olderMessagesPresent" @click="fetchOlderMessagesAndUsers" class="w-100 py-3 text-center message more-show">
          さらに表示
        </div>

        <div class="d-flex justify-content-start w-100 p-3 message" id="content" v-if="messageAndUser.message.content">
          <div>
            <img :src="messageAndUser.user.avatar" v-if="messageAndUser.user.avatar">
            <img :src="defaultAvatar" v-else width="50px" height="50px">
          </div>
          <div class="pl-2">
            <div class="name">
              {{ messageAndUser.user.name }} <span class="created-at">{{ messageAndUser.message.created_at }}</span>
            </div>
            <div class="content">
              {{ messageAndUser.message.content }}
            </div>
          </div>
        </div>

        <div class="d-flex justify-content-start w-100 p-3 message" id="avatar" v-if="messageAndUser.message.avatar">
          <div>
            <img :src="messageAndUser.user.avatar" v-if="messageAndUser.user.avatar">
            <img :src="defaultAvatar" v-else width="50px" height="50px">
          </div>
          <div class="pl-2">
            <div class="name">
              {{ messageAndUser.user.name }} <span class="created-at">{{ messageAndUser.message.created_at }}</span>
            </div>
            <div class="avatar">
              <img :src="messageAndUser.message.avatar" class="message-avatar">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="message-form p-3">
      <ValidationObserver ref="observer">
        <form class="row" @submit.prevent="createMessage">
          <b-col md="7">
            <ValidationProvider rules="max:200">
              <input type="text" v-model="message.content" placeholder="メッセージ（200文字迄）" class="form-control">
            </ValidationProvider>
          </b-col>
          <b-col md="1">
            <label>
              <ValidationProvider rules="image">
                <input type="file" class="d-none" @change="onChange">
              </ValidationProvider>
              <font-awesome-icon icon="image" size="2x"></font-awesome-icon>
            </label>
          </b-col>
          <b-col md="1">
            <b-button type="submit" variant="primary">送信</b-button>
          </b-col>
        </form>
      </ValidationObserver>
    </div>
  </div>
</template>

<script>
import { client } from '../plugins/client'
import defaultAvatar from '../images/default.jpg'

export default {
  name: 'Group',
  props: {
    groupId: String
  },
  data() {
    return {
      group: {},
      message: {
        avatar: null,
        content: ''
      },
      messagesAndUsers: [],
      lastMessagesId: 0,
      firstMessageId: 0,
      olderMessagesPresent: false,
      defaultAvatar: defaultAvatar
    }
  },
  methods: {
    async fetchGroup() {
      try {
        const response = await client.get(`/api/groups/${this.groupId}`)
        this.group = Object.assign({}, this.group, response.data.group)
      } catch (error) {
        console.log(error)
      }
    },
    async fetchMessagesAndUsers() {
      try {
        const response = await client.get(`/api/groups/${this.groupId}/messages`)
        if (Array.isArray(response.data)) {
          response.data.forEach((messageAndUser) => {
            this.messagesAndUsers.push(messageAndUser)
          })
          this.lastMessageId = this.messagesAndUsers[this.messagesAndUsers.length - 1].message.id
          this.firstMessageId = this.messagesAndUsers[0].message.id
          this.olderMessagesPresent = this.messagesAndUsers[0].older_messages_present
        }
      } catch (error) {
        console.log(error)
      }
    },
    async fetchNewMessagesAndUsers() {
      try {
        const response = await client.get(`/api/groups/${this.groupId}/messages/return_new_messages`, { params: { last_message_id: this.lastMessageId } })
        if (Array.isArray(response.data)) {
          response.data.forEach((messageAndUser) => {
            this.messagesAndUsers.push(messageAndUser)
          })
          this.last_message_id = this.messagesAndUsers[this.messagesAndUsers.length - 1].message.id
        }
      } catch (error) {
        console.log(error)
      }
    },
    async fetchOlderMessagesAndUsers() {
      try {
        const response = await client.get(`/api/groups/${this.groupId}/messages/return_older_messages`, { params: { first_message_id: this.firstMessageId } })
        if (Array.isArray(response.data)) {
          this.messagesAndUsers = response.data.concat(this.messagesAndUsers)
          this.firstMessageId = this.messagesAndUsers[0].message.id
          this.olderMessagesPresent = this.messagesAndUsers[0].older_messages_present
        }
      } catch (error) {
        console.log(error)
      }
    },
    async deleteGroup() {
      try {
        const response = await client.delete(`/api/groups/${this.groupId}`)
        this.$toasted.show('グループを削除しました。', {
          theme: "bubble", 
          position: "top-right", 
          duration : 5000
        })
        this.$router.push('/')
      } catch (error) {
        console.log(error)
      }
    },
    onChange() {
      let file = event.target.files[0]
      let fileReader = new FileReader()
      fileReader.readAsDataURL(file)
      fileReader.onload = () => {
        this.message.avatar = event.target.result
      }
    },
    async createMessage() {
      try {
        let valid = await this.$refs.observer.validate()
        if (valid && (this.message.avatar || this.message.content)) {
          const response = await client.post(`/api/groups/${this.groupId}/messages`, { message: this.message })
          this.messagesAndUsers.push(response.data)
          this.message = Object.assign({}, { avatar: null, content: '' })
        }
      } catch (error) {
        console.log(error)
      }
    },
    resetData() {
      this.last_message_id = 0
      this.firstMessageId = 0
      this.messagesAndUsers = []
      this.olderMessagesPresent = false
      this.message = Object.assign({}, { avatar: null, content: '' })
    }
  },
  async mounted() {
    this.fetchGroup(),
    await this.fetchMessagesAndUsers()
    let that = this
    this.timer = setInterval(() => {
      that.fetchNewMessagesAndUsers()
    }, 3000)
  },
  watch: {
    '$route': ['resetData', 'fetchGroup', 'fetchMessagesAndUsers']
  },
  beforeDestroy() {
    clearInterval(this.timer)
  }
}
</script>

<style scoped>
#group {
  display: flex;
  flex-direction: column;
  min-height: calc(100vh - 66px)
}

.message-form {
  margin-top: auto;
}

.cog:hover {
  color: black;
  cursor: pointer;
}

.cog {
  color: #657786;
  line-height: 75px;
}

.group-name {
  line-height: 75px;
  height: 75px;
  font-size: 25px;
}

.underline {
  border-bottom: 1px solid #e6ecf0;
}

.messages {
  height: calc(100vh - 66px - 108px - 74px);
  overflow: scroll;
}

.message {
  border-bottom: 1px solid #e6ecf0;
}

.message:hover {
  background-color: #f5f8fa;
}

.name {
  font-weight: bold;
  font-size: 20px;
}

.created-at {
  font-weight: normal;
  font-size: 14px;
}

.content {
  font-size: 20px;
}

.message-avatar {
  max-width: 80%;
}

.more-show {
  font-weight: bold;
  font-size: 20px;
}

.more-show:hover {
  cursor: pointer;
}
</style>