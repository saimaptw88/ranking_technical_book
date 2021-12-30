require "rails_helper"

RSpec.describe "V1::Homes", type: :request do
  describe "GET /v1/home/:id" do
    subject { get(v1_home_path(book_id)) }

    let(:book_id) { book.id }
    let(:book) { create(:reccomended_book) }

    before do
      ReccomendedBook.destroy_all

      create(:amazon_affiliate, reccomended_book: book)
      create(:qiita_article, reccomended_book: book)
      create_list(:qiita_tag, 3, reccomended_book: book)
    end

    it "returns http success" do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
