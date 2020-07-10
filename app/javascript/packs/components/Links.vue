<template>
  <b-row no-gutters id="links">
    <b-col>
      <router-link to="/" tag="div" active-class="current" class="text-center link p-3">
        フレンド <span v-if="getUsersCountApplyingForFriends !== 0">{{ getUsersCountApplyingForFriends}}</span>
      </router-link>
    </b-col>
    <b-col>
      <router-link to="/" tag="div" active-class="current" class="text-center link p-3">
        トーク
      </router-link>
    </b-col>
    <b-col>
      <router-link to="/" tag="div" active-class="current" class="text-center link p-3">
        設定
      </router-link>
    </b-col>
  </b-row>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'Link',
  computed: {
    ...mapGetters('Count', ['getUsersCountApplyingForFriends', 'getNotReadMessagesCount']),
    ...mapGetters('CurrentUser', ['getCurrentUser'])
  },
  methods: mapActions('Count', ['fetchUsersCountApplyingForFriends', 'fetchNotReadMessagesCount']),
  created() {
    let that = this
    this.timer = setInterval(() => {
      // that.fetchNotReadMessagesCount(that.currentUserId)
    }, 5000)
  },
  beforeDestroy() {
    clearInterval(this.timer)
  },
  mounted() {
    this.fetchUsersCountApplyingForFriends(this.getCurrentUser.id)
  }
}
</script>

<style scoped>
.link:hover {
  cursor: pointer;
  background-color: #e6ecf0;
}

.link {
  color: #657786;
  font-weight: bold;
  font-size: 20px;
}

.current {
  color: #1b95e0;
  border-bottom-width: 3px;
  border-bottom-color: #1da1f2;
  border-bottom-style: solid;
}
</style>