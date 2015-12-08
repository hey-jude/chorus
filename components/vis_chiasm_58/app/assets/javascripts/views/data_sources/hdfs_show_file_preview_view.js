chorus.views.HdfsShowFilePreview = chorus.views.Base.extend({
    templateName: "hdfs_show_file_preview",

    events: {},

    setup: function () {
    },

    postRender: function () {
        var dataset_id = 1;

        this.chiasmInit(dataset_id);
    },

    additionalContext: function () {
        return {
            includeHeader: true
        }
    },

    chiasmInit: function (dataset_id) {
        if (!this.chiasm) {

            var chiasm = new ChiasmBundle();
            this.chiasm = chiasm;

            chiasm.setConfig({
                "layout": {
                    "plugin": "layout",
                    "state": {
                        "containerSelector": "#chiasm-container",
                        "layout": "barChart"
                    }
                },
                "barChart": {
                    "plugin": "barChart",
                    "state": {
                        "xColumn": "name",
                        "xAxisLabelText": "name",
                        "yColumn": "age",
                        "yAxisLabelText": "age"
                    }
                }
            });

            var dataset = {
                data: [
                    {name: "Joe", age: 29, birthday: new Date(1986, 11, 17)},
                    {name: "Jane", age: 31, birthday: new Date(1985, 1, 15)}
                ],
                metadata:{
                    columns: [
                        { name: "name", type: "string" },
                        { name: "age", type: "number" },
                        { name: "birthday", type: "date" }
                    ]
                }
            };

            chiasm.getComponent("barChart").then(function (barChart) {
                console.log(barChart);
                barChart.dataset = dataset;
            });
        }
    }

});