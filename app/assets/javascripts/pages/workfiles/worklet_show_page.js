chorus.pages.WorkletWorkspaceDisplayBase = chorus.pages.Base.extend({
    helpId: "touchpoint",

    setup: function (workspaceId, workletId) {
        // this.subNav = new chorus.views.SubNav({workspace: this.workspace, tab: "workfiles"});
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
    }
});

chorus.pages.WorkletEditPage = chorus.pages.WorkletWorkspaceDisplayBase.extend({
    setup: function (workspaceId, workletId) {
        this._super("setup", [workspaceId, workletId]);

        this.subscribePageEvent("submenu:worklet", this.workletStepsMenuEventHandler);

        this.listenTo(this.worklet, "saved", this.workletSaved);
        this.listenTo(this.worklet, "saveFailed", this.workletSaveFailed);
    },

    menuEventHandler: function(menu_item) {
        this._super("menuEventHandler", [menu_item]);

        if (menu_item === 'close') {
            this.closePage();
        } else if (menu_item === 'save') {
            this.saveAll();
        }
    },

    closePage: function() {
    },

    workletSaved: function(e) {
        chorus.PageEvents.trigger("worklet:editor:save", "saved");
    },

    workletSaveFailed: function(e) {
        chorus.PageEvents.trigger("worklet:editor:save", "failed");
    },

    saveAll: function() {
        // For each editor view, check if it's unsaved or has errors.
        // For error-having views, indicate the error and short-circuit
        // save.
        var views = _.pairs(this.editorViews);
        var error_having_views = _.filter(views, function (view_pair) {
            return view_pair[1].content.hasErrors();
        });

        if (error_having_views.length > 0) {
            // console.log(error_having_views[0][0] + " has errors.");
            this.showEditorMode(error_having_views[0][0]);
            return;
        }

        //var unsaved_views = _.filter(views, function (view_pair) {
        //    return view_pair[1].content.hasUnsavedChanges();
        //});

        chorus.PageEvents.trigger("worklet:editor:save", "saving");
        this.worklet.save();
        this.editorViews['inputs'].content.saveParameters();
    },

    workletStepsMenuEventHandler: function(menu_item) {
        var valid_modes = _.keys(this.editorViews);
        if (valid_modes.indexOf(menu_item) !== -1) {
            this.showEditorMode(menu_item);
        }
    },

    showEditorMode: function(edit_mode) {
        var editorView = this.editorViews[edit_mode];
        this.subNav = editorView.subNav;
        this.sidebar = editorView.sidebar;
        this.mainContent.contentHeader = editorView.contentHeader;
        this.mainContent.content = editorView.content;

        this.render();
    },

    buildEditorView: function(mode, settings) {
        // Each worklet edit page has these view components:
        return {
            subNav: new chorus.views.WorkletHeader({
                model: this.worklet,
                mode: mode,
                state: 'editing',
                menuOptions: settings.menuOptions
            }),
            sidebar: new chorus.views.WorkletParameterSidebar({
                model: this.worklet,
                state: 'editing',
                editorMode: mode
            }),
            contentHeader: new chorus.views.WorkletEditorSubheader({
                mode: mode
            }),
            content: new (settings.viewClass)({
                model: this.worklet
            })
        };
    },

    buildPage: function() {
        // Initial (default) view for the editor:
        var initial_mode = 'inputs';

        // Build the editor views:
        this.editorViews = {};

        this.editorViews['inputs'] = this.buildEditorView('inputs', {
            menuOptions: [],
            viewClass: chorus.views.WorkletInputsConfiguration
        });

        this.editorViews['details'] = this.buildEditorView('details', {
            menuOptions: [],
            viewClass: chorus.views.WorkletDetailsConfiguration
        });

        this.editorViews['workflow'] = this.buildEditorView('workflow', {
            menuOptions: [],
            viewClass: chorus.views.WorkletWorkflowConfiguration
        });

        this.editorViews['outputs'] = this.buildEditorView('outputs', {
            menuOptions: [],
            viewClass: chorus.views.WorkletOutputsConfiguration
        });

        // Render initial view
        this.subNav = this.editorViews[initial_mode].subNav;
        this.sidebar = this.editorViews[initial_mode].sidebar;
        this.mainContent = new chorus.views.MainContentView({
            model: this.worklet,
            contentHeader: this.editorViews[initial_mode].contentHeader,
            content: this.editorViews[initial_mode].content
        });
        this.render();
    }
});


chorus.pages.WorkletRunPage = chorus.pages.WorkletWorkspaceDisplayBase.extend({
    setup: function (workspaceId, workletId) {
        this._super("setup", [workspaceId, workletId]);

        this.subscribePageEvent("worklet:run", this.runEventHandler);
        this.subscribePageEvent("menu:worklet", this.menuEventHandler);

        this.pollForRunStatus = _.bind(function() {
            this.worklet.fetch({
                success: _.bind(function(model) {
                    if(!model.get('running')) {
                        clearInterval(this.pollerID);
                        chorus.PageEvents.trigger("worklet:run", "runStopped");
                        if(this.clickedStop) {
                            this.clickedStop = false;
                        }
                        else {
                            var activities = model.activities();
                            activities.loaded = false;
                            activities.fetchAll();
                            this.onceLoaded(activities, this.reloadHistory);
                        }
                    }
                    else {
                        this.sidebar.runEventHandler('runStarted');
                    }
                }, this)
            });
        }, this);
    },

    menuEventHandler: function(menu_item) {
        this._super("menuEventHandler", [menu_item]);
    },

    runEventHandler: function(event) {
        if (event === 'runStarted') {
            this.pollerID = setInterval(this.pollForRunStatus, 1000);
        }
        else if( event === 'clickedStop') {
            this.clickedStop = true;
        }
    },

    reloadHistory: function() {
        this.mainContent.content.workletHistory.render();
        this.mainContent.content.workletHistory.$('.history_item')[0].click();
    },

    showHistory: function() {
        var history_options = {
            model: this.model,
            collection: this.history,
            mainPage: this
        };

        var newView = new chorus.views.PublishedWorkletHistory(history_options);

        if (this.mainContent.content.workletHistory) {
            this.mainContent.content.workletHistory.teardown(true);
        }
        this.mainContent.content.workletHistory = newView;
        this.mainContent.content.renderSubview('workletHistory');

        this.trigger('resized');
    },

    buildPage: function() {
        this.history = this.worklet.activities({resultsOnly: true, currentUserOnly: true});
        this.history.fetchAll();
        this.onceLoaded(this.history, this.showHistory);

        this.headerView = new chorus.views.WorkletHeader({
            model: this.worklet,
            menuOptions: [],
            state: 'workspaceRun'
        });

        this.subNav = this.headerView;
        this.sidebar = new chorus.views.WorkletParameterSidebar({
            model: this.worklet,
            state: 'running'
        });

        this.contentView = new chorus.views.PublishedWorkletContent({
            model: this.worklet,
            collection: this.history,
            mainPage: this
        });

        this.mainContent = new chorus.views.MainContentView({
            model: this.model,
            content: this.contentView
        });

        this.render();

        if(this.worklet.get('running')) {
            chorus.PageEvents.trigger("worklet:run", "runStarted");
        }
    }
});
