class WorkfileUniqueNameValidator < ActiveModel::Validator

  def validate(record)
    workfiles = Workfile.where(:file_name => record.file_name, :workspace_id => record.workspace_id, :deleted_at => nil)
    if(record.content_type == 'published_worklet')
      workfiles.each do |workfile|
        if workfile != record && workfile.content_type == 'published_worklet'
          record.errors.add(:file_name, :taken)
          break
        end
      end
    else
      workfiles.each do |workfile|
        if workfile != record && workfile.content_type != 'published_worklet'
          record.errors.add(:file_name, :taken)
          break
        end
      end
    end

  end

end
