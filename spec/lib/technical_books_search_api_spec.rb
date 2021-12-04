require "rails_helper"

describe TechnicalBooksSearchApi do
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
end
