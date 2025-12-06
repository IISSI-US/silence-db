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
    return this.generateCard(user, { editMode: false });
  },

  asEditPage(user, userHobbyLinks, allHobbies) {
    const userCardHtml = this.generateCard(user, {
      editMode: true,
      userHobbyLinks
    }).outerHTML;

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

  generateCard(user, options = {}) {
    const { editMode = false, userHobbyLinks = [] } = options;
    const hobbiesHtml = this.generateHobbiesHtml(user, editMode, userHobbyLinks);
    const wrapperClass = editMode ? "col-md-6 mx-auto" : "col-md-4 col-sm-6";
    const cardContent = editMode ? "" : `onmouseover="this.style.backgroundColor='#f8f9fa'; this.style.transform='scale(1.02)'" onmouseout="this.style.backgroundColor=''; this.style.transform=''"`;
    const linkStart = editMode ? "" : `<a class="text-decoration-none text-dark" href="updateHobby.html?user_id=${user.user_id}">`;
    const linkEnd = editMode ? "" : `</a>`;

    const html = `
    <div class="${wrapperClass}">
      ${linkStart}
        <div class="card mb-3" ${cardContent}>
          <div class="row g-0">
            <div class="col-md-4">
              <img src="/images/${user.avatar_url}" class="rounded-circle mx-auto d-block ${editMode ? 'mt-3' : ''}" ${editMode ? 'style="width: 100px; height: 100px;"' : ''} alt="Avatar de ${user.full_name}">
            </div>
            <div class="col-md-8">
              <div class="card-body">
                <h5 class="card-title">${user.full_name}</h5>
                <p class="card-text">
                  <span class="badge bg-secondary">${user.gender}</span><br>
                  <strong>${user.age} años</strong><br>
                  ${user.email}<br>
                  ${editMode ? '<small class="text-muted">Aficiones (click para eliminar):</small><br>' : '<small>'}
                  ${hobbiesHtml}
                  ${editMode ? '' : '</small>'}
                </p>
              </div>
            </div>
          </div>
        </div>
      ${linkEnd}
    </div>`;

    return parseHTML(html);
  },

  generateHobbiesHtml(user, editMode, userHobbyLinks) {
    if (editMode) {
      if (userHobbyLinks.length === 0) {
        return '<span class="text-muted">Sin aficiones</span>';
      }
      return userHobbyLinks.map(link =>
        `<span class="badge bg-primary me-1 hobby-badge" 
               data-link-id="${link.user_hobby_id}" 
               style="cursor: pointer;" 
               title="Click para eliminar">${link.hobby_name} ×</span>`
      ).join('');
    } else {
      return user.hobbies.map(hobby =>
        `<span class="badge bg-primary me-1">${hobby.hobby_name}</span>`
      ).join('');
    }
  }
};

export { hobbiesRenderer };
