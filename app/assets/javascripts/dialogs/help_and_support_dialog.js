chorus.dialogs.HelpAndSupport = chorus.dialogs.Base.extend({
  templateName: "dialogs/help_and_support",
  title: t("help.help_and_support.title"),

  events: {
    "click button.download_logs": "downloadLogs"
  },

  downloadLogs: function (event) {
    event.preventDefault();
    chorus.fileDownload("/log_archiver", {httpMethod: "GET"});
  }
});
