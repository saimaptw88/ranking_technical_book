require "rails_helper"

RSpec.describe "V1::Ranking::Total::Points", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/v1/ranking/total/point/index"
      expect(response).to have_http_status(:success)
    end
  end
end
