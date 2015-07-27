chorus.pages.WorkletWorkspaceDisplayBase = chorus.pages.Base.extend({
    helpId: "workfile",

    setup: function (workspaceId, workletId) {
        this.subNav = new chorus.views.SubNav({workspace: this.workspace, tab: "workfiles"});
        this.requiredResources.add(this.workspace);

        this.subscribePageEvent("menu:worklet", this.menuEventHandler);

        this.worklet = new chorus.models.Worklet({id: workletId, workspace: this.workspace});
        this.worklet.fetch();

        this.onceLoaded(this.worklet, this.buildPage);
    },

    makeModel: function(workspaceId) {
        this.loadWorkspace(workspaceId);
    },

    menuEventHandler: function(menu_item) {
        if (menu_item === 'edit_mode') {
            chorus.router.navigate(this.worklet.showUrl());
        }

        if (menu_item === 'preview_mode') {
            chorus.router.navigate(this.worklet.showUrl() + '/preview');
        }
    },

    updateMiddleContent: function(newView) {
        if (this.mainContent.content.workletOutput) {
            this.mainContent.content.workletOutput.teardown(true);
        }

        this.mainContent.content.workletOutput = newView;
        this.mainContent.content.renderSubview('workletOutput');

        this.trigger('resized');
    },

    hideHistory: function() {
        $(this.mainContent.content.workletHistory.el).toggle(false);
        $('.published_worklet_content').addClass('no_history');
    },

    showHistory: function() {
        var history_options = {
            model: this.model,
            collection: this.history,
            mainPage: this
        };

        var newView = new chorus.views.PublishedWorkletHistory(history_options);

        // Refactor updateMiddleContent to be updateContent(which_pane, new_content) instead of this redundant code:
        if (this.mainContent.content.workletHistory) {
            this.mainContent.content.workletHistory.teardown(true);
        }
        this.mainContent.content.workletHistory = newView;
        this.mainContent.content.workletSubmit.historyView = newView;
        this.mainContent.content.renderSubview('workletHistory');

        $('.published_worklet_content').removeClass('no_history');
        this.trigger('resized');
    }
});

chorus.pages.WorkletPreviewPage = chorus.pages.WorkletWorkspaceDisplayBase.extend({
    //menuEventHandler: function(menu_item) {
    //    this._super("menuEventHandler", [menu_item]);
    //},

    buildPage: function() {
        this.history = this.worklet.activities({resultsOnly: true, currentUserOnly: true});
        this.history.fetchAll();
        this.onceLoaded(this.history, this.showHistory);

        this.headerView = new chorus.views.WorkletHeader({
            model: this.worklet,
            menuOptions: [],
            mode: 'preview'
        });

        this.contentView = new chorus.views.PublishedWorkletContent({
            model: this.worklet,
            collection: this.history
        });

        this.mainContent = new chorus.views.MainContentView({
            model: this.model,
            contentHeader: this.headerView,
            content: this.contentView
        });

        this.render();

        // Show history
        // $(this.mainContent.content.workletSubmit.el).find('.form_controls').toggle(true);
        // this.showHistory();
    }
});

chorus.pages.WorkletEditPage = chorus.pages.WorkletWorkspaceDisplayBase.extend({
    menuEventHandler: function(menu_item) {
        this._super("menuEventHandler", [menu_item]);

        if (menu_item === 'details') {
            this.showDetailsConfiguration();
        }

        if (menu_item === 'inputs') {
            this.showInputsConfiguration();
        }
    },

    showDetailsConfiguration: function() {
        var details_configuration = new chorus.views.WorkletDetailsConfiguration({
            model: this.worklet,
            workflowOperators: this.workflowOperators
        });

        this.updateMiddleContent(details_configuration);
    },

    showInputsConfiguration: function() {
        var inputs_configuration = new chorus.views.WorkletInputsConfiguration({
            model: this.worklet,
            previewPane: this.mainContent.content.workletSubmit,
            workflowVariables: this.workflowVariables && this.workflowVariables.get('variableMap'),
        });

        this.updateMiddleContent(inputs_configuration);
    },

    hidePreviewControls: function() {
        this.hideHistory();
        $(this.mainContent.content.workletSubmit.el).find('.form_controls').toggle(false);
    },

    buildPage: function() {
        this.workflowVariables = new chorus.models.WorkFlowVariables({workfile_id: this.worklet.get('workflowId')});
        this.workflowVariables.fetch();
        //this.onceLoaded(this.workflowVariables, this.showInputsConfiguration);

        this.workflowOperators = new chorus.models.WorkFlowOperators({workfile_id: this.worklet.get('workflowId')});
        this.workflowOperators.fetch();
        this.onceLoaded(this.workflowOperators, this.showDetailsConfiguration);

        //this.workflow = new chorus.models.AlpineWorkfile({id: this.worklet.workflow_id, workspace: this.workspace});
        //this.workflow.fetch();
        //this.onceLoaded(this.workflow, function (e) {
        //    debugger;
        //});

        this.headerView = new chorus.views.WorkletHeader({
            model: this.worklet,
            menuOptions: [
                {data: "details", text: "Configure Details"}, //t("workfiles.header.menu.sort.by_date")
                {data: "inputs", text: "Configure Inputs"}
            ],
            mode: 'edit'
        });

        this.contentView = new chorus.views.PublishedWorkletContent({
            model: this.worklet,
            collection: this.history
        });

        this.mainContent = new chorus.views.MainContentView({
            model: this.model,
            contentHeader: this.headerView,
            content: this.contentView
        });

        this.render();
        this.hidePreviewControls();
    }
});
