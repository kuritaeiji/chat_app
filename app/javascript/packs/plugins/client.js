import axios from 'axios'
export const client = axios.create()
if (document.querySelector('meta[name="csrf-token"]')) {
  const csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  client.defaults.headers.common = {
    "X-Requested-With": "XMLHttpRequest",
    "X-CSRF-Token": csrf_token
  }
}