<template>
  <div class="home">
    <b-row class="justify-content-md-center">
      <b-col col lg="6">
      <!--Comment out the line below if you aren't capturing the uid of the user logging into the piv exemption portal-->
      <p><b>Logged In As: </b> <b class="auid">{{ this.userName }}</b></p>
      <p>To start, select the jamf server for the user. <br> Once the jamf server is selected, you will be able to enter a username and search for any computer that user is assigned to.</p>
        <b-form-select size="sm" v-model="selectedCenter" :options="centerList" @change="changedCenter">
          <template slot="first">
              <option :value="null" disabled selected>Select A Jamf Server..</option>
          </template>
        </b-form-select>
      </b-col>
    </b-row>

    <div v-if="selectedCenter" class="centerMenu">

      <b-row class="justify-content-md-center">
        <b-col col lg="1">
          <b>Username:</b>
        </b-col>
        <b-col col lg="2">
            <b-form-input
            size="sm"
            id="usernameField" 
            v-model="userSearch" 
            type="text" 
            placeholder="srocket"
            @input="resetField"/>
            <b-form-text id="usernameFieldHelp">User's Username</b-form-text>
        </b-col>
          <b-col col lg="1">
            <div v-if="userSearch.length > '4'">
              <b-button size="sm" @click="onSearch" variant="outline-primary">Search</b-button>
            </div>
          </b-col>
      </b-row>

      <b-row class="justify-content-md-center">
        <b-col col lg="4">
          <div v-if="startSearch === 'yes' && userSearch.length > '4'">
              <b-table :items="computersList" :fields="fields" striped>
                <template slot="show_details" slot-scope="row">
                  <b-button size="sm" @click="selectComputer(row)" class="mr-2">
                    Select Computer
                  </b-button>
                </template>

                <template slot="row-details" slot-scope="row">
                  <div v-if="!row.item.exempt">
                  <b-card>
                    <div>
                    <b-row class="mb-2">
                      <b-col sm="6" class="text-sm-right"><b>Computer Name:</b></b-col>
                      <b-col>{{ row.item.name }}</b-col>
                    </b-row>
                    </div>

                    <b-row class="mb-2">
                      <div v-if="exemptionStatus != 'Exempted' && checkStatus != 'checking'" class="exemptionChoices">
                      <b-form-group label="PIV Exemption Reason">
                          <b-form-radio-group v-model="selectedReason" :options="exemptionReason" :state="state" name="reasonOptions">
                          <b-form-invalid-feedback :state="state">Please select one</b-form-invalid-feedback>
                          <b-form-valid-feedback :state="state">Selected: {{ selectedReason }}</b-form-valid-feedback>
                        </b-form-radio-group>
                      </b-form-group>
                      </div>
                    </b-row>
                  

                    <b-row class="justify-content-md-center">
                      <div>  
                        <!--Alert for exemption check-->
                        <div v-if="checkStatus == 'checking'">
                          <b-alert
                            :show="dismissCountDown"
                            
                            variant="info"
                            @dismissed="dismissCountDown=0"
                            @dismiss-count-down="countDownChanged"
                          >
                            <pre>Checking Current PIV Exemption Status for
{{ row.item.name }}
Please wait..</pre>
                            <b-progress
                              variant="dark"
                              :max="dismissSecs"
                              :value="dismissCountDown"
                              height="0px"
                            ></b-progress>
                          </b-alert>
                        </div>
                        <div v-if="exemptionStatus == 'Not Exempt' && checkStatus == 'done'">
                        <b-button size="sm" @click="issueExemption(row)">Issue PIV Exemption</b-button>
                        </div>  
                        <div v-if="exemptionStatus == 'Exempted' && checkStatus == 'done'">
                        <b class="auid">This computer is currently in a PIV Exempt state. Instruct the user to contact their System Administrator Team for troubleshooting if needed.</b>
                        </div>
                      </div>
                    </b-row>
                  </b-card>
                  </div>

                  <div v-else>
                    <b-card>
                      <b-row class="mb-2">
                        <b-col sm="6" class="text-sm-center"><b>PIV Exemption Completed</b></b-col>
                      </b-row>
                    </b-card>
                  </div>
                </template>
              </b-table>

            </div>
          </b-col>
        </b-row>

        <div v-if="this.computersList == 'No Computers Found.'">
            <p class="auid"> No Computers Found for {{ this.userSearch }}.</p>
        </div>

    </div>
  </div>
</template>

<script>
export default {
  name: 'home',
  computed: {
  state() {
    return Boolean(this.selectedReason)
  },
},
  mounted () {
    this.$http.get('api/user.php')
      .then(resp => {
        this.userName = resp.data
        console.log(this.userName)
      })
    this.$http.get('api/centers.php')
      .then(resp => {
        this.centerList = resp.data    
      })
  },
  methods: {
    changedCenter () {
      this.$http.get('api/exemptions.php', {
        params: {
          selectedCenter: this.selectedCenter
        }
      })
        .then(resp => {
          this.exemptionReason = resp.data //.map(i => { return { text: i, value: i } })
        })
    },
    selectComputer(row) {
      // console.log(this.$refs.tableList)
      this.computersList.forEach(i => {
        this.$set(i, '_showDetails', i.id === row.item.id)
      }),
      console.log(row)
      this.selectedReason = ''
      this.exemptionStatus = ''
      this.checkStatus = "checking"
      this.exemptionStatus = ''
      this.dismissCountDown = this.dismissSecs
      this.$http.get('api/exemption_check.php', {
        params: {
          id: row.item.id,
          selectedCenter: this.selectedCenter
        }
      })
      .then(resp => {
        this.checkStatus = 'done'
        this.exemptionStatus = resp.data
      });
      // this.$set(item, '_showDetails', !item._showDetails)
    },
    onSearch () {
      const pThis = this
      this.startSearch = 'yes'
      this.$http.get('api/computers.php', {
        params: {
          user: this.userSearch,
          selectedCenter: this.selectedCenter
        }
      })
      .then((computers) => {
        console.log(computers);
        if (computers.data == '') {
          this.computersList = "No Computers Found."; }   
        else {
          this.computersList = computers.data.map(i => { return { ...i, _showDetails: false, exempt: false } })
        }
        console.log(this.computersList);     
      });
    },
    resetField () {
      this.computersList = ''
    },
    countDownChanged(dismissCountDown) {
      this.dismissCountDown = dismissCountDown
    },
    issueExemption(row) {
      row.item.exempt = true
      // alert("Testing Mode")
      this.$http.post('api/issueexemption.php', {
        params: {
          id: row.item.id,
          selectedCenter: this.selectedCenter,
          selectedReason: this.selectedReason
        }
      })
      .then((exemption) => {
        console.log(exemption)
        alert("The PIV Exemption for \n \n    User: " + this.userSearch + "\n" + "    Computer: " + row.item.name + "\n \nhas been completed and is PIV Exempted for 48 hours.\n\n Exemption Reason:\n " + this.selectedReason + ".")
        this.selectedReason = ''
        this.checkStatus = ''
      });
    },
  },
  data () {
    return {
      checkStatus: '',
      dismissSecs: 10,
      dismissCountDown: 0,
      showDismissableAlert: false,
      selectedCenter: null,
      exemptionStatus: null,
      userSearch: '',
      startSearch: '',
      selectedReason: null,
      fields: [
        {
          key: 'name',
          label: 'Computer Name',
        },{
          key: 'show_details',
          label: 'Show Details'
        }
      ],
      computersList: [],
      selected: [],
      exemptionReason: [],
      centerList: [],
    }
  }
}
</script>

<style>
.centerMenu {
  margin-top: 15px;
}

.exemptionChoices {
  border-color:green;
}

b.auid {
  color: rgb(214, 39, 39);
  font-weight: bold;
  /* text-shadow: 1px 2px 2px rgb(0, 0, 0); */
}

p.auid {
  color: rgb(214, 39, 39);
  font-weight: bold;
  /* text-shadow: 1px 2px 2px rgb(0, 0, 0); */
}
</style>
