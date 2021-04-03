require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe '#create' do
    context 'when no code provided' do
      subject { post :create }
      it_behaves_like "unauthorized_requests"
    end

    context 'when invalid code provided' do
      let(:github_error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }

      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return(github_error)
      end

      subject { post :create, params: { code: 'invalid_code' } }

      it_behaves_like "unauthorized_requests"
    end

    context 'when success request' do
      let(:user_data) do {
        login: "phillee",
        url: "http://example.com",
        avatar_url: "http://example.com/avatar",
        name: "Phil Lee"
        }
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return("valid_access_token")
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end

      subject { post :create, params: { code: "valid_code" }}

      it "should return 201 status" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "should return right json format" do
        expect{ subject }.to change{ User.count }.by(1)
        user = User.find_by(login: "phillee")
        expect(json_data[:attributes]).to eq(
          { "token" => user.access_token.token }.deep_symbolize_keys
        )
      end
    end
  end

  describe "#destroy" do
    subject { delete :destroy }

    context "when no authorization header provided" do
      it_behaves_like "forbidden_request"
    end

    context "when invalid authorization header provided" do
      before { request.headers["authorization"] = "Invalid_token" }
      it_behaves_like "forbidden_request"
    end

    context "when valid request" do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }

      before { request.headers["authorization"] = "Bearer #{access_token.token}" }

      it "should return 204 status" do
        subject
        expect(response).to have_http_status(:no_content)
      end

      it "should remove right access token" do
        expect{ subject }.to change{ AccessToken.count }.by(-1)
      end
    end
  end
end
