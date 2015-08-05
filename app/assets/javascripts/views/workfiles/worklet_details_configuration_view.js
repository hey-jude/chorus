chorus.views.WorkletDetailsConfiguration = chorus.views.Base.extend({
    constructorName: "WorkletDetailsConfigurationView",
    templateName: "worklet_details_configuration",

    events: {
        "click a.visual_operator": 'workflowImageOperatorClicked',
        "click input.checkbox_operator": 'includeOperatorClicked',
        "click button.save_details": 'saveDetails'
    },

    setup: function() {
        this.model = this.options.model;
        this.workflowOperators = this.options.workflowOperators;
        this.listenTo(this.model, "saved", this.workletSaved);
        this.listenTo(this.model, "saveFailed", this.workletSaveFailed);
        //this.disableFormUnlessValid({
        //    formSelector: "form.new_worklet",
        //    inputSelector: "input[name='workletName']"
        //});

    },

    postRender: function() {
        // Adjusts workflow canvas so that the top or left-most operator is within view.
        var icon_size = 50;
        var wfi = $('#workfile_image_container');

        if (typeof(wfi) !== 'undefined') {
            var leftTop = _.reduce(this.workflowOperators.getOperators(), function(bound, op) {
                    (op.position.startX < bound.x) && (bound.x = op.position.startX);
                    (op.position.startY < bound.y) && (bound.y = op.position.startY);

                    return bound;
                }, {
                    x: Infinity,
                    y: Infinity
                }
            );

            wfi.scrollTop(leftTop.y - icon_size);
            wfi.scrollLeft(leftTop.x - icon_size);
        }
    },

    workflowImageOperatorClicked: function(e) {
        e && e.preventDefault();

        var op = this.workflowOperators.getOperators()[e.target.dataset.index];
        op.selected = typeof(op.selected) === 'undefined' ? true : !op.selected;

        $(e.target).toggleClass('bordered');

        // Also update checkbox
        var checkbox_op = $('#op_' + e.target.dataset.index + '_checkbox');
        checkbox_op && checkbox_op.prop('checked', !checkbox_op.prop('checked'));
    },

    includeOperatorClicked: function(e) {
        var op = this.workflowOperators.getOperators()[e.currentTarget.dataset.index];
        op.selected = typeof(op.selected) === 'undefined' ? true : !op.selected;

        // Also update visualization
        var vis_op = $('#op_' + e.currentTarget.dataset.index);
        vis_op && vis_op.toggleClass('bordered');
    },

    saveDetails: function(e) {
        e && e.preventDefault();

        // Gather text attributes
        var updates = {};
        _.each(this.$("input[type=text], textarea"), function (i) {
            var input = $(i);
            var val = input.val().trim();
            updates[input.attr("name")] = val;
        });

        // Gather the checked output operators into updates['output_operators'] array.
        var checked_ops = _.filter($('.checkbox_operator'), function(el) { return el.checked; });
        var all_ops = this.workflowOperators.getOperators();
        updates['outputTable'] = _.map(checked_ops, function (el) {
            return this.ops[el.dataset.index].name;
        }, {
            ops: all_ops
        });

        // Gather "Run as" persona from radio box
        var run_persona = $("input:radio[name = 'run_persona']:checked").val();
        if (typeof(run_persona) === 'undefined') {
            // Uses first persona if one isn't defined.
            run_persona = $($("input:radio[name = 'run_persona']")[0]).val();
        }
        updates['runPersona'] = run_persona;

        this.$(".form_controls").hide();
        this.$(".spinner_div").show();
        this.model.save(updates);
    },

    workletSaved: function(e) {
        this.$(".form_controls").show();
        this.$(".spinner_div").hide();
    },

    workletSaveFailed: function(e) {
        this.$(".form_controls").show();
        this.$(".spinner_div").hide();
    },

    annotatedOperators: function() {
        var icon_size = 50;
        var output_table = this.model.get('outputTable');

        return _.map(this.workflowOperators.getOperators(), function (op, index) {
                return {
                    id: "op_" + index,
                    name: op.name,
                    index: index,
                    left: op.position.startX - this.icon_size/2,
                    top: op.position.startY - this.icon_size/2,
                    selected: _.contains(this.output_table, op.name)
                };
            }, {
                icon_size: icon_size,
                output_table: output_table
            }
        );
    },

    additionalContext: function () {
        var run_persona = this.model.get('runPersona');
        return {
            description: this.model.get('description'),

            // Worklet avatar
            avatarUrl: this.model.url({workflow_action: 'image'}),

            // View details for "Run as" options
            runPersonas: [
                {
                    run_persona: "creator",
                    persona_run_statement: "Run as worklet creator",
                    selected: !run_persona || run_persona === "creator"
                },
                {
                    run_persona: "person_running",
                    persona_run_statement: "Run as the person running the worklet",
                    selected: run_persona === "person_running"
                }
            ],

            // Workflow image URL
            workflowImageUrl: this.model.basisWorkflow().imageUrl(),

            // View details for the operators to select as outputs
            operators: this.annotatedOperators()
        };
    }
});