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

  filterresults(){
    console.log(this.couleurTarget.value)
    console.log(this.formTarget.action)
    const url = `${this.formTarget.action}?&search%5Bcave%5D=${this.caveTarget.value}&search%5Bcouleur%5D=${this.couleurTarget.value}&search%5Bregion%5D=${this.regionTarget.value}&search%5Bkeyword%5D=${this.keywordTarget.value}`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data)=> {
      this.displayResultsTarget.outerHTML = data;
    })
  }

}
