"use strict";

import { parseHTML } from "/js/utils/parseHTML.js";

const hobbiesRenderer = {
  asCards(users) {
    let html = "";
    for (const user of users) {
      html += this.asCard(user).outerHTML;
    }
    return parseHTML(`<div class="row">${html}</div>`);
  },

  asCard(user) {
    let hobbiesHtml = "";
    for (const hobby of user.hobbies) {
      hobbiesHtml += `<span class="badge bg-primary me-1">${hobby.hobby_name}</span>`;
    }

    const html = `
    <div class="col-md-4 col-sm-6">
      <a class="text-decoration-none text-dark" href="updateHobby.html?user_id=${user.user_id}">
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
                  <strong>${user.age} años</strong><br>
                  ${user.email}<br>
                  <small>${hobbiesHtml}</small>
                </p>
              </div>
            </div>
          </div>
        </div>
      </a>
    </div>`;

    return parseHTML(html);
  },

  asEditCard(user, userHobbyLinks) {
    let hobbiesHtml = "";

    if (userHobbyLinks.length === 0) {
      hobbiesHtml = '<span class="text-muted">Sin aficiones</span>';
    } else {
      for (const link of userHobbyLinks) {
        hobbiesHtml += `<span class="badge bg-primary me-1 hobby-badge" 
                             data-link-id="${link.user_hobby_id}" 
                             style="cursor: pointer;" 
                             title="Click para eliminar">${link.hobby_name} ×</span>`;
      }
    }

    const html = `
    <div class="col-md-6 mx-auto">
      <div class="card mb-3">
        <div class="row g-0">
          <div class="col-md-4">
            <img src="/images/${user.avatar_url}" class="rounded-circle mx-auto d-block mt-3" style="width: 100px; height: 100px;" alt="Avatar de ${user.full_name}">
          </div>
          <div class="col-md-8">
            <div class="card-body">
              <h5 class="card-title">${user.full_name}</h5>
              <p class="card-text">
                <span class="badge bg-secondary">${user.gender}</span><br>
                <strong>${user.age} años</strong><br>
                ${user.email}<br>
                <small class="text-muted">Aficiones (click para eliminar):</small><br>
                ${hobbiesHtml}
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
