document.addEventListener("DOMContentLoaded", function (event) {

  /*
   * Display the menu items on smaller screens
   */
  var pull = document.getElementById('pull');
  var menu = document.querySelector('nav ul');


  ['click', 'touch'].forEach(function (e) {
    pull.addEventListener(e, function () {
      menu.classList.toggle('hide')
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
