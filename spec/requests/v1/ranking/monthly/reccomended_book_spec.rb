require "rails_helper"

RSpec.describe "V1::Ranking::Monthly::ReccomendedBooks", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/v1/ranking/monthly/reccomended_book/index"
      expect(response).to have_http_status(:success)
    end
  end
end