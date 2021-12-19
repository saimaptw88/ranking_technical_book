require "rails_helper"

RSpec.describe "V1::Homes", type: :request do
  describe "GET /v1/home" do
    subject { get(v1_home_index_path) }

    before do
      ReccomendedBook.destroy_all

      b = create(:reccomended_book)
      create(:amazon_affiliate, reccomended_book: b)
    end

    it "returns http success" do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
