//= require ./alpine_workfile
chorus.models.Worklet = chorus.models.AlpineWorkfile.include(
    ).extend({
        constructorName: "Worklet",
        entityType: "worklet",
        defaults: {
            entitySubtype: "worklet"
        },

        showUrlTemplate: "workspaces/{{workspace.id}}/worklets/{{this.id}}",

        urlTemplate: function(options) {
            var action = options && options.workflow_action;
            var url =  "workspaces/{{workspace.id}}/worklets/{{this.id}}";


            if (action === 'publish') {
                url += "/publish/";
            } else if (action === 'unpublish') {
                url += "/unpublish/";
            } else if (action === 'run') {
                url += "/run";
            } else if (action === 'image') {
                url += '/image';
            }
            return url;
        },

        isWorklet: function() {
            return true;
        },

        basisWorkflow: function() {
            return new chorus.models.AlpineWorkfile({id: this.get('workflowId')});
        },

        iconUrl: function(options) {
            return chorus.urlHelpers.fileIconUrl('worklet', options && options.size);
        },

        declareValidations: function(newAttrs) {
            this.require("fileName", newAttrs);
        },

        publishWorklet: function() {
            this.save({}, {
                workflow_action: 'publish'
            });
        },

        unpublishWorklet: function() {
            this.save({}, {
                workflow_action: 'unpublish'
            });
        },

        variables: function () {
            if(!this._variables) {
                this._variables = new chorus.collections.WorkletVariableSet(this.get('variables'),
                    {
                        workletId: this.get("id"),
                        workspaceId: this.workspace().id
                    });
            }

            return this._variables;
        },

        run: function(worklet_parameters) {
            this.save({worklet_parameters: worklet_parameters}, {
                workflow_action: 'run',
                silent: true,
                unprocessableEntity: function() {
                    chorus.toast('work_flows.start_running_unprocessable.toast', {toastOpts: {type: "error"}});
                }
            });
        },

        save: function(attrs, options) {
            var overrides = {};
            return this._super("save", [attrs, _.extend(options, overrides)]);
        }
    });
