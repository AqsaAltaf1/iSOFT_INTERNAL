import { Controller } from "@hotwired/stimulus";
import DataTable from "datatables.net";
import "datatables.net-dt";

export default class extends Controller {
  connect() {
    // Fetch the table ID from the data-table-id attribute
    const tableId = this.element.getAttribute("data-table-id");

    // Check if the table with the given ID exists
    const tableElement = document.querySelector(`#${tableId}`);

    // Only initialize DataTable if the table element exists and isn't already a DataTable
    if (tableElement && !tableElement.classList.contains("dataTable")) {
      this.dataTableInstance = new DataTable(tableElement, {
        responsive: true,
        scrollY: 400,
        ordering: true,
      });
    }
  }

  disconnect() {
    if (this.dataTableInstance) {
      this.dataTableInstance.destroy(false);
      // this.dataTableInstance = null;
    }
  }
}
