async function loadUsers() {
    try {
      const res = await fetch('http://localhost:3000/api/profile/all');
      const data = await res.json();
      const tbody = document.getElementById('userTableBody');
      tbody.innerHTML = '';
  
      if (data.success && data.data.length) {
        data.data.forEach(u => {
          tbody.innerHTML += `
            <tr>
              <td>${u.user_id}</td>
              <td>${u.user_name}</td>
              <td>${u.email}</td>
              <td>${u.phone || ''}</td>
              <td>${u.dob || ''}</td>
              <td>${u.citizen_id || ''}</td>
              <td>${u.address || ''}</td>
              <td>${u.avatar ? `<img src="${u.avatar}" width="50" height="50" class="rounded-circle">` : ''}</td>
              <td>${u.background ? `<img src="${u.background}" width="80" height="50" class="rounded">` : ''}</td>
              <td>${u.bio || ''}</td>
            </tr>`;
        });
      } else {
        tbody.innerHTML = `<tr><td colspan="10" class="text-center text-danger">Không có người dùng nào.</td></tr>`;
      }
    } catch (err) {
      console.error(err);
      document.getElementById('userTableBody').innerHTML =
        `<tr><td colspan="10" class="text-center text-danger">Lỗi tải dữ liệu!</td></tr>`;
    }
  }
  
  document.addEventListener('DOMContentLoaded', loadUsers);
  