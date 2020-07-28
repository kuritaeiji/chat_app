<template>
  <div id="modal" @click.self="closeModal" v-show="showModal">
    <div id="content">
      <div class="card border-0">
        <img class="card-img-top" :src="image">
        <div class="card-body">
          <h3 class="card-title font-weight-bold">{{ friend.name }}</h3>
          <p class="card-text">{{ friend.description }}</p>
          <b-button variant="primary" @click.stop="talkWithFriend" id="talk-button">トーク</b-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { client } from '../plugins/client'
import { mapGetters } from 'vuex'

export default {
  name: 'FriendModal',
  props: {
    showModal: Boolean,
    friend: Object,
    defaultAvatar: String
  },
  data() {
    return {
      image: ''
    }
  },
  computed: mapGetters('CurrentUser', ['getCurrentUser']),
  methods: {
    closeModal() {
      this.$emit('closeFriendModal')
    },
    setImage() {
      this.image = this.friend.avatar ? this.friend.avatar : this.defaultAvatar
    },
    async talkWithFriend() {
      try {
        let group = {
          name: `${this.getCurrentUser.name} ${this.friend.name}`,
          avatar: null,
          user_ids: [`${this.getCurrentUser.id}`, `${this.friend.id}`]
        }
        const response = await client.post('/api/groups.json', { group: group })
        let groupId = response.data.group_id
        this.$router.push(`/groups/${groupId}`)
      } catch (error) {
        console.log(error)
      }
    }
  },
  mounted() {
    this.setImage()
  }
}
</script>

<style scoped>
#modal {
  z-index: 1;

  position:fixed;
  top:0;
  left:0;
  width:100%;
  height:100%;
  background-color:rgba(0,0,0,0.5);

  display: flex;
  align-items: center;
  justify-content: center;

}

#content {
  z-index: 2;
  width: 30%;
  background:#fff;
}
</style>