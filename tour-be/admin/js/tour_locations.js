// admin/js/tour_locations.js
let MAPBOX_TOKEN = null;

async function loadMapboxToken() {
  const res = await fetch(`${BASE_API}/mapbox/token`);
  const json = await res.json();
  MAPBOX_TOKEN = json.token;
  mapboxgl.accessToken = MAPBOX_TOKEN;
}

let mapModal = null;
let marker = null;
let editingId = null;
let searchBox = null;

const modalEl = document.getElementById("locationModal");
const bootstrapModal = new bootstrap.Modal(modalEl);
const formEl = document.getElementById("locationForm");
const saveBtn = document.getElementById("saveBtn");
const addBtn = document.getElementById("btnAdd");

async function loadTours() {
  const res = await fetch(API.TOURS);
  const tours = await res.json();
  const select = document.getElementById("tourSelect");

  select.innerHTML = `<option value="">-- Chọn tour --</option>`;
  tours.forEach((t) => {
    select.innerHTML += `<option value="${t.id}">${t.name}</option>`;
  });
}

async function loadLocations() {
  const res = await fetch(API.TOUR_LOCATIONS);
  const json = await res.json();
  const tbody = document.getElementById("locationTableBody");

  tbody.innerHTML = "";

  (json.data || []).forEach((loc) => {
    tbody.innerHTML += `
      <tr>
        <td>${loc.location_id}</td>
        <td>${loc.tour_name}</td>
        <td>${loc.location_name}</td>
        <td>${loc.description || ""}</td>
        <td>${loc.latitude}</td>
        <td>${loc.longitude}</td>
        <td class="text-nowrap">
          <button class="btn btn-warning btn-sm me-2"
              onclick="editLocation(${loc.location_id}, ${loc.tour_id}, '${loc.location_name.replace(/'/g, "\\'")}', '${(loc.description || '').replace(/'/g, "\\'")}', ${loc.latitude}, ${loc.longitude})">
              Sửa
          </button>
          <button class="btn btn-danger btn-sm"
              onclick="deleteLocation(${loc.location_id})">
              Xóa
          </button>
        </td>
      
      </tr>
    `;
  });
}

async function fetchPlaceName(lat, lng) {
  const url = `https://api.mapbox.com/geocoding/v5/mapbox.places/${lng},${lat}.json?access_token=${MAPBOX_TOKEN}`;
  const r = await fetch(url);
  const j = await r.json();
  return j.features?.[0]?.place_name || "";
}

function initMap() {
  if (mapModal) return;

  mapModal = new mapboxgl.Map({
    container: "mapModal",
    style: "mapbox://styles/mapbox/streets-v12",
    center: [108.206, 16.047],
    zoom: 12,
  });

  mapModal.on("click", async (e) => {
    const { lng, lat } = e.lngLat;
    setMarker(lat, lng);

    document.getElementById("latitude").value = lat;
    document.getElementById("longitude").value = lng;

    const place = await fetchPlaceName(lat, lng);
    if (place) document.getElementById("locationName").value = place;
  });

  initSearchBox();
}

function initSearchBox() {
  if (searchBox) return;

  searchBox = new MapboxSearchBox();
  searchBox.accessToken = MAPBOX_TOKEN;

  searchBox.options = {
    types: "place,address,poi",
    proximity: null,
    country: null,
    limit: 10,
    language: "vi,en"
  };

  searchBox.mapboxgl = mapboxgl;
  searchBox.marker = false;

  const box = document.getElementById("mapSearchBox");
  box.appendChild(searchBox);

  searchBox.sessionToken = null;

  searchBox.addEventListener("retrieve", (e) => {

    searchBox.sessionToken = null;

    const f = e.detail.features?.[0];
    if (!f) return;

    const [lng, lat] = f.geometry.coordinates;

    setMarker(lat, lng);
    mapModal.flyTo({ center: [lng, lat], zoom: 14 });

    document.getElementById("latitude").value = lat;
    document.getElementById("longitude").value = lng;

    const placeName =
      f.place_name || f.text || f.properties?.name || `${lat}, ${lng}`;
    document.getElementById("locationName").value = placeName;
  });
}


function setMapPosition(lat, lng) {
  mapModal.setCenter([lng, lat]);
  mapModal.setZoom(14);
}

function setMarker(lat, lng) {
  if (marker) marker.remove();
  marker = new mapboxgl.Marker().setLngLat([lng, lat]).addTo(mapModal);
}

function openForm() {
  editingId = null;
  document.getElementById("formTitle").innerText = "Thêm địa điểm";

  document.getElementById("editId").value = "";
  document.getElementById("tourSelect").value = "";
  document.getElementById("locationName").value = "";
  document.getElementById("description").value = "";
  document.getElementById("latitude").value = "";
  document.getElementById("longitude").value = "";

  bootstrapModal.show();

  modalEl.addEventListener(
    "shown.bs.modal",
    () => {
      initMap();
      setMapPosition(16.047, 108.206);
      if (marker) marker.remove();
    },
    { once: true }
  );
}

window.editLocation = function (id, tour_id, name, desc, lat, lng) {
  editingId = id;

  document.getElementById("formTitle").innerText = "Sửa địa điểm";

  document.getElementById("editId").value = id;
  document.getElementById("tourSelect").value = tour_id;
  document.getElementById("locationName").value = name || "";
  document.getElementById("description").value = desc || "";
  document.getElementById("latitude").value = lat;
  document.getElementById("longitude").value = lng;

  bootstrapModal.show();

  modalEl.addEventListener(
    "shown.bs.modal",
    () => {
      initMap();
      setMapPosition(lat, lng);
      setMarker(lat, lng);
    },
    { once: true }
  );
};

formEl.addEventListener("submit", async (e) => {
  e.preventDefault();

  saveBtn.disabled = true;
  saveBtn.innerText = "Đang lưu...";

  const payload = {
    tour_id: document.getElementById("tourSelect").value,
    location_name: document.getElementById("locationName").value,
    description: document.getElementById("description").value,
    latitude: parseFloat(document.getElementById("latitude").value),
    longitude: parseFloat(document.getElementById("longitude").value),
  };

  const id = document.getElementById("editId").value;
  const url = id ? `${API.TOUR_LOCATIONS}/${id}` : API.TOUR_LOCATIONS;
  const method = id ? "PUT" : "POST";

  await fetch(url, {
    method,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  bootstrapModal.hide();
  loadLocations();

  saveBtn.disabled = false;
  saveBtn.innerText = "Lưu";
});

window.deleteLocation = async function (id) {
  if (!confirm("Bạn có chắc chắn muốn xóa?")) return;
  await fetch(`${API.TOUR_LOCATIONS}/${id}`, { method: "DELETE" });
  loadLocations();
};

document.addEventListener("DOMContentLoaded", async () => {
  addBtn.addEventListener("click", openForm);
  await loadTours();
  await loadMapboxToken();
  await loadLocations();
});
