"use strict";

import { parseHTML } from "/js/utils/parseHTML.js";
import { userRenderer } from "/js/renderers/userRenderer.js";
import { formRenderer } from "/js/renderers/formRenderer.js";

const hobbiesRenderer = {
  asCards(users) {
    let html = "";
    for (const user of users) {
      html += userRenderer.asCard(user).outerHTML;
    }
    return parseHTML(`<div class="row">${html}</div>`);
  },

  asEditPage(user, userHobbyLinks, allHobbies) {
    // Use the existing card renderer but modify it for edit mode
    const userCardHtml = this.generateEditCard(user, userHobbyLinks, allHobbies);

    const html = `
    <div>
      <div class="d-flex justify-content-between align-items-center mb-3">
        <button id="back-button" class="btn btn-outline-secondary">&larr; Volver</button>
        <div id="errors" class="mb-0"></div>
      </div>
      ${userCardHtml}
    </div>`;

    return parseHTML(html);
  },

  generateEditCard(user, userHobbyLinks, allHobbies) {
    let hobbiesHtml = "";

    if (userHobbyLinks.length === 0) {
      hobbiesHtml = '<span class="text-muted">Sin aficiones</span>';
    } else {
      for (const link of userHobbyLinks) {
        const hobby = allHobbies.find(h => h.hobby_id === link.hobby_id);
        const hobbyName = hobby ? hobby.hobby_name : "Desconocido";
        hobbiesHtml += `<span class="badge bg-primary me-1 hobby-badge" 
                             data-link-id="${link.user_hobby_id}" 
                             style="cursor: pointer;" 
                             title="Click para eliminar">${hobbyName} ×</span>`;
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

    return html;
  }
};

export { hobbiesRenderer };
