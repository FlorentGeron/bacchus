import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchInput", "form", "formFiltered", "createNewCuveeFromExisting", "revealCaveFields", "revealWishFields" ]

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

  addtocave() {
   this.revealCaveFieldsTarget.classList.remove("d-none");
   this.createNewCuveeFromExistingTarget.innerHTML = "";
  }

  addtowishlist() {
    this.revealWishFieldsTarget.classList.remove("d-none");
    this.createNewCuveeFromExistingTarget.innerHTML = "";
  }

}
