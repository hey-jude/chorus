chorus.views.HdfsShowFilePreview = chorus.views.Base.extend({
    templateName: "hdfs_show_file_preview",
    additionalClass: "relational_data_preview",

    events: {
        "click .save_entry_metadata": "saveEntryMetadata",
        "change #hasHeader": "setHeader",
        "click input.delimiter[type=radio]": "setDelimiter",
        "keyup input.delimiter[name=custom_delimiter]": "setOtherDelimiter",
        "paste input.delimiter[name=custom_delimiter]": "setOtherDelimiter",
        "click input#delimiter_other": "focusOtherInputField"
    },

    subviews: {
        ".relational_data_preview": "relationalDataPreview"
    },

    _default_metadata: {
        hasHeader:  true,
        delimiter: ','
    },

    setup: function() {
        // TODO: If this entry is relational format, then we want to show it in the preview
        this._is_relational = true; // Could use something like _.last(name.split(".")) === "csv"

        this.listenTo(this.model, "loaded", this.populateDataPreview);
        if (this.model.loaded === true) {
            this.populateDataPreview();
        }

        // this.listenTo(this.model, "saved")
    },

    populateDataPreview: function() {
        if (_.isUndefined(this.model.get('metadata')) || _.isNull(this.model.get('metadata'))) {
            this.model.set({ metadata: this._default_metadata }, { silent: true });
            this.delimiter = this._default_metadata.delimiter;
        }

        var data_schema = this.model.get('metadata');
        this.csvParser = new chorus.utilities.CsvParser(this.model.content(), {
            hasHeader: data_schema.hasHeader,
            delimiter: data_schema.delimiter
        });

        // TODO: Rather than using the import grid class, we should create one more appropriate to our needs here.
        this.relationalDataPreview = new chorus.views.NewTableImportDataGrid();

        // This is nullifying the addNameInputsToTopRow method on chorus.views.NewTableImportDataGrid so that we
        // don't give the ability to edit the column names.
        _.extend(this.relationalDataPreview, { addNameInputsToTopRow: $.noop });
    },

    postRender: function() {
        if (_.isUndefined(this.csvParser)) {
            return;
        }

        var columns = this.csvParser.getColumnOrientedData();
        var rows = this.csvParser.rows();

        //this.model.serverErrors = this.csvParser.serverErrors;
        //this.model.set({
        //    types: _.pluck(columns, "type")
        //}, {silent: true});
        //
        //if(this.model.serverErrors) {
        //    this.showErrors();
        //}

        this.$("input.delimiter").prop("checked", false);
        if(_.contains([",", "\t", ";", " ", "|"], this.delimiter)) {
            this.$("input.delimiter[value='" + this.delimiter + "']").prop("checked", true);
        } else {
            this.$("input#delimiter_other").prop("checked", true);
        }
        this.relationalDataPreview.initializeDataGrid(columns, rows, this.getColumnNames());
    },

    generateColumnNames: function() {
        var headerRow = this.csvParser.parseColumnNames();
        this.headerColumnNames = headerRow;
        this.generatedColumnNames = _.map(headerRow, function(column, i) {
            return "column_" + (i + 1);
        });
    },

    getColumnNames: function() {
        if (_.isUndefined(this.generatedColumnNames)) {
            this.generateColumnNames();
        }

        return this.model.get('metadata') && this.model.get('metadata').hasHeader ? this.headerColumnNames : this.generatedColumnNames;
    },

    updateModel: function() {
        this.model.set({
            metadata: {
                hasHeader: !!(this.$("#hasHeader").prop("checked")),
                delimiter: this.delimiter,
                column_info: {
                    names: this.getColumnNames(),
                    types: this.relationalDataPreview.getColumnTypes()
                }
            }
        });
    },

    parseCsv: function() {
        this.csvParser.setOptions({
            hasHeader: !!(this.$("#hasHeader").prop("checked")),
            delimiter: this.delimiter
        });
        this.csvParser.parse();
    },

    // Event Functions
    saveEntryMetadata: function(e) {
        e && e.preventDefault();
        this.updateModel();
        this.model.save();
    },

    setHeader: function() {
        this.parseCsv();
        this.generateColumnNames();
        this.updateModel();
        this.render();
    },

    setDelimiter: function(e) {
        if(e.target.value === "other") {
            this.delimiter = this.$("input[name=custom_delimiter]").val();
            this.other_delimiter = true;
        } else {
            this.delimiter = e.target.value;
            this.other_delimiter = false;
        }
        this.parseCsv();
        this.generateColumnNames();
        this.updateModel();
        this.render();
    },

    setOtherDelimiter: function() {
        this.$("input.delimiter[type=radio]").prop("checked", false);
        var otherRadio = this.$("input#delimiter_other");
        otherRadio.prop("checked", true);
        otherRadio.click();
    },

    focusOtherInputField: function(e) {
        this.$("input[name=custom_delimiter]").focus();
    },

    additionalContext: function() {
        return {
            includeHeader: true,
            showRelationalDataPreview: this._is_relational,
            content: this.model && this.model.content()
        }
    }
});