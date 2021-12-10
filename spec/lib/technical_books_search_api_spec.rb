require "rails_helper"

describe TechnicalBooksSearchApi do
  let(:result) do
    { "title" => "Rails5",
      "subtitle" => "5.2対応",
      "authors" => ["大場寧子", "松本拓也", "櫻井達生", "小田井優", "大塚隆弘", "依光奏江", "銭神裕宜", "小芝美由紀"],
      "publishedDate" => "2018-10",
      "description" => "Railsアプリの基本から実践的なノウハウまでこの1冊で!",
      "industryIdentifiers" => [{ "type" => "ISBN_10", "identifier" => "4839962227" }, { "type" => "ISBN_13", "identifier" => "9784839962227" }],
      "readingModes" => { "text" => false, "image" => false },
      "pageCount" => 480,
      "printType" => "BOOK",
      "maturityRating" => "NOT_MATURE",
      "allowAnonLogging" => false,
      "contentVersion" => "preview-1.0.0",
      "panelizationSummary" => { "containsEpubBubbles" => false, "containsImageBubbles" => false },
      "imageLinks" =>
       { "smallThumbnail" => "http://books.google.com/books/content?id=bP46vQEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api" } }
  end

  # 未実装
  # describe ".execute" do
  #   subject { TechnicalBooksSearchApi.execute }

  #   before { ReccomendedBook.destroy_all }
  # end

  # # 未実装
  # describe ".update_book(url:)" do
  #   subject { TechnicalBooksSearchApi.update_book(url: url) }

  #   before { ReccomendedBook.destroy_all }

  #   let(:url) { "https://www.googleapis.com/books/v1/volumes?q=rails&maxResults=1&startIndex=1&printType=books&key=#{ENV["GCP_API_KEY"]}" }
  # end

  describe ".destroy_all" do
    subject { TechnicalBooksSearchApi.destroy_all }

    before do
      3.times do
        reccomended_book = create(:reccomended_book)
        create(:amazon_affiliate, reccomended_book: reccomended_book)
      end
    end

    it "レコードを全て削除できる" do
      expect { subject }.to change { ReccomendedBook.count }.by(-3) && change { AmazonAffiliate.count }.by(-3)
    end
  end

  describe ".title_present?(result:)" do
    subject { TechnicalBooksSearchApi.title_present?(result: result) }

    before { ReccomendedBook.destroy_all }

    context "title が存在し、文字数が6文字以上の場合" do
      it "true" do
        expect(subject).to eq true
      end
    end

    context "title が存在しない場合" do
      let(:result) { { "rails" => "" } }

      it "false" do
        expect(subject).to eq false
      end
    end

    context "title の文字数が6文字未満の場合" do
      let(:result) { { "title" => "Rails" } }

      it "false" do
        expect(subject).to eq false
      end
    end
  end

  describe ".thumbnail_image_url(result:)" do
    subject { TechnicalBooksSearchApi.thumbnail_image_url(result: result) }

    before { ReccomendedBook.destroy_all }

    context "image が存在する場合" do
      it "戻り値が存在する" do
        expect(subject.present?).to eq true
      end
    end

    context "image が存在しな場合" do
      let(:result) { { "title" => "Rails" } }

      it "nil を返す" do
        expect(subject).to eq nil
      end
    end
  end

  describe ".title_registered?(title:)" do
    subject { TechnicalBooksSearchApi.title_registered?(title: title) }

    before { ReccomendedBook.destroy_all }

    context "title　が存在する場合" do
      before { create(:reccomended_book, title: title) }

      let(:title) { "図解まるわかり プログラミングのしくみ" }
      let(:amazon_affiliate) { create(:amazon_affiliate) }

      it "true を返す" do
        expect(subject).to eq true
      end
    end

    context "title が存在しない場合" do
      let(:title) { "foo" }

      it "false を返す" do
        expect(subject).to eq false
      end
    end
  end

  describe ".isbn_present?(result:)" do
    subject { TechnicalBooksSearchApi.isbn_present?(result: result) }

    before { ReccomendedBook.destroy_all }

    context "isbn が存在し isbn13も存在する場合" do
      it "true" do
        expect(subject).to eq true
      end
    end

    context "isbn が存在しない場合" do
      let(:result) { { "title" => "Rails" } }

      it "false" do
        expect(subject).to eq false
      end
    end

    context "isbn13 が存在しない場合" do
      let(:result) { { "industryIdentifiers" => [{ "type" => "ISBN_10", "identifier" => "4839962227" }] } }

      it "false" do
        expect(subject).to eq false
      end
    end
  end

  describe ".isbn13(result:)" do
    subject { TechnicalBooksSearchApi.isbn13(result: result) }

    before { ReccomendedBook.destroy_all }

    it "戻り値が存在する" do
      expect(subject.present?).to eq true
    end
  end
end
