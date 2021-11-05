require "rails_helper"

RSpec.describe ReccomendedBook, type: :model do
  describe "field check" do
    it { is_expected.to have_field(:title).of_type(String) }
  end

  describe "validation check" do
    context "no title" do
      let(:reccomended_book) { build(:reccomended_book, :with_qiita_article, :with_qiita_tag, title: nil) }

      it "error create document" do
        expect(reccomended_book).to be_invalid
      end
    end

    context "no qiita_article" do
      let(:reccomended_book) { build(:reccomended_book, :with_qiita_tag) }

      it "success create document" do
        expect(reccomended_book).to be_valid
      end
    end

    context "no qiita_tag" do
      let(:reccomended_book) { build(:reccomended_book) }

      it "success create document" do
        expect(reccomended_book).to be_valid
      end
    end
  end

  describe "association check" do
    context "qiita_articles" do
      it { is_expected.to have_many(:qiita_articles).with_dependent(:destroy) }
    end

    context "qiita_tags" do
      it { is_expected.to have_many(:qiita_tags).with_dependent(:destroy) }
    end
  end
end
