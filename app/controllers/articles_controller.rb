class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :authorize!, only: :create

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    render json: Article.created_desc.page(params[:page]), status: :ok
  end

  def show
    render json: @article
  end

  def create
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def not_found
      render json: { message: "We Couldn't find the object you were looking for!" }, status: 404
    end
end
