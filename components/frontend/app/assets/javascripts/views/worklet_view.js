chorus.views.WorkletView = chorus.views.Base.extend({
    constructorName: 'WorkletView',
    templateName: 'worklets/worklet',

    events: {
        "submit form": 'saveWorklet'
    },

    saveWorklet: function saveWorklet(e) {
        e.preventDefault();
        chorus.page.stopListening(this.model, "unprocessableEntity");
        var updates = {};
        _.each(this.$("input"), function (i) {
            var input = $(i);
            updates[input.attr("name")] = input.val().trim();
        });

        var outputs = [];

        _.each(this.$("input[name='output']"), function(i) {
            if(i.checked) {
                outputs.push(i.value);
            }
        });
        delete updates["output"];
        updates["outputTable"] = outputs;

        updates.contentType = 'worklet';

        this.model.save(updates);
    },

    makeModel: function () {
        this.model = this.model || new chorus.models.Worklet();
    },

    setup: function(options) {
        this.workspaceId = options.workspaceId;
        $.ajax({
            url: "/alpinedatalabs/main/chorus.do?method=getFlowOperators&workfile_id=260&session_id=" + chorus.session.get('sessionId'),
            type: "GET",
            dataType: "json",
            success: function(data) {
            }
        });
    }
});
