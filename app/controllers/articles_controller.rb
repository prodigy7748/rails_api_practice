class ArticlesController < ApplicationController
  def index
    render json: Article.all.order("id desc"), status: :ok
  end
end
