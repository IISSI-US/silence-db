"use strict";

import { parseHTML } from "/js/utils/parseHTML.js";

const userRenderer = {
    asCard(user) {
        let hobbiesHtml = "";
        for (const hobby of user.hobbies) {
            hobbiesHtml += `<span class="badge bg-primary me-1">${hobby.hobby_name}</span>`;
        }

        const html = `<div class="col-md-4 col-sm-6">
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
                  <strong>${user.age} años</strong> <br>
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

    asDetails(user) {
        const html = `
    <div class="card shadow-sm mb-3">
      <div class="card-body d-flex align-items-center">
        <img id="user-avatar" src="/images/${user.avatar_url}" class="rounded-circle me-3" style="width: 72px; height: 72px;" alt="Avatar de ${user.full_name}">
        <div>
          <h5 id="user-name" class="mb-1">${user.full_name}</h5>
          <div id="user-meta" class="text-muted small">${user.gender} · ${user.age} años</div>
          <div id="user-email" class="small">${user.email}</div>
        </div>
      </div>
    </div>`;
        return parseHTML(html);
    }
};

export { userRenderer };
