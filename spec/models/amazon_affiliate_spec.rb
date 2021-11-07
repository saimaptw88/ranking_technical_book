require "rails_helper"

RSpec.describe AmazonAffiliate, type: :model do
  describe "field check" do
    it { is_expected.to have_field(:affiliate_url).of_type(String) }
    it { is_expected.to have_field(:author).of_type(String) }
    it { is_expected.to have_field(:explanation).of_type(String) }
    it { is_expected.to have_field(:thumbnail_url).of_type(String) }
    it { is_expected.to have_field(:publication_data).of_type(Time) }
  end

  describe "assosiation check" do
    context "reccomended_book" do
      it { is_expected.to belong_to(:reccomended_book) }
    end

    context "amazon_affiliate_tag" do
      it { is_expected.to embed_many(:amazon_affiliate_tags) }
    end
  end
end
