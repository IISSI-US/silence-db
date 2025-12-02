"use strict";

import { v_user_hobbiesAPI_auto } from "/js/api/_v_user_hobbies.js";
import { messageRenderer } from "/js/renderers/messages.js";
import { hobbiesRenderer } from "/js/renderers/hobbiesRenderer.js";

document.addEventListener("DOMContentLoaded", loadAndRender);

async function loadAndRender() {
  try {
    const data = await v_user_hobbiesAPI_auto.getAll();
    const groupedUsers = groupUsersWithHobbies(data);
    const wrapper = document.getElementById("wrapper");
    wrapper.replaceChildren(hobbiesRenderer.asCards(groupedUsers));
  } catch (err) {
    messageRenderer.showErrorMessage("No se han podido obtener los usuarios", err);
  }
}

function groupUsersWithHobbies(data) {
  const users = [];

  for (const item of data) {
    let user = users.find((u) => u.user_id === item.user_id);
    if (!user) {
      user = {
        user_id: item.user_id,
        full_name: item.full_name,
        avatar_url: item.avatar_url,
        email: item.email,
        gender: item.gender,
        age: item.age,
        hobbies: []
      };
      users.push(user);
    }

    user.hobbies.push({
      hobby_id: item.hobby_id,
      hobby_name: item.hobby_name
    });
  }

  return users;
}
