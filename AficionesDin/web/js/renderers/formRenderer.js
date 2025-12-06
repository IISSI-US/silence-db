"use strict";

import { parseHTML } from "/js/utils/parseHTML.js";

const formRenderer = {
    asSelect(options, id, name, label, required = true) {
        const optionsHtml = options.map(opt =>
            `<option value="${opt.value}" ${opt.selected ? "selected" : ""} ${opt.disabled ? "disabled" : ""}>${opt.text}</option>`
        ).join("");

        const html = `
    <div class="col-12">
      <label class="form-label" for="${id}">${label}</label>
      <select class="form-select" id="${id}" name="${name}" ${required ? "required" : ""}>
        ${optionsHtml}
      </select>
    </div>`;
        return html; // Returning string to be embedded in form
    },

    asButton(text, type = "submit", className = "btn-primary", id = "", disabled = false) {
        const idAttr = id ? `id="${id}"` : "";
        const disabledAttr = disabled ? "disabled" : "";
        return `
    <div class="col-12 d-flex justify-content-end">
      <button ${idAttr} class="btn ${className}" type="${type}" ${disabledAttr}>${text}</button>
    </div>`;
    }
};

export { formRenderer };
