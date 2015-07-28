chorus.views.WorkletHeader = chorus.views.Base.extend({
    templateName: "worklet_header",
    constructorName: "WorkletHeaderView",
    //additionalClass: 'taggable_header',

    events: {
        "click a.edit_mode": 'clickedEditMode',
        "click a.preview_mode": 'clickedPreviewMode'
    },

    clickedEditMode: function(e) {
        e && e.preventDefault();
        chorus.PageEvents.trigger("menu:worklet", "edit_mode");
    },

    clickedPreviewMode: function(e) {
        e && e.preventDefault();
        chorus.PageEvents.trigger("menu:worklet", "preview_mode");
    },

    setup: function() {
        // this.subscribePageEvent("menu:worklet", this.menuEventHandler);
    },

    postRender: function() {
        if (this.options.menuOptions && this.options.menuOptions.length > 0) {
            var menu = new chorus.views.LinkMenu({
                title: "Actions:", //t("workfiles.header.menu.sort.title"),
                options: this.options.menuOptions,
                event: "worklet"
            });

            $(".menus").append(
                menu.render().el
            );

            menu.bind("choice", function(eventType, choice) {
                chorus.PageEvents.trigger("menu:" + eventType, choice);
            });
        }
    },

    additionalContext: function() {
        return {
            editing: this.options.mode === 'edit',
            iconUrl: this.model.iconUrl()
        };
    }
});