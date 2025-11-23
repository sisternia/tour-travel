const guideTableBody = document.getElementById("guideTableBody");
const guideForm = document.getElementById("guideForm");
const editGuideId = document.getElementById("editGuideId");

// Modal
const guideModalEl = document.getElementById("addGuideModal");
const guideModal = new bootstrap.Modal(guideModalEl);

let guides = [];
function formatDateDisplay(dateStr) {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  const d = String(date.getDate()).padStart(2, "0");
  const m = String(date.getMonth() + 1).padStart(2, "0");
  const y = date.getFullYear();
  return `${d}/${m}/${y}`;
}

async function loadGuides() {
  try {
    const res = await fetch(API.TOUR_GUIDES);
    guides = await res.json();

    if (guides.length === 0) {
      guideTableBody.innerHTML = `<tr><td colspan="10" class="text-center">Chưa có dữ liệu</td></tr>`;
      return;
    }

    guideTableBody.innerHTML = guides
      .map(
        (g) => `
      <tr>
        <td>${g.guide_id}</td>
        <td>${g.guide_name}</td>
        <td>${g.email}</td>
        <td>${g.phone}</td>
        <td>${formatDateDisplay(g.birthday)}</td>

        <td>${g.gender || ""}</td>
        <td>${g.language_job || ""}</td>

        <td>${
          g.certification
            ? `<img src="${g.certification}" width="50" height="50" style="object-fit:cover;border-radius:6px">`
            : ""
        }</td>

        <td>${g.address || ""}</td>

        <td>${
          g.avatar_image
            ? `<img src="${g.avatar_image}" width="50" height="50" style="object-fit:cover;border-radius:6px">`
            : ""
        }</td>

        <td>
          <button class="btn btn-warning btn-sm" onclick="editGuide(${
            g.guide_id
          })"> <i class="bi bi-pencil-square"></i> </button>
          <button class="btn btn-sm btn-danger" onclick="deleteGuide(${
            g.guide_id
          })"> <i class="bi bi-trash"></i> </button>
        </td>
      </tr>
    `
      )
      .join("");
  } catch (err) {
    console.error(err);
  }
}

function mapGender(value) {
  switch (value) {
    case "Nam":
      return "male";
    case "Nữ":
      return "female";
    case "Khác":
      return "other";
    default:
      return null;
  }
}

guideForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const formData = new FormData();
  formData.append("guide_name", document.getElementById("guide_name").value);
  formData.append("email", document.getElementById("email").value);
  formData.append("phone", document.getElementById("phone").value);
  formData.append("birthday", document.getElementById("birthday").value || "");
  formData.append("gender", mapGender(document.getElementById("gender").value));
  formData.append(
    "language_job",
    document.getElementById("language_job").value || ""
  );
  formData.append("address", document.getElementById("address").value || "");
  const avatarFile = document.getElementById("avatar_image").files[0];
  if (avatarFile) formData.append("avatar", avatarFile);
  const certFiles = document.getElementById("certification").files;
  for (let i = 0; i < certFiles.length; i++) {
    formData.append("certificates", certFiles[i]);
  }

  const id = editGuideId.value;

  try {
    let res;
    if (id) {
      res = await fetch(`${API.TOUR_GUIDES}/${id}`, {
        method: "PUT",
        body: formData,
      });
    } else {
      res = await fetch(API.TOUR_GUIDES, {
        method: "POST",
        body: formData,
      });
    }

    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Lỗi server");

    guideModal.hide();
    guideForm.reset();
    editGuideId.value = "";
    loadGuides();
  } catch (err) {
    console.error(err);
    alert(err.message);
  }
});

function formatDateForInput(dateStr) {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  return date.toISOString().split("T")[0];
}

function editGuide(id) {
  const guide = guides.find((g) => g.guide_id === id);
  if (!guide) return;

  document.getElementById("guide_name").value = guide.guide_name;
  document.getElementById("email").value = guide.email;
  document.getElementById("phone").value = guide.phone;
  document.getElementById("birthday").value = formatDateForInput(
    guide.birthday
  );
  document.getElementById("gender").value = guide.gender || "";
  document.getElementById("language_job").value = guide.language_job || "";
  document.getElementById("address").value = guide.address || "";
  document.getElementById("avatar_image").value = "";
  document.getElementById("certification").value = "";

  editGuideId.value = guide.guide_id;
  guideModal.show();
}

async function deleteGuide(id) {
  if (!confirm("Bạn có chắc muốn xóa hướng dẫn viên này?")) return;

  try {
    const res = await fetch(`${API.TOUR_GUIDES}/${id}`, { method: "DELETE" });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Lỗi server");
    loadGuides();
  } catch (err) {
    console.error(err);
    alert(err.message);
  }
}

window.addEventListener("DOMContentLoaded", loadGuides);
