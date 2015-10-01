chorus.translation = {
    parseProperties:function (propertiesString) {
        var lineJoiningRegex = /\\\s*\n/g;
        var joinedLines = propertiesString.replace(lineJoiningRegex, '').split("\n");

        var result = {};
        _.each(joinedLines, function (line) {
            var match = line.split("=");
            if (match.length < 2) return;
            if (match[0].match(/^\s*#/)) return;
            var keys = match[0].split("."),
                val = _.rest(match).join("=");

            var innerHash = _.reduce(_.initial(keys), function (hash, key) {
                return hash[key] || (hash[key] = {});
            }, result);

            if (!_.isUndefined(innerHash[_.last(keys)]) || !_.isObject(innerHash)) {
                window.alert("Translation: " + line + " is a collision with an existing translation");
            }
            innerHash[_.last(keys)] = val;
        });

        return result;
    }
};

$.when.apply($, window.chorus.translation_files.map(function(url) {
    return $.ajax({
        url:url,
        async:false,
        dataType:'text'
    });
})).done(function() {

    var concatenatedTranslationsFiles = '';
    for (var i = 0; i < arguments.length; i++) {
        concatenatedTranslationsFiles += arguments[i][0];
    }

    I18n.translations = {};
    I18n.translations[chorus.locale] = chorus.translation.parseProperties(concatenatedTranslationsFiles);
});