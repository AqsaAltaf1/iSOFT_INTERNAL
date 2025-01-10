import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="address"
export default class extends Controller {
  connect() {
  }
  states(event) {
    const requestType = event.target.getAttribute('data-id')
    var selectedValue = event.target.value;
    if(requestType == 'state'){
      var selectedCountry = $("#user_address_attributes_country").find(":selected").val();
      var query = `state=${selectedValue}&country=${selectedCountry}`
    }else{
      var query = `country=${selectedValue}`
    }
    
    // Send AJAX request to the new action of the users controller
    
    fetch(`/users/new?${query}`, {
      method: 'GET',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    })
    .then(response => response.json())
      .then(data => {

        if(requestType == 'country'){
          const stateSelect = document.getElementById('user_address_attributes_state');
            stateSelect.innerHTML = ''; // Clear existing options
            data.states.forEach(state => {
              const option = document.createElement('option');
              option.value = state[1]; // Assuming state has an 'id' attribute
              option.text = state[0]; // Assuming state has a 'name' attribute
              stateSelect.appendChild(option);
            });
        }else{
          const citySelect = document.getElementById('user_address_attributes_city');
          citySelect.innerHTML = ''; // Clear existing options
          // debugger
          console.log(data.cities)
          data.cities.forEach(city => {
            const option = document.createElement('option');
            option.value = city; // Assuming city has an 'id' attribute
            option.text = city; // Assuming city has a 'name' attribute
            citySelect.appendChild(option);
          });
        } 
      })
      .catch(error => {
        console.error('Error:', error);
      });
  } 

  locationstates(event) {
    const requestType = event.target.getAttribute('data-id')
    var selectedValue = event.target.value;
    if(requestType == 'state'){
      var selectedCountry = $("#location_country").find(":selected").val();
      var query = `state=${selectedValue}&country=${selectedCountry}`
    }else{
      var query = `country=${selectedValue}`
    }
    
    // Send AJAX request to the new action of the users controller
    
    fetch(`/locations/new?${query}`, {
      method: 'GET',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    })
    .then(response => response.json())
      .then(data => {

        if(requestType == 'country'){
          const stateSelect = document.getElementById('location_state');
            stateSelect.innerHTML = ''; // Clear existing options
            data.states.forEach(state => {
              const option = document.createElement('option');
              option.value = state[1]; // Assuming state has an 'id' attribute
              option.text = state[0]; // Assuming state has a 'name' attribute
              stateSelect.appendChild(option);
            });
        }else{
          const citySelect = document.getElementById('location_city');
          citySelect.innerHTML = ''; // Clear existing options
          // debugger
          console.log(data.cities)
          data.cities.forEach(city => {
            const option = document.createElement('option');
            option.value = city; // Assuming city has an 'id' attribute
            option.text = city; // Assuming city has a 'name' attribute
            citySelect.appendChild(option);
          });
        } 
      })
      .catch(error => {
        console.error('Error:', error);
      });
  } 
}

