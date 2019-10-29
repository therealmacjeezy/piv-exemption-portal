import Vue from 'vue'
import App from './App.vue'
import router from './router'
import axios from 'axios'
import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.config.productionTip = false
Vue.use(BootstrapVue)
Vue.prototype.$http = axios.create({
  baseURL: process.env.VUE_APP_API_SITE_URL,
  withCredentials: false,
  headers: {
    // 'Access-Control-Allow-Origin': '*',
    // 'Content-Type': 'application/json',
  },
})

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
