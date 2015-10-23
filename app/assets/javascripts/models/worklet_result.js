chorus.models.WorkletResult = chorus.models.WorkFlowResult.include(
    ).extend({
        constructorName: "WorkletResult",

        name: function() {
            return t("worklet_result.attachment_name");
        },

        urlTemplate: function() {
            var outputVars = this.get('outputVars') || [];
            return 'alpinedatalabs/main/chorus.do?method=showWorkletResults&session_id={{sessionId}}&workfile_id={{workfileId}}&result_id={{id}}&output_names=' + outputVars.join(';;;');
        }
    });