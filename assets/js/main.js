(() => {
  const header = document.querySelector(".site-header");
  const hero = document.querySelector(".hero");
  const nav = document.querySelector(".site-nav");
  const toggle = document.querySelector(".nav-toggle");
  const navLinks = document.querySelectorAll('.site-nav a[href^="#"]');
  const yearEl = document.querySelector("[data-year]");
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  if (yearEl) {
    yearEl.textContent = String(new Date().getFullYear());
  }

  const setHeaderState = () => {
    if (!header) return;
    const scrolled = window.scrollY > 24;
    header.classList.toggle("is-scrolled", scrolled);

    if (hero) {
      const heroBottom = hero.offsetTop + hero.offsetHeight;
      const overHero = window.scrollY < heroBottom - header.offsetHeight;
      header.classList.toggle("is-over-hero", overHero);
    }
  };

  const closeNav = () => {
    if (!nav || !toggle) return;
    nav.classList.remove("is-open");
    toggle.setAttribute("aria-expanded", "false");
    toggle.setAttribute("aria-label", "Open menu");
    document.body.style.overflow = "";
  };

  const openNav = () => {
    if (!nav || !toggle) return;
    nav.classList.add("is-open");
    toggle.setAttribute("aria-expanded", "true");
    toggle.setAttribute("aria-label", "Close menu");
    document.body.style.overflow = "hidden";
  };

  if (toggle && nav) {
    toggle.addEventListener("click", () => {
      const expanded = toggle.getAttribute("aria-expanded") === "true";
      if (expanded) {
        closeNav();
      } else {
        openNav();
      }
    });
  }

  navLinks.forEach((link) => {
    link.addEventListener("click", () => {
      closeNav();
    });
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
      closeNav();
    }
  });

  const sections = document.querySelectorAll("main section[id]");
  const setActiveNav = () => {
    const offset = (header?.offsetHeight || 0) + 40;
    let currentId = "";

    sections.forEach((section) => {
      if (window.scrollY + offset >= section.offsetTop) {
        currentId = section.id;
      }
    });

    navLinks.forEach((link) => {
      const href = link.getAttribute("href");
      const isActive = href === `#${currentId}`;
      if (isActive) {
        link.setAttribute("aria-current", "true");
      } else {
        link.removeAttribute("aria-current");
      }
    });
  };

  if (!reduceMotion && "IntersectionObserver" in window) {
    const revealEls = document.querySelectorAll(".reveal");
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.18, rootMargin: "0px 0px -8% 0px" }
    );

    revealEls.forEach((el) => observer.observe(el));
  } else {
    document.querySelectorAll(".reveal").forEach((el) => {
      el.classList.add("is-visible");
    });
  }

  window.addEventListener("scroll", () => {
    setHeaderState();
    setActiveNav();
  }, { passive: true });

  window.addEventListener("resize", () => {
    if (window.innerWidth > 768) {
      closeNav();
    }
    setHeaderState();
  });

  setHeaderState();
  setActiveNav();
})();
