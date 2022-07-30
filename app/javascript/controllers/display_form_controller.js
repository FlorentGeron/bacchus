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

  addtocave({params : {cuveeref}}) {
    console.log(cuveeref)
    const url = `${this.formTarget.action}/addtolist?cuveeref=${cuveeref}&save=cave`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(response => response.text())
      .then ((data) => {
        this.revealFieldsTarget.innerHTML = data;
      });
   this.createNewCuveeFromExistingTarget.innerHTML = "";
  }

  addtowishlist({params : {cuveeref}}) {
    const url = `${this.formTarget.action}/addtolist?cuveeref=${cuveeref}&save=wishlist`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(response => response.text())
      .then ((data) => {
        this.revealFieldsTarget.innerHTML = data;
      });
    this.createNewCuveeFromExistingTarget.innerHTML = "";
  }

}
