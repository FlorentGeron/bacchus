import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["displayDevise"]

  connect() {
    console.log("Hello, I am the devise conroller");
  }

  displayForm() {
    console.log("clicked on the right button")
  }
}
