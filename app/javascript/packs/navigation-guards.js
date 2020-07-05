let logInGuarad = (to, from, next) => {
  if (this.isLoggedIn) {
    next()
  } else {
    next({ path: '/login' })
  }
}