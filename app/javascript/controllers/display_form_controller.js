import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchInput", "form", "formFiltered", "createNewCuveeFromExisting", "revealFields"]

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
    const url = `${this.formTarget.action}/renderbuttons?cuveeref=${e.currentTarget.value}`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(response => response.text())
      .then((data) => {
        this.createNewCuveeFromExistingTarget.outerHTML = data;
    });
}

  addtolist({params : {cuveeref, save}}) {
    const url = `${this.formTarget.action}/addtolist?cuveeref=${cuveeref}&save=${save}`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(response => response.text())
      .then ((data) => {
        this.revealFieldsTarget.innerHTML = data;
      });
    this.createNewCuveeFromExistingTarget.innerHTML = "";
  }

}
