chorus.dialogs.WorkletTest = chorus.dialogs.Base.extend({
    constructorName: "WorkletTest",
    additionalClass: 'dialog_wide',
    templateName: "worklets/worklet_test",
    title: t("worklet.test.title"),

    setup: function() {
        this.model = this.options.model;
        this.workletParameters = this.options.workletParameters;

        this.listenTo(this.model, "saved", this.startRun);
        this.subscribePageEvent("worklet:run", this.runEventHandler);

        this.model.run(this.workletParameters, true);
        this.listenToOnce(this.model, "saved", this.runStarted);
    },

    runStarted: function() {
        chorus.PageEvents.trigger("worklet:run", "runStarted");
    },

    postRender: function() {
        // container box will be 2*radius + 2*
        this.$('#spinner').startLoading(null, {
            lines: 12,
            length: 32,
            width: 11,
            radius: 36,
            color: '#00A0E5',
            speed: 1,
            trail: 75,
            shadow: false,
            scale: 1
        });
    },


    updateElapsedTime: function() {
        var cur_time = new Date().getTime() / 1000;
        var elapsed_time = Math.floor(cur_time - this.startTime);

        this.$('#elapsed_time').html(elapsed_time + ' sec.');
    },

    startRun: function() {
        this.resultId = this.model.get('killableId');
        this.startTime = new Date().getTime() / 1000;
        this.elapsedTimeCounter = setInterval(this.updateElapsedTime.bind(this), 1000);
    },

    runEventHandler: function(event) {
        if (event === 'runStopped') {
            this.$('#testResults_frame')[0].src = this.testResultUrl();
            this.$("#testResults_frame").on("load",
                { counter: this.elapsedTimeCounter },
                function (event) {
                    if(this.getAttribute('src')) {
                        $('#spinner').stopLoading();
                        $('#workletResults_loading').hide();
                        $('#testResults_frame').show();
                        clearInterval(event.data.counter);
                        this.style.height = '500px';
                    }
                }
            );
        }
    },

    modalClosed: function() {
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