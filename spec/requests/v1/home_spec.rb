require 'rails_helper'

RSpec.describe "V1::Homes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/v1/home/index"
      expect(response).to have_http_status(:success)
    end
  end

end
