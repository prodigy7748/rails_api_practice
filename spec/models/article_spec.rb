require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "#validations" do
    let(:article) { create(:article) }

    it "has an invalid title" do
      article.title = ""
      expect(article).to be_invalid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it "has an invalid content" do
      article.content = ""
      expect(article).to be_invalid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it "has an invalid slug" do
      article.slug = ""
      expect(article).to be_invalid
      expect(article.errors[:slug]).to include("can't be blank")
    end

    it "has a slug been taken" do
      article1 = create(:article)
      expect(article1).to be_valid
      article2 = build(:article, slug: article1.slug)
      expect(article2).not_to be_valid
      expect(article2.errors[:slug]).to include('has already been taken')
    end
    
  end
end
