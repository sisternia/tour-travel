// admin/js/tour_type.js
const TYPE_API = API.TOUR_TYPES;
const tbodyType = document.getElementById("tourTypeTableBody");
const modalType = new bootstrap.Modal(document.getElementById("typeModal"));
const formType = document.getElementById("tourTypeForm");
const typeIdInput = document.getElementById("typeId");
let editingTypeId = null;
let cachedTourTypes = [];

async function loadTourTypes() {
  tbodyType.innerHTML = `<tr><td colspan="4" class="text-center">Đang tải...</td></tr>`;
  try {
    const res = await fetch(TYPE_API);
    const data = await res.json();
    tbodyType.innerHTML = "";
    cachedTourTypes = data || [];

    if (!Array.isArray(cachedTourTypes) || cachedTourTypes.length === 0) {
      tbodyType.innerHTML = `<tr><td colspan="4" class="text-center text-danger">Không có dữ liệu.</td></tr>`;
      return;
    }

    cachedTourTypes.forEach(item => {
      tbodyType.innerHTML += `
        <tr>
          <td>${item.type_id}</td>
          <td>${item.type_name}</td>
          <td>${item.image ? `<img src="${item.image}" width="80">` : ""}</td>
          <td>
            <button class="btn btn-warning btn-sm me-2" onclick="editTourType('${item.type_id}', '${item.type_name}')">Sửa</button>
            <button class="btn btn-danger btn-sm" onclick="deleteTourType('${item.type_id}')">Xóa</button>
          </td>
        </tr>`;
    });
  } catch (err) {
    console.error(err);
    tbodyType.innerHTML = `<tr><td colspan="4" class="text-center text-danger">Lỗi tải dữ liệu!</td></tr>`;
  }
}

document.querySelector("[data-bs-target='#typeModal']").addEventListener("click", () => {
  formType.reset();
  editingTypeId = null;
  document.querySelector(".modal-title").innerText = "Thêm kiểu Tour";
  typeIdInput.disabled = true;

  let newId = 1;
  if (cachedTourTypes.length > 0) {
    const ids = cachedTourTypes.map(t => parseInt(t.type_id)).filter(Number.isFinite);
    newId = Math.max(...ids) + 1;
  }
  typeIdInput.value = newId;
});

formType.addEventListener("submit", async (e) => {
  e.preventDefault();
  const formData = new FormData();
  formData.append("type_id", typeIdInput.value);
  formData.append("type_name", document.getElementById("typeName").value);
  const file = document.getElementById("typeImage").files[0];
  if (file) formData.append("image", file);

  const method = editingTypeId ? "PUT" : "POST";
  const url = editingTypeId ? `${TYPE_API}/${editingTypeId}` : TYPE_API;
  const res = await fetch(url, { method, body: formData });
  const result = await res.json();

  alert(result.message || "Thao tác thành công!");
  modalType.hide();
  formType.reset();
  editingTypeId = null;
  loadTourTypes();
});

function editTourType(id, name) {
  editingTypeId = id;
  document.querySelector(".modal-title").innerText = "Sửa kiểu Tour";
  typeIdInput.value = id;
  typeIdInput.disabled = true;
  document.getElementById("typeName").value = name;
  modalType.show();
}

async function deleteTourType(id) {
  if (!confirm("Bạn có chắc chắn muốn xóa kiểu tour này?")) return;
  const res = await fetch(`${TYPE_API}/${id}`, { method: "DELETE" });
  const result = await res.json();
  alert(result.message);
  loadTourTypes();
}

document.addEventListener("DOMContentLoaded", loadTourTypes);
