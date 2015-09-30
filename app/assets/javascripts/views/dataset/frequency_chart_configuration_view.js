chorus.views.FrequencyChartConfiguration = chorus.views.ChartConfiguration.extend({
    constructorName: "FrequencyChartConfiguration",
    templateName: "chart_configuration",
    additionalClass: "frequency",

    events: {
        "click input.orientation_radio": "orientationSelected"
    },

    columnGroups: [
        {
            type: "all",
            name: "category",
            options: true
        }
    ],

    setup: function() {
        this._super("setup");

        this._chart_options = {
            orientation: "vertical"
        };
    },

    orientationSelected: function(e) {
        this._chart_options.orientation = e.target.dataset.orientation;
        this.trigger("configChanged");
    },

    chartOptions: function() {
        return {
            orientation: this._chart_options.orientation,
            type: "frequency",
            name: this.model.get("objectName"),
            yAxis: this.$(".category select option:selected").text(),
            bins: this.$(".limiter .selected_value").text()
        };
    },

    additionalContext: function() {
        var ctx = this._super("additionalContext");

        _.extend(ctx, {
            isHorizontal: this.chartOptions().orientation === 'horizontal'
        });

        return ctx;
    }
});