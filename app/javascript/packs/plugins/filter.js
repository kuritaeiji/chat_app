import Vue from 'vue'

Vue.filter('trim', (value, length) => {
  if (typeof value !== 'string') {
    return value
  }
  return value.slice(0, length)
})