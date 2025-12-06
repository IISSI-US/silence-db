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
    // PASO 1: Obtener datos de la vista desnormalizada
    // La vista incluye user_hobby_id necesario para poder borrar
    const viewData = await v_user_hobbiesAPI_auto.getAll();
    const userRows = viewData.filter(row => row.user_id === Number(userId));

    if (userRows.length === 0) {
      messageRenderer.showErrorMessage("Usuario no encontrado");
      return;
    }

    // PASO 2: Construir objeto de usuario con sus aficiones
    // Tomamos los datos del usuario de la primera fila (todos iguales)
    const user = {
      user_id: userRows[0].user_id,
      full_name: userRows[0].full_name,
      email: userRows[0].email,
      age: userRows[0].age,
      gender: userRows[0].gender,
      avatar_url: userRows[0].avatar_url,
      // Mapeamos cada fila a un objeto de hobby con user_hobby_id para poder borrar
      hobbies: userRows.map(row => ({
        user_hobby_id: row.user_hobby_id,  // ID del link (necesario para DELETE)
        hobby_id: row.hobby_id,
        hobby_name: row.hobby_name
      }))
    };

    // PASO 3: Renderizar la tarjeta editable
    const wrapper = document.getElementById("wrapper");
    wrapper.innerHTML = "";

    const pageContent = hobbiesRenderer.asEditCard(user, user.hobbies);
    wrapper.appendChild(pageContent);

    // PASO 4: Conectar eventos (clicks en badges para borrar)
    wireEvents(userId);
  } catch (err) {
    messageRenderer.showErrorMessage("No se han podido cargar los datos del usuario", err);
  }
}

function wireEvents(userId) {
  // Conectar badges de aficiones para borrado
  const hobbyBadges = document.querySelectorAll(".hobby-badge");
  hobbyBadges.forEach(badge => {
    badge.addEventListener("click", () => {
      const linkId = badge.dataset.linkId;  // Obtenemos el user_hobby_id del atributo data
      const hobbyName = badge.textContent.replace(' ×', '').trim();
      if (confirm(`¿Eliminar la afición "${hobbyName}"?`)) {
        onDelete(linkId, userId);
      }
    });
  });

  // Conectar botón de volver
  const back = document.getElementById("back-button");
  if (back) {
    back.addEventListener("click", () => {
      window.location.href = "index.html";
    });
  }
}

async function onDelete(linkId, userId) {
  try {
    // OPERACIÓN DELETE: Eliminar el link usuario-afición
    await user_hobby_linksAPI_auto.delete(linkId);

    // Recargar los datos para reflejar el cambio
    await loadAndRender(userId);

    messageRenderer.showSuccessMessage("Afición eliminada del usuario");
  } catch (err) {
    messageRenderer.showErrorMessage("No se ha podido eliminar la afición", err);
  }
}
