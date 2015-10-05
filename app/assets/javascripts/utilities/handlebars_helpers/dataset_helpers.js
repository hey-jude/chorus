chorus.handlebarsHelpers.dataset = {
    sqlDefinition: function(definition) {
        if (!definition) {
            return '';
        }
        definition || (definition = '');
        var promptSpan = $('<span>').addClass('sql_prompt').text(t("dataset.content_details.sql_prompt")).outerHtml();
        var sqlSpan = $('<span>').addClass('sql_content').attr('title', definition).text(definition).outerHtml();
        return new Handlebars.SafeString(t("dataset.content_details.definition", {sql_prompt: promptSpan, sql: sqlSpan}));
    },

    datasetLocation: function(dataset, label) {
        var locationPieces = [];
        var dataSource;
        var dataSourceName;

        function locateDBDataset() {
            dataSource = dataset.dataSource();
            dataSourceName = dataSource.name();
            var schema = dataset.schema();
            var database = dataset.database();

            var databaseName = (database && Handlebars.helpers.withSearchResults(database).name()) || "";
            var schemaName = Handlebars.helpers.withSearchResults(schema).name();

            if (dataset.get('hasCredentials') === false) {
                locationPieces.push(dataSourceName);
                if (databaseName.toString()) {
                    locationPieces.push(databaseName);
                }
                locationPieces.push(schemaName);
            } else {
                locationPieces.push(Handlebars.helpers.linkTo(dataSource.showUrl(), dataSourceName, {"class": "data_source"}).toString());
                if (databaseName.toString()) {
                    locationPieces.push(Handlebars.helpers.linkTo(database.showUrl(), databaseName, {"class": "database"}).toString());
                }
                locationPieces.push(Handlebars.helpers.linkTo(schema.showUrl(), schemaName, {'class': 'schema'}).toString());
            }
        }

        function locateHdfsDataset() {
            dataSource = dataset.dataSource();
            dataSourceName = dataSource.name();
            locationPieces.push(Handlebars.helpers.linkTo(dataSource.showUrl(), dataSourceName, {"class": "data_source"}).toString());
        }

        if (dataset.get('entitySubtype') === 'HDFS') {
            locateHdfsDataset();
        } else {
            if (!dataset.schema()) return "";
            locateDBDataset();
        }

        label = _.isString(label) ? label : "dataset.from";
        var translation = t(label, {location: locationPieces.join('.')});
        return new Handlebars.SafeString($("<span></span>").html(translation).outerHtml());
    },

    humanizedDatasetType: function(dataset, statistics) {
        if (!dataset) { return ""; }
        var keys = ["dataset.entitySubtypes", dataset.entitySubtype];
        if (statistics instanceof chorus.models.DatasetStatistics && statistics.get("objectType")) {
            keys.push(statistics.get("objectType"));
        }
        else if (dataset.entitySubtype === "CHORUS_VIEW" || dataset.entitySubtype === "SOURCE_TABLE" || dataset.entitySubtype === "HDFS")
        {
            keys.push(dataset.objectType);
        }
        else if (dataset.entitySubtype === "SANDBOX_TABLE")
        {
            if (dataset.objectType === "TABLE") {
                keys.push("BASE_"+dataset.objectType);
            } else {
                keys.push(dataset.objectType);
            }
        }
        else {
            return t("general.loading");
        }
        var key = keys.join(".");
        return t(key);
    }
};

_.each(chorus.handlebarsHelpers.dataset, function(helper, name) {
    Handlebars.registerHelper(name, helper);
});
