"use strict";

import { user_hobby_linksAPI_auto } from "/js/api/_user_hobby_links.js";
import { v_user_hobbiesAPI_auto } from "/js/api/_v_user_hobbies.js";
import { messageRenderer } from "/js/renderers/messages.js";
import { hobbiesRenderer } from "/js/renderers/hobbiesRenderer.js";

document.addEventListener("DOMContentLoaded", main);

async function main() {
  const userId = new URLSearchParams(window.location.search).get("user_id");

  if (userId) {
    await loadAndRender(userId);
  } else {
    messageRenderer.showErrorMessage("Falta el parámetro user_id en la URL");
  }
}

async function loadAndRender(userId) {
  try {
    const viewData = await v_user_hobbiesAPI_auto.getAll();
    const userRows = viewData.filter(row => row.user_id === Number(userId));

    if (userRows.length === 0) {
      messageRenderer.showErrorMessage("Usuario no encontrado");
      return;
    }

    // Build user object with hobbies
    const user = {
      user_id: userRows[0].user_id,
      full_name: userRows[0].full_name,
      email: userRows[0].email,
      age: userRows[0].age,
      gender: userRows[0].gender,
      avatar_url: userRows[0].avatar_url,
      hobbies: userRows.map(row => ({
        user_hobby_id: row.user_hobby_id,
        hobby_id: row.hobby_id,
        hobby_name: row.hobby_name
      }))
    };

    const wrapper = document.getElementById("wrapper");
    wrapper.innerHTML = "";

    const pageContent = hobbiesRenderer.asEditPage(user, user.hobbies, []);
    wrapper.appendChild(pageContent);

    wireEvents(userId);
  } catch (err) {
    messageRenderer.showErrorMessage("No se han podido cargar los datos del usuario", err);
  }
}

function wireEvents(userId) {
  // Wire hobby badges for deletion
  const hobbyBadges = document.querySelectorAll(".hobby-badge");
  hobbyBadges.forEach(badge => {
    badge.addEventListener("click", () => {
      const linkId = badge.dataset.linkId;
      const hobbyName = badge.textContent.replace(' ×', '').trim();
      if (confirm(`¿Eliminar la afición "${hobbyName}"?`)) {
        onDelete(linkId, userId);
      }
    });
  });

  // Wire back button
  const back = document.getElementById("back-button");
  if (back) {
    back.addEventListener("click", () => {
      window.location.href = "index.html";
    });
  }
}

async function onDelete(linkId, userId) {
  try {
    await user_hobby_linksAPI_auto.delete(linkId);
    await loadAndRender(userId);
    messageRenderer.showSuccessMessage("Afición eliminada del usuario");
  } catch (err) {
    messageRenderer.showErrorMessage("No se ha podido eliminar la afición", err);
  }
}
