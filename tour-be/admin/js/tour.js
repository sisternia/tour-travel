// admin/js/tour.js
const TOUR_API = API.TOURS;
const CATEGORY_API = API.TOUR_CATEGORIES;
const TYPE_API = API.TOUR_TYPES;
const ASSIGN_API = API.TOUR_GUIDE_ASSIGNMENT;
const GUIDE_API = API.TOUR_GUIDES;

const tbody = document.getElementById("tourTableBody");
const modal = new bootstrap.Modal(document.getElementById("addModal"));
const form = document.getElementById("tourForm");
const categorySelect = document.getElementById("tour_category_id");
const typeCheckboxContainer = document.getElementById("tourTypeCheckboxes");
let selectedTourId = null;
let editingId = null;
let categories = [];
let types = [];

function formatDate(dateStr) {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  if (isNaN(date)) return dateStr;
  return date.toLocaleDateString("vi-VN");
}
async function loadSelectOptions() {
  const [categoriesRes, typesRes] = await Promise.all([
    fetch(CATEGORY_API),
    fetch(TYPE_API),
  ]);

  categories = await categoriesRes.json();
  types = await typesRes.json();

  // Category SelectBox
  categorySelect.innerHTML = `<option value="">-- Chọn danh mục --</option>`;
  categories.forEach((c) => {
    categorySelect.innerHTML += `<option value="${c.category_id}">${c.categories_name}</option>`;
  });

  // Type Checkbox List
  typeCheckboxContainer.innerHTML = "";
  types.forEach((t) => {
    typeCheckboxContainer.innerHTML += `
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" value="${t.type_id}" id="type_${t.type_id}">
        <label class="form-check-label" for="type_${t.type_id}">
          ${t.type_name}
        </label>
      </div>`;
  });
}

// Load all tours
async function loadTours() {
  tbody.innerHTML = `<tr><td colspan="11" class="text-center">Đang tải...</td></tr>`;
  const res = await fetch(TOUR_API);
  const data = await res.json();
  tbody.innerHTML = "";

  data.forEach((tour) => {
    const category = categories.find(
      (c) => c.category_id === tour.tour_category_id
    );
    const categoryName = category ? category.categories_name : "";

    const rawTypeValue = Array.isArray(tour.tour_type_id)
      ? tour.tour_type_id.join(",")
      : (tour.tour_type_id || "").toString();

    const selectedTypeIds = rawTypeValue
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean);

    const typeNames = selectedTypeIds
      .map((id) => {
        const type = types.find((t) => t.type_id == id);
        return type ? type.type_name : "";
      })
      .filter(Boolean)
      .join(", ");

    tbody.innerHTML += `
      <tr>
        <td>${tour.id}</td>
        <td>${tour.name}</td>
        <td>${tour.number_of_people}</td>
        <td>${formatDate(tour.start_date)}</td>
        <td>${formatDate(tour.end_date)}</td>
        <td>${tour.departure_address}</td>
        <td>${tour.destination_address}</td>
        <td>${categoryName}</td>
        <td>${typeNames}</td>
        <td>${tour.status || ""}</td>
    <td>
  <div class="d-flex gap-2">
    <button class="btn btn-warning btn-sm" onclick="editTour(${tour.id})">
      <i class="bi bi-pencil-square"></i> 
    </button>
    <button class="btn btn-danger btn-sm" onclick="deleteTour(${tour.id})">
      <i class="bi bi-trash"></i> 
    </button>
    <button class="btn btn-info btn-sm" onclick="openAssignModal(${tour.id})">
       Chọn HDV
    </button>
  </div>
</td>



      </tr>`;
  });
}

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  const selectedTypeIds = Array.from(
    document.querySelectorAll("#tourTypeCheckboxes input:checked")
  ).map((cb) => cb.value);

  const tourData = {
    name: document.getElementById("name").value,
    number_of_people: document.getElementById("number_of_people").value,
    start_date: document.getElementById("start_date").value,
    end_date: document.getElementById("end_date").value,
    departure_address: document.getElementById("departure_address").value,
    destination_address: document.getElementById("destination_address").value,
    status: document.querySelector('input[name="status"]:checked')?.value || "",
    tour_category_id: document.getElementById("tour_category_id").value,
    tour_type_id: selectedTypeIds.join(","),
  };

  const method = editingId ? "PUT" : "POST";
  const url = editingId ? `${TOUR_API}/${editingId}` : TOUR_API;

  const res = await fetch(url, {
    method,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(tourData),
  });

  const result = await res.json();
  alert(result.message || "Thao tác thành công!");
  modal.hide();
  form.reset();
  editingId = null;
  loadTours();
});

// Edit tour
async function editTour(id) {
  const res = await fetch(TOUR_API);
  const tours = await res.json();
  const tour = tours.find((t) => t.id === id);
  if (!tour) return alert("Không tìm thấy tour");

  editingId = id;
  document.querySelector(".modal-title").innerText = "Sửa Tour";

  document.getElementById("name").value = tour.name;
  document.getElementById("number_of_people").value = tour.number_of_people;
  document.getElementById("start_date").value = tour.start_date.split("T")[0];
  document.getElementById("end_date").value = tour.end_date.split("T")[0];
  document.getElementById("departure_address").value = tour.departure_address;
  document.getElementById("destination_address").value =
    tour.destination_address;
  document.getElementById("tour_category_id").value =
    tour.tour_category_id || "";

  document
    .querySelector(`input[name="status"][value="${tour.status}"]`)
    ?.click();

  const rawTypeValue = Array.isArray(tour.tour_type_id)
    ? tour.tour_type_id.join(",")
    : (tour.tour_type_id || "").toString();

  const selectedTypeIds = rawTypeValue
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);

  document.querySelectorAll("#tourTypeCheckboxes input").forEach((checkbox) => {
    checkbox.checked = selectedTypeIds.includes(checkbox.value);
  });

  modal.show();
}

// Delete tour
async function deleteTour(id) {
  if (!confirm("Bạn có chắc chắn muốn xóa tour này?")) return;
  const res = await fetch(`${TOUR_API}/${id}`, { method: "DELETE" });
  const result = await res.json();
  alert(result.message);
  loadTours();
}
function showTab(tab) {
  document
    .getElementById("tab_tourList")
    .classList.toggle("d-none", tab !== "tourList");
  document
    .getElementById("tab_tourGuideList")
    .classList.toggle("d-none", tab !== "tourGuideList");

  document
    .getElementById("tabTourList")
    .classList.toggle("active", tab === "tourList");
  document
    .getElementById("tabTourGuide")
    .classList.toggle("active", tab === "tourGuideList");

  if (tab === "tourGuideList") loadTourGuideTable();
}

document.addEventListener("DOMContentLoaded", async () => {
  await loadSelectOptions();
  loadTours();
});
async function openAssignModal(tourId) {
  selectedTourId = tourId;
  const res = await fetch(GUIDE_API);
  const guides = await res.json();

  const select = document.getElementById("selectGuide");
  select.innerHTML = "";

  guides.forEach((g) => {
    select.innerHTML += `
      <option value="${g.guide_id}">
        ${g.guide_name} (${g.email})
      </option>`;
  });

  // Mở modal
  new bootstrap.Modal(document.getElementById("assignGuideModal")).show();
}
async function assignGuide() {
  const guideId = document.getElementById("selectGuide").value;

  if (!guideId || !selectedTourId) return alert("Thiếu dữ liệu để gán");

  const res = await fetch(ASSIGN_API, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      tour_id: selectedTourId,
      tour_guide_id: guideId,
    }),
  });

  const data = await res.json();

  if (!res.ok) return alert(data.message);

  alert("Gán hướng dẫn viên thành công!");

  document
    .getElementById("assignGuideModal")
    .querySelector(".btn-close")
    .click();
}
async function loadTourGuideTable() {
  const tbody = document.getElementById("tourGuideTableBody");
  tbody.innerHTML = `<tr><td colspan="4" class="text-center">Đang tải...</td></tr>`;

  const res = await fetch(API.TOURS);
  const tours = await res.json();

  tbody.innerHTML = "";

  for (let tour of tours) {
    // Lấy toàn bộ guide theo tour_id
    const guideRes = await fetch(`${API.TOUR_GUIDE_ASSIGNMENT}/${tour.id}`);
    const guides = await guideRes.json();

    // Cột Hướng dẫn viên (Avatar + Tên)
    const guideList = guides.length
      ? guides
          .map(
            (g) => `
              <div class="d-flex align-items-center mb-1">
                <img src="${g.avatar_image}" width="35" height="35"
                  style="object-fit:cover;border-radius:50%;margin-right:8px;">
                ${g.guide_name}
              </div>
            `
          )
          .join("")
      : "<i>Chưa gán</i>";

    // Cột Language Job
    const guideLangList = guides.length
      ? guides
          .map(
            (g) => `
              <div class="mb-1">
                ${g.language_job || "<i>Không rõ</i>"}
              </div>
            `
          )
          .join("")
      : "<i>Không rõ</i>";

    tbody.innerHTML += `
      <tr>
        <td>${tour.id}</td>
        <td>${tour.name}</td>
        <td>${guideList}</td>
        <td>${guideLangList}</td>
      </tr>
    `;
  }
}
