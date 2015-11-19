chorus.views.JobTaskItem = chorus.views.Base.extend({
    constructorName: "JobTaskItemView",
    templateName: "job_task_item",

    jobsIconPath: "/images/jobs/",
    
    events: {
        "click .move_down_arrow": "moveTaskDown",
        "click .move_up_arrow"  : "moveTaskUp"
    },
    
    iconMap: {
//      run_work_flow: "/images/jobs/task-afm.png",
        run_work_flow: "task-afm.svg",
        
//      run_sql_workfile: "/images/jobs/task-sql.png",
        run_sql_workfile: "task-sql.svg",
        
//      import_source_data: "/images/jobs/task-import.png"
        import_source_data: "task-import.svg"
    },

    additionalContext: function () {
        var action = this.model.get("action");
        var collection = this.model.collection;
        return {
            checkable: false,
            url: this.model.showUrl(),
            actionKey: "job_task.action." + action,
            iconUrl: this.iconUrlForType(action),
            firstItem: collection.indexOf(this.model) === 0,
            lastItem: collection.indexOf(this.model) === collection.length - 1,
            moreThanOneTask: (collection.length > 1)
        };
    },

    iconUrlForType: function (action) {
        return this.jobsIconPath + this.iconMap[action];
    },

    moveTaskDown: function() {
        chorus.page.model.moveTaskDown(this.model);
    },

    moveTaskUp: function() {
        chorus.page.model.moveTaskUp(this.model);
    }

});
