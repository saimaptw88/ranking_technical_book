require "rails_helper"

RSpec.describe "V1::Homes", type: :request do
  # NOTE : Do not know how to test with redis.
  # describe "GET /v1/home" do
  #   subject { get(v1_home_index_path) }

  #   before do
  #     ReccomendedBook.destroy_all

  #     5.times do
  #       book = create(:reccomended_book)
  #       create(:amazon_affiliate, reccomended_book: book)
  #     end
  #   end

  #   fit "returns http success" do
  #     subject
  #     expect(response).to have_http_status(:success)
  #   end
  # end

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
