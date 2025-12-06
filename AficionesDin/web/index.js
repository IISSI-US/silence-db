"use strict";

import { v_user_hobbiesAPI_auto } from "/js/api/_v_user_hobbies.js";
import { messageRenderer } from "/js/renderers/messages.js";
import { hobbiesRenderer } from "/js/renderers/hobbiesRenderer.js";

document.addEventListener("DOMContentLoaded", main);

async function main() {
  try {
    const viewData = await v_user_hobbiesAPI_auto.getAll();
    const usersWithHobbies = groupUserHobbies(viewData);
    renderUsers(usersWithHobbies);
  } catch (err) {
    messageRenderer.showErrorMessage("No se han podido cargar los datos", err);
  }
}

function groupUserHobbies(viewData) {
  const users = [];

  for (const row of viewData) {
    let user = users.find(u => u.user_id === row.user_id);

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
