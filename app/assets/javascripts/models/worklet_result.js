chorus.models.WorkletResult = chorus.models.WorkFlowResult.include(
    ).extend({
        urlTemplate: "alpinedatalabs/main/chorus.do?method=showWorkletResults&session_id={{sessionId}}&workfile_id={{workfileId}}&result_id={{id}}"
    });