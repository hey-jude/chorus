chorus.alerts.WorkletUnpublish = chorus.alerts.Confirm.extend({
    constructorName: "WorkletUnublish",
    text: t("worklet.unpublish.alert.text"),
    ok: t("worklet.unpublish.alert.ok"),

    setup: function() {
        this.title = t("worklet.unpublish.alert.title");
    },

    confirmAlert: function() {
        this.model.unpublishWorklet();
        this.$("button.submit").startLoading("actions.unpublishing");
        this.listenToOnce(this.model, "saved", this.closeModal);
        this.listenToOnce(this.model, "saveFailed", this.closeModal);
    }
});