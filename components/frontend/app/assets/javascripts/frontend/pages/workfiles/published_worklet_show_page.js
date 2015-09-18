chorus.pages.PublishedWorkletShowPage = chorus.pages.Base.extend({
    setup: function(workletId) {
        this.subscribePageEvent("worklet:run", this.runEventHandler);
        this.subscribePageEvent("menu:worklet", this.menuEventHandler);

        this.worklet = new chorus.models.PublishedWorklet({ id:workletId });
        this.worklet.fetch();
        this.handleFetchErrorsFor(this.worklet);

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

    closePage: function() {
        if (!_.isUndefined(this.pollerID)) {
            clearInterval(this.pollerID);
            this.pollerID = void 0;
        }

        chorus.router.navigate('#/touchpoints');
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
            if (!_.isUndefined(this.pollerID)) {
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

                clearInterval(this.pollerID);
                this.pollerID = void 0;
            }
        }
        else if (event === 'clickedStop') {
            this.clickedStop = true;
        }
    },

    buildPage: function() {
        this.history = this.worklet.activities({
            resultsOnly: true,
            currentUserOnly: true
        });
        this.history.fetchAll();

        this.headerView = new chorus.views.WorkletHeader({
            worklet: this.worklet,
            menuOptions: [],
            state: 'publishedRun'
        });

        this.subNav = this.headerView;
        this.sidebar = new chorus.views.WorkletParameterSidebar({
            worklet: this.worklet,
            state: 'running'
        });

        this.contentView = new chorus.views.PublishedWorkletContent({
            worklet: this.worklet,
            history: this.history,
            mainPage: this
        });

        this.mainContent = new chorus.views.MainContentView({
            worklet: this.worklet,
            content: this.contentView
        });

        this.render();

        if(this.worklet.get('running')) {
            chorus.PageEvents.trigger("worklet:run", "runStarted");
        }

    }
});