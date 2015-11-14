chorus.views.PublishedWorkletHistoryEntry = chorus.views.Base.extend({
    constructorName: 'PublishedWorkletHistoryEntryView',
    templateName: 'worklets/published_worklet_history_entry',

    events: {
        'click div.history_entry': 'historyEntryClicked'
    },

    historyEntryClicked: function(e) {
        e && e.preventDefault();

        chorus.PageEvents.trigger("worklet:history_entry_clicked", this);
        this.showResults();
    },

    showResults: function() {
        // Render worklet output into the middle pane
        var main = this.options.mainPage.contentView;
        var newView = new chorus.views.PublishedWorkletOutput({
            resultsId: this.model.id,
            worklet: this.model.workfile(),
            flowResultsId: this.model.attachments()[0].id,
            resultsUrl: this.model.attachments()[0].url(),
            outputTable: this.model.get('outputTable')
        });

        chorus.PageEvents.trigger("worklet:history_results_shown", "");

        if (main.workletOutput) {
            main.workletOutput.teardown(true);
        }

        main.workletOutput = newView;
        main.renderSubview('workletOutput');
        this.trigger('resized');

        // Style the selected history entry
        $('.history_entry').removeClass('selected');
        $(this.el).find('.history_entry').addClass('selected');

        $('#workletResults_loading').show();

        this.workletParameterVersions = new chorus.collections.WorkletParameterVersionSet([], {eventId: this.model.id});
        this.workletParameterVersions.fetch();
        this.onceLoaded(this.workletParameterVersions, this.populateFields);
    },

    populateFields: function() {
        this.workletParameterVersions.each(function(model) {
            var dataType = model.get('dataType');
            var name = model.get('name');
            var value = model.get('value');

            if (dataType === t('worklet.parameter.datatype.number') ||
                dataType === t('worklet.parameter.datatype.text') ||
                dataType === 'integer' ||
                dataType === 'string') {
                $("input[name='" + name +"']").val(value);
            }
            else if (dataType === t('worklet.parameter.datatype.single_option_select') || dataType === 'singleOption') {
                var select = $("select[name='" + name +"']");
                select.val(value);
                select.next().find('.ui-selectmenu-text').text(value);
            }
            else if (dataType === t('worklet.parameter.datatype.multiple_option_select') || dataType === 'multipleOptions') {
                _.each($("[name^='" + name + "']"), function(p) {
                    $(p).prop('checked', false);
                });

                _.each(value.split(','), function(v) {
                    $("[name^='" + name + "'][value=\'" + v + "\']").prop('checked', true);
                });
            }
            else if (dataType === t('worklet.parameter.datatype.datetime_calendar')) {
                var d = moment(value);
                var date_container = $("div[data-var-name='" + name + "']");
                date_container.find('.day').val(d.format("DD"));
                date_container.find('.month').val(d.format("MM"));
                date_container.find('.year').val(d.format("YYYY"));
            }
        }, this);
    },

    additionalContext: function() {
        // data values for the history entry
        var date = new Date(this.model.get('timestamp'));
        var dateString = date.toString('HH:mm:ss  dd-MM-yyyy');
        var relativeTime = date.toRelativeTime();
        return {
            number: this.options.index,
            dateString: dateString,
            relativeTime: relativeTime
        };
    }
});
