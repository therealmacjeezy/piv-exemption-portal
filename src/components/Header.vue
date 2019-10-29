<template>
  <b-navbar toggleable="lg" class="navbar-custom">
    <!-- <b-navbar-nav>
      <b-nav-item col lg="2" :to="{ name: 'home' }">Home</b-nav-item >
    </b-navbar-nav> -->

    <b-col class="justify-content-md-center" size="auto"><h5>PIV Exemption Portal</h5></b-col>
  </b-navbar>
</template>

<script>
export default {
  name: 'header',
}
</script>

<style scoped>
.col { 
  border: 1px solid transparent;
  padding-top: 5px; 
}

h5 {
  color: white;
  text-shadow: 1px 2px 6px rgb(0, 0, 0);
}

.navbar-custom {
    color: #000;
    background-color: rgb(214, 39, 39);
    margin-bottom: 10px;
}

.sitesLabel { 
  padding-right: 5px;
}

.navbar-custom .nav-link{
    color: #ffffff;
}

.dropdown-menu a:hover{
  background-color: rgb(136, 194, 248);
}

.navbar-custom .nav-item.b-nav-dropdown active{
  color: #ff0000 !important;
  font-weight: bold;
}

.navbar-custom li.nav-item a:hover{
    color: #ffffff;
}

.navbar-custom .nav-link.router-link-exact-active.router-link-active{
    color: #a1f1fc;
    font-weight: bold;
}
</style>