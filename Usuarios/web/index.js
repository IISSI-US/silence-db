"use strict";

import { usersAPI_auto as usersAPI } from "/js/api/_users.js";
import { messageRenderer } from "/js/renderers/messages.js";
import { userRenderer } from "/js/renderers.js";

document.addEventListener("DOMContentLoaded", main);

function main() {
    loadUsers();
}

async function loadUsers() {
    let tableBody = document.querySelector("#users-table tbody");
    tableBody.innerHTML = "";

    try {
        let users = await usersAPI.getAll();
        tableBody.innerHTML = userRenderer.asTableRows(users);
    } catch (err) {
        tableBody.innerHTML = userRenderer.asMessageRow("Ha ocurrido un error al cargar los usuarios.");
        messageRenderer.showErrorMessage("No se han podido obtener los usuarios", err);
    }
}
