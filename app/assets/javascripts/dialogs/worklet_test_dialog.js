chorus.dialogs.WorkletTest = chorus.dialogs.Base.extend({
    constructorName: "WorkletTest",
    additionalClass: 'dialog_wide',
    templateName: "worklets/worklet_test",
    title: t("worklet.test.title"),

    setup: function() {
        this.model = this.options.model;
        this.workletParameters = this.options.workletParameters;

        this.listenTo(this.model, "saved", this.startPolling);
        this.model.run(this.workletParameters, true);
    },

    startPolling: function(model) {

        this.resultId = model.get('killableId');

        this.pollForRunStatus = _.bind(function() {
            this.model.fetch({
                success: _.bind(function(model) {
                    if(!model.get('running')) {
                        clearInterval(this.pollerID);
                        this.$('#test_results')[0].src = this.testResultUrl();
                        this.$("#test_results").on("load", function () {
                            if(this.getAttribute('src')) {
                                $('#test_results').show();
                                $('#share_results_loading').hide();
                                this.style.height='500px';
                            }
                        });
                    }
                }, this)
            });
        }, this);

        this.pollerID = setInterval(this.pollForRunStatus, 5000);

    },

    modalClosed: function() {
        if(this.pollerID) {
            clearInterval(this.pollerID);
        }
        if(this.model.get('running')) {
            this.model.stop();
        }

        this._super("modalClosed");
    },

    testResultUrl: function() {
        var outputVars = this.model.get('outputTable') || [];
        return "/alpinedatalabs/main/chorus.do?method=showWorkletResults&session_id=" + chorus.session.get("sessionId") + "&workfile_id=" + this.model.id + "&result_id=" + this.resultId + "&output_names=" +  outputVars.join(';;;') + "&iebuster=" + chorus.cachebuster();
    },

    additionalContext: function(context) {

    }
});