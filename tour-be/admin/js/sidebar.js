
function initSidebar() {
  const container = document.getElementById("sidebar-container");
  if (!container) return;

  fetch("sidebar.html")
    .then((res) => res.text())
    .then((html) => {
      container.innerHTML = html;

      const sidebarLinks = container.querySelectorAll(".sidebar-link");
      const currentPage = window.location.pathname.split("/").pop();

      sidebarLinks.forEach((link) => {
        const href = link.getAttribute("href");
        if (!href || href === "#") return; 
        const linkPage = href.split("/").pop();

        if (linkPage === currentPage) {
          link.classList.add("active");
        } else {
          link.classList.remove("active");
        }
      });

      
      const sidebar = container.querySelector(".sidebar");
      const toggleBtn = document.querySelector(".menu-button"); 
      if (sidebar && toggleBtn) {
        toggleBtn.addEventListener("click", () => {
          sidebar.classList.toggle("collapsed");
        });
      }
    })
    .catch((err) => console.error("Failed to load sidebar:", err));
}

window.showSidebar = function () {
  const sidebar = document.querySelector(".sidebar");
  if (sidebar) sidebar.style.display = "flex";
};

window.hideSidebar = function () {
  const sidebar = document.querySelector(".sidebar");
  if (sidebar) sidebar.style.display = "none";
};
document.addEventListener("DOMContentLoaded", () => {
  initSidebar();
});
