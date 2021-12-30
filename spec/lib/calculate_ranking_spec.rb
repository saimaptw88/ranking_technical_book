require "rails_helper"

describe CalculateRanking do
  # ポイントの更新
  # NOTE : all pairs法, 条件項目 : term　記事数　直近1ヶ月の記事数　LGTM数　初心者、初学者、新人タグ数, アクション : point correct?
  describe ".update_point(term:)" do
    subject { CalculateRanking.update_point(term: term) }

    let(:time_current) { Time.current }
    let(:time_this_month) { time_current.prev_month }
    let(:time_this_year) { time_current.prev_year }
    let(:reccomended_book) { create(:reccomended_book) }
    # 項目 : 記事数  直近1ヶ月の記事数       LGTM数  初心者、初学者、新人タグ合計数
    # total   1       0       0       1
    # total   2       1       1       2
    # total   0       2       2       0
    context "term = total" do
      let(:term) { "total" }

      context "1       0       0       1" do
        before do
          ReccomendedBook.destroy_all
          create(:qiita_article, published_at: time_this_year, lgtm_count: 0, reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "元初学者が教える", reccomended_book: reccomended_book)
        end

        it "point = 1100" do
          subject
          expect(ReccomendedBook.first.total_point).to eq 1100
        end
      end

      context "2       1       1       2" do
        before do
          ReccomendedBook.destroy_all
          create(:qiita_article, published_at: time_this_year, lgtm_count: 0, reccomended_book: reccomended_book)
          create(:qiita_article, published_at: time_this_month + 1.second, lgtm_count: 1, reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "元初学者が教える", reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "新人です！", reccomended_book: reccomended_book)
        end

        it "point = 100 * 3 + 1 + 1000 * 2" do
          subject
          expect(ReccomendedBook.first.total_point).to eq 2301
        end
      end

      context "0       2       2       0" do
        before do
          ReccomendedBook.destroy_all
          reccomended_book
        end

        it "point = 0" do
          subject
          expect(ReccomendedBook.first.total_point).to eq 0
        end
      end
    end

    # 項目 : 記事数  直近1ヶ月の記事数       LGTM数  初心者、初学者、新人タグ合計数
    # yearly  1       1       2       2
    # yearly  0       1       0       1
    # yearly  2       0       2       1
    # yearly  0       0       1       0
    # yearly  0       2       0       2
    context "term = yearly" do
      let(:term) { "yearly" }

      context "1       1       2       2" do
        before do
          ReccomendedBook.destroy_all
          create(:qiita_article, published_at: time_this_month + 1.second, lgtm_count: 2, reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "元初学者が教える", reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "新人です！", reccomended_book: reccomended_book)
        end

        it "point = 2202" do
          subject
          expect(ReccomendedBook.first.yearly_point).to eq 2202
        end
      end

      context "0       1       0       1, 0       0       1       0, 0       2       0       2" do
        before do
          ReccomendedBook.destroy_all
          reccomended_book
        end

        it "point = 0" do
          subject
          expect(ReccomendedBook.first.yearly_point).to eq 0
        end
      end

      context "2       0       2       1" do
        before do
          ReccomendedBook.destroy_all
          create_list(:qiita_article, 2, published_at: time_this_year + 1.second, lgtm_count: 1, reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "元初学者が教える", reccomended_book: reccomended_book)
        end

        it "point = 1202" do
          subject
          expect(ReccomendedBook.first.yearly_point).to eq 1202
        end
      end
    end

    # 項目 : 記事数  直近1ヶ月の記事数       LGTM数  初心者、初学者、新人タグ合計数
    # monthly 1       1       1       0
    # monthly 0       0       2       2
    # monthly 2       2       0       0
    # monthly 0       1       0       1
    context "term = monthly" do
      let(:term) { "monthly" }

      context "1       1       1       0" do
        before do
          ReccomendedBook.destroy_all
          create(:qiita_article, published_at: time_this_month + 1.second, lgtm_count: 1, reccomended_book: reccomended_book)
        end

        it "point = 201" do
          subject
          expect(ReccomendedBook.first.monthly_point).to eq 101
        end
      end

      context "0       0       2       2, 0       1       0       1" do
        before do
          ReccomendedBook.destroy_all
          reccomended_book
        end

        it "point = 0" do
          subject
          expect(ReccomendedBook.first.monthly_point).to eq 0
        end
      end

      context "2       2       0       0" do
        before do
          ReccomendedBook.destroy_all
          create_list(:qiita_article, 2, published_at: time_this_month + 1.second, lgtm_count: 0, reccomended_book: reccomended_book)
        end

        it "point = 200" do
          subject
          expect(ReccomendedBook.first.monthly_point).to eq 200
        end
      end
    end
  end

  # 各期間のポイントを更新
  # ランキングが正しく更新されていること
  # describe ".update_ranking(term:)" do
  #   subject { CalculateRanking.update_ranking(term: term) }

  #   context "term = total" do
  #     before { ReccomendedBook.destroy_all }

  #     let!(:article1) { create(:reccomended_book, total_point: 1) }
  #     let!(:article2) { create(:reccomended_book, total_point: 2) }
  #     let!(:article3) { create(:reccomended_book, total_point: 3) }

  #     let(:term) { "total" }

  #     it "ranking is correct" do
  #       subject
  #       expect(ReccomendedBook.pluck(:id, :total_ranking)).to eq [[article1.id, 3], [article2.id, 2], [article3.id, 1]]
  #     end
  #   end

  #   context "term = yearly" do
  #     before { ReccomendedBook.destroy_all }

  #     let!(:article1) { create(:reccomended_book, yearly_point: 1) }
  #     let!(:article2) { create(:reccomended_book, yearly_point: 2) }
  #     let!(:article3) { create(:reccomended_book, yearly_point: 3) }

  #     let(:term) { "yearly" }

  #     it "ranking is correct" do
  #       subject
  #       expect(ReccomendedBook.pluck(:id, :yearly_ranking)).to eq [[article1.id, 3], [article2.id, 2], [article3.id, 1]]
  #     end
  #   end

  #   context "term = monthly" do
  #     before { ReccomendedBook.destroy_all }

  #     let!(:article1) { create(:reccomended_book, monthly_point: 1) }
  #     let!(:article2) { create(:reccomended_book, monthly_point: 2) }
  #     let!(:article3) { create(:reccomended_book, monthly_point: 3) }

  #     let(:term) { "monthly" }

  #     it "ranking is correct" do
  #       subject
  #       expect(ReccomendedBook.pluck(:id, :monthly_ranking)).to eq [[article1.id, 3], [article2.id, 2], [article3.id, 1]]
  #     end
  #   end
  # end

  # reccomended_book に紐づく記事を全て取得
  # NOTE : 同値クラステスト　境界値テスト
  describe ".get_articles(reccomended_book:, term:)" do
    subject { CalculateRanking.get_articles(reccomended_book: reccomended_book, term: term) }

    before do
      ReccomendedBook.destroy_all
      create(:qiita_article, published_at: time_current, reccomended_book: reccomended_book)
      create(:qiita_article, published_at: time_this_month + 1.second, reccomended_book: reccomended_book)
      create(:qiita_article, published_at: time_this_month, reccomended_book: reccomended_book)
      create(:qiita_article, published_at: time_this_month - 1.second, reccomended_book: reccomended_book)
      create(:qiita_article, published_at: time_this_year + 1.second, reccomended_book: reccomended_book)
      create(:qiita_article, published_at: time_this_year, reccomended_book: reccomended_book)
      create(:qiita_article, published_at: time_this_year - 1.second, reccomended_book: reccomended_book)
    end

    let(:reccomended_book) { create(:reccomended_book) }
    let(:time_current) { Time.current }
    let(:time_this_month) { Time.current.prev_month }
    let(:time_this_year) { Time.current.prev_year }

    context "term = total" do
      let(:term) { "total" }

      it "articles は 7 つの記事を含む" do
        expect(subject.count).to eq 7
      end
    end

    context "term = yearly" do
      let(:term) { "yearly" }

      it "articles は 5 つの記事を含む" do
        expect(subject.count).to eq 5
      end
    end

    context "term = monthly" do
      let(:term) { "monthly" }

      it "articles は 2 つの記事を含む" do
        expect(subject.count).to eq 2
      end
    end
  end

  # 直近1ヶ月の記事数を取得する
  # NOTE : 同値クラステスト : 直近1ヶ月とそれ以外
  # NOTE : 境界値テスト : 現在時刻から1ヶ月前を含まない, 現在時刻から1ヶ月前 - 1秒を含む
  describe ".get_recently_article_count(articles_id:)" do
    subject { CalculateRanking.get_recently_article_count(articles_id: articles_id) }

    let(:articles_id) { [article1.id, article2.id, article3.id] }
    let(:reccomended_book) { create(:reccomended_book) }
    let(:article1) { create(:qiita_article, published_at: Time.current, reccomended_book: reccomended_book) }
    let(:article2) { create(:qiita_article, published_at: Time.current.prev_month + 1.second, reccomended_book: reccomended_book) }
    let(:article3) { create(:qiita_article, published_at: Time.current.prev_month, reccomended_book: reccomended_book) }

    context "同値クラス 境界値テスト" do
      before { ReccomendedBook.destroy_all }

      it "recently_article_count = 2" do
        expect(subject).to eq 2
      end
    end
  end

  # ポイント計算の1要素の初学者タグがあるか確認する
  # NOTE : all_pairs法,　条件項目 : Qiitaタグが存在する	初学者が存在する	初心者が存在する	新人が存在する
  describe ".get_beginner_count(reccomended_book:)" do
    subject { CalculateRanking.get_beginner_count(reccomended_book: reccomended_book) }

    before { ReccomendedBook.destroy_all }

    let(:reccomended_book) { create(:reccomended_book) }

    context "Qiita記事に付随するタグが存在しない場合" do
      it "beginner_count = 0" do
        expect(subject).to eq 0
      end
    end

    context "Qiita記事に付随するタグが存在する場合" do
      context "「初学者」がない	「初心者」がある	「新人」がある" do
        before do
          ReccomendedBook.destroy_all
          create(:qiita_tag, kind: "初学者におすすめ", reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "新人におすすめ", reccomended_book: reccomended_book)
        end

        it "beginner_count = 2" do
          expect(subject).to eq 2
        end
      end

      context "「初学者」がない	「初心者」がない	「新人」がない" do
        before { ReccomendedBook.destroy_all }

        it "beginner_count = 0" do
          expect(subject).to eq 0
        end
      end

      context "「初学者」が複数ある	「初心者」が複数ある	「新人」が複数ある" do
        before do
          ReccomendedBook.destroy_all
          create(:qiita_tag, kind: "初心者におすすめ", reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "初心者", reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "初学者におすすめ", reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "初学者", reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "新人におすすめ", reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "新人", reccomended_book: reccomended_book)
        end

        it "beginner_count = 6" do
          expect(subject).to eq 6
        end
      end

      context "「初学者」がある	「初心者」がない	「新人」がある" do
        before do
          ReccomendedBook.destroy_all
          create(:qiita_tag, kind: "初心者におすすめ", reccomended_book: reccomended_book)
          create(:qiita_tag, kind: "新人におすすめ", reccomended_book: reccomended_book)
        end

        it "beginner_count = 2" do
          expect(subject).to eq 2
        end
      end
    end
  end
end
