chorus.views.PublishedWorkletList = chorus.views.Base.extend({
    constructorName: "PublishedWorkletListView",
    templateName: "published_worklet_list",

    postRender:function () {
        var div = this.$(".published_worklets");
        this.published_worklets = [];

        this.collection.each(function(model) {
            try {
                var view = new chorus.views.PublishedWorklet({
                    model: model
                });
                this.published_worklets.push(view);
                this.registerSubView(view);
                div.append(view.render().el);
            } catch (err) {
                chorus.log(err.message, err, "processing published_worklet", model);
                if (chorus.isDevMode()) {
                    var action, id;
                    try {action = model.get("action");  id = model.id;} catch(err2) {}
                    // KT: TODO
                    //chorus.toast("bad_published_worklet.toast", {type: action, id: id, toastOpts: {type: "error"}});
                }
            }
        }, this);
    }
});
