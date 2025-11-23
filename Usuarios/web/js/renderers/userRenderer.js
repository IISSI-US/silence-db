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
          <div class="card-body">
            <h5 class="card-title">${u.full_name}</h5>
            <p class="card-text">
              <strong>ID:</strong> ${u.user_id}<br>
              <strong>Género:</strong> ${u.gender}<br>
              <strong>Edad:</strong> ${u.age}<br>
              <strong>Email:</strong> ${u.email}
            </p>
          </div>
        </div>
      </div>`;
    }
    return parseHTML(`<div class="row g-3">${html}</div>`);
  }
};

export { userRenderer };
