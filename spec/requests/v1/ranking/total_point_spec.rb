require "rails_helper"

RSpec.describe "V1::Ranking::TotalPoints", type: :request do
  describe "GET v1/ranking/total_point#index" do
    subject { get(v1_ranking_total_point_index_path) }

    before do
      ReccomendedBook.destroy_all
      create_list(:reccomended_book, 5)
    end

    it "returns http success" do
      subject
      expect(response).to have_http_status(:success)
    end

    it "have 5 titles" do
      subject
      expect(JSON.parse(response.body).count).to eq 5
    end
  end
end
