({
	rerender: function (component, helper) {
    this.superRerender();
        var focusBottom = document.getElementById("adobewordpress");
  focusBottom.scrollTop = focusBottom.scrollHeight;
     //   console.log('afterrende');
    // interact with the DOM here
}// Your renderer method overrides go here// Your renderer method overrides go here
})