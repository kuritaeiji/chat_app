<template>
  <div id="app">
    <b-button variant="primary">{{ message }}</b-button>
  </div>
</template>

<script>
export default {
  name: 'app',
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
