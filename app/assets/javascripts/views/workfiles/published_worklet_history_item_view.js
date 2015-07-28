chorus.views.PublishedWorkletHistoryItem = chorus.views.Base.extend({
    constructorName: 'PublishedWorkletHistoryItemView',
    templateName: 'published_worklet_history_item',

    events: {
        'click div.history_item': 'showResults'
    },

    setup: function() {

    },

    showResults: function() {
        // Render worklet output into the middle pane
        var main = this.options.mainPage;
        var newView = new chorus.views.PublishedWorkletOutput({
            resultsId: this.model.id,
            worklet: this.model.workfile(),
            resultsUrl: this.model.attachments()[0].url()
        });
        main.updateMiddleContent(newView);

        // Style the selected history item.
        $('.published_worklet_history_item').removeClass('history_item_selected');
        $(this.el).addClass('history_item_selected');

        $('#share_results').show();

        this.workletVariableVersions = new chorus.collections.WorkletVariableVersionSet([], {eventId: this.model.id});
        this.workletVariableVersions.fetch();
        this.onceLoaded(this.workletVariableVersions, this.populateFields);
    },

    populateFields: function() {
        this.workletVariableVersions.each(function(model) {
            var dataType = model.get('dataType');
            var name = model.get('name');
            if(dataType === 'integer' || dataType === 'string') {
                $("input[name='" + name +"']").val(model.get('value'));
            }
            else if(dataType === 'singleOption') {
                var select = $("select[name='" + name +"']");
                select.val(model.get('value'));
                select.next().find('.ui-selectmenu-text').text(model.get('value'));

            }
            else if(dataType === 'multipleOptions') {
                var value = model.get('value');
                value = value.substring(1, value.length-1);
                var values = value.split(',');
                _.each(values, function(v) {
                    $("[name='" + name + "']").find("input[value=\'" + v + "\']").prop('checked', true);
                });
            }
        });
    },

    additionalContext: function() {
        var date = new Date(this.model.get('timestamp'));
        var dateString = date.toString('yyyy-MM-dd HH:mm:ss');
        var relativeTime = date.toRelativeTime();
        return {
            number: this.options.index,
            dateString: dateString,
            relativeTime: relativeTime
        };
    }
});
