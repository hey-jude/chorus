// This is a manifest file that'll be compiled into application, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require handlebars
//= require_tree ./frontend/templates
//= require jquery
//= require frontend/vendor/underscore-1.6.0
//= require frontend/vendor/backbone-1.0.0
//= require frontend/vendor/backbone.router.title.helper
//= require frontend/vendor/jquery.ui.core
//= require frontend/vendor/jquery.ui.widget
//= require frontend/vendor/jquery.ui.mouse
//= require codemirror
//= require codemirror/modes/sql
//= require codemirror/modes/ruby
//= require codemirror/modes/python
//= require codemirror/modes/javascript
//= require codemirror/modes/r
//= require codemirror/modes/pig
//= require codemirror/modes/markdown
//= require codemirror/addons/edit/matchbrackets
//= require codemirror/addons/hint/show-hint
//= require codemirror/addons/hint/sql-hint
//= require codemirror/addons/selection/active-line
//= require codemirror/addons/search/match-highlighter
//= require frontend/vendor/textext
//= require frontend/vendor/es5-shim
//= require frontend/vendor/d3
//= require frontend/vendor/datepicker_lang
//= require_tree ./frontend/vendor
//= require messenger

//= require frontend/environment
//= require frontend/csrf
//= require frontend/application_misc
//= require frontend/chorus

// KT: Some 'componentized' javascript needs to be loaded before other files (mixins & translations, for example) ...
// put these in '<component name>_boot' and require it up top in the manifest file:
//= require vis_legacy_boot

//= require_tree ./frontend/utilities
//= require_tree ./frontend/mixins

//= require frontend/router
//= require frontend/models
//= require frontend/collections

//= require frontend/views/core/bare_view
//= require frontend/views/core/base_view
//= require frontend/views/core/main_content_view
//= require frontend/views/core/list_header_view
//= require frontend/views/core/main_content_list_view
//= require frontend/views/dashboard/dashboard_module
//= require frontend/pages
//= require frontend/modals
//= require frontend/presenters
//= require frontend/dialogs
//= require frontend/alerts/base
//= require frontend/alerts/confirm
//= require frontend/alerts/model_delete_alert
//= require_tree ./frontend/alerts
//= require frontend/views/sidebar_view
//= require frontend/views/dataset/chart_configuration_view
//= require frontend/views/database_sidebar_list_view
//= require frontend/views/utilities/code_editor_view
//= require frontend/views/workfiles/workfile_content_details_view
//= require frontend/views/workfiles/workfile_content_view
//= require frontend/views/workfiles/text_workfile_content_view
//= require frontend/views/search/search_item_base
//= require frontend/views/filter_wizard_view
//= require frontend/views/filter_view
//= require frontend/views/tag_box_view
//= require frontend/views/import_data_grid_view
//= require_tree ./frontend/views
//= require frontend/dialogs/pick_items_dialog
//= require frontend/dialogs/workspaces/pick_workspace_dialog
//= require frontend/dialogs/memo_new_dialog
//= require frontend/dialogs/dataset/new_table_import_csv
//= require frontend/dialogs/sql_preview_dialog
//= require frontend/dialogs/upload_dialog
//= require frontend/models/dataset
//= require frontend/models/workspace_dataset
//= require frontend/models/tasks/task
//= require frontend/models/tasks/chart_task
//= require frontend/models/csv_import
//= require frontend/models/tasks/data_preview_task
//= require frontend/models/tasks/workfile_execution_task
//= require frontend/models/activity
//= require frontend/models/note
//= require frontend/models/insight
//= require frontend/models/filter
//= require_tree ./frontend/models
//= require frontend/collections/hdfs_entry_set
//= require frontend/collections/schema_dataset_set
//= require frontend/collections/user_set
//= require frontend/collections/workfile_set
//= require frontend/collections/workspace_set
//= require frontend/pages/dataset/dataset_show_page
//= require frontend/pages/dataset/workspace_dataset_show_page
//= require frontend/pages/search_index_page
//= require frontend/pages/workspaces/workspace_show_page

//= require_tree ./frontend

//= require vis_legacy