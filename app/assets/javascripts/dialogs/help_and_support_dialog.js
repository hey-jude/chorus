chorus.dialogs.HelpAndSupport = chorus.dialogs.Base.extend({
    templateName: "dialogs/help_and_support",
    title: t("help.help_and_support.title"),
    events: {
        "submit form": "downloadLogs"
    },

    downloadLogs: function() {
        chorus.fileDownload("/log_archiver", { httpMethod: "GET"});
    }
});
