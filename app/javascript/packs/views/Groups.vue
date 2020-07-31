<template>
  <div id="groups">
    <b-container fluid class="p-0">
      <Links></Links>

      <b-row class="no-gutters">
        <b-col cols="6" sm="3" class="p-3 groups">
          <div v-for="(group, index) in groups" :key="index" class="d-flex flex-row py-2 group" :id="group.name" @click="readMessages(group, index)">
            <div class="image-column">
              <img v-if="group.avatar" :src="group.avatar" class="img-fluid">
              <img v-else :src="defaultAvatar" class="img-fluid">
            </div>
            <div class="px-3 group-name">{{ group.name | trim(10) }}<span class="pl-2"><b-badge variant="success" v-if="group.unread_messages_count_by_group != 0">{{ group.unread_messages_count_by_group }}</b-badge></span></div>
          </div>
        </b-col>

        <b-col cols="6" sm="9">
          <router-view />
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
import Links from '../components/Links.vue'
import { client } from '../plugins/client'
import defaultAvatar from '../images/default.jpg'
import { mapActions } from 'vuex'

export default {
  name: 'Groups',
  components: {
    Links
  },
  data() {
    return {
      groups: [],
      defaultAvatar: defaultAvatar
    }
  },
  mounted() {
    this.fetchGroups()
    let that = this
    this.timer = setInterval(() => {
      that.fetchGroups()
    }, 5000)
  },
  methods: {
    ...mapActions('Count', ['updateUnreadMessagesCount']),
    async fetchGroups() {
      try {
        const response = await client.get('/api/groups')
        if (Array.isArray(response.data)) {
          this.groups = []
          response.data.forEach((group) => {
            this.groups.push(group)
          })
        } else {
          console.log(response.data.message)
        }
      } catch (error) {
        console.log(error)
      }
    },
    readMessages(group, index) {
      if (group.unread_messages_count_by_group != 0) {
        this.updateUnreadMessagesCount(group.unread_messages_count_by_group)
        group.unread_messages_count_by_group = 0
        this.groups.splice(index, 1, group)
      }
      this.$router.push(`/groups/${group.id}`)
    }
  },
  beforeDestroy() {
    clearInterval(this.timer)
  }
}
</script>

<style scoped>
.image-column {
  width: 75px;
  height: 75px;
}

.group-name {
  line-height: 75px;
  white-space: nowrap;
}

.group:hover {
  background-color: #f5f8fa;
  cursor: pointer;
}

.group {
  border-bottom: 1px solid #e6ecf0;
  font-size: 25px;
  font-weight: bold;
}

.groups {
  border-right: 1px solid #e6ecf0;
  height: calc(100vh - 66px);
  overflow: scroll;
}
</style>