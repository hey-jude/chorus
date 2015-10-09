chorus.Mixins.DatasetContentDetailsVisualizations = {

    preInitialize: function() {

        this.events["click .create_chart .cancel"] = "cancelVisualization";
        this.events["click .chart_icon"] = "selectVisualization";
        this.events["click button.visualize"] = "startVisualizationWizard";

        this._super("preInitialize", arguments);
    },

    startVisualizationWizard: function() {
        this.resultsConsole.clickClose();
        this.$('.chart_icon:eq(0)').click();
        this.$('.column_count').addClass('hidden');
        this.$('.info_bar').removeClass('hidden');
        this.$('.definition').addClass("hidden");
        this.$('.create_chart').removeClass("hidden");
        this.$(".filters").removeClass("hidden");
        this.filterWizardView.options.showAliasedName = false;
        this.filterWizardView.resetFilters();
        chorus.PageEvents.trigger("start:visualization");
    },

    selectVisualization: function(e) {
        var type = $(e.target).data('chart_type');
        this.$(".create_chart .cancel").data("type", type);
        this.$('.chart_icon').removeClass('selected');
        $(e.target).addClass('selected');
        this.showTitle(e);
        this.showVisualizationConfig(type);
    },

    cancelVisualization: function(e) {
        e.preventDefault();
        this.$('.definition').removeClass("hidden");
        this.$('.create_chart').addClass("hidden");
        this.$(".filters").addClass("hidden");
        this.$('.column_count').removeClass("hidden");
        this.$('.info_bar').addClass('hidden');
        this.$(".chart_config").addClass('hidden');
        chorus.PageEvents.trigger('cancel:visualization');
        if (this.chartConfig) {
            this.chartConfig.teardown(true);
            delete this.chartConfig;
        }
    },

    showVisualizationConfig: function(chartType) {
        if (this.chartConfig) { this.chartConfig.teardown(true);}

        var options = {model: this.dataset, collection: this.collection, errorContainer: this};
        this.chartConfig = chorus.views.ChartConfiguration.buildForType(chartType, options);
        this.chartConfig.filters = this.filterWizardView.collection;

        this.$(".chart_config").removeClass("hidden");
        this.renderSubview("chartConfig");
    },

    additionalContextForVisualizations: function() {
        var self = this;

        return {showVisualize: this.dataset.schema()};
    }
};