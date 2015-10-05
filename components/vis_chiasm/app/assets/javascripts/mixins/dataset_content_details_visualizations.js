chorus.Mixins.DatasetContentDetailsVisualizations = {

    preInitialize: function() {

        this.events["click .create_chart .cancel"] = "cancelVisualization";
        this.events["click .chart_icon"] = "selectVisualization";
        this.events["click button.visualize"] = "startVisualizationWizard";

        this._super("preInitialize", arguments);
    },

    startVisualizationWizard: function() {
        this.resultsConsole.clickClose();

        // This flag comes from the file chorus/config/chorus.properties
        if(instance.attributes.chiasmEnabled){

          // Show the Chiasm visualization container.
          $("#chiasm-container").removeClass("hidden");
        }

        this.$(".chart_icon:eq(0)").click();
        this.$(".column_count").addClass("hidden");
        this.$(".info_bar").removeClass("hidden");
        this.$(".definition").addClass("hidden");
        this.$(".create_chart").removeClass("hidden");
        this.$(".filters").removeClass("hidden");
        this.filterWizardView.options.showAliasedName = false;
        this.filterWizardView.resetFilters();

        chorus.PageEvents.trigger("start:visualization");
    },

    selectVisualization: function(e) {

        // Extract the selected chart type.
        var type = $(e.target).data("chart_type");

        this.$(".create_chart .cancel").data("type", type);
        this.$(".chart_icon").removeClass("selected");
        $(e.target).addClass("selected");
        this.showTitle(e);
        this.showVisualizationConfig(type);
    },

    // TODO Mike Souza: perhaps this is where we would pass the 'check_id' to the controller and cancel the query?
    cancelVisualization: function(e) {
        e.preventDefault();

        // Hide the Chiasm visualization container.
        if(instance.attributes.chiasmEnabled){
            $("#chiasm-container").addClass("hidden");
        }

        this.$(".definition").removeClass("hidden");
        this.$(".create_chart").addClass("hidden");
        this.$(".filters").addClass("hidden");
        this.$(".column_count").removeClass("hidden");
        this.$(".info_bar").addClass("hidden");
        this.$(".chart_config").addClass("hidden");
        chorus.PageEvents.trigger("cancel:visualization");
        if(this.chartConfig) {
            this.chartConfig.teardown(true);
            delete this.chartConfig;
        }
    },

    showVisualizationConfig: function(chartType) {

        if(this.chartConfig) { this.chartConfig.teardown(true);}

        var options = { model: this.dataset, collection: this.collection, errorContainer: this };
        this.chartConfig = chorus.views.ChartConfiguration.buildForType(chartType, options);
        this.chartConfig.filters = this.filterWizardView.collection;
        this.chartConfig.chartType = chartType;

        this.$(".chart_config").removeClass("hidden");
        this.renderSubview("chartConfig");

        // This flag comes from the file chorus/config/chorus.properties
        if(instance.attributes.chiasmEnabled){

            // Update the Chiasm visualization to initialize.
            this.updateChiasmVisualization();

            // Update the Chiasm visualization when configuration changes.
            // The "configChanged" event is triggered whenever any part of the
            // visualization configuration changes.
            this.chartConfig.on("configChanged", _.bind(this.updateChiasmVisualization, this));
        }
    },

    // Queries the server for data, depending on the current chart type and configuration.
    //chiasmFetchData: function (chartOptions, callback){
    //    var chartType = chartOptions.type;
    //    var datasetId = this.chartConfig.model.id;
    //    var checkId =  Math.floor((Math.random()*1e8)+1).toString();
    //    var url = "datasets/" + datasetId + "/visualizations";

    //    // This code fetches the data via a "task" abstraction.
    //    // Copied from chart_configuration_view.js
    //    var func = "make" + _.capitalize(chartType) + "Task";
    //    var task = this.chartConfig.model[func](chartOptions);
    //    task.set({filters: chartOptions.filters && chartOptions.filters.sqlStrings()});

    //    // This callback gets invoked once the data is loaded.
    //    task.bindOnce("saved", function (model, data){

    //        // Extract the tabular data format that Chiasm visualizations expect (array of objects)
    //        callback(data.response.rows);
    //    });
    //    task.bindOnce("saveFailed", function (){
    //        // TODO bubble errors to the UI
    //        console.log("save failed");
    //    });

    //    var x = task.save();
    //},
    chiasmInit: function (){
        if(!this.chiasm){
            this.chiasm = new ChiasmBundle();
        }
        return this.chiasm;
    },
    updateChiasmVisualization: function(){
        var chartOptions = this.chartConfig.chartOptions();
        var alpineBlue = "#00a0e5";
        var chiasm = this.chiasmInit();

        //$("#chiasm-container")[0]
        /*
        var visualizationPlugin;

        if(chartOptions.type === "frequency"){
          visualizationPlugin = "barChart";
        }

        var config = {
            "layout": {
                "plugin": "layout",
                "state": {
                    "layout": "visualization"
                }
            },
            "visualization": {
                "plugin": visualizationPlugin,
                "state": {
                    "xColumn": chartOptions.yAxis,
                    "xAxisLabel": chartOptions.yAxis,
                    "yColumn": "count",
                    "yAxisLabel": "Count",
                    "xAxisLabelOffset": 1.9,
                    "yAxisLabelOffset": 1.4,
                    "colorDefault": alpineBlue,
                    "yDomainMin": 0,
                    "margin": {
                        "top": 15,
                        "right": 0,
                        "bottom": 60,
                        "left": 50
                    }
                }
            },
            "dataLoader": {
                "plugin": "visEngineDataLoader",
                "state": {
                    "dataset_id": this.chartConfig.model.id
                }
            },
            "dataReduction": {
                "plugin": "dataReduction",
                "state": {
                    "aggregate": {
                        "dimensions": [{
                            "column": chartOptions.yAxis
                        }],
                        "measures": [{
                            "outColumn": "count",
                            "operator": "count"
                        }]
                    }
                }
            },
            "links": {
              "plugin": "links",
              "state": {
                "bindings": [
                  "dataLoader.data -> dataReduction.dataIn",
                  "dataReduction.dataOut -> visualization.data"
                ]
              }
            }
        };
*/
        var params = {
            orientation: chartOptions.orientation,
            selectedColumn: {
                name: chartOptions.yAxis,

                // In the future, this is where we can put the
                // human-readable label for the column
                label: chartOptions.yAxis,

                type: "number"// TODO get this working
            },
            barColor: alpineBlue,
            dataset_id: this.chartConfig.model.id,
            numBins: chartOptions.bins
        };

        chiasm.setConfig(this.generateConfig(params));


        //this.chiasmFetchData(chartOptions, function (data){
        //    chiasm.getComponent("visualization").then(function(visualization){
        //        visualization.data = data;
        //    });
        //});
    },
    generateConfig: function(params){
        return {
            "layout": {
                "plugin": "layout",
                "state": {
                    "containerSelector": "#chiasm-container",
                    "layout": "visualization"
                }
            },
            "visualization": {
                "plugin": "barChart",
                "state": {
                    "sizeColumn": "count",
                    "sizeLabel": "Count",
                    "idColumn": params.selectedColumn.name,
                    "idLabel": params.selectedColumn.label,
                    "orientation": params.orientation,
                    "fill": params.barColor
                }
            },
            "loader": {
                "plugin": "visEngineDataLoader",
                "state": {
                    "dataset_id": params.dataset_id
                }
            },
            "reduction": {
                "plugin": "dataReduction",
                "state": {
                    "aggregate": {
                        "dimensions": [{
                            "column": params.selectedColumn.name,
                            "histogram": params.selectedColumn.type !== "string",
                            "numBins": parseFloat(params.numBins)
                        }],
                        "measures": [{
                            "outColumn": "count",
                            "operator": "count"
                        }]
                    }
                }
            },
            "links": {
                "plugin": "links",
                "state": {
                    "bindings": [
                        "loader.dataset -> reduction.datasetIn",
                        "reduction.datasetOut -> visualization.dataset"
                    ]
                }
            }
        };
    },

    additionalContextForVisualizations: function() {
        var self = this;

        return {showVisualize: this.dataset.schema()};
    }
};