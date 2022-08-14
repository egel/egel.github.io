document.addEventListener("DOMContentLoaded", function (event) {

  /*
   * Display the menu items on smaller screens
   */
  var menuToggleButton = document.getElementById('menu-toggle');
  var menu = document.querySelector('nav ul');


  ['click', 'touch'].forEach(function (e) {
    menuToggleButton.addEventListener(e, function () {
      console.log("asdfasfdasdf")
      menu.classList.toggle('open-menu')
    }, false);
  });

  /*
   * Make the header images move on scroll
   */
  gsap.to("#scrollable-background", {
    backgroundPosition: "70% 100%",
    ease: "none",
    scrollTrigger: {
      trigger: "#scrollable-background",
      start: "top bottom",
      end: "bottom top",
      scrub: true
    }
  });
});
