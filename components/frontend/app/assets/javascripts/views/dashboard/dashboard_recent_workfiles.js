chorus.views.DashboardRecentWorkfiles = chorus.views.DashboardModule.extend({
    constructorName: "DashboardRecentWorkfiles",
    templateName: "dashboard/recent_workfiles",

    events: {
        "click #recent_workfiles_main_content .configure": "showOptions",
        "click #recent_workfiles_main_content .clear_list": "clearList",
        "click #recent_workfiles_configuration .cancel": "hideOptions",
        "click #recent_workfiles_configuration .submit": "saveOptions"
    },

    setup: function() {
        this.model = new chorus.models.DashboardData({});
        this.model.urlParams = { entityType: 'recent_workfiles' };
        this.model.fetch({
            success: _.bind(this.fetchComplete, this)
        });
        this.recentWorkfileModel = new chorus.models.RecentWorkfiles();
    },

    fetchComplete: function() {
        var workfiles = _.map(this.model.get("data"), function(openEvent) {
            openEvent.workfile.lastOpened = openEvent.lastOpened;
            return openEvent.workfile;
        }, this);
        this.resource = this.collection = new chorus.collections.WorkfileSet(workfiles);
        this.render();
        if (this.$('#recent_workfiles_configuration').is(':visible')) {
			this.$('#recent_workfiles_configuration').fadeOut(100);
        }
    },

    additionalContext: function () {
        return {
            modelLoaded: this.model.get("data") !== undefined,
            hasModels: this.model.get("data") ? this.model.get("data").length > 0 : false
        };
    },

    collectionModelContext: function(model) {
        //TODO: better solution for this, hard-coding for published worklets for now, similar to workspace_helpers.js
        var model_is_published_touchpoint = model.get('fileType') === 'published_worklet';
        return {
            iconUrl: model.iconUrl(),
            showUrl: model.showUrl(),
            workspaceShowUrl: model_is_published_touchpoint ? "#/touchpoints" : model.workspace().showUrl(),
            workspaceIconUrl: model.workspace().defaultIconUrl("small"),
            workspaceName: model_is_published_touchpoint ? "Touchpoints" : model.workspace().name()
        };
    },

    showOptions: function(e) {
        e.preventDefault();
        this.$('#recent_workfiles_configuration').fadeIn(160);

        _.defer(_.bind(function () {
            chorus.styleSelect(this.$(".recent_items_select"));
        }, this));
        this.$(".recent_items_select").val(this.$('#recent_workfiles_main_content li').length);
    },

    hideOptions: function(e) {
        e.preventDefault();
        this.$('#recent_workfiles_configuration').fadeOut(100);
    },

    saveOptions: function(e) {
        e.preventDefault();
        this.recentWorkfileModel.save({action: "updateOption", optionValue: this.$(".recent_items_select").val()}, {
            success: _.bind(this.setup, this)
        });
    },

    clearList: function(e) {
        e.preventDefault();
        this.recentWorkfileModel.save({action: "clearList"}, {
            success: _.bind(this.setup, this)
        });
    }
});
