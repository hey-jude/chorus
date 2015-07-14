module Dashboard
  class RecentWorkfiles < DataModule

    attr_reader :user

    def assign_params(params)
      @user = params[:user]
    end

    private

    def fetch_results
      limitValue = user.dashboard_items.where(:name => 'RecentWorkfiles').select('options').map(&:options).first
      if limitValue == ''
        limitValue = 5
      end
      workfiles = nil
      active_rel =  OpenWorkfileEvent.
          select('max(created_at) as created_at, workfile_id, id').
          where(:user_id => user.id).
          group(:workfile_id).
          group(:id).
          order('created_at DESC').
          includes(:workfile).
          limit(limitValue)
      if active_rel != nil
        workfiles = active_rel.all
      end
      if Permissioner.user_in_scope? @user
        # PTELI:SCOPE Filter results by scope for current user
        workfiles = OpenWorkfileEvent.filter_by_scope(@user, workfiles)
      else
        workfiles
      end
    end
  end
end
