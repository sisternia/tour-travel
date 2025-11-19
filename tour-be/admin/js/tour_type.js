const API_URL = "http://localhost:3000/api/tour-types/tour_type";
const tbody = document.getElementById("tourTypeTableBody");
const modal = new bootstrap.Modal(document.getElementById("addModal"));
const form = document.getElementById("tourTypeForm");
let editingId = null;

// Load danh sách
async function loadTourTypes() {
  tbody.innerHTML = `<tr><td colspan="4" class="text-center">Đang tải...</td></tr>`;
  const res = await fetch(API_URL);
  const data = await res.json();
  tbody.innerHTML = "";

  data.forEach(item => {
    tbody.innerHTML += `
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
}

// Thêm / Sửa
form.addEventListener("submit", async (e) => {
  e.preventDefault();
  const formData = new FormData();
  formData.append("type_id", document.getElementById("typeId").value);
  formData.append("type_name", document.getElementById("typeName").value);
  const file = document.getElementById("typeImage").files[0];
  if (file) formData.append("image", file);

  const method = editingId ? "PUT" : "POST";
  const url = editingId ? `${API_URL}/${editingId}` : API_URL;

  const res = await fetch(url, { method, body: formData });
  const result = await res.json();

  alert(result.message || "Thao tác thành công!");
  modal.hide();
  form.reset();
  editingId = null;
  loadTourTypes();
});

function editTourType(id, name) {
  editingId = id;
  document.querySelector(".modal-title").innerText = "Sửa loại Tour";
  document.getElementById("typeId").value = id;
  document.getElementById("typeId").disabled = true;
  document.getElementById("typeName").value = name;
  modal.show();
}

async function deleteTourType(id) {
  if (!confirm("Bạn có chắc chắn muốn xóa loại tour này?")) return;
  const res = await fetch(`${API_URL}/${id}`, { method: "DELETE" });
  const result = await res.json();
  alert(result.message);
  loadTourTypes();
}

document.addEventListener("DOMContentLoaded", loadTourTypes);
