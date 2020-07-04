<template>
  <div id="error">
    <div class="alert alert-danger" v-if="errorMessages.length">
      <ul class="list-unstyled">
        <li v-for="(message, index) in errorMessages" :key="index">
          {{ index + 1 }}： {{ message }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Error',
  props: {
    errorMessages: Array
  }
}
</script>