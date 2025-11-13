// admin\js\tour_images.js

const assignBody = document.getElementById("assignTableBody");
const assignForm = document.getElementById("assignForm");
const tourSelect = document.getElementById("tourSelect");
const imgSelect = document.getElementById("imgSelect");
const folderSelectAssign = document.getElementById("folderSelectAssign");

let assigning = false;
let selectedImageId = null;

function createFolderDropdownForAssign() {
  const list = window.__folderList || [];
  folderSelectAssign.innerHTML = `<option value="">-- Chọn thư mục --</option>`;
  list.forEach(f => {
    folderSelectAssign.innerHTML += `<option value="${f.folder_id}">${f.folder_name}</option>`;
  });
}

folderSelectAssign?.addEventListener("change", () => {
  const folderId = folderSelectAssign.value;

  imgSelect.innerHTML = "";
  selectedImageId = null;

  if (!folderId) return;

  const imgs = window.__imageList.filter(i => i.folder_id == folderId);

  if (imgs.length === 0) {
    imgSelect.innerHTML = `<p class="text-muted">Không có ảnh</p>`;
    return;
  }

  imgs.forEach(img => {
    const row = document.createElement("div");
    row.className = "d-flex align-items-center mb-2";

    row.innerHTML = `
      <input type="checkbox" name="imgCheck" value="${img.id}" class="form-check-input me-2">
      <img src="${img.url}" width="70" class="rounded me-2">
      <span>${img.url.split("/").pop()}</span>
    `;

    row.querySelector("input").addEventListener("change", e => {
      document.querySelectorAll('input[name="imgCheck"]').forEach(i => i.checked = false);
      e.target.checked = true;
      selectedImageId = img.id;
    });

    imgSelect.appendChild(row);
  });
});

async function loadAssignments() {
  const res = await fetch(`${TOUR_IMG_URL}/assignments`);
  const data = await res.json();
  assignBody.innerHTML = "";

  if (!Array.isArray(data) || data.length === 0) {
    assignBody.innerHTML = `<tr><td colspan="5" class="text-center">Chưa có ảnh gán</td></tr>`;
    return;
  }

  data.forEach(a => {
    assignBody.innerHTML += `
      <tr>
        <td>${a.id}</td>
        <td>${a.tour_name}</td>
        <td><img src="${a.tour_img}" width="70" class="rounded"></td>
        <td>${a.folder_name}</td>
        <td><button type="button" class="btn btn-danger btn-sm" onclick="deleteAssignment(${a.id})">Hủy</button></td>
      </tr>`;
  });
}

async function loadTours() {
  const res = await fetch(TOUR_URL);
  const data = await res.json();
  tourSelect.innerHTML = `<option value="">-- Chọn tour --</option>`;
  data.forEach(t => {
    tourSelect.innerHTML += `<option value="${t.id}">${t.name}</option>`;
  });
}

assignForm.addEventListener("submit", async e => {
  e.preventDefault();
  if (assigning) return;
  assigning = true;

  const tour_id = tourSelect.value;

  if (!tour_id || !selectedImageId) {
    assigning = false;
    return;
  }

  try {
    await fetch(`${TOUR_IMG_URL}/assignments`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ tour_id, tour_img_id: selectedImageId }),
    });

    bootstrap.Modal.getInstance(document.getElementById("assignModal")).hide();
    loadAssignments();
    selectedImageId = null;

  } finally {
    assigning = false;
  }
});

async function deleteAssignment(id) {
  await fetch(`${TOUR_IMG_URL}/assignments/${id}`, { method: "DELETE" });
  loadAssignments();
}

document.addEventListener("DOMContentLoaded", () => {
  loadTours();
  loadAssignments();

  setTimeout(createFolderDropdownForAssign, 500);
});
