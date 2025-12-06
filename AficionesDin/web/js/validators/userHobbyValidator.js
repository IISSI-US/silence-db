"use strict";

const userHobbyValidator = {
    validateAdd(formData) {
        let errors = [];
        const hobbyId = formData.get("hobby_id");

        if (!hobbyId) {
            errors.push("Debe seleccionar una afición para añadir.");
        }

        return errors;
    },

    validateUpdate(formData) {
        let errors = [];
        const currentLinkId = formData.get("user_hobby_id");
        const newHobbyId = formData.get("new_hobby_id");

        if (!currentLinkId) {
            errors.push("Debe seleccionar la afición actual que desea cambiar.");
        }

        if (!newHobbyId) {
            errors.push("Debe seleccionar la nueva afición.");
        }

        return errors;
    }
};

export { userHobbyValidator };
