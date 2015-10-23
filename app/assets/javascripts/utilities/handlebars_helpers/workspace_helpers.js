chorus.handlebarsHelpers.workspace = {
    workspaceUsage: function(percentageUsed, sizeText) {
        var markup = "";
        if (percentageUsed >= 100) {
            markup = '<div class="usage_bar">' +
                '<div class="used full" style="width: 100%;">' +
                '<span class="size_text">' + sizeText + '</span>' +
                '<span class="percentage_text">' + percentageUsed + '%</span>' +
                '</div>' +
                '</div>';
        } else {
            if (percentageUsed >= 50) {
                markup = '<div class="usage_bar">' +
                    '<div class="used" style="width: ' + percentageUsed + '%;">' +
                    '<span class="size_text">' + sizeText + '</span></div>' +
                    '</div>';
            } else {
                markup = '<div class="usage_bar">' +
                    '<div class="used" style="width: ' + percentageUsed + '%;"></div>' +
                    '<span class="size_text">' + sizeText + '</span>' +
                    '</div>';
            }
        }
        return new Handlebars.SafeString(markup);
    },

    usedInWorkspaces: function(workspaceSet, contextObject) {
        contextObject = contextObject.clone();
        if (!workspaceSet || workspaceSet.length === 0) { return ""; }

        if (!(workspaceSet instanceof chorus.collections.WorkspaceSet)) {
            workspaceSet = new chorus.collections.WorkspaceSet(workspaceSet);

        }

        function linkToContextObject(workspace) {
            contextObject.setWorkspace(workspace);

            //TODO: better solution for this, hard-coding for published worklets for now
            if(contextObject.get('entitySubtype') === 'published_worklet') {
                return Handlebars.helpers.linkTo('#/touchpoints', 'Touchpoints', {
                    title: 'Touchpoints'
                }).toString();
            }
            else {
                return Handlebars.helpers.linkTo(contextObject.workspace().showUrl(), workspace.get('name'), {
                    title: workspace.get('name')
                }).toString();
            }
        }

        var workspaceLink = linkToContextObject(workspaceSet.at(0));

        var result = $("<div></div>").addClass('found_in workspace_association');
        var otherWorkspacesMenu = Handlebars.helpers.linkTo('#', t('workspaces_used_in.other_workspaces', {count: workspaceSet.length - 1}), {'class': 'open_other_menu'}).toString();

        result.append(t('workspaces_used_in.body', {workspaceLink: workspaceLink, otherWorkspacesMenu: otherWorkspacesMenu, count: workspaceSet.length }));
        if (workspaceSet.length > 1) {
            var list = $('<ul></ul>').addClass('other_menu');
            _.each(_.rest(workspaceSet.models), function(workspace) {
                list.append($('<li></li>').html(linkToContextObject(workspace)));
            });
            result.append(list);
        }

        return new Handlebars.SafeString(result.outerHtml());
    },

    executionLocationHtml: function(name_state_url_arrays){
        var html = '<span class="execution_locations">' + t("work_flows.show.in");
        var first = name_state_url_arrays.shift();

        name = first[0];
        state = first[1];
        url = first[2];
        html += ' <img class="state" src="' + url + '" title="' + state + '"/> ' + name;

        _.each(name_state_url_arrays, function(arguments_array){
            name = arguments_array[0];
            state = arguments_array[1];
            url = arguments_array[2];
            html += ', <img class="state" src="' + url + '" title="' + state + '"/> ' + name;
        });
        
        html += '</span>';

        return new Handlebars.SafeString(html);
    }
};

_.each(chorus.handlebarsHelpers.workspace, function(helper, name) {
    Handlebars.registerHelper(name, helper);
});