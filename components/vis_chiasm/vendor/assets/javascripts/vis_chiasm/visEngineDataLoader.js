var Model = require("model-js");
var dsvDataset = require("dsv-dataset");

module.exports = function() {

    var model = Model({
        publicProperties: ["dataset_id"],
        dataset_id: Model.None
    });

    model.when("dataset_id", function(dataset_id) {
        if (dataset_id !== Model.None) {

            var urls = ['datasets/' + dataset_id + '/chiasm_api_datasets/show_column_data',
                'datasets/' + dataset_id + '/chiasm_api_datasets/show_data'];

            $.when.apply($, urls.map(function(url) {
                return $.ajax({
                    url: url,
                    async: false,
                    dataType: 'text'
                });
            })).done(function() {

                var column_data = eval(arguments[0][0]);
                var data = arguments[1][0];

                var dsvDatasetConfig = {
                    "dsvString": data,
                    "metadata": {
                        "delimiter": ",",
                        "columns": column_data
                    }
                }

                var dataset = dsvDataset.parse(dsvDatasetConfig);
                model.data = dataset.data;

            });

        }
    });
    return model;
};
