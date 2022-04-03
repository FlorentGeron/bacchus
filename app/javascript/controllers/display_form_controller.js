import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchInput", "form", "formFiltered", "createNewCuveeFromExisting", "revealFields" ]

  connect() {
    console.log("Hello, controller");
  }

  updatecuvee(e) {
    //console.log(e.currentTarget.value);
    const url = `${this.formTarget.action}?keyword=${this.searchInputTarget.value}`
  fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data) => {
      this.formFilteredTarget.outerHTML = data;
  })
}

  proposeyear(e) {
    console.log("received a click")
    const url = `${this.formTarget.action}/renderbuttons?cuveeref=${e.currentTarget.value}`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(response => response.text())
      .then((data) => {
        this.createNewCuveeFromExistingTarget.outerHTML = data;
    });
}

  nextfields() {
   this.revealFieldsTarget.classList.remove("d-none");
  }

}
