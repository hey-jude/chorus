chorus.models.AbstractDataSource = chorus.models.Base.extend({
    constructorName: 'AbstractDataSource',
    _imagePrefix: "/images/data_sources/",

    providerIconUrl: function() {
        var dataSourceType = this.get("isHawq") ? "hawq_data_source" : this.get("entityType");
        return this._imagePrefix + 'icon_' + dataSourceType + '.png';
    },

    iconUrl: function () {
        return this.providerIconUrl();
    },

    eventType: function() {
        return "data_source";
    },

    isOnline: function() {
        return this.get("online");
    },

    isOffline: function() {
        return !this.isOnline();
    },

    isDisabled: function() {
        return this.get("state") === 'disabled';
    },

    isIncomplete: function() {
        return this.get("state") === 'incomplete';
    },

    stateText: function() {
        return t("data_sources.state." + (this.isOnline() ? 'online' : 'offline'));
    },

    version: function() {
        return this.get("version");
    },

    stateIconUrl: function() {
        var filename = this.isOnline() ? 'green.svg' : 'yellow.svg';
        return this._imagePrefix + filename;
    },

    owner: function() {
        return new chorus.models.User(
            this.get("owner")
        );
    },

    isOwner: function(user) {
        return this.owner().get("id") === user.get('id') && user instanceof chorus.models.User;
    },

    isGreenplum: function() {
        return false;
    },

    isPostgres: function() {
        return false;
    },

    isHadoop: function() {
        return false;
    },

    isGnip: function() {
        return false;
    },

    isOracle: function() {
        return false;
    },

    isJdbc: function() {
        return false;
    },

    isJdbcHive: function() {
        return false;
    },

    isSingleLevelSource: function () {
        return false;
    },

    canHaveIndividualAccounts: function() {
        return false;
    },

    accountForCurrentUser: function() {
        return null;
    },

    accounts: function() {
        return [];
    },

    usage: function() {
        return false;
    },

    // KT TODO refactor: the two methods following, belong more in HdfsDataSource -- but, it's difficult to get that
    // to work, due to the way that the DataSourceNewDialog is written.
    numberOfConnectionParameters: function() {
        return this.connectionParametersWithoutHadoopHive().length;
    },
    connectionParametersWithoutHadoopHive: function() {
      var pairs = this.get('connectionParameters');

      pairs = _.map(pairs, function (pair) {
        if(pair['key'] !== 'is_hive' && pair['key'] !== 'hive.metastore.uris') {
          return pair;
        }
      });
      pairs = _.compact(pairs);

      return pairs;
    }
});
