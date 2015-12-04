chorus.views.HdfsShowFilePreview = chorus.views.Base.extend({
    templateName: "hdfs_show_file_preview",

    events: {
    },

    setup: function() {
    },

    additionalContext: function() {
        return {
            includeHeader: true
        }
    }
});