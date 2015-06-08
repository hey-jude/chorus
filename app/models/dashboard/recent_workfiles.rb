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

      workfiles =  OpenWorkfileEvent.
          select('id, user_id, max(created_at) as created_at, workfile_id').
          where(:user_id => user.id).
          group(:workfile_id).
          group(:id).
          order('created_at DESC').
          includes(:workfile).
          limit(limitValue).all

      # PTELI:SCOPE Filter results by scope for current user
      workfiles = OpenWorkfileEvent.filter_by_scope(user, workfiles)

      workfiles
    end
  
  end
end
