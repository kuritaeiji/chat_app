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
  </div>
</template>

<script>
import { client } from '../plugins/client'

export default {
  name: 'Group',
  props: {
    groupId: String
  },
  data() {
    return {
      group: {}
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
    }
  },
  mounted() {
    this.fetchGroup()
  },
  watch: {
    '$route': 'fetchGroup'
  }
}
</script>

<style scoped>
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
</style>