chorus.Mixins.DataSourceCredentials = {};

chorus.Mixins.DataSourceCredentials.model = {
    dataSourceRequiringCredentials: function() {
        if (_.isUndefined(this.serverErrors)){
            return;
        }
        this.invalidCredentials = (this.serverErrors.record === 'INVALID_CREDENTIALS');
        return new chorus.models.DynamicDataSource(this.serverErrors.modelData);
    }
};

chorus.Mixins.DataSourceCredentials.page = {
    unauthorizedErrorPageOptions: function() {
        return {
            title: t("data_sources.shared_account_invalid.title"),
            text: t("data_sources.shared_account_invalid.text")
        };
    },

    dependentResourceForbidden: function(resource) {
        var dataSource = resource.dataSourceRequiringCredentials && resource.dataSourceRequiringCredentials();
        if(dataSource) {
            if(chorus.models.DataSourceAccount.currentUserCanUpdateCredentialsFor(dataSource)) {
                this.launchDataSourceAccountDialog(dataSource, resource);
            } else {
                chorus.pageOptions = this.unauthorizedErrorPageOptions();
                Backbone.history.loadUrl("/forbidden");
                return;
            }
        } else {
            this._super("dependentResourceForbidden", arguments);
            return;
        }

        if (resource.attributes.entitySubtype === "alpine" && resource.executionLocations() && _.isEmpty(resource.executionLocations())){
            Backbone.history.loadUrl("/forbidden");
            return;
        }
    },

    launchDataSourceAccountDialog: function(dataSource, resource) {
        var title = (dataSource.get('shared') || resource.invalidCredentials) ? t("data_sources.account.update.title") : t("data_sources.account.add.title");
        var dialog = new chorus.dialogs.DataSourceAccount({
            title: title,
            dataSource: dataSource,
            reload: true,
            goBack: true
        });
        dialog.launchModal();
    }
};