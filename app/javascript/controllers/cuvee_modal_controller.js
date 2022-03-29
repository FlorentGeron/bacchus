// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "closedModal", "openModal" ]

  connect() {
    console.log('Hello, Stimulus!');
  }

  openCuveeModal(e) {
  e.preventDefault();
  this.closedModalTarget.classList.toggle('d-none')
  this.openModalTarget.classList.toggle('d-none')
  }

  closeModal(e) {
    this.openModalTarget.classList.toggle('d-none')
    this.closedModalTarget.classList.toggle('d-none')
    console.log("done closing")
  }
}
