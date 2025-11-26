const scheduleModal = new bootstrap.Modal(document.getElementById("scheduleModal"));

const scheduleForm = document.getElementById("scheduleForm");
const scheduleTableBody = document.getElementById("scheduleTableBody");

const scheduleTourSelect = document.getElementById("scheduleTourSelect");
const dayNumber = document.getElementById("dayNumber");
const scheduleDescription = document.getElementById("scheduleDescription");
const scheduleEditId = document.getElementById("scheduleEditId");

const btnAddSchedule = document.getElementById("btnAddSchedule");

// Load danh sách tour
async function loadScheduleTours() {
  const res = await fetch(`${API.TOUR_SCHEDULES}/tours/list`);
  const data = await res.json();

  scheduleTourSelect.innerHTML = data
    .map(t => `<option value="${t.id}">${t.name}</option>`)
    .join("");
}

// Load toàn bộ lịch trình
async function loadSchedules() {
  scheduleTableBody.innerHTML = `<tr><td colspan="6" class="text-center">Đang tải...</td></tr>`;

  const res = await fetch(`${API.TOUR_SCHEDULES}`);
  const data = await res.json();

  scheduleTableBody.innerHTML = data
    .map(
      s => `
  <tr>
    <td>${s.schedule_id}</td>
    <td>${s.tour_name}</td>
    <td>${s.day_number}</td>
    <td>${s.description || ""}</td>
    <td>
      <button class="btn btn-warning btn-sm" onclick="editSchedule(${s.schedule_id})">Sửa</button>
      <button class="btn btn-danger btn-sm" onclick="deleteSchedule(${s.schedule_id})">Xóa</button>
    </td>
  </tr>`
    )
    .join("");
}

// Mở modal thêm
btnAddSchedule.onclick = () => {
  document.getElementById("scheduleFormTitle").innerText = "Thêm lịch trình";
  scheduleForm.reset();
  scheduleEditId.value = "";
  scheduleModal.show();
};

// Lưu tạo / cập nhật
scheduleForm.onsubmit = async (e) => {
  e.preventDefault();

  const body = {
    tour_id: scheduleTourSelect.value,
    day_number: dayNumber.value,
    description: scheduleDescription.value,
  };

  let url = `${API.TOUR_SCHEDULES}`;
  let method = "POST";

  if (scheduleEditId.value) {
    url += `/${scheduleEditId.value}`;
    method = "PUT";
  }

  await fetch(url, {
    method,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });

  scheduleModal.hide();
  loadSchedules();
};

// Load dữ liệu để sửa
async function editSchedule(id) {
  const res = await fetch(`${API.TOUR_SCHEDULES}`);
  const data = await res.json();
  const found = data.find(x => x.schedule_id === id);
  if (!found) return;

  document.getElementById("scheduleFormTitle").innerText = "Sửa lịch trình";

  scheduleEditId.value = found.schedule_id;
  scheduleTourSelect.value = found.tour_id;
  dayNumber.value = found.day_number;
  scheduleDescription.value = found.description;

  scheduleModal.show();
}

// Xóa
async function deleteSchedule(id) {
  if (!confirm("Xóa lịch trình này?")) return;

  await fetch(`${API.TOUR_SCHEDULES}/${id}`, { method: "DELETE" });
  loadSchedules();
}

// Khởi chạy
loadScheduleTours();
loadSchedules();
