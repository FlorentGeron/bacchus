import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchInput", "form", "formFiltered" ]

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

}
