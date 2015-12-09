chorus.views.HdfsShowFilePreview = chorus.views.Base.extend({
    templateName: "hdfs_show_file_preview",

    events: {},

    setup: function () {
    },

    postRender: function () {

        this.chiasmInit();
    },

    additionalContext: function () {
        return {
            includeHeader: true
        }
    },

    chiasmInit: function () {

        // Guard against multiple invocations.
        // This function actually gets called about 5 times, for whatever reason,
        // maybe some technical debt regarding the Backbone setup.
        if (!this.chiasm) {
            this.chiasm = ChiasmBundle();

            var fileName = this.model.get('name');
            var filePath = this.model.get('path');

            // Remove leading slash.
            filePath = filePath.substr(1);

            var hdfsDataSource = this.model.get('hdfsDataSource');
            //console.log(hdfsDataSource);

            // These are the parameters required to invoke the data loading API.
            var dataLoaderParams = {
                dataSourceName: hdfsDataSource.name,
                token: window.chorus.session.get('sessionId'),

                // HDFS - CSV file path with no leading slash
                // DB - database.schema.table (not implemented yet)
                // Hive - database.table (not implemented yet)
                path: filePath + "/" + fileName,

                // TODO get this out of Chorus properties file.
                numRows: 5000
            }

            this.chiasm.setConfig({
                "layout": {
                    "plugin": "layout",
                    "state": {
                        "containerSelector": "#chiasm-container",
                        "layout": "vis"
                    }
                },
                "vis": {
                    "plugin": "barChart",
                    "state": {
                        "xColumn": "name",
                        "xAxisLabelText": "name",
                        "yColumn": "age",
                        "yAxisLabelText": "age"
                    }
                },

                // This component fetches data from the Alpine API.
                // It is defined under
                // vis_chiasm_58/vendor/assets/javascripts/vis_chiasm
                "loader": {
                    "plugin": "visEngineDataLoader",
                    "state": dataLoaderParams
                },

                "links": {
                    "plugin": "links",
                    "state": {
                        "bindings": [
                            "loader.dataset -> vis.dataset"
                        ]
                    }
                }
            });
        }
    }

});