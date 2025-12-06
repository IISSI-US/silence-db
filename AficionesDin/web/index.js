"use strict";

import { v_user_hobbiesAPI_auto } from "/js/api/_v_user_hobbies.js";
import { messageRenderer } from "/js/renderers/messages.js";
import { hobbiesRenderer } from "/js/renderers/hobbiesRenderer.js";

document.addEventListener("DOMContentLoaded", main);

async function main() {
  try {
    // PASO 1: Obtener datos de la vista desnormalizada
    // La vista v_user_hobbies devuelve una fila por cada combinación usuario-afición
    const viewData = await v_user_hobbiesAPI_auto.getAll();

    // PASO 2: Agrupar datos por usuario (procesamiento en cliente)
    // Convertimos las filas de la vista en objetos de usuario con arrays de hobbies
    const usersWithHobbies = groupUserHobbies(viewData);

    // PASO 3: Renderizar usando el renderizador reutilizable
    renderUsers(usersWithHobbies);
  } catch (err) {
    messageRenderer.showErrorMessage("No se han podido cargar los datos", err);
  }
}

function groupUserHobbies(viewData) {
  const users = [];

  // Recorremos cada fila de la vista
  for (const row of viewData) {
    // Buscamos si ya tenemos este usuario en el array
    let user = users.find(u => u.user_id === row.user_id);

    // Si no existe, lo creamos
    if (!user) {
      user = {
        user_id: row.user_id,
        full_name: row.full_name,
        email: row.email,
        age: row.age,
        gender: row.gender,
        avatar_url: row.avatar_url,
        hobbies: []
      };
      users.push(user);
    }

    // Añadimos la afición al array de hobbies del usuario
    user.hobbies.push({
      hobby_id: row.hobby_id,
      hobby_name: row.hobby_name
    });
  }

  return users;
}

function renderUsers(users) {
  const container = document.getElementById("users-container");
  container.innerHTML = "";
  const cardsElement = hobbiesRenderer.asCards(users);
  container.appendChild(cardsElement);
}
