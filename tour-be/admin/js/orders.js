document.addEventListener("DOMContentLoaded", loadOrders);

async function loadOrders() {
  const tbody = document.getElementById("orderTableBody");
  tbody.innerHTML = `<tr><td colspan="10" class="text-center">Đang tải...</td></tr>`;

  const res = await fetch(API.ORDERS);
  const orders = await res.json();

  tbody.innerHTML = "";

  orders.forEach((o) => {
    const tr = document.createElement("tr");

    tr.innerHTML = `
      <td>${o.id}</td>
      <td>${o.name_tourist}</td>
      <td>${o.phone_tourist}</td>
      <td>${o.email_tourist ?? "-"}</td>
      <td>${o.number_of_adult}</td>
      <td>${o.number_of_child}</td>
    <td>${formatMoney(o.total)} VNĐ</td>

      <td>${renderStatus(o.type_confirm_id)}</td>
      <td>${formatDate(o.order_at)}</td>

      <td>
        <button class="btn btn-info btn-sm" onclick="viewOrder(${o.id})">
          <i class="bi bi-eye"></i>
        </button>

        <button class="btn btn-warning btn-sm" onclick="openStatusModal(${
          o.id
        }, ${o.type_confirm_id})">
          <i class="bi bi-pencil-square"></i>
        </button>

        <button class="btn btn-danger btn-sm" onclick="deleteOrder(${o.id})">
          <i class="bi bi-trash"></i>
        </button>
      </td>
    `;

    tbody.appendChild(tr);
  });
}

// -------------------- Helpers --------------------

function renderStatus(id) {
  if (id == 1) return `<span class="badge bg-secondary">Chờ xác nhận</span>`;
  if (id == 2) return `<span class="badge bg-primary">Đã xác nhận</span>`;
  if (id == 3) return `<span class="badge bg-success">Đã thanh toán</span>`;
  return `<span class="badge bg-dark">Không rõ</span>`;
}

function formatDate(dt) {
  return new Date(dt).toLocaleString("vi-VN");
}

// -------------------- Xem chi tiết --------------------
function formatMoney(amount) {
  return Number(amount).toLocaleString("vi-VN", {
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  });
}

async function viewOrder(id) {
  const res = await fetch(`${API.ORDERS}/${id}`);
  const o = await res.json();

  const box = document.getElementById("orderDetailContent");

  box.innerHTML = `
    <p><strong>Tên khách:</strong> ${o.name_tourist}</p>
    <p><strong>Email:</strong> ${o.email_tourist ?? "-"}</p>
    <p><strong>SĐT:</strong> ${o.phone_tourist}</p>
    <p><strong>Người lớn:</strong> ${o.number_of_adult}</p>
    <p><strong>Trẻ em:</strong> ${o.number_of_child}</p>
    <p><strong>Tổng tiền:</strong> ${formatMoney(o.total)} VNĐ</p>
    <p><strong>Đặt lúc:</strong> ${formatDate(o.order_at)}</p>
    <p><strong>Ghi chú:</strong> ${o.note ?? "-"}</p>
    <p><strong>Trạng thái:</strong> ${renderStatus(o.type_confirm_id)}</p>
  `;

  new bootstrap.Modal("#orderDetailModal").show();
}

// -------------------- Cập nhật trạng thái --------------------

function openStatusModal(id, currentType) {
  document.getElementById("statusOrderId").value = id;
  document.getElementById("type_confirm_id").value = currentType;
  new bootstrap.Modal("#updateStatusModal").show();
}

document
  .getElementById("updateStatusForm")
  .addEventListener("submit", async (e) => {
    e.preventDefault();

    const id = document.getElementById("statusOrderId").value;
    const typeId = document.getElementById("type_confirm_id").value;

    await fetch(`${API.ORDERS}/${id}/status`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ type_confirm_id: typeId }),
    });

    alert("Cập nhật thành công!");
    loadOrders();
  });

// -------------------- Xóa đơn --------------------

async function deleteOrder(id) {
  if (!confirm("Bạn có chắc muốn xóa đơn này?")) return;

  await fetch(`${API.ORDERS}/${id}`, { method: "DELETE" });

  alert("Xóa thành công!");
  loadOrders();
}
