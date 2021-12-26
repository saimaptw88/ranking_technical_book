require "rails_helper"

RSpec.describe "V1::Ranking::Titles", type: :request do
  describe "GET v1/ranking/title#index" do
    subject { get(v1_ranking_title_index_path) }

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
