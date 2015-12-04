chorus.views.HdfsShowFileDetails = chorus.views.Base.extend({
    templateName: "hdfs_show_file_details",

    events: {
        "click button.visualize": "openColumnTypePicker"
    },

    setup: function() {

    },

    openColumnTypePicker: function() {
        if (this.model.loaded) {
            dialog = new chorus.dialogs.NewTableImportCSV({
                model: _.extend({
                    attributes: this.model.attributes.contents[0]
                }, this.model),
                csvOptions: {
                    hasHeader:  true,
                    contents: this.model.attributes.contents,
                    tableName: "trash"
                }
            });

            dialog.launchModal();
        }
    },

    additionalContext: function(){
        return {
            showVisualize: true
        }
    }
});