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

            // Details on Alpine's API here: https://github.com/alpinedatalabs/adl/pull/920
            // http://localhost:9090/alpinedatalabs/api/v1/json/data/datasources/GPDB/airline.airports/rows?fetch=random&max=10&columns=airport,city&token=c2060462434fb03bc12076f202a36720d279ac35

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
                        "sizeColumn": "age",
                        "idColumn": "name",
                        "fill": "none",
                        "stroke": "black",
                        "strokeWidth": "2px",
                        "barPadding": 0.2,
                        "orientation": "vertical"
                    }
                }
            });

            var dataset = {
                data: [
                    {name: "Joe", age: 29, birthday: new Date(1986, 11, 17)},
                    {name: "Jane", age: 31, birthday: new Date(1985, 1, 15)}
                ],
                metadata:{}
            };

            chiasm.getComponent("barChart").then(function (barChart) {
                console.log(barChart);
                barChart.dataset = dataset;
            });
        }
    }

});