//= require ./alpine_workfile
chorus.WorkletConstants = {
    DataTypes: [
        t('worklet.parameter.datatype.text'),
        t('worklet.parameter.datatype.number'),
        t('worklet.parameter.datatype.single_option_select'),
        t('worklet.parameter.datatype.multiple_option_select'),
        t('worklet.parameter.datatype.datetime_calendar')//,
        //t('worklet.parameter.datatype.datetime_relative')
    ],
    OmittedWorkflowVariables: [
        '@flow_name', '@user_name', '@default_schema',
        '@default_prefix', '@default_tempdir',
        '@default_delimiter', '@pig_number_of_reducers',
        '@flow_id', '@user_id'
    ]
};

chorus.models.Worklet = chorus.models.AlpineWorkfile.include(
).extend({
    constructorName: "Worklet",
    entityType: "worklet",
    defaults: {
        entitySubtype: "worklet"
    },

    showUrlTemplate: "workspaces/{{workspace.id}}/worklets/{{this.id}}",

    showRunUrl: function() {
        return this.showUrl() + '/run';
    },

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
        } else if (action === 'upload_image') {
            url += '/upload_image';
        } else if (action === 'stop') {
            url += "/stop/";
        }
        return url;
    },

    initialize:function () {
        this._super('initialize', arguments);
        this.files = [];
    },

    addFileUpload:function (uploadModel) {
        this.files.push(uploadModel);
    },

    removeFileUpload:function (uploadModel) {
        this.files.splice(this.files.indexOf(uploadModel), 1);
    },

    saveFiles:function () {

        this.fileUploadErrors = 0;
        this.filesToBeSaved = this.files.length;
        _.each(this.files, function(file) {
            file.data.url = this.url({ workflow_action: 'upload_image' });
            file.data.submit();
            this.removeFileUpload(file);
        }, this);
    },

    isWorklet: function() {
        return true;
    },

    canEdit: function() {
        return this.isLatestVersion() && this.workspace().isActive();
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
        this.bind("saved", this.publishSuccess);
        this.save({}, {
            workflow_action: 'publish'
        });
    },

    unpublishWorklet: function() {
        this.bind("saved", this.unpublishSuccess);
        this.save({}, {
            workflow_action: 'unpublish'
        });
    },

    parameters: function () {
        if(!this._parameters) {
            this._parameters = new chorus.collections.WorkletParameterSet(this.get('parameters'),
                {
                    workletId: this.get("id"),
                    workspaceId: this.workspace().id
                });
        }

        return this._parameters;
    },

    fetchWorkflowVariables: function(options) {
        if (this._fetchedWorkflowVars !== true) {
            // Alpine-passed workflow variables
            if (_.isUndefined(this.get('workflowId'))) {
                return;
            }

            this.workflowVariables = new chorus.models.WorkFlowVariables({
                workfile_id: this.get('workflowId')
            });

            this.workflowVariables.fetch(options);
            this.workflowVariables.once('loaded', _.bind(function() {
                this._fetchedWorkflowVars = true;
                chorus.PageEvents.trigger("worklet:workflow_variables_loaded", this._filteredWorkflowVariables());
            }, this));
        } else {
            chorus.PageEvents.trigger("worklet:workflow_variables_loaded", this._filteredWorkflowVariables());
        }
    },

    _filteredWorkflowVariables: function() {
        var varMap = this.workflowVariables && this.workflowVariables.get('variableMap');
        var filteredVars = _.omit(varMap, chorus.WorkletConstants.OmittedWorkflowVariables);

        return _.map(filteredVars, function (value, prop) {
            return {
                variableName: prop,
                variableDefault: value
            };
        });
    },

    run: function(worklet_parameters, test_run) {
        this.save({worklet_parameters: worklet_parameters, test_run: test_run}, {
            workflow_action: 'run',
            silent: true,
            unprocessableEntity: _.bind(function(e) {
                if(this.serverErrorMessage()) {
                    chorus.toast(this.serverErrorMessage(), {skipTranslation: true, toastOpts: {type: "error"}});
                }
                else {
                    chorus.toast('work_flows.start_running_unprocessable.toast', {toastOpts: {type: "error"}});
                }
            }, this)
        });
    },

    stop: function() {
        this.save({}, {
            workflow_action: 'stop',
            method: 'create'
        });
    },

    save: function(attrs, options) {
        var overrides = {};
        return this._super("save", [attrs, _.extend(options, overrides)]);
    },

    publishSuccess: function(e) {
        this.unbind("saved", this.publishSuccess);
        chorus.toast("worklet.publish.success.toast", {"workletName": this.name(), toastOpts: {type: "success"}});
    },

    unpublishSuccess: function(e) {
        this.unbind("saved", this.unpublishSuccess);
        chorus.toast("worklet.unpublish.success.toast", {"workletName": this.name(), toastOpts: {type: "deletion"}});
    }
});
