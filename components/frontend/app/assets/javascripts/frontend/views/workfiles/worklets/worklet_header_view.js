chorus.views.WorkletHeader = chorus.views.Base.extend({
    templateName: "worklets/worklet_header",
    constructorName: "WorkletHeaderView",
    additionalClass: "sub_nav",

    events: {
        "click button.save": 'clickedMenu',
        "click button.close": 'clickedMenu',
        "click a.menu_item": 'clickedMenu',
        "click a.actions_menu": 'togglePopupMenu'
    },

    setup: function() {
        this.worklet = this.options.worklet;

        this.subscribePageEvent("worklet:editor:save", this.editorSavingEvent);
        this.state = this.options.state || 'running';
    },

    clickedMenu: function(e) {
        e && e.preventDefault();
        var eventType = e.currentTarget.dataset.eventType;
        chorus.PageEvents.trigger("menu:worklet", eventType);
    },

    editorSavingEvent: function(event) {
        if (event === 'saving') {
            this.$('button.save').startLoading("general.saving");
        } else {
            this.$('button.save').stopLoading();
        }
    },

    togglePopupMenu: function(e) {
        chorus.PopupMenu.toggle(this, ".menu.popup_worklet_menu", e, '.actions_menu');
    },

    additionalContext: function() {
        return {
            editing: this.state === 'editing',
            fileName: this.worklet.get('fileName'),
            iconUrl: this.worklet.iconUrl()
        };
    }
});