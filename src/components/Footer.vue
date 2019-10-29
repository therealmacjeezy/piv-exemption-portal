<template>
  <div class="footer">
    <hr >
      <b-row>
        <b-col sm="auto">
          <img src="tux.png">
        </b-col>
        <!-- <b-col col lg="4">  -->
        <b-col sm="auto" class="info">
          <b>Created by:</b> Joshua Harvey<br>
          <b>Contact information: </b> <a href="mailto:josh@macjeezy.com">josh@macjeezy.com</a><br>
          <b>Last Updated:</b> Oct 2019<br>
        </b-col>
      </b-row>
  </div>
</template>

<script>
export default {
  name: 'footer',
}
</script>

<style>
.footer {
    text-align: left;
    /* font-family: Arial, Helvetica, sans-serif; */
    font-size: 14px;
    padding-left: 15px;  
}

.footer a {
    color: rgb(19, 114, 158);
    /* font-family: Arial, Helvetica, sans-serif; */
    text-decoration: none;
}

.footer .col {
  border: 0px;
}

.footer .info {
  padding-top: 5px;
}
</style>