//= require ./workfile_sidebar
chorus.views.WorkletSidebar = chorus.views.AlpineWorkfileSidebar.extend ({
    additionalContext: function() {
        var ctx = this._super('additionalContext', arguments);
        ctx.showPublishWorklet = this.model.get('state') === 'completed';
        ctx.showUnpublishWorklet = this.model.get('state') === 'published';
        return ctx;
    },
    setup: function() {
        this.events["click a.publish"] = "publishWorklet";
        this.events["click a.unpublish"] = "unpublishWorklet";
        this._super('setup', arguments);
    },

    publishWorklet: function(e) {
        e && e.preventDefault();
        this.model.isWorklet() && this.model.publishWorklet();
    },

    unpublishWorklet: function(e) {
        e && e.preventDefault();
        this.model.isWorklet() && this.model.unpublishWorklet();
    }
});