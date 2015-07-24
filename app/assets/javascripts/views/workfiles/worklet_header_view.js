chorus.views.WorkletHeader = chorus.views.Base.extend({
    templateName: "worklet_header",
    constructorName: "WorkletHeaderView",
    //additionalClass: 'taggable_header',

    //subviews: {
    //    '.tag_box': 'tagBox'
    //},

    setup: function() {
    },

    postRender: function() {
        var menu = new chorus.views.LinkMenu({
            title: "Actions:", //t("workfiles.header.menu.sort.title"),
            options: [
                {data: "details", text: "Configure Details"}, //t("workfiles.header.menu.sort.by_date")
                {data: "inputs", text: "Configure Inputs"}
            ],
            event: "worklet"
        });

        $(".menus").append(
            menu.render().el
        );

        menu.bind("choice", function(eventType, choice) {
            chorus.PageEvents.trigger("menu:" + eventType, choice);
        });
    },

    additionalContext: function() {
        return {
            iconUrl: this.model.iconUrl()
        };
    }
});
