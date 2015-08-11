chorus.dialogs.WorkletUsage = chorus.dialogs.Base.include(
        chorus.Mixins.DialogFormHelpers
    ).extend({
        constructorName: "WorkletUsage",
        templateName: "worklets/worklet_usage_dialog",
        title: t("worklet.worklet_usage_title"),
        persistent:true,

        setup:function () {
            this.associatedWorklets = this.options.associatedWorklets;
        },

        additionalContext: function() {
            return {
                associatedWorklets: this.associatedWorklets
            };
        }
    });
