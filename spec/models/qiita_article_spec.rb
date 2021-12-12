require "rails_helper"

RSpec.describe QiitaArticle, type: :model do
  describe "field check" do
    it { is_expected.to have_field(:title).of_type(String) }
    it { is_expected.to have_field(:lgtm_count).of_type(Integer).with_default_value_of(0) }
    it { is_expected.to have_field(:published_at).of_type(Time) }
  end

  describe "validation check" do
    it { is_expected.to validate_presence_of(:title) }

    it {
      expect(subject).to validate_numericality_of(:lgtm_count).
                           greater_than_or_equal_to(0).to_allow(only_integer: true)
    }

    it { is_expected.to validate_presence_of(:lgtm_count) }
    it { is_expected.to validate_presence_of(:published_at) }
  end

  describe "assosiation check" do
    context "reccomended_book" do
      it { is_expected.to belong_to(:reccomended_book) }
    end
  end

  describe "methods check" do
    context "published_at_this_month?" do
      before { ReccomendedBook.destroy_all }

      let(:reccomended_book) { create(:reccomended_book) }
      let(:qiita_article1) { create(:qiita_article, published_at: time, reccomended_book: reccomended_book) }
      let(:qiita_article2) { create(:qiita_article, published_at: time.prev_month, reccomended_book: reccomended_book) }
      let(:qiita_article3) { create(:qiita_article, published_at: time.prev_month + 1.second, reccomended_book: reccomended_book) }
      let(:time) { Time.current }

      it "本日執筆された記事は含む" do
        expect(qiita_article1.published_at_this_month?).to eq true
      end

      it "1ヶ月前に執筆された記事は含まない" do
        expect(qiita_article2.published_at_this_month?).to eq false
      end

      it "1ヶ月前直前に執筆された記事は含む" do
        expect(qiita_article3.published_at_this_month?).to eq true
      end
    end

    context "published_at_this_year?" do
      before { ReccomendedBook.destroy_all }

      let(:reccomended_book) { create(:reccomended_book) }
      let(:qiita_article1) { create(:qiita_article, published_at: time, reccomended_book: reccomended_book) }
      let(:qiita_article2) { create(:qiita_article, published_at: time.prev_year, reccomended_book: reccomended_book) }
      let(:qiita_article3) { create(:qiita_article, published_at: time.prev_year + 1.second, reccomended_book: reccomended_book) }
      let(:time) { Time.current }

      it "本日執筆された記事は含む" do
        expect(qiita_article1.published_at_this_year?).to eq true
      end

      it "1年前に執筆された記事は含まない" do
        expect(qiita_article2.published_at_this_year?).to eq false
      end

      it "1年前直前に執筆された記事は含む" do
        expect(qiita_article3.published_at_this_year?).to eq true
      end
    end

    context "published_before_this_year?" do
      before { ReccomendedBook.destroy_all }

      let(:reccomended_book) { create(:reccomended_book) }
      let(:qiita_article1) { create(:qiita_article, published_at: Time.current, reccomended_book: reccomended_book) }
      let(:qiita_article2) { create(:qiita_article, published_at: Time.current.prev_year + 1.second, reccomended_book: reccomended_book) }
      let(:qiita_article3) { create(:qiita_article, published_at: Time.current.prev_year, reccomended_book: reccomended_book) }
      let(:qiita_article4) { create(:qiita_article, published_at: Time.current.prev_year - 1.month, reccomended_book: reccomended_book) }

      it "本日執筆された記事は含まない" do
        expect(qiita_article1.published_before_this_year?).to eq false
      end

      it "1年前直前に執筆された記事は含まない" do
        expect(qiita_article2.published_before_this_year?).to eq false
      end

      it "1年前前に執筆された記事は含む" do
        expect(qiita_article3.published_before_this_year?).to eq true
      end

      it "1年1ヶ月前に執筆された記事は含む" do
        expect(qiita_article4.published_before_this_year?).to eq true
      end
    end
  end
end
