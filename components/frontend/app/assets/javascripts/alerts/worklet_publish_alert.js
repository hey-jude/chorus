chorus.alerts.WorkletPublish = chorus.alerts.Confirm.extend({
    constructorName: "WorkletPublish",
    text: t("worklet.publish.alert.text"),
    ok: t("worklet.publish.alert.ok"),

    setup: function() {
        this.title = t("worklet.publish.alert.title");
    },

    confirmAlert: function() {
        this.model.publishWorklet();
        this.$("button.submit").startLoading("actions.publishing");
        this.listenToOnce(this.model, "saved", this.closeModal);
    }
});