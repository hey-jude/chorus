chorus.alerts.WorkletUnsavedAlert = chorus.Modal.extend({
    templateName: "worklets/unsaved_alert",
    constructorName: "WorkletUnsavedAlert",
    additionalClass: "alert error",

    events: {
        "click button.close_with_save": "closeWithSave",
        "click button.close_without_save": "closeWithoutSave",
        "click button.cancel_close": "cancelClose"
    },

    focusSelector: "button.cancel",

    closeWithSave: function(e) {
        e && e.preventDefault();
        chorus.PageEvents.trigger("menu:worklet", "close_with_save");
        this.closeModal();
    },

    closeWithoutSave: function(e) {
        e && e.preventDefault();
        chorus.PageEvents.trigger("menu:worklet", "close_without_save");
        this.closeModal();
    },

    cancelClose: function(e) {
        e && e.preventDefault();
        this.closeModal();
    },

    revealed: function() {
        $("#facebox").removeClass().addClass("alert_facebox");
    },

    additionalContext: function(ctx) {
        return {
            text: t("worklet.edit.unsaved_changes.text"),
            title: t("worklet.edit.unsaved_changes.title"),
            save: t("worklet.edit.unsaved_changes.close_with_save"),
            cancel: t("worklet.edit.unsaved_changes.cancel"),
            close: t("worklet.edit.unsaved_changes.close_without_save")
        };
    }
});