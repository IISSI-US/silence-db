"use strict";

import { parseHTML } from "/js/utils/parseHTML.js";

const hobbiesRenderer = {
  asCards: function (users) {
    let html = "";
    for (const u of users) {
      const cardNode = this.asCard(u);
      html += cardNode.outerHTML;
    }
    return parseHTML(`<div class="row">${html}</div>`);
  },

  asCard: function (user) {
    // Crear lista de hobbies
    let hobbiesHtml = "";
    for (const h of user.hobbies) {
      hobbiesHtml += `<span class="badge bg-primary me-1">${h.hobby}</span>`;
    }

    const html = `<div class="col-md-4 col-sm-6">
      <div class="card mb-3" onmouseover="this.style.backgroundColor='#f8f9fa'; this.style.transform='scale(1.02)'" onmouseout="this.style.backgroundColor=''; this.style.transform=''">
        <div class="row g-0">
          <div class="col-md-4">
            <img src="/images/${user.avatar_url}" class="rounded-circle mx-auto d-block" alt="Avatar de ${user.full_name}">
          </div>
          <div class="col-md-8">
            <div class="card-body">
              <h5 class="card-title">${user.full_name}</h5>
              <p class="card-text">
                <span class="badge bg-secondary">${user.gender}</span><br>
                <strong>${user.age} años</strong> <br>
                ${user.email}<br>
                <small>${hobbiesHtml}</small>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>`;
    return parseHTML(html);
  }

};

export { hobbiesRenderer };
