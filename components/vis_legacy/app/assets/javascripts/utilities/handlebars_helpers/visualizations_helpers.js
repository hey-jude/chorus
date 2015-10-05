chorus.handlebarsHelpers.visualizations = {
    chooserMenu: function(choices, options) {
        options = options.hash;
        var max = options.max || 20;
        choices = choices || _.range(1, max + 1);
        options.initial = options.initial || _.last(choices);
        var selected = options.initial || choices[0];
        var translationKey = options.translationKey || "dataset.visualization.sidebar.category_limit";
        var className = options.className || '';

//         var markup = "<div class='limiter " + className + "'><span class='pointing_l'></span>" + t(translationKey) + " <a href='#'><span class='selected_value'>" + selected + "</span><span class='triangle'></span></a><div class='limiter_menu_container'><ul class='limiter_menu " + className + "'>";
        var markup = "<div class='limiter " + className + "'><span class='pointing_l'></span>" + t(translationKey) + " <a href='#'><span class='selected_value'>" + selected + "</span><span class='fa fa-caret-down'></span></a><div class='limiter_menu_container'><ul class='limiter_menu " + className + "'>";
        
        _.each(choices, function(thing) {
            markup = markup + '<li>' + thing + '</li>';
        });
        markup = markup + '</ul></div></div>';
        return new Handlebars.SafeString(markup);
    }};

_.each(chorus.handlebarsHelpers.visualizations, function(helper, name) {
    Handlebars.registerHelper(name, helper);
});
