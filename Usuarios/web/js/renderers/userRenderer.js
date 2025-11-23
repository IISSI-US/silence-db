"use strict";

import { parseHTML } from "/js/utils/parseHTML.js";

const userRenderer = {
  asTable: function (users) {
    let rows = "";
    for (const u of users) {
      rows += `<tr>
        <th scope="row">${u.user_id}</th>
        <td>${u.full_name}</td>
        <td>${u.gender}</td>
        <td>${u.age}</td>
        <td>${u.email}</td>
      </tr>`;
    }

    return parseHTML(
      `<table class="table table-hover align-middle" id="users-table">
        <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Nombre completo</th>
            <th>Género</th>
            <th>Edad</th>
            <th>Email</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`
    );
  },

  asCards: function (users) {
    let html = "";
    for (const u of users) {
      html += `<div class="col-md-4 col-sm-6">
        <div class="card h-100">
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
