"use strict";

import { v_user_hobbiesAPI_auto } from "/js/api/_v_user_hobbies.js";
import { messageRenderer } from "/js/renderers/messages.js";
import { hobbiesRenderer } from "/js/renderers/hobbiesRenderer.js";


document.addEventListener("DOMContentLoaded", main);

function main() {
    loadData();
}


async function loadData() {
    try {
        const data = await v_user_hobbiesAPI_auto.getAll();
        const groupedData = groupUsersWithHobbies(data);
        const wrapper = document.getElementById("wrapper");
        wrapper.innerHTML = "";
        let node;
        node = hobbiesRenderer.asCards(groupedData);
        wrapper.append(node);
    } catch (err) {
        messageRenderer.showErrorMessage("No se han podido obtener los usuarios", err);
    }
}

function groupUsersWithHobbies(data) {
    const usersMap = new Map();

    for (const item of data) {
        const userId = item.user_id;
        if (!usersMap.has(userId)) {
            usersMap.set(userId, {
                user_id: item.user_id,
                full_name: item.full_name,
                avatar_url: item.avatar_url,
                email: item.email,
                gender: item.gender,
                age: item.age,
                hobbies: []
            });
        }
        usersMap.get(userId).hobbies.push({
            hobby_id: item.hobby_id,
            hobby: item.hobby
        });
    }

    return Array.from(usersMap.values());
}


