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
      expect(json_data.length).to eq(1)
      expected = json_data.first
      aggregate_failures do
        expect(expected[:id]).to eq(article.id.to_s)
        expect(expected[:type]).to eq("articles")
        expect(expected[:attributes]).to eq(
          title: article.title,
          content: article.content,
          slug: article.slug
        )
      end
    end

    it "should return articles in desc order" do
      new_article = create(:article)
      old_article = create(:article, created_at: 1.hour.ago)
      get "/articles"
      ids = json_data.map { |item| item[:id].to_i }
      expect(ids).to eq(
        [new_article.id, old_article.id]
      )
    end

    it "paginates results" do
      create_list(:article, 26)
      get "/articles", params: { page: 2 }
      expect(json_data.length).to eq(1)
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(
        :self, :first, :prev, :next, :last
      )
      expect(json_data.first[:id]).to eq(Article.first.id.to_s)
    end

    it "contains pagination links in the response" do
      get "/articles"
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(
        :self, :first, :prev, :next, :last
      )
    end
  end
end
