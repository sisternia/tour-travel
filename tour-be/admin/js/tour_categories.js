// admin/js/tour_categories.js
const CATEGORY_API = API.TOUR_CATEGORIES;
const tbodyCategory = document.getElementById("categoriesTableBody");
const modalCategory = new bootstrap.Modal(document.getElementById("categoryModal"));
const formCategory = document.getElementById("categoriesForm");
const categoryIdInput = document.getElementById("categoryId");
let editingCategoryId = null;
let cachedCategories = [];

async function loadCategories() {
  tbodyCategory.innerHTML = `<tr><td colspan="4" class="text-center">Đang tải...</td></tr>`;
  const res = await fetch(CATEGORY_API);
  const data = await res.json();
  tbodyCategory.innerHTML = "";
  cachedCategories = data || [];

  if (!Array.isArray(cachedCategories) || cachedCategories.length === 0) {
    tbodyCategory.innerHTML = `<tr><td colspan="4" class="text-center text-danger">Không có dữ liệu.</td></tr>`;
    return;
  }

  cachedCategories.forEach(item => {
    tbodyCategory.innerHTML += `
      <tr>
        <td>${item.category_id}</td>
        <td>${item.categories_name}</td>
        <td>${item.image ? `<img src="${item.image}" width="80">` : ""}</td>
        <td>
          <button class="btn btn-warning btn-sm me-2" onclick="editCategory('${item.category_id}', '${item.categories_name}')">Sửa</button>
          <button class="btn btn-danger btn-sm" onclick="deleteCategory('${item.category_id}')">Xóa</button>
        </td>
      </tr>`;
  });
}

document.querySelector("[data-bs-target='#categoryModal']").addEventListener("click", () => {
  formCategory.reset();
  editingCategoryId = null;
  document.querySelector(".modal-title").innerText = "Thêm loại Tour";
  categoryIdInput.disabled = true;

  let newId = 1;
  if (cachedCategories.length > 0) {
    const ids = cachedCategories.map(t => parseInt(t.category_id)).filter(Number.isFinite);
    newId = Math.max(...ids) + 1;
  }
  categoryIdInput.value = newId;
});

formCategory.addEventListener("submit", async (e) => {
  e.preventDefault();
  const formData = new FormData();
  formData.append("category_id", categoryIdInput.value);
  formData.append("categories_name", document.getElementById("categoryName").value);
  const file = document.getElementById("categoryImage").files[0];
  if (file) formData.append("image", file);

  const method = editingCategoryId ? "PUT" : "POST";
  const url = editingCategoryId ? `${CATEGORY_API}/${editingCategoryId}` : CATEGORY_API;
  const res = await fetch(url, { method, body: formData });
  const result = await res.json();

  alert(result.message || "Thao tác thành công!");
  modalCategory.hide();
  formCategory.reset();
  editingCategoryId = null;
  loadCategories();
});

function editCategory(id, name) {
  editingCategoryId = id;
  document.querySelector(".modal-title").innerText = "Sửa loại Tour";
  categoryIdInput.value = id;
  categoryIdInput.disabled = true;
  document.getElementById("categoryName").value = name;
  modalCategory.show();
}

async function deleteCategory(id) {
  if (!confirm("Bạn có chắc chắn muốn xóa loại tour này?")) return;
  const res = await fetch(`${CATEGORY_API}/${id}`, { method: "DELETE" });
  const result = await res.json();
  alert(result.message);
  loadCategories();
}

document.addEventListener("DOMContentLoaded", loadCategories);
