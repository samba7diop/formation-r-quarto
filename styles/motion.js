(() => {
  const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  if (reduce) return;

  document.documentElement.classList.add("motion-ready");

  const reveal = () => {
    document.querySelectorAll(".reveal-on-scroll").forEach((el, i) => {
      el.style.setProperty("--reveal-delay", `${Math.min(i * 60, 240)}ms`);
    });

    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            io.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: "0px 0px -8% 0px" }
    );

    document.querySelectorAll(".reveal-on-scroll").forEach((el) => io.observe(el));
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", reveal);
  } else {
    reveal();
  }
})();
