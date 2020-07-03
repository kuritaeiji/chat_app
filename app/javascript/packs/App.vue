<template>
  <div id="app">
    <b-container>
      <router-link to="/users/new">登録</router-link>
    </b-container>
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>