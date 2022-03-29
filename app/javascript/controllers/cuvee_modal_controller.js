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

  openCuveeModal() {
  this.closedModalTarget.classList.remove('d-none');
  this.openModalTarget.classList.remove('d-none');
  console.log("done opening")
  }

  closeModal() {
    this.openModalTarget.classList.add('d-none');
    this.closedModalTarget.classList.add('d-none');
    console.log("done closing");
  }
}
