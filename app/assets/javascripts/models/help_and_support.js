chorus.models.HelpAndSupport = chorus.models.Base.extend({
    constructorName: "HelpAndSupport",
    urlTemplate: "help_and_support/download_logs",

    downloadLogs: function() {
        alert("downloading logs" );

        return "help_and_support/download_logs";
    }
});