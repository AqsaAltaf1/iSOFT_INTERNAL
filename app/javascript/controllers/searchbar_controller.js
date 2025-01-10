import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="searchbar"
export default class extends Controller {
  static targets = ['results'];
  connect() {
    this.searchInput = this.element.querySelector('#search-input');
    this.searchResults = this.resultsTarget;
  }
  
  onInput() {
    const query = this.searchInput.value;
    this.searchResults.innerHTML = '';
  
    if (query) {
      this.searchResults.style.display = 'block';
      this.searchResults.style.backgroundColor = 'white';
      fetch(`/search/search?query=${query}`)
        .then(response => response.json())
        .then(data => {
          data.forEach(user => {
            this.fetchProfileURL(user.id)
              .then(response => response.json())
              .then(data => {
                this.searchResults.insertAdjacentHTML(
                  'beforeend',
                  `<div><a href="${data.profile_url}">${user.first_name} ${user.last_name}</a></div>`
                );
              });
          });
        });
    } else {
      this.searchResults.style.display = 'none';
    }
  }
  
  async fetchProfileURL(userId) {
    return fetch(`/users/${userId}/profile_url`);
  }

}
