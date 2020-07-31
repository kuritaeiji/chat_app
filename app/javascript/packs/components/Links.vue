<template>
  <b-row no-gutters id="links">
    <b-col class="link">
      <router-link to="/" tag="div" active-class="current" class="text-center p-3" exact>
        フレンド <span v-if="getUsersCountApplyingForFriends !== 0">{{ getUsersCountApplyingForFriends}}</span>
      </router-link>
    </b-col>
    <b-col class="link">
      <router-link to="/groups" tag="div" active-class="current" class="text-center p-3">
        トーク <span v-if="getUnreadMessagesCount !== 0">{{ getUnreadMessagesCount }}</span>
      </router-link>
    </b-col>
    <b-col class="link">
      <router-link to="/settings" tag="div" active-class="current" class="text-center p-3">
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
    ...mapGetters('Count', ['getUsersCountApplyingForFriends', 'getUnreadMessagesCount']),
    ...mapGetters('CurrentUser', ['getCurrentUser'])
  },
  methods: {
    ...mapActions('Count', ['fetchUsersCountApplyingForFriends', 'fetchUnreadMessagesCount']),
    getCookie() {
      return document.cookie.split('; ').find((cookie) => cookie.startsWith('user_id')).split('=')[1]
    }
  },
  created() {
    let that = this
    this.timer = setInterval(() => {
      that.fetchUnreadMessagesCount()
    }, 5000)
  },
  beforeDestroy() {
    clearInterval(this.timer)
  },
  mounted() {
    this.fetchUsersCountApplyingForFriends(this.getCookie())
    this.fetchUnreadMessagesCount()
  }
}
</script>

<style scoped>
#links {
  border-bottom: 1px solid #e6ecf0;
}

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