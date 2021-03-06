require "rails_helper"

RSpec.describe ReccomendedBook, type: :model do
  describe "field check" do
    it { is_expected.to have_field(:title).of_type(String) }
    it { is_expected.to have_field(:isbn).of_type(Integer) }
    it { is_expected.to have_field(:total_point).of_type(Integer).with_default_value_of(0) }
    it { is_expected.to have_field(:yearly_point).of_type(Integer).with_default_value_of(0) }
    it { is_expected.to have_field(:monthly_point).of_type(Integer).with_default_value_of(0) }
    it { is_expected.to have_field(:total_ranking).of_type(Integer) }
    it { is_expected.to have_field(:yearly_ranking).of_type(Integer) }
    it { is_expected.to have_field(:monthly_ranking).of_type(Integer) }
  end

  describe "validation check" do
    context "point_until_last_year" do
      it { is_expected.to validate_presence_of(:total_point) }
      it { is_expected.to validate_numericality_of(:total_point).greater_than_or_equal_to(0) }
    end

    context "yearly_point" do
      it { is_expected.to validate_presence_of(:yearly_point) }
      it { is_expected.to validate_numericality_of(:yearly_point).greater_than_or_equal_to(0) }
    end

    context "monthly_point" do
      it { is_expected.to validate_presence_of(:monthly_point) }
      it { is_expected.to validate_numericality_of(:monthly_point).greater_than_or_equal_to(0) }
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
      it { is_expected.to embed_many(:qiita_tags) }
    end

    context "ammazon_affiliate" do
      it { is_expected.to have_one(:amazon_affiliate).with_dependent(:destroy) }
    end
  end
end
