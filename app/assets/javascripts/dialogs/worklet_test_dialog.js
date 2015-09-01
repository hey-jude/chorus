chorus.dialogs.WorkletTest = chorus.dialogs.Base.extend({
    constructorName: "WorkletTest",
    additionalClass: 'dialog_wide',
    templateName: "worklets/worklet_test",
    title: t("worklet.test.title"),

    setup: function() {
        this.workletParameters = this.options.workletParameters;
        this.worklet = this.options.worklet;
        this.outputTable = this.options.outputTable;

        this.listenTo(this.worklet, "saved", this.startRun);
        this.subscribePageEvent("worklet:run", this.runEventHandler);

        // DEV-12572
        // used to avoid weird situations where test run worklet isn't concluded but dialog closes for some reason
        $(window).on("beforeunload", this.closeModal);

        this.worklet.run(this.workletParameters, true);
        this.listenToOnce(this.worklet, "saved", this.runStarted);
        this.listenToOnce(this.worklet, "saveFailed", this.runFailed);
    },

    runStarted: function() {
        chorus.PageEvents.trigger("worklet:run", "runStarted");
    },

    runFailed: function() {
        // This line is a terrible hack to get rid of any unnecessary error fields that come from running the test window.  Not pretty, but we can think of a better way later.
        window.$('.errors').hide();
        this.closeModal();
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
        this.$('#elapsed_time').html(elapsed_time + ' ' + t("time.abbrv.second") );
    },

    startRun: function() {
        this.resultId = this.worklet.get('killableId');
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
        // see above, unbind event if the modal is closed
        $(window).off("beforeunload", this.closeModal);
        if (this.worklet.get('running')) {
            this.worklet.stop();
        }
        this.worklet.restorePreRunAttributes();
        this._super("modalClosed");
    },

    testResultUrl: function() {
        var outputVars = this.outputTable || this.worklet.get('outputTable') || [];
        return "/alpinedatalabs/main/chorus.do?method=showWorkletResults&session_id=" + chorus.session.get("sessionId") + "&workfile_id=" + this.worklet.id + "&result_id=" + this.resultId + "&output_names=" +  outputVars.join(';;;') + "&iebuster=" + chorus.cachebuster();
    },

    additionalContext: function(context) {
        // If there's no this.model, additionalContext must return an object.
        return {
        };
    }
});