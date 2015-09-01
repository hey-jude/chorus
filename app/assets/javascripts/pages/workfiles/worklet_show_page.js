chorus.pages.WorkletWorkspaceDisplayBase = chorus.pages.Base.extend({
    helpId: "touchpoint",

    setup: function (workspaceId, workletId) {
        // this.subNav = new chorus.views.SubNav({workspace: this.workspace, tab: "workfiles"});
        this.requiredResources.add(this.workspace);

        this.subscribePageEvent("menu:worklet", this.menuEventHandler);

        this.worklet = new chorus.models.Worklet({id: workletId, workspace: this.workspace});
        this.worklet.fetch();

        this.subscribePageEvent("worklet:run", this.runEventHandler);
        this.pollForRunStatus = _.bind(function() {
            this.worklet.fetch({
                success: _.bind(function(model) {
                    if(!model.get('running')) {
                        chorus.PageEvents.trigger("worklet:run", "runStopped");
                    }
                }, this)
            });
        }, this);

        this.onceLoaded(this.worklet, this.buildPage);
    },

    menuEventHandler: function(menu_item) {
        if (menu_item === 'close') {
            this.closePage();
        }
    },

    runEventHandler: function(event) {
        if (event === 'runStarted') {
            if (_.isUndefined(this.pollerID)) {
                this.pollerID = setInterval(this.pollForRunStatus, 1000);
            }
        }
        else if (event === 'runStopped') {
            if (!_.isUndefined(this.pollerID)) {
                clearInterval(this.pollerID);
                this.pollerID = void 0;
            }
        }
    },

    closePage: function() {
        chorus.router.navigate(this.worklet.workspace().workfilesUrl());
    },

    makeModel: function(workspaceId) {
        this.loadWorkspace(workspaceId);
    }
});

chorus.pages.WorkletEditPage = chorus.pages.WorkletWorkspaceDisplayBase.extend({
    setup: function (workspaceId, workletId) {
        this._super("setup", [workspaceId, workletId]);

        this.subscribePageEvent("submenu:worklet", this.workletStepsMenuEventHandler);

        this.listenTo(this.worklet, "saved", this.workletSaved);
        this.listenTo(this.worklet, "saveFailed", this.workletSaveFailed);

        // Show input editor if scrollto on a parameter is clicked.
        this.subscribePageEvent("parameter:scrollTo", _.bind(function(e) {
            if (this._edit_mode !== 'inputs') {
                this.showEditorMode('inputs');
                chorus.PageEvents.trigger("parameter:scrollTo", e);
            }
        }, this));
    },

    menuEventHandler: function(menu_item) {
        if (menu_item === 'close') {
            if (this.hasUnsavedChanges()) {
                new chorus.alerts.WorkletUnsavedAlert({
                    model: this.worklet
                }).launchModal();
            } else {
                this.closePage();
            }
        } else if (menu_item === 'save') {
            this.saveAll();
        } else if (menu_item === 'close_with_save') {
            if (this.saveAll()) {
                this.closePage();
            }
        } else if (menu_item === 'close_without_save') {
            this.closePage();
        }
    },

    hasUnsavedChanges: function() {
        var views = _.pairs(this.editorViews);
        var unsaved_views = _.filter(views, function (view_pair) {
            return view_pair[1].content.hasUnsavedChanges();
        });

        var error_having_views = _.filter(views, function (view_pair) {
            return view_pair[1].content.hasErrors();
        });

        return error_having_views.length > 0 || unsaved_views.length > 0;
    },

    workletSaved: function(e) {
        if (this.worklet.wasRunRelatedSave()) {
            return;
        }

        chorus.toast('worklet.updated.success.toast', {name: this.worklet.get('fileName'), toastOpts: {type: "success"}});
        chorus.PageEvents.trigger("worklet:editor:save", "saved");
    },

    workletSaveFailed: function(e) {
        chorus.PageEvents.trigger("worklet:editor:save", "failed");
    },

    saveAll: function() {
        // For each editor view, check if it's unsaved or has errors.
        // For error-having views, indicate the error and short-circuit save
        var error_having_views = _.filter(_.pairs(this.editorViews), function (view_pair) {
            return view_pair[1].content.hasErrors();
        });

        if (error_having_views.length > 0) {
            this.showEditorMode(error_having_views[0][0]);
            return;
        }

        chorus.PageEvents.trigger("worklet:editor:save", "saving");

        if (this.editorViews['inputs'].content.saveParameters() && // Inputs view
            this.worklet.saveImageFile() && // Details view's image
            this.worklet.save(this.worklet.attributes, { wait: true })) { // Other views
            return true;
        } else {
            chorus.PageEvents.trigger("worklet:editor:save", "failed");
            return false;
        }
    },

    workletStepsMenuEventHandler: function(menu_item) {
        var valid_modes = _.keys(this.editorViews);
        if (valid_modes.indexOf(menu_item) !== -1) {
            this.showEditorMode(menu_item);
        }
    },

    showEditorMode: function(edit_mode) {
        this._edit_mode = edit_mode;
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
                worklet: this.worklet,
                mode: mode,
                state: 'editing',
                menuOptions: settings.menuOptions
            }),
            sidebar: new chorus.views.WorkletParameterSidebar({
                worklet: this.worklet,
                state: 'editing',
                editorMode: mode
            }),
            contentHeader: new chorus.views.WorkletEditorSubheader({
                mode: mode
            }),
            content: new (settings.viewClass)({
                worklet: this.worklet
            })
        };
    },

    buildPage: function() {
        // Initial (default) view for the editor steps when opening worklet
        // possible values: from WorkletEditorSubheader. 
        // 'workflow', 'details', 'outputs', 'inputs'

        // DEV-12645: re-route user to run page if user does not have permission to update (i.e., not admin and not member of workspace)
        // TODO: make this better
        if (!(this.worklet.workspace().canUpdate())) {
            chorus.router.navigate(this.worklet.showRunUrl(), { trigger: true, replace: true });
            return;
        }

        var initial_mode = 'inputs';

        // Build the editor views:
        this.editorViews = {};

        this.editorViews['inputs'] = this.buildEditorView('inputs', {
            menuOptions: [],
            viewClass: chorus.views.WorkletInputsConfiguration
        });

        this.editorViews['outputs'] = this.buildEditorView('outputs', {
            menuOptions: [],
            viewClass: chorus.views.WorkletOutputsConfiguration
        });

        this.editorViews['details'] = this.buildEditorView('details', {
            menuOptions: [],
            viewClass: chorus.views.WorkletDetailsConfiguration
        });

        this.editorViews['workflow'] = this.buildEditorView('workflow', {
            menuOptions: [],
            viewClass: chorus.views.WorkletWorkflowConfiguration
        });

        // Render initial view
        this.subNav = this.editorViews[initial_mode].subNav;
        this.sidebar = this.editorViews[initial_mode].sidebar;
        this.mainContent = new chorus.views.MainContentView({
            worklet: this.worklet,
            contentHeader: this.editorViews[initial_mode].contentHeader,
            content: this.editorViews[initial_mode].content
        });
        this.render();
    }
});


chorus.pages.WorkletRunPage = chorus.pages.WorkletWorkspaceDisplayBase.extend({
    setup: function (workspaceId, workletId) {
        this._super("setup", [workspaceId, workletId]);
    },

    menuEventHandler: function(menu_item) {
        this._super("menuEventHandler", [menu_item]);
    },

    runEventHandler: function(event) {
        if (event === 'runStarted') {
            if (_.isUndefined(this.pollerID)) {
                this._last_hist_len = this.history.length;
                this.sidebar.runEventHandler('runStarted');
                this.pollerID = setInterval(this.pollForRunStatus, 1000);
            }
        }
        else if (event === 'runStopped') {
            // We want to continue polling until we have a history; running stop and history are asynchronously updated.
            // Unless we "clicked stop"; in which case we don't expect an update in the history.
            this.history.fetchAll({ wait: true });
            if (this.clickedStop !== true && this._last_hist_len === this.history.length) {
                return;
            }

            if (this.clickedStop !== true) {
                this.mainContent.content.workletHistory._showLatestEntry = true;
            }
            this.clickedStop = false;
            this.sidebar.runEventHandler('runStopped');

            clearInterval(this.pollerID);
            this.pollerID = void 0;
        }
        else if (event === 'clickedStop') {
            this.clickedStop = true;
        }
    },

    buildPage: function() {
        this.history = this.worklet.activities({resultsOnly: true, currentUserOnly: true});
        this.history.fetchAll();

        this.headerView = new chorus.views.WorkletHeader({
            worklet: this.worklet,
            menuOptions: [],
            state: 'workspaceRun'
        });

        this.subNav = this.headerView;
        this.sidebar = new chorus.views.WorkletParameterSidebar({
            worklet: this.worklet,
            state: 'running'
        });

        this.contentView = new chorus.views.PublishedWorkletContent({
            worklet: this.worklet,
            collection: this.history,
            mainPage: this
        });

        this.mainContent = new chorus.views.MainContentView({
            worklet: this.worklet,
            content: this.contentView
        });

        this.render();

        if (this.worklet.get('running')) {
            chorus.PageEvents.trigger("worklet:run", "runStarted");
        }
    }
});
