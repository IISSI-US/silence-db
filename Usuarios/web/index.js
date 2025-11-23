"use strict";

import { usersAPI_auto as usersAPI } from "/js/api/_users.js";
import { messageRenderer } from "/js/renderers/messages.js";
import { userRenderer } from "/js/renderers/userRenderer.js";

let viewMode = "table";

document.addEventListener("DOMContentLoaded", main);

function main() {
        setupToggleView();
        loadUsers();
}

function setupToggleView() {
    const toggleBtn = document.getElementById("toggle-view");
    if (viewMode === "table") {
        toggleBtn.textContent = "Ver tarjetas";
    } else {
        toggleBtn.textContent = "Ver tabla";
    }
    toggleBtn.addEventListener("click", () => {
        viewMode = viewMode === "table" ? "cards" : "table";
        if (viewMode === "table") {
            toggleBtn.textContent = "Ver tarjetas";
        } else {
            toggleBtn.textContent = "Ver tabla";
        }
        loadUsers();
    });
}

async function loadUsers() {
    try {
        const users = await usersAPI.getAll();
        const wrapper = document.getElementById("users-wrapper");
        wrapper.innerHTML = "";
        let node;
        if (viewMode === "table") {
            node = userRenderer.asTable(users);
        } else {
            node = userRenderer.asCards(users);
        }
        wrapper.append(node);
    } catch (err) {
        messageRenderer.showErrorMessage("No se han podido obtener los usuarios", err);
    }
}


