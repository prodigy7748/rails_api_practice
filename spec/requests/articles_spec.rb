require 'rails_helper'

RSpec.describe ArticlesController do
  describe "#index" do
    it "should return a success responce" do
      get "/articles"
      expect(response).to have_http_status(:ok)
    end

    it "should return right format of JSON" do
      article = create(:article)
      get "/articles"
      body = JSON.parse(response.body).deep_symbolize_keys
      expect(body).to eq(
        data: [
          {
            id: article.id.to_s,
            type: "articles",
            attributes: {
              title: article.title,
              content: article.content,
              slug: article.slug
            }
          }
        ]
      )
    end
  end
end
