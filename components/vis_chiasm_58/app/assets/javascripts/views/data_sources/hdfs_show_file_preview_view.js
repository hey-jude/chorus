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
            //console.log(hdfsDataSource);

            // These are the parameters required to invoke the data loading API.
            var dataLoaderParams = {
                datasetId: hdfsDataSource.id,
                token: window.chorus.session.get('sessionId')
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

                // This component is defined under
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