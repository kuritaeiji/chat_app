<template>
  <div id="groups">
    <b-container fluid class="p-0">
      <Links></Links>

      <b-row class="no-gutters">
        <b-col cols="6" sm="3" class="p-3 groups">
          <div v-for="(group, index) in groups" :key="index" class="d-flex flex-row py-2 group" @click="redirectToGroup(group.id)" :id="group.name">
            <div class="image-column">
              <img v-if="group.avatar" :src="group.avatar" class="img-fluid">
              <img v-else :src="defaultAvatar" class="img-fluid">
            </div>
            <div class="px-3 group-name">{{ group.name | trim(12) }}</div>
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
  },
  methods: {
    async fetchGroups() {
      try {
        const response = await client.get('/api/groups')
        if (Array.isArray(response.data)) {
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
    redirectToGroup(group_id) {
      this.$router.push(`/groups/${group_id}`)
    }
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
}
</style>