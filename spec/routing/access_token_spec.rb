require 'rails_helper'

RSpec.describe "access_token routes", :type => :routing do
  describe "access_tokens routes" do
    it "should route to access_token create action" do
      expect(post '/login').to route_to("access_tokens#create")
    end
  end
end
