class BaseSchema < ActiveRecord::Migration

  def change

    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"

    tables = ActiveRecord::Base.connection.tables

    if tables.include?("schema_migrations")
      execute("DELETE FROM schema_migrations WHERE CAST(version AS bigint) < 20150516000000")
    end

    unless tables.include?("activities")
      create_table "activities", force: true do |t|
        t.integer "entity_id"
        t.string "entity_type"
        t.integer "event_id"
      end

      add_index "activities", ["entity_id", "entity_type"], name: "index_activities_on_entity_id_and_entity_type", using: :btree
      add_index "activities", ["event_id"], name: "index_activities_on_event_id", using: :btree
    end

    unless tables.include?("associated_datasets")
      create_table "associated_datasets", force: true do |t|
        t.integer "dataset_id"
        t.integer "workspace_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "legacy_id"
        t.datetime "deleted_at"
      end

      add_index "associated_datasets", ["dataset_id", "workspace_id"], name: "index_associated_datasets_on_dataset_id_and_workspace_id", using: :btree
    end

    unless tables.include?("attachments")
      create_table "attachments", force: true do |t|
        t.integer "note_id"
        t.string "contents_file_name"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "contents_content_type"
        t.integer "contents_file_size"
        t.datetime "contents_updated_at"
        t.string "legacy_id"
      end

      add_index "attachments", ["note_id"], name: "index_attachments_on_note_id", using: :btree
    end

    unless tables.include?("chorus_classes")
      create_table "chorus_classes", force: true do |t|
        t.string "name", null: false
        t.string "description"
        t.integer "parent_class_id"
        t.string "parent_class_name"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("chorus_object_roles")
      create_table "chorus_object_roles", force: true do |t|
        t.integer "chorus_object_id"
        t.integer "user_id"
        t.integer "role_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("chorus_objects")
      create_table "chorus_objects", force: true do |t|
        t.integer "chorus_class_id", null: false
        t.integer "instance_id", null: false
        t.string "parent_class_id"
        t.string "parent_class_name"
        t.integer "permissions_mask"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.integer "scope_id"
        t.integer "owner_id"
      end
    end

    unless tables.include?("comments")
      create_table "comments", force: true do |t|
        t.integer "author_id"
        t.text "body"
        t.integer "event_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "legacy_id"
        t.datetime "deleted_at"
      end

      add_index "comments", ["event_id", "deleted_at"], name: "index_comments_on_event_id_and_deleted_at", using: :btree
      add_index "comments", ["event_id"], name: "index_comments_on_event_id", using: :btree
    end

    unless tables.include?("csv_files")
      create_table "csv_files", force: true do |t|
        t.integer "workspace_id"
        t.string "contents_file_name"
        t.string "contents_content_type"
        t.integer "contents_file_size"
        t.datetime "contents_updated_at"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.boolean "has_header"
        t.text "column_names"
        t.text "types"
        t.string "to_table"
        t.string "delimiter"
        t.integer "user_id"
        t.boolean "new_table"
        t.boolean "truncate", default: false
        t.boolean "user_uploaded", default: true
        t.integer "import_id"
      end

      add_index "csv_files", ["workspace_id"], name: "index_csv_files_on_workspace_id", using: :btree
    end

    unless tables.include?("dashboard_items")
      create_table "dashboard_items", force: true do |t|
        t.integer "user_id"
        t.string "name"
        t.integer "location"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "options", default: "", null: false
      end
    end

    unless tables.include?("data_source_account_permissions")
      create_table "data_source_account_permissions", force: true do |t|
        t.integer "accessed_id", null: false
        t.integer "data_source_account_id", null: false
        t.string "accessed_type", null: false
      end

      add_index "data_source_account_permissions", ["accessed_id", "accessed_type"], name: "index_instance_account_permissions_on_accessed", using: :btree
      add_index "data_source_account_permissions", ["accessed_id"], name: "index_databases_instance_accounts_on_database_id", using: :btree
      add_index "data_source_account_permissions", ["data_source_account_id"], name: "index_instance_account_permissions_on_instance_account_id", using: :btree
    end

    unless tables.include?("data_source_accounts")
      create_table "data_source_accounts", force: true do |t|
        t.string "db_username", limit: 256
        t.integer "data_source_id", null: false
        t.integer "owner_id", null: false
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string "legacy_id"
        t.string "encrypted_db_password"
        t.boolean "invalid_credentials"
      end

      add_index "data_source_accounts", ["data_source_id"], name: "index_instance_accounts_on_data_source_id", using: :btree
      add_index "data_source_accounts", ["owner_id"], name: "index_instance_accounts_on_owner_id", using: :btree
    end

    unless tables.include?("data_sources")
      create_table "data_sources", force: true do |t|
        t.string "name", limit: 256
        t.text "description"
        t.string "host", limit: 256
        t.integer "port"
        t.string "db_name", limit: 256
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.integer "owner_id", null: false
        t.boolean "shared", default: false
        t.string "version", limit: 256
        t.string "state", default: "online"
        t.string "legacy_id"
        t.datetime "last_checked_at"
        t.datetime "last_online_at"
        t.datetime "deleted_at"
        t.string "type"
        t.boolean "is_hawq"
        t.boolean "ssl", default: false
        t.boolean "hive", default: false
        t.boolean "hive_kerberos", default: false
        t.string "hive_kerberos_principal", default: "", null: false
        t.string "hive_kerberos_keytab_location", default: "", null: false
        t.string "hive_hadoop_version", default: "", null: false
      end

      add_index "data_sources", ["deleted_at", "id"], name: "index_data_sources_on_deleted_at_and_id", using: :btree
      add_index "data_sources", ["owner_id"], name: "index_data_sources_on_owner_id", using: :btree
    end

    unless tables.include?("databases")
      create_table "databases", force: true do |t|
        t.integer "data_source_id", null: false
        t.string "name", limit: 256
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.datetime "stale_at"
        t.datetime "deleted_at"
        t.string "type", null: false
      end

      add_index "databases", ["data_source_id", "name"], name: "index_databases_on_data_source_id_and_name", unique: true, using: :btree
      add_index "databases", ["data_source_id"], name: "index_databases_on_data_source_id", using: :btree
      add_index "databases", ["deleted_at", "id"], name: "index_gpdb_databases_on_deleted_at_and_id", using: :btree
    end

    unless tables.include?("datasets")
      create_table "datasets", force: true do |t|
        t.string "type", limit: 256
        t.string "name", limit: 256
        t.integer "schema_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.boolean "master_table", default: false
        t.datetime "stale_at"
        t.text "query"
        t.string "legacy_id"
        t.string "edc_workspace_id"
        t.datetime "deleted_at"
        t.integer "workspace_id"
        t.integer "hdfs_data_source_id"
      end

      add_index "datasets", ["deleted_at", "id"], name: "index_datasets_on_deleted_at_and_id"

      # KT TODO: note this is not database agnostic, not serializable to schema.rb, and forces use of structure.sql --
      # Prakash says: "Rails 4 migrations support indexing and constraints. We should look into it."
      execute "CREATE UNIQUE INDEX index_datasets_on_name_schema_id_and_type ON datasets ( name, schema_id, type ) WHERE deleted_at IS NULL"

      add_index "datasets", ["schema_id"], name: "index_database_objects_on_schema_id"
    end

    unless tables.include?("datasets_notes")
      create_table "datasets_notes", force: true do |t|
        t.integer "dataset_id"
        t.integer "note_id"
        t.string "legacy_id"
      end
    end

    unless tables.include?("events")
      create_table "events", force: true do |t|
        t.string "action"
        t.integer "actor_id"
        t.integer "target1_id"
        t.string "target1_type"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "target2_type"
        t.integer "target2_id"
        t.text "additional_data"
        t.integer "workspace_id"
        t.datetime "deleted_at"
        t.string "legacy_id"
        t.string "legacy_type"
        t.boolean "insight", default: false
        t.integer "promoted_by_id"
        t.datetime "promotion_time"
        t.boolean "published", default: false
        t.string "target3_type"
        t.integer "target3_id"
      end

      add_index "events", ["id", "action", "deleted_at"], name: "index_events_on_id_and_action_and_deleted_at", using: :btree
      add_index "events", ["id", "action"], name: "index_events_on_id_and_action", using: :btree
      add_index "events", ["id", "deleted_at"], name: "index_events_on_id_and_deleted_at", using: :btree
      add_index "events", ["workspace_id"], name: "index_events_on_workspace_id", using: :btree
    end

    unless tables.include?("gnip_data_sources")
      create_table "gnip_data_sources", force: true do |t|
        t.string "name"
        t.text "description"
        t.integer "owner_id"
        t.string "username"
        t.string "password"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "stream_url"
        t.datetime "deleted_at"
      end

      add_index "gnip_data_sources", ["deleted_at", "id"], name: "index_gnip_data_sources_on_deleted_at_and_id", using: :btree
    end

    unless tables.include?("groups")
      create_table "groups", force: true do |t|
        t.string "name", null: false
        t.string "description"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("groups_roles")
      create_table "groups_roles", id: false, force: true do |t|
        t.integer "group_id"
        t.integer "role_id"
      end

      add_index "groups_roles", ["group_id", "role_id"], name: "index_groups_roles_on_group_id_and_role_id", using: :btree
    end

    unless tables.include?("groups_users")
      create_table "groups_users", id: false, force: true do |t|
        t.integer "group_id"
        t.integer "user_id"
      end

      add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", using: :btree
    end

    unless tables.include?("hdfs_data_sources")
      create_table "hdfs_data_sources", force: true do |t|
        t.string "name", limit: 256
        t.text "description"
        t.string "host", null: false
        t.integer "port"
        t.integer "owner_id", null: false
        t.string "version", limit: 256
        t.string "username", limit: 256
        t.string "group_list", limit: 256
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "legacy_id"
        t.datetime "last_checked_at"
        t.datetime "last_online_at"
        t.string "state", default: "online", null: false
        t.datetime "deleted_at"
        t.string "job_tracker_host"
        t.integer "job_tracker_port"
        t.string "hdfs_version"
        t.boolean "high_availability", default: false
        t.text "connection_parameters"
      end

      add_index "hdfs_data_sources", ["deleted_at", "id"], name: "index_hdfs_data_sources_on_deleted_at_and_id", using: :btree
      add_index "hdfs_data_sources", ["owner_id"], name: "index_hdfs_data_sources_on_owner_id", using: :btree
    end

    unless tables.include?("hdfs_entries")
      create_table "hdfs_entries", force: true do |t|
        t.string "path", limit: 4096
        t.integer "hdfs_data_source_id"
        t.datetime "modified_at"
        t.integer "size", limit: 8
        t.boolean "is_directory"
        t.integer "content_count"
        t.integer "parent_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.datetime "stale_at"
        t.string "legacy_id"
        t.datetime "deleted_at"
      end

      add_index "hdfs_entries", ["deleted_at", "id"], name: "index_hdfs_entries_on_deleted_at_and_id", using: :btree
      add_index "hdfs_entries", ["hdfs_data_source_id", "path"], name: "index_hdfs_entries_on_hadoop_instance_id_and_path", unique: true, using: :btree
    end

    unless tables.include?("hdfs_imports")
      create_table "hdfs_imports", force: true do |t|
        t.integer "hdfs_entry_id"
        t.integer "user_id"
        t.integer "upload_id"
        t.string "file_name"
        t.boolean "success"
        t.datetime "finished_at"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("import_templates")
      create_table "import_templates", force: true do |t|
        t.integer "destination_id"
        t.integer "source_id"
        t.string "destination_name"
        t.boolean "truncate"
        t.integer "row_limit"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("imports")
      create_table "imports", force: true do |t|
        t.integer "import_schedule_id"
        t.datetime "finished_at"
        t.datetime "created_at"
        t.integer "workspace_id"
        t.string "to_table"
        t.integer "source_id"
        t.boolean "truncate"
        t.boolean "new_table"
        t.integer "user_id"
        t.integer "sample_count"
        t.text "file_name"
        t.boolean "success"
        t.integer "destination_dataset_id"
        t.string "legacy_id"
        t.datetime "started_at"
        t.string "type", null: false
        t.integer "schema_id"
        t.string "source_type"
        t.datetime "canceled_at"
        t.string "cancel_message"
      end
    end

    unless tables.include?("job_results")
      create_table "job_results", force: true do |t|
        t.integer "job_id"
        t.datetime "started_at"
        t.datetime "finished_at"
        t.boolean "succeeded"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("job_subscriptions")
      create_table "job_subscriptions", force: true do |t|
        t.integer "user_id", null: false
        t.integer "job_id", null: false
        t.string "condition"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end

      add_index "job_subscriptions", ["job_id", "condition", "user_id"], name: "index_job_subscriptions_on_job_id_and_condition_and_user_id", using: :btree
    end

    unless tables.include?("job_task_results")
      create_table "job_task_results", force: true do |t|
        t.integer "job_result_id"
        t.string "name"
        t.datetime "started_at"
        t.datetime "finished_at"
        t.string "status"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.text "message"
        t.string "payload_result_id"
        t.integer "payload_id"
        t.string "type"
      end
    end

    unless tables.include?("job_tasks")
      create_table "job_tasks", force: true do |t|
        t.integer "index"
        t.datetime "deleted_at"
        t.integer "job_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "type"
        t.integer "payload_id"
        t.string "payload_type"
        t.string "status"
        t.string "payload_result_id"
        t.string "killable_id"
      end
    end

    unless tables.include?("jobs")
      create_table "jobs", force: true do |t|
        t.text "name"
        t.boolean "enabled"
        t.integer "workspace_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.datetime "deleted_at"
        t.datetime "next_run"
        t.datetime "last_run"
        t.string "interval_unit"
        t.integer "interval_value"
        t.datetime "end_run"
        t.string "time_zone", default: "Alaska"
        t.string "status", default: "idle"
        t.integer "owner_id"
        t.string "success_notify", default: "nobody"
        t.string "failure_notify", default: "nobody"
      end

      add_index "jobs", ["workspace_id"], name: "index_jobs_on_workspace_id", using: :btree
    end

    unless tables.include?("memberships")
      create_table "memberships", force: true do |t|
        t.integer "user_id", null: false
        t.integer "workspace_id", null: false
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string "legacy_id"
        t.string "role"
      end

      add_index "memberships", ["user_id", "workspace_id"], name: "index_memberships_on_user_id_and_workspace_id", using: :btree
      add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree
      add_index "memberships", ["workspace_id"], name: "index_memberships_on_workspace_id", using: :btree
    end

    unless tables.include?("milestones")
      create_table "milestones", force: true do |t|
        t.string "name"
        t.string "state"
        t.date "target_date"
        t.integer "workspace_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end

      add_index "milestones", ["workspace_id"], name: "index_milestones_on_workspace_id", using: :btree
    end

    unless tables.include?("notes_work_flow_results")
      create_table "notes_work_flow_results", force: true do |t|
        t.string "result_id"
        t.integer "note_id"
      end
    end

    unless tables.include?("notes_workfiles")
      create_table "notes_workfiles", force: true do |t|
        t.integer "note_id"
        t.integer "workfile_id"
        t.string "legacy_id"
      end
    end

    unless tables.include?("notifications")
      create_table "notifications", force: true do |t|
        t.integer "recipient_id"
        t.integer "event_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.boolean "read", default: false, null: false
        t.string "legacy_id"
        t.integer "comment_id"
        t.datetime "deleted_at"
      end
    end

    unless tables.include?("open_workfile_events")
      create_table "open_workfile_events", force: true do |t|
        t.integer "user_id"
        t.integer "workfile_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("operations")
      create_table "operations", force: true do |t|
        t.integer "chorus_class_id"
        t.string "name", null: false
        t.string "description"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("permissions")
      create_table "permissions", force: true do |t|
        t.integer "role_id", null: false
        t.integer "chorus_class_id", null: false
        t.integer "permissions_mask"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end

      add_index "permissions", ["role_id", "chorus_class_id"], name: "index_permissions_on_role_id_and_chorus_class_id", unique: true, using: :btree
    end

    unless tables.include?("queue_classic_jobs")
      create_table "queue_classic_jobs", force: true do |t|
        t.string "q_name"
        t.string "method"
        t.text "args"
        t.datetime "locked_at"
      end

      add_index "queue_classic_jobs", ["q_name", "id"], name: "idx_qc_on_name_only_unlocked", using: :btree
    end

    unless tables.include?("roles")
      create_table "roles", force: true do |t|
        t.string "name", null: false
        t.string "description"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("roles_users")
      create_table "roles_users", id: false, force: true do |t|
        t.integer "role_id"
        t.integer "user_id"
      end

      add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", using: :btree
    end

    unless tables.include?("schemas")
      create_table "schemas", force: true do |t|
        t.string "name", limit: 256
        t.integer "parent_id", null: false
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.integer "active_tables_and_views_count", default: 0
        t.datetime "stale_at"
        t.datetime "refreshed_at"
        t.datetime "deleted_at"
        t.string "parent_type", null: false
        t.string "type", null: false
      end

      add_index "schemas", ["deleted_at", "id"], name: "index_schemas_on_deleted_at_and_id", using: :btree
      add_index "schemas", ["name", "parent_id", "parent_type"], name: "index_schemas_on_name_and_parent_id_and_parent_type", unique: true, using: :btree
      add_index "schemas", ["parent_id"], name: "index_gpdb_schemas_on_database_id", using: :btree
    end

    unless tables.include?("scopes")
      create_table "scopes", force: true do |t|
        t.string "name", null: false
        t.string "description"
        t.integer "group_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("sessions")
      create_table "sessions", force: true do |t|
        t.string "session_id", limit: 40
        t.integer "user_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end

      add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    end

    unless tables.include?("system_statuses")
      create_table "system_statuses", force: true do |t|
        t.boolean "expired", default: false
        t.boolean "user_count_exceeded", default: false
        t.string "message", limit: 2048
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("tableau_workbook_publications")
      create_table "tableau_workbook_publications", force: true do |t|
        t.string "name"
        t.integer "dataset_id"
        t.integer "workspace_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "project_name"
        t.integer "linked_tableau_workfile_id"
        t.string "site_name", default: "Default"
      end
    end

    unless tables.include?("taggings")
      create_table "taggings", force: true do |t|
        t.integer "tag_id"
        t.integer "taggable_id"
        t.string "taggable_type"
        t.integer "tagger_id"
        t.string "tagger_type"
        t.string "context", limit: 128
        t.datetime "created_at"
      end

      add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
      add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
      add_index "taggings", ["taggable_id", "taggable_type", "tag_id"], name: "index_taggings_on_taggable_id_and_taggable_type_and_tag_id", unique: true, using: :btree
    end

    unless tables.include?("tags")
      create_table "tags", force: true do |t|
        t.string "name"
        t.integer "taggings_count", default: 0, null: false
      end

      # KT TODO: note this is not database agnostic, not serializable to schema.rb, and forces use of structure.sql --
      # Prakash says: "Rails 4 migrations support indexing and constraints. We should look into it."
      execute "CREATE UNIQUE INDEX index_tags_on_lowercase_name ON tags ((lower(name)));"
    end

    unless tables.include?("uploads")
      create_table "uploads", force: true do |t|
        t.integer "user_id"
        t.text "contents_file_name"
        t.text "contents_content_type"
        t.integer "contents_file_size"
        t.datetime "contents_updated_at"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless tables.include?("users")
      create_table "users", force: true do |t|
        t.string "username", limit: 256
        t.string "password_digest", limit: 256
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "first_name", limit: 256
        t.string "last_name", limit: 256
        t.string "email", limit: 256
        t.string "title", limit: 256
        t.string "dept", limit: 256
        t.text "notes"
        t.boolean "admin", default: false
        t.datetime "deleted_at"
        t.string "image_file_name", limit: 256
        t.string "image_content_type", limit: 256
        t.integer "image_file_size"
        t.datetime "image_updated_at"
        t.string "password_salt", default: "", null: false
        t.string "legacy_id"
        t.string "legacy_password_digest"
        t.boolean "subscribed_to_emails", default: true
        t.boolean "developer", default: false, null: false
        t.string "auth_method"
        t.string "ldap_group_id"
      end

      # KT TODO: note this is not database agnostic, not serializable to schema.rb, and forces use of structure.sql --
      # Prakash says: "Rails 4 migrations support indexing and constraints. We should look into it."
      execute "CREATE UNIQUE INDEX index_users_on_lower_case_username ON users (lower(username)) WHERE deleted_at IS NULL;"

      add_index "users", ["deleted_at", "id"], name: "index_users_on_deleted_at_and_id", using: :btree
    end

    unless tables.include?("workfile_drafts")
      create_table "workfile_drafts", force: true do |t|
        t.integer "workfile_id", null: false
        t.integer "base_version"
        t.integer "owner_id", null: false
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.text "content"
        t.string "legacy_id"
      end

      add_index "workfile_drafts", ["owner_id"], name: "index_workfile_drafts_on_owner_id", using: :btree
      add_index "workfile_drafts", ["workfile_id", "owner_id"], name: "index_workfile_drafts_on_workfile_id_and_owner_id", unique: true, using: :btree
      add_index "workfile_drafts", ["workfile_id"], name: "index_workfile_drafts_on_workfile_id", using: :btree
    end

    unless tables.include?("workfile_execution_locations")
      create_table "workfile_execution_locations", force: true do |t|
        t.integer "workfile_id"
        t.string "workfile_type"
        t.integer "execution_location_id"
        t.string "execution_location_type"
      end

      add_index "workfile_execution_locations", ["workfile_id"], name: "index_workfile_execution_locations_on_workfile_id", using: :btree
    end

    unless tables.include?("workfile_versions")
      create_table "workfile_versions", force: true do |t|
        t.integer "workfile_id", null: false
        t.integer "version_num"
        t.integer "owner_id", null: false
        t.string "commit_message", limit: 256
        t.integer "modifier_id", null: false
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "contents_file_name", limit: 256
        t.string "contents_content_type", limit: 256
        t.integer "contents_file_size"
        t.datetime "contents_updated_at"
        t.string "legacy_id"
      end

      add_index "workfile_versions", ["modifier_id"], name: "index_workfile_versions_on_modifier_id", using: :btree
      add_index "workfile_versions", ["owner_id"], name: "index_workfile_versions_on_owner_id", using: :btree
      add_index "workfile_versions", ["workfile_id"], name: "index_workfile_versions_on_workfile_id", using: :btree
    end

    unless tables.include?("workfiles")
      create_table "workfiles", force: true do |t|
        t.integer "workspace_id", null: false
        t.integer "owner_id", null: false
        t.text "description"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "file_name"
        t.datetime "deleted_at"
        t.integer "latest_workfile_version_id"
        t.string "content_type"
        t.integer "execution_location_id"
        t.string "legacy_id"
        t.string "type", default: "Workfile", null: false
        t.text "additional_data"
        t.datetime "user_modified_at"
        t.text "execution_location_type"
        t.string "status", default: "idle"
      end

      # KT TODO: note this is not database agnostic, not serializable to schema.rb, and forces use of structure.sql --
      # Prakash says: "Rails 4 migrations support indexing and constraints. We should look into it."
      execute "CREATE UNIQUE INDEX index_workfiles_on_file_name_and_workspace_id ON workfiles (file_name, workspace_id) WHERE deleted_at IS NULL"
      add_index "workfiles", ["owner_id"], name: "index_workfiles_on_owner_id", using: :btree
      add_index "workfiles", ["workspace_id"], name: "index_workfiles_on_workspace_id", using: :btree
    end

    unless tables.include?("workspaces")
      create_table "workspaces", force: true do |t|
        t.string "name", limit: 256
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.boolean "public", default: false
        t.datetime "archived_at"
        t.integer "archiver_id"
        t.text "summary"
        t.integer "owner_id", null: false
        t.string "image_file_name", limit: 256
        t.string "image_content_type", limit: 256
        t.integer "image_file_size"
        t.datetime "image_updated_at"
        t.datetime "deleted_at"
        t.boolean "has_added_member", default: false
        t.boolean "has_added_workfile", default: false
        t.boolean "has_added_sandbox", default: false
        t.boolean "has_changed_settings", default: false
        t.integer "sandbox_id"
        t.string "legacy_id"
        t.boolean "show_sandbox_datasets", default: true
        t.boolean "is_project", default: true
        t.string "project_status", default: "on_track"
        t.string "project_status_reason"
        t.integer "milestones_count", default: 0
        t.integer "milestones_achieved_count", default: 0
        t.date "project_target_date"
        t.boolean "archived", default: false
      end

      add_index "workspaces", ["archiver_id"], name: "index_workspaces_on_archiver_id", using: :btree
      add_index "workspaces", ["deleted_at", "id"], name: "index_workspaces_on_deleted_at_and_id", using: :btree
      add_index "workspaces", ["deleted_at"], name: "index_workspaces_on_deleted_at", using: :btree
      add_index "workspaces", ["id", "deleted_at"], name: "index_workspaces_on_id_and_deleted_at", using: :btree
      add_index "workspaces", ["owner_id"], name: "index_workspaces_on_owner_id", using: :btree
    end

  end
end