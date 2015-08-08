chorus.views.WorkletHeader = chorus.views.Base.extend({
    templateName: "worklets/worklet_header",
    constructorName: "WorkletHeaderView",
    additionalClass: "sub_nav",
    //tagName: "ul",

    events: {
        "click button.save": 'clickedMenu',
        "click button.close": 'clickedMenu',
        "click a.menu_item": 'clickedMenu',
        "click a.menu_launcher": 'togglePopupMenu'
    },

    setup: function() {
        this.subscribePageEvent("worklet:editor:save", this.editorSavingEvent);

        this.state = this.options.state || 'running';
    },

    clickedMenu: function(e) {
        e && e.preventDefault();

        var eventType = e.currentTarget.dataset.eventType;
        chorus.PageEvents.trigger("menu:worklet", eventType);
    },

    editorSavingEvent: function(event) {
        this._saving = (event === 'saving');
        this.render();
    },

    togglePopupMenu: function(e) {
        chorus.PopupMenu.toggle(this, ".menu.popup_worklet_menu", e, '.menu_launcher');
    },

    additionalContext: function() {
        return {
            saving: this._saving,
            editing: this.state === 'editing',
            iconUrl: this.model.iconUrl()
        };
    }
});