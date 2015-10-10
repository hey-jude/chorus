chorus.dialogs.WorkletViewLogsDialog = chorus.dialogs.Base.include(
        chorus.Mixins.DialogFormHelpers
    ).extend({
        constructorName: "WorkletViewLogsDialog",
        templateName: "worklets/worklet_view_logs_dialog",
        title: t("worklet.dialog.view_worklet_logs.title"),
        persistent:true,

        setup:function () {

            var flowId = this.options.flowId;
            var resultsId = this.options.resultsId;

            $.ajax({
                url: "/alpinedatalabs/main/flow.do?method=getFlowResultInfoData&flowName=" + flowId + "&uuid=" + resultsId + "&resultType=public",
                type: "GET",
                dataType: "json",
                success: function(data) {
                    var dialogDiv = $('#logsDiv');
                    var badDataMsg = '';
                    var logs = data.logs;
                    for (var i = 0; i < logs.length; i++) {
                        var log = logs[i];
                        if (!log) {
                            continue;
                        }
                        var div = $('<div></div>')[0];
                        var name = log.nodeName === "null" ? "" : log.nodeName;
                        var message = log.logmessage;
                        if(log.message === 'sql_log'){
                            //existing flow results have this key, but it is wrong so do not display it
                            continue;
                        }
                        else if(log.message === 'bad_data'){
                            badDataMsg += log.logmessage + '<br/>';
                        }
                        else{
                            div.innerHTML = " [" + log.dateTime + "] " + "  " + name + "  " + message;
                            dialogDiv.append(div);
                            //append error message
                            if (log.message === 'process_error') {
                                var div1 = $('<div></div>')[0];
                                div1.id = name + "_errdiv";
                                div1.style.color = "FF0000";

                                div1.innerHTML = log.errMessage;
                                dialogDiv.append(div1);
                            }
                        }
                    }

                    if(badDataMsg.length > 0){
                        var badDataDiv = $('<div></div>')[0];
                        badDataDiv.innerHTML = badDataMsg;
                        dialogDiv.appendChild(badDataDiv);
                    }
                },

                error: function() {
                    $('#logs').text('There was an error retrieving the run logs for this worklet.');
                }
            });
        }
    });
