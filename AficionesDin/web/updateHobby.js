"use strict";

import { usersAPI_auto } from "/js/api/_users.js";
import { hobbiesAPI_auto } from "/js/api/_hobbies.js";
import { user_hobby_linksAPI_auto } from "/js/api/_user_hobby_links.js";
import { v_user_hobbiesAPI_auto } from "/js/api/_v_user_hobbies.js";
import { messageRenderer } from "/js/renderers/messages.js";

let hobbies = [];
let userHobbyLinks = [];
let currentUser = null;
let userHobbiesView = [];

document.addEventListener("DOMContentLoaded", main);

async function main() {
  const userId = new URLSearchParams(window.location.search).get("user_id");
  if (!userId) {
    messageRenderer.showErrorMessage("Falta el parámetro user_id en la URL");
    return;
  }

  try {
    const [viewData, hobbiesData, linksData] = await Promise.all([
      v_user_hobbiesAPI_auto.getAll(),
      hobbiesAPI_auto.getAll(),
      user_hobby_linksAPI_auto.getAll()
    ]);

    userHobbiesView = viewData.filter((item) => item.user_id === Number(userId));
    currentUser = userHobbiesView[0] ?? (await usersAPI_auto.getById(userId));
    hobbies = hobbiesData;
    userHobbyLinks = linksData.filter((link) => link.user_id === Number(userId));

    renderUser();
    renderHobbies();
    populateSelects();
    wireForms(userId);
    wireBackButton();
  } catch (err) {
    messageRenderer.showErrorMessage("No se han podido cargar los datos del usuario", err);
  }
}

function renderUser() {
  if (!currentUser) return;
  document.getElementById("user-name").textContent = currentUser.full_name;
  document.getElementById("user-meta").textContent = `${currentUser.gender} · ${currentUser.age} años`;
  document.getElementById("user-email").textContent = currentUser.email;
  const avatar = document.getElementById("user-avatar");
  avatar.src = `/images/${currentUser.avatar_url}`;
  avatar.alt = `Avatar de ${currentUser.full_name}`;
}

function renderHobbies() {
  const list = document.getElementById("current-hobbies");
  list.innerHTML = "";

  if (userHobbyLinks.length === 0) {
    list.innerHTML = '<li class="list-group-item text-muted">Sin aficiones aún</li>';
    return;
  }

  for (const link of userHobbyLinks) {
    const hobbyName = getHobbyName(link.hobby_id);
    const item = document.createElement("li");
    item.className = "list-group-item d-flex justify-content-between align-items-center";
    item.innerHTML = `
      <span>${hobbyName}</span>
      <button class="btn btn-sm btn-outline-danger" data-link-id="${link.user_hobby_id}">Eliminar</button>
    `;
    item.querySelector("button").addEventListener("click", () => onDelete(link.user_hobby_id));
    list.appendChild(item);
  }
}

function populateSelects() {
  const addSelect = document.getElementById("add-hobby");
  const updateCurrentSelect = document.getElementById("current-link");
  const updateNewSelect = document.getElementById("new-hobby");
  const updateButton = document.getElementById("update-submit");

  addSelect.innerHTML = optionsFromHobbies();
  updateNewSelect.innerHTML = optionsFromHobbies();

  if (userHobbyLinks.length === 0) {
    updateCurrentSelect.innerHTML = '<option value="" disabled selected>Sin aficiones para actualizar</option>';
    updateButton.disabled = true;
  } else {
    updateCurrentSelect.innerHTML = userHobbyLinks
      .map((link) => `<option value="${link.user_hobby_id}">${getHobbyName(link.hobby_id)}</option>`)
      .join("");
    updateButton.disabled = false;
  }
}

function wireBackButton() {
  const back = document.getElementById("back-button");
  if (!back) return;
  back.addEventListener("click", () => {
    window.location.href = "index.html";
  });
}

function optionsFromHobbies() {
  if (hobbies.length === 0) {
    return '<option value="" disabled selected>No hay aficiones disponibles</option>';
  }

  return hobbies
    .map((hobby, index) => `<option value="${hobby.hobby_id}" ${index === 0 ? "selected" : ""}>${hobby.hobby_name}</option>`)
    .join("");
}

function getHobbyName(hobbyId) {
  const fromView = userHobbiesView.find((h) => h.hobby_id === hobbyId);
  if (fromView) {
    return fromView.hobby_name;
  }
  const fromAll = hobbies.find((h) => h.hobby_id === hobbyId);
  return fromAll ? fromAll.hobby_name : "Hobby";
}

function wireForms(userId) {
  const addForm = document.getElementById("add-form");
  addForm.addEventListener("submit", (event) => onAdd(event, userId));

  const updateForm = document.getElementById("update-form");
  updateForm.addEventListener("submit", (event) => onUpdate(event, userId));
}

async function onAdd(event, userId) {
  event.preventDefault();
  const hobbyId = Number(event.target.hobby_id.value);

  try {
    await user_hobby_linksAPI_auto.create({ user_id: Number(userId), hobby_id: hobbyId });
    await reloadLinks(userId);
    messageRenderer.showSuccessMessage("Afición añadida al usuario");
  } catch (err) {
    messageRenderer.showErrorMessage("No se ha podido añadir la afición", err);
  }
}

async function onUpdate(event, userId) {
  event.preventDefault();
  const linkId = Number(event.target.user_hobby_id.value);
  const newHobbyId = Number(event.target.new_hobby_id.value);

  try {
    await user_hobby_linksAPI_auto.update({ user_id: Number(userId), hobby_id: newHobbyId }, linkId);
    await reloadLinks(userId);
    messageRenderer.showSuccessMessage("Afición actualizada");
  } catch (err) {
    messageRenderer.showErrorMessage("No se ha podido actualizar la afición", err);
  }
}

async function onDelete(linkId) {
  try {
    await user_hobby_linksAPI_auto.delete(linkId);
    await reloadLinks(currentUser.user_id);
    messageRenderer.showSuccessMessage("Afición eliminada del usuario");
  } catch (err) {
    messageRenderer.showErrorMessage("No se ha podido eliminar la afición", err);
  }
}

async function reloadLinks(userId) {
  const linksData = await user_hobby_linksAPI_auto.getAll();
  userHobbyLinks = linksData.filter((link) => link.user_id === Number(userId));
  renderHobbies();
  populateSelects();
}
