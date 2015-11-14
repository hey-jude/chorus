module Api
  class TagsController < ApiController
    def index
      tags = params[:q].present? ? Tag.named_like(params[:q]) : Tag.all
      present paginate(tags.order("LOWER(name)"))
    end

    def update
      tag = Tag.find(params[:id])
      tag.name = params[:tag][:name]
      tag.save!

      present tag
    end

    def destroy
      tag = Tag.find(params[:id])
      Authority.authorize! :destroy, tag, current_user
      tag.destroy

      head :ok
    end
  end
end