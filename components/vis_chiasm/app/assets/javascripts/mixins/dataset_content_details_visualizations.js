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

    // Initializes the Chiasm runtime.
    // Calls the given callback with the Chiasm instance and fetched column type information.
    // This is an ugly hack done under time pressure.
    // It is necessary for knowing the column types
    // at the time the full configuration is generated, so the category selector UI
    // will work for both numeric and categorical columns. -- CK 10/5/15
    chiasmInit: function (dataset_id, callback){
        if(!this.chiasm){
            this.chiasm = new ChiasmBundle();
        }
        var chiasm = this.chiasm;

        chiasm.setConfig({
            "loader": this.generateLoaderConfig(dataset_id)
        });

        this.chiasm.getComponent("loader").then(function (loader){
            loader.when("dataset", function (dataset){
                callback(chiasm, dataset.metadata.columns);
            });
        });
    },
    updateChiasmVisualization: function(){
        var chartOptions = this.chartConfig.chartOptions();
        var dataset_id = this.chartConfig.model.id;
        var chartType = chartOptions.type;

        var alpineBlue = "#00a0e5";
        var alpineBlueDark = "#007FB5";

        // TODO go back and refactor to remove this nasty handling of "this"
        var generateBarChartConfig = _.bind(this.generateBarChartConfig, this);
        var generateHeatMapConfig = _.bind(this.generateHeatMapConfig, this);
        var generateBoxPlotConfig = _.bind(this.generateBoxPlotConfig, this);


        this.chiasmInit(dataset_id, function (chiasm, columns){

            // TODO refactor this code to use a more elegant construct than a series of conditionals
            if(chartType === "frequency"){

                var params = {
                    orientation: chartOptions.orientation,
                    selectedColumn: {
                        name: chartOptions.yAxis,

                        // In the future, this is where we can put the
                        // human-readable label for the column
                        label: chartOptions.yAxis,

                        // Use the fetched column metadata to determine the type of the selected column.
                        // TODO refactor this ugly hack.
                        type: columns.find(function (column){
                            return column.name === chartOptions.yAxis;
                        }).type
                    },
                    barColor: alpineBlue,
                    dataset_id: dataset_id,
                    numBins: chartOptions.bins
                };
                chiasm.setConfig(generateBarChartConfig(params));

            } else if(chartType === "heatmap") {
                var params = {
                    xColumn: {
                        name: chartOptions.xAxis,
                        label: chartOptions.xAxis,
                        type: columns.find(function (column){
                            return column.name === chartOptions.xAxis;
                        }).type
                    },
                    yColumn: {
                        name: chartOptions.yAxis,
                        label: chartOptions.yAxis,
                        type: columns.find(function (column){
                            return column.name === chartOptions.yAxis;
                        }).type
                    },
                    color: alpineBlueDark,
                    dataset_id: dataset_id,
                    numBinsX: chartOptions.xBins,
                    numBinsY: chartOptions.yBins
                };
                chiasm.setConfig(generateHeatMapConfig(params));
            } else if(chartType === "boxplot") {
                console.log("here");
                console.log(chartOptions);
                var params = {
                    xColumn: {
                        name: chartOptions.xAxis,
                        label: chartOptions.xAxis,

                        // TODO make the UI for selecting this column
                        // restrict options to categorical only.
                        // TODO show an error if a non-categorical column is selected here.
                        type: columns.find(function (column){
                            return column.name === chartOptions.xAxis;
                        }).type
                    },
                    yColumn: {
                        name: chartOptions.yAxis,
                        label: chartOptions.yAxis,
                        type: columns.find(function (column){
                            return column.name === chartOptions.yAxis;
                        }).type
                    },
                    color: alpineBlueDark,
                    dataset_id: dataset_id,
                    numBinsX: chartOptions.bins
                };
                chiasm.setConfig(generateBoxPlotConfig(params));
            } else {
                //chiasm.setConfig({});
            }
        });




        //this.chiasmFetchData(chartOptions, function (data){
        //    chiasm.getComponent("visualization").then(function(visualization){
        //        visualization.data = data;
        //    });
        //});
    },
    generateBarChartConfig: function(params){

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
            "loader": this.generateLoaderConfig(params.dataset_id),
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
    generateHeatMapConfig: function(params){
        return {
            "layout": {
                "plugin": "layout",
                "state": {
                    "containerSelector": "#chiasm-container",
                    "layout": "visualization"
                }
            },
            "visualization": {
                "plugin": "heatMap",
                "state": {
                    "colorColumn": "count",
                    "xColumn": params.xColumn.name,
                    "xLabel": params.xColumn.label,
                    "yColumn": params.yColumn.name,
                    "yLabel": params.yColumn.label,
                    "colorRangeMin": "#FFFFFF",
                    "colorRangeMax": params.color
                }
            },
            "loader": this.generateLoaderConfig(params.dataset_id),
            "reduction": {
                "plugin": "dataReduction",
                "state": {
                    "aggregate": {
                        "dimensions": [
                            {
                                "column": params.xColumn.name,
                                "histogram": params.xColumn.type !== "string",
                                "numBins": parseFloat(params.numBinsX)
                            },
                            {
                                "column": params.yColumn.name,
                                "histogram": params.yColumn.type !== "string",
                                "numBins": parseFloat(params.numBinsY)
                            }
                        ],
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
    generateBoxPlotConfig: function(params){
        return {
            //TODO factor out layout config similar to loader config
            "layout": {
                "plugin": "layout",
                "state": {
                    "containerSelector": "#chiasm-container",
                    "layout": "visualization"
                }
            },
            "visualization": {
                "plugin": "boxPlot",
                "state": {
                    "xColumn": params.xColumn.name,
                    "xAxisLabelText": params.xColumn.label,
                    "yColumn": params.yColumn.name,
                    "yAxisLabelText": params.yColumn.label
                }
            },
            "loader": this.generateLoaderConfig(params.dataset_id),
            "links": {
                "plugin": "links",
                "state": {
                    "bindings": [
                        "loader.data -> visualization.data"
                    ]
                }
            }
        };
    },
    generateLoaderConfig: function (dataset_id){
        return {
            "plugin": "visEngineDataLoader",
            "state": {
                "dataset_id": dataset_id,
                "numRows": 1000 // TODO move this default into chorus.properties
            }
        }
    },

    additionalContextForVisualizations: function() {
        var self = this;

        return {showVisualize: this.dataset.schema()};
    },

    // This line disables the funky "StickyHeader" behavior that was
    // causing problems with the orientation radio buttons. -- CK 10/6/2015
    stickyHeaderElements: function() { return []; }
};