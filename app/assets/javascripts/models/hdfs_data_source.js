chorus.models.HdfsDataSource = chorus.models.AbstractDataSource.extend({
    constructorName: "HdfsDataSource",
    urlTemplate: "hdfs_data_sources/{{id}}",
    shared: true,
    entityType: "hdfs_data_source",

    isShared: function() {
        return true;
    },

    showUrlTemplate: function() {
      if(this.isHdfsHive()) {
        return null;
      } else {
        return "hdfs_data_sources/{{id}}/browse/";
      }
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

    attrToLabel: {
      "hiveMetastoreLocation":"data_sources.dialog.hive_metastore_location",
      "name":"data_sources.dialog.data_source_name",
      "host":"data_sources.dialog.hadoop_host",
      "username":"data_sources.dialog.hadoop_account",
      "groupList":"data_sources.dialog.hadoop_group_list",
      "port":"data_sources.dialog.port",
      "jobTrackerHost":"data_sources.dialog.hadoop_job_tracker_host",
      "jobTrackerPort":"data_sources.dialog.port"
    }

});
