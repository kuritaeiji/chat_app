const VueAxiosPlugin = {}
export default VueAxiosPlugin.install = function(Vue, { axios }) {
  const csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  axios.defaults.headers.common = {
    "X-Requested-With": "XMLHttpRequest",
    "X-CSRF-Token": csrf_token
  }
  Vue.prototype.$axios = axios
}