(function () {
  var toggle = document.querySelector(".nav-toggle");
  var nav = document.querySelector(".main-nav");
  if (!toggle || !nav) return;

  toggle.addEventListener("click", function () {
    var open = nav.classList.toggle("open");
    toggle.setAttribute("aria-expanded", open ? "true" : "false");
  });

  nav.querySelectorAll("a").forEach(function (link) {
    link.addEventListener("click", function () {
      nav.classList.remove("open");
      toggle.setAttribute("aria-expanded", "false");
    });
  });

  document.querySelectorAll(".nav-caret").forEach(function (btn) {
    btn.addEventListener("click", function (e) {
      e.preventDefault();
      var item = btn.closest(".nav-item");
      var isOpen = item.classList.contains("open");
      document.querySelectorAll(".nav-item.open").forEach(function (other) {
        if (other !== item) other.classList.remove("open");
      });
      item.classList.toggle("open", !isOpen);
      btn.setAttribute("aria-expanded", String(!isOpen));
    });
  });

  document.addEventListener("click", function (e) {
    document.querySelectorAll(".nav-item.open").forEach(function (item) {
      if (!item.contains(e.target)) item.classList.remove("open");
    });
  });

  var filterButtons = document.querySelectorAll("[data-ref-filter]");
  var refCards = document.querySelectorAll("[data-ref-sector]");
  if (filterButtons.length && refCards.length) {
    filterButtons.forEach(function (btn) {
      btn.addEventListener("click", function () {
        filterButtons.forEach(function (b) { b.classList.remove("active"); });
        btn.classList.add("active");
        var filter = btn.getAttribute("data-ref-filter");
        refCards.forEach(function (card) {
          var match = filter === "all" || card.getAttribute("data-ref-sector") === filter;
          card.style.display = match ? "" : "none";
        });
      });
    });
  }
})();
