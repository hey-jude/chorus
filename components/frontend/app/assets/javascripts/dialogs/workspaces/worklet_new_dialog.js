chorus.dialogs.WorkletNew = chorus.dialogs.Base.include(
        chorus.Mixins.DialogFormHelpers
    ).extend({
        constructorName: "WorkletNew",
        templateName: "worklets/worklet_new_dialog",
        title: t("worklet.create_new_title"),
        events: {
            "submit form": "save"
        },
        persistent: true,

        makeModel: function () {
            this.workspace = this.options.pageModel;
            this.model = this.model || new chorus.models.Worklet({workspace: this.workspace.attributes});

            this.workflow = this.options.workflow || {};
            if (typeof(this.workflow.id) !== 'undefined') {
                this.model.set({
                    workflowId: this.workflow.id
                });
            }
        },

        setup: function () {
            this.listenTo(this.model, "saved", this.workletSaved);
            this.listenTo(this.model, "saveFailed", this.saveFailed);
            this.disableFormUnlessValid({
                formSelector: "form.new_worklet",
                inputSelector: "input[name='workletName']"
            });
        },

        save: function (e) {
            e.preventDefault();

            var attrs = {
                fileName: this.$("input[name=workletName]").val().trim(),
                description: this.$("textarea[name=workletDescription]").val().trim()
            };
            this.$("button.submit").startLoading("actions.creating");

            this.model.save(attrs, {wait: true});
        },

        workletSaved: function () {
            this.closeModal();
            chorus.router.navigate("/workspaces/" + this.workspace.get('id') + "/touchpoints/" + this.model.get("id"));
        },

        additionalContext: function() {
            var context = {
                workflow: this.workflow.attributes,
                fromExisting: typeof(this.workflow.id) !== 'undefined',
                modifiedTime: new Date(this.workflow.get('userModifiedAt')).toString('MM-dd-yyyy HH:mm:ss'),
                hasComments: this.workflow.get('recentComments').length > 0
            };
            if (this.workflow.get('recentComments').length > 0) {
                context['lastComment'] = this.workflow.get('recentComments')[0].body;
            }
            return context;
        }
    });
