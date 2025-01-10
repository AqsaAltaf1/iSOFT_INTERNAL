import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="placeholder-for-data-tables"
export default class extends Controller {
  connect() {
    const dataTable = document.getElementById('employee_details_search_wrapper');
    if (dataTable) {
      const searchInput = dataTable.querySelector('.dataTables_filter input');
      if (searchInput) {
        searchInput.setAttribute('placeholder', 'Search records...');
      }
    }

  }
}
