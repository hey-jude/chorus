chorus.models.HdfsDataSource = chorus.models.AbstractDataSource.extend({
    constructorName: "HdfsDataSource",
    urlTemplate: "hdfs_data_sources/{{id}}",
    showUrlTemplate: "hdfs_data_sources/{{id}}/browse/",
    shared: true,
    entityType: "hdfs_data_source",

    beforeSave: function() {
      this._super("beforeSave");
      this.set('connectionParameters', this.connectionParametersWithoutHadoopHive());
    },

    isShared: function() {
        return true;
    },

    providerIconUrl: function() {
        if(this.isHdfsHive()) {
          return this._imagePrefix + "icon_hdfs_hive_data_source.png";
        } else {
          return this._imagePrefix + "icon_hdfs_data_source.png";
        }
    },

    isHadoop: function() {
        return true;
    },

    isHdfsHive: function() {
      if(this.get('isHdfsHive')) {
        return true;
      }
    },

    isSingleLevelSource: function () {
        return true;
    },

    declareValidations: function(newAttrs) {

        if(this.get('isHdfsHive')) {
          this.require("hiveMetastoreLocation", newAttrs);
        }

        this.require("name", newAttrs);
        this.requirePattern("name", chorus.ValidationRegexes.MaxLength64(), newAttrs);
        this.require("host", newAttrs);
        this.require("username", newAttrs);
        this.require("groupList", newAttrs);
        if (newAttrs.highAvailability === 'false') {
            this.require("port", newAttrs);
            this.requirePattern("port", chorus.ValidationRegexes.OnlyDigits(), newAttrs);
        }
        if (newAttrs.jobTrackerHost || newAttrs.jobTrackerPort) {
            this.require("jobTrackerHost", newAttrs);
            this.require("jobTrackerPort", newAttrs);
            this.requirePattern("jobTrackerPort", chorus.ValidationRegexes.OnlyDigits(), newAttrs);
        }
    },

    sharedAccountDetails: function() {
        return this.get("username") + ", " + this.get("groupList");
    },

    version: function() {
        return this.get("hdfsVersion");
    },

    connectionParametersWithoutHadoopHive: function() {
      var pairs = this.get('connectionParameters');

      pairs = _.map(pairs, function (pair) {
        if(pair['key'] != 'is_hive' && pair['key'] != 'hive.metastore.uris') {
          return pair;
        }
      });
      pairs = _.compact(pairs);

      return pairs;
    }

});
