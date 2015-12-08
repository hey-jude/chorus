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

            var hdfsDataSource = this.model.get('hdfsDataSource');
            var datasetId = hdfsDataSource.id;
            //console.log(hdfsDataSource);

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
                "loader": {
                    "plugin": "visEngineDataLoader",
                    "state": {
                        "datasetId": datasetId
                    }
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