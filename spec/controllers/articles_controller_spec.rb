require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe '#create' do
    subject { post :create }

    context "when no authorization header provided" do
      it_behaves_like "forbidden_request"
    end

    context "when invalid authorization header provided" do
      before { request.headers["authorization"] = "Invalid_token" }
      it_behaves_like "forbidden_request"
    end

    context 'when invalid parameters provided' do

    end
  end
end
