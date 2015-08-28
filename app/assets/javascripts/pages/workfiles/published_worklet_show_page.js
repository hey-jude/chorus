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
                        clearInterval(this.pollerID);
                        chorus.PageEvents.trigger("worklet:run", "runStopped");
                        if(this.clickedStop) {
                            this.clickedStop = false;
                        }
                        else {
                            var activities = model.activities({resultsOnly: true, currentUserOnly: true});
                            activities.loaded = false;
                            activities.fetchAll();
                            this.mainContent.content.workletHistory._showLatestEntry = true;
                        }
                    }
                    else {
                        this.sidebar.runEventHandler('runStarted');
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
        chorus.router.navigate('#/touchpoints');
    },

    runEventHandler: function(event) {
        if (event === 'runStarted') {
            this.pollerID = setInterval(this.pollForRunStatus, 1000);
        }
        else if( event === 'clickedStop') {
            this.clickedStop = true;
        }
    },

    buildPage: function() {
        this.history = this.worklet.activities({resultsOnly: true, currentUserOnly: true});
        this.history.fetchAll();

        this.headerView = new chorus.views.WorkletHeader({
            model: this.worklet,
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
            collection: this.history,
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