// admin\js\tour_folders.js

const TOUR_IMG_URL = API.TOUR_IMAGES;
const TOUR_URL = API.TOURS;

const folderBody = document.getElementById("folderTableBody");
const folderForm = document.getElementById("folderForm");
const uploadForm = document.getElementById("uploadForm");
const folderSelect = document.getElementById("folderSelect");

let uploading = false;
let creatingFolder = false;

function fixModalCloseButtons() {
  document.querySelectorAll("form .btn-close, form button[data-bs-dismiss='modal']")
    .forEach(btn => { btn.type = "button"; });
}
fixModalCloseButtons();

function escapeHtml(str) {
  return (str + "").replace(/'/g, "\\'").replace(/"/g, '\\"');
}

async function loadFolders() {
  try {
    const res = await fetch(`${TOUR_IMG_URL}/folders`);
    const data = await res.json();

    window.__folderList = data;

    folderBody.innerHTML = "";
    folderSelect.innerHTML = `<option value="">-- Chọn thư mục --</option>`;

    if (!Array.isArray(data) || data.length === 0) {
      folderBody.innerHTML = `<tr><td colspan="4" class="text-center">Không có thư mục</td></tr>`;
      return;
    }

    data.forEach(f => {
      const imgs = f.images && f.images.length
        ? f.images.map(img =>
            `<img src="${img.tour_img}" width="60" class="m-1 rounded shadow-sm">`
          ).join("")
        : `<span class="text-muted fst-italic">Không có ảnh</span>`;

      folderBody.innerHTML += `
        <tr>
          <td>${f.folder_id}</td>
          <td>${f.folder_name}</td>
          <td>${imgs}</td>
          <td>
            <button class="btn btn-sm btn-secondary" type="button"
              onclick="openUpload(${f.folder_id}, '${escapeHtml(f.folder_name)}')">+ Ảnh</button>
          </td>
        </tr>
      `;

      folderSelect.innerHTML += `
        <option value="${f.folder_id}" data-name="${escapeHtml(f.folder_name)}">
          ${f.folder_name}
        </option>`;
    });

    loadImages(data);

  } catch (err) {
    folderBody.innerHTML = `<tr><td colspan="4" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>`;
  }
}

function loadImages(folderData) {
  window.__imageList = [];

  folderData.forEach(folder => {
    folder.images.forEach(img => {
      window.__imageList.push({
        id: img.tour_img_id,
        url: img.tour_img,
        folder_id: folder.folder_id,
        folder: folder.folder_name
      });
    });
  });
}

function openUpload(id, name) {
  folderSelect.value = id;
  folderSelect.dataset.name = name;
  new bootstrap.Modal(document.getElementById("uploadModal")).show();
}

folderForm.addEventListener("submit", async e => {
  e.preventDefault();
  if (creatingFolder) return;
  creatingFolder = true;

  const folder_name = document.getElementById("folder_name").value.trim();
  if (!folder_name) {
    creatingFolder = false;
    return;
  }

  try {
    await fetch(`${TOUR_IMG_URL}/folders`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ folder_name }),
    });

    folderForm.reset();
    bootstrap.Modal.getInstance(document.getElementById("folderModal")).hide();
    loadFolders();

  } finally {
    creatingFolder = false;
  }
});

uploadForm.addEventListener("submit", async e => {
  e.preventDefault();
  if (uploading) return;
  uploading = true;

  const files = uploadForm.querySelector('input[name="tour_images"]').files;
  if (!files.length) {
    uploading = false;
    return;
  }

  const folder_id = folderSelect.value;
  const folder_name = folderSelect.options[folderSelect.selectedIndex].dataset.name;

  const fd = new FormData();
  for (let file of files) fd.append("tour_images", file);
  fd.append("folder_id", folder_id);

  try {
    await fetch(`${TOUR_IMG_URL}/upload?folder_name=${encodeURIComponent(folder_name)}`, {
      method: "POST",
      body: fd,
    });

    uploadForm.reset();
    bootstrap.Modal.getInstance(document.getElementById("uploadModal")).hide();
    loadFolders();

  } finally {
    uploading = false;
  }
});

document.addEventListener("DOMContentLoaded", () => {
  loadFolders();
});
