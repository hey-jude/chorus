chorus.handlebarsHelpers.config = {

    ifTouchpoints: function (block) {
        this.config = chorus.models.Config.instance();
        var touchpoints = this.config.get("touchpointsEnabled");
        if (touchpoints === true) {
            return block.fn(this);
        } else if (block.inverse) {
            return block.inverse(this);
        }
    }
};

_.each(chorus.handlebarsHelpers.config, function(helper, name) {
    Handlebars.registerHelper(name, helper);
});
