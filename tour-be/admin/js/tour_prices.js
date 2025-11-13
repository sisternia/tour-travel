// admin/js/tour_prices.js
const TOUR_PRICES_URL = API.TOUR_PRICES;
const priceBody = document.getElementById("priceTableBody");
const assignBody = document.getElementById("assignTableBody");
const priceForm = document.getElementById("priceForm");
const assignForm = document.getElementById("assignForm");
const priceSelect = document.getElementById("priceSelect");
const tourSelect = document.getElementById("tourSelect");

let editingPrice = null;

// === Load danh sách bảng giá ===
async function loadPrices() {
  const res = await fetch(`${TOUR_PRICES_URL}/prices`);
  const data = await res.json();
  priceBody.innerHTML = "";
  data.forEach(p => {
    priceBody.innerHTML += `
      <tr>
        <td>${p.price_id}</td>
        <td>${p.price_adult}</td>
        <td>${p.price_child}</td>
        <td>${p.valid_from ? formatDate(p.valid_from) : "-"}</td>
        <td>${p.valid_to ? formatDate(p.valid_to) : "-"}</td>
        <td>
          <button class="btn btn-warning btn-sm me-2" 
            onclick="editPrice(${p.price_id},${p.price_adult},${p.price_child},'${p.valid_from}','${p.valid_to}')">Sửa</button>
          <button class="btn btn-danger btn-sm" 
            onclick="deletePrice(${p.price_id})">Xóa</button>
        </td>
      </tr>`;
  });
  loadPriceOptions();
}

// === Load danh sách bảng giá cho dropdown ===
async function loadPriceOptions() {
  const res = await fetch(`${TOUR_PRICES_URL}/prices`);
  const data = await res.json();
  priceSelect.innerHTML = `<option value="">-- Chọn bảng giá --</option>`;
  data.forEach(p => {
    priceSelect.innerHTML += `<option value="${p.price_id}">#${p.price_id} | ${p.price_adult}₫ - ${p.price_child}₫</option>`;
  });
}

// === Load danh sách Tour ===
async function loadTours() {
  const res = await fetch(`${TOUR_PRICES_URL}/tours`);
  const data = await res.json();
  tourSelect.innerHTML = `<option value="">-- Chọn tour --</option>`;
  data.forEach(t => {
    tourSelect.innerHTML += `<option value="${t.id}">${t.name}</option>`;
  });
}

// === Load danh sách gán Tour với Giá ===
async function loadAssignments() {
  const res = await fetch(`${TOUR_PRICES_URL}/assignments`);
  const data = await res.json();
  assignBody.innerHTML = "";
  data.forEach(a => {
    assignBody.innerHTML += `
      <tr>
        <td>${a.id}</td>
        <td>${a.tour_name}</td>
        <td>${a.price_adult}</td>
        <td>${a.price_child}</td>
        <td>${a.valid_from ? formatDate(a.valid_from) : "-"} - ${a.valid_to ? formatDate(a.valid_to) : "-"}</td>
        <td>
          <button class="btn btn-danger btn-sm" onclick="deleteAssignment(${a.id})">Hủy</button>
        </td>
      </tr>`;
  });
}

// === Thêm hoặc sửa bảng giá ===
priceForm.addEventListener("submit", async e => {
  e.preventDefault();
  const data = {
    price_adult: document.getElementById("priceAdult").value,
    price_child: document.getElementById("priceChild").value,
    valid_from: document.getElementById("validFrom").value,
    valid_to: document.getElementById("validTo").value,
  };
  const method = editingPrice ? "PUT" : "POST";
  const url = editingPrice
    ? `${TOUR_PRICES_URL}/prices/${editingPrice}`
    : `${TOUR_PRICES_URL}/prices`;

  await fetch(url, {
    method,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });

  alert("Lưu thành công");
  editingPrice = null;
  document.getElementById("priceModal").querySelector(".btn-close").click();
  loadPrices();
});

// === Gán tour với bảng giá ===
assignForm.addEventListener("submit", async e => {
  e.preventDefault();
  const data = { tour_id: tourSelect.value, price_id: priceSelect.value };
  await fetch(`${TOUR_PRICES_URL}/assignments`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  alert("Gán tour thành công");
  document.getElementById("assignModal").querySelector(".btn-close").click();
  loadAssignments();
});

// === Chỉnh sửa bảng giá ===
function editPrice(id, pa, pc, vf, vt) {
  editingPrice = id;
  document.getElementById("priceAdult").value = pa;
  document.getElementById("priceChild").value = pc;
  document.getElementById("validFrom").value = vf?.split("T")[0] || "";
  document.getElementById("validTo").value = vt?.split("T")[0] || "";
}

// === Xóa bảng giá ===
async function deletePrice(id) {
  if (!confirm("Xóa bảng giá này?")) return;
  await fetch(`${TOUR_PRICES_URL}/prices/${id}`, { method: "DELETE" });
  loadPrices();
}

// === Hủy gán tour ===
async function deleteAssignment(id) {
  if (!confirm("Hủy gán này?")) return;
  await fetch(`${TOUR_PRICES_URL}/assignments/${id}`, { method: "DELETE" });
  loadAssignments();
}

// === Định dạng ngày ===
function formatDate(dateStr) {
  const d = new Date(dateStr);
  return d.toLocaleDateString("vi-VN");
}

document.addEventListener("DOMContentLoaded", () => {
  loadPrices();
  loadTours();
  loadAssignments();
});
