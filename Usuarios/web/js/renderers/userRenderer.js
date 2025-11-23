"use strict";

import { parseHTML } from "/js/utils/parseHTML.js";

const userRenderer = {
  asTabular: function (users) {
    let html = `<div class="row fw-bold bg-light py-2 border-bottom">
      <div class="col">ID</div>
      <div class="col">Nombre completo</div>
      <div class="col">Género</div>
      <div class="col">Edad</div>
      <div class="col">Email</div>
    </div>`;
    for (const u of users) {
      html += `<div class="row py-2 border-bottom" onmouseover="this.style.backgroundColor='#f8f9fa'" onmouseout="this.style.backgroundColor=''">
        <div class="col">${u.user_id}</div>
        <div class="col">${u.full_name}</div>
        <div class="col">${u.gender}</div>
        <div class="col">${u.age}</div>
        <div class="col">${u.email}</div>
      </div>`;
    }
    return parseHTML(`<div class="container-fluid">${html}</div>`);
  },

  asCards: function (users) {
    let html = "";
    for (const u of users) {
      html += `<div class="col-md-4 col-sm-6">
        <div class="card h-100" onmouseover="this.style.backgroundColor='#f8f9fa'; this.style.transform='scale(1.02)'" onmouseout="this.style.backgroundColor=''; this.style.transform=''">
          <img src="/images/${u.avatar_url}" class="rounded-circle mx-auto d-block" style="width: 80px; height: 80px;" alt="Avatar de ${u.full_name}">
          <div class="card-body text-center">
            <h5 class="card-title">${u.full_name}</h5>
            <p class="card-text">
              <span class="badge bg-secondary">${u.gender}</span><br>
              <strong>${u.age} años</strong> <br>
              ${u.email}
            </p>
          </div>
        </div>
      </div>`;
    }
    return parseHTML(`<div class="row g-3">${html}</div>`);
  }
};

export { userRenderer };
