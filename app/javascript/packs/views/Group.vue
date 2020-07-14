<template>
  <div id="group">
    <div class="d-flex justify-content-between p-3 underline">
      <div class="font-weight-bold group-name">{{ group.name }}</div>
      <router-link tag="div" to="/settings/groups/edit">
        <font-awesome-icon icon="cog" size="3x" class="cog" />
      </router-link>
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