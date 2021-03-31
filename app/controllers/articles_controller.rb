class ArticlesController < ApplicationController
  def index
    render json: Article.created_desc.page(params[:page]), status: :ok
  end
end
