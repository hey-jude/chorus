chorus.views.WorkletHeader = chorus.views.Base.extend({
    templateName: "worklets/worklet_header",
    constructorName: "WorkletHeaderView",
    additionalClass: "sub_nav",

    events: {
        "click button.save": 'clickedMenu',
        "click button.close": 'clickedMenu',
        "click a.menu_item": 'clickedMenu',
        "click a.actions_menu": 'toggleWorkletMenu',
        "click #worklet_header_shareResultsLink": "openShareResults",
        "click #worklet_header_saveReportLink": "saveHTMLReport",
        "click #worklet_header_viewLogsLink": "viewLogs"
    },

    setup: function() {
        this.worklet = this.options.worklet;
        this.workletLoaded = false;

        this.subscribePageEvent("worklet:editor:save", this.editorSavingEvent);
        this.subscribePageEvent("worklet:history_results_shown", this.activatePopupMenu);
        this.state = this.options.state || 'running';
    },

    clickedMenu: function(e) {
        e && e.preventDefault();
        var eventType = e.currentTarget.dataset.eventType;
        chorus.PageEvents.trigger("menu:worklet", eventType);
    },

    editorSavingEvent: function(e) {
        if (e === 'saving') {
            this.$('button.save').startLoading("general.saving");
        } else {
            this.$('button.save').stopLoading();
        }
    },

    togglePopupMenu: function(e) {
        chorus.PopupMenu.toggle(this, ".menu.popup_worklet_menu", e, '.actions_menu');
    },

    toggleWorkletMenu: function(e) {
        e && e.preventDefault();
        if(this.workletLoaded) {
            chorus.PopupMenu.toggle(this, ".menu.popup_worklets", e, '.worklet_action_menu');
        }
    },

    openShareResults: function(e) {
        e && e.preventDefault();
        chorus.PageEvents.trigger("worklet:open_share_results_dialog");
    },

    saveHTMLReport: function(e) {
        e && e.preventDefault();
        chorus.PageEvents.trigger("worklet:export_html_report");
    },

    viewLogs: function(e) {
        e && e.preventDefault();
        chorus.PageEvents.trigger("worklet:view_logs");
    },

    activatePopupMenu: function(data) {
        this.activity = data.activity;
        this.outputView = data.outputView;
        if(!this.workletLoaded) {
            this.workletLoaded = true;
            this.$('.worklet_action_menu a').removeClass('inactive');
        }
    },

    additionalContext: function() {
        return {
            editing: this.state === 'editing',
            fileName: this.worklet.get('fileName'),
            iconUrl: this.worklet.iconUrl(),
            published: this.worklet.get('entitySubtype') === 'published_worklet'
        };
    }
});