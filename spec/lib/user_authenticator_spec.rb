require 'rails_helper'

describe UserAuthenticator do
  describe "#perform" do
    let(:authenticator) { described_class.new("sample_code") }
    subject { authenticator.perform }

    context "when code is incorrect" do
      let(:error) {
        double("Sawyer::Resource", error: "bad_varification_code")
      }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(error)
      end

      it "should raise an error" do
        expect{ subject }.to raise_error(
          UserAuthenticator::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end

    context "when code is correct" do
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

      it "should save the user when doesn't exist" do
        expect{ subject }.to change{ User.count }.by(1)
        expect( User.last.name ).to eq("Phil Lee")
      end
    end
  end
end