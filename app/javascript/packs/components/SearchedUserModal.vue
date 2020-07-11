<template>
  <div id="modal" @click.self="closeModal" v-show="showModal">
    <div id="content">
      <div class="card border-0">
        <img class="card-img-top" :src="image">
        <div class="card-body">
          <h3 class="card-title font-weight-bold">{{ user.name }}</h3>
          <p class="card-text">{{ user.description }}</p>
          <b-button variant="primary" @click.stop="applyForFriend" id="apply-button">フレンド申請</b-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { client } from '../plugins/client'
import { mapGetters } from 'vuex'

export default {
  name: 'Modal',
  props: {
    showModal: Boolean,
    user: Object,
    defaultAvatar: String,
  },
  data() {
    return {
      image: ''
    }
  },
  computed: mapGetters('CurrentUser', ['getCurrentUser']),
  methods: {
    closeModal() {
      this.$emit('closeModal')
    },
    setImage() {
      this.image = this.user.avatar ? this.user.avatar : this.defaultAvatar
    },
    async applyForFriend() {
      try {
        const response = await client.post(`/api/users/${this.getCurrentUser.id}/friendships.json`, { requested_user_id: this.user.id })
        if (response.data.message == 'success') {
          this.$toasted.show('フレンド申請しました。', {
            theme: "bubble", 
            position: "top-right", 
            duration : 5000
          })
          this.$router.push('/')
        }
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