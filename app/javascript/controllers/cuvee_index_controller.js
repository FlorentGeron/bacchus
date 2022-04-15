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
  static targets = [ "form", "cave", "couleur", "region", "keyword", "displayResults" ]

  connect() {
    console.log( 'Hello, Stimulus!')
  }

  filterresults(){
    console.log(this.couleurTarget.value)
    const url = `${this.formTarget.action}?keyword=${this.keywordTarget.value}&cave=${this.caveTarget.value}&couleur=${this.couleurTarget.value}&region=${this.regionTarget.value}`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data)=> {
      this.displayResultsTarget.outerHTML = data;
    })
  }

}
