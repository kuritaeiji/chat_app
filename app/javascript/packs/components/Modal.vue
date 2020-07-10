<template>
  <div id="modal" @click.self="closeUserModal" v-show="showUser">
    <div id="content">
      <div class="card border-0">
        <img class="card-img-top" :src="image">
        <div class="card-body">
          <h3 class="card-title font-weight-bold">{{ user.name }}</h3>
          <p class="card-text">{{ user.description }}</p>
          <b-button variant="primary" @click.stop="approve" id="approve-button">承認</b-button>
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
    showUser: Boolean,
    user: Object,
    defaultAvatar: String
  },
  data() {
    return {
      image: ''
    }
  },
  computed: mapGetters('CurrentUser', ['getCurrentUser']),
  methods: {
    closeUserModal() {
      this.$emit('closeUserModal')
    },
    setImage() {
      this.image = this.user.avatar ? this.user.avatar : this.defaultAvatar
    },
    async approve() {
      try {
        const response = await client.put(`/api/users/${this.getCurrentUser.id}/friendships/approve.json`, { requesting_user_id: this.user.id })
        console.log('approveした')
        this.$toasted.show('フレンド承認しました。', {
          theme: "bubble", 
          position: "top-right", 
          duration : 5000
        })
        this.$router.go({ path: this.$router.currentRoute.path, force: true })
      } catch (error) {
        console.log(error)
      }
    }
  },
  mounted() {
    this.setImage()
    console.log(this.getCurrentUser.id)
    console.log(this.user.id)
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