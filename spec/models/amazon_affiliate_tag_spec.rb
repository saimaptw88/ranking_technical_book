require "rails_helper"

RSpec.describe AmazonAffiliateTag, type: :model do
  describe "field check" do
    it { is_expected.to have_field(:tag).of_type(String) }
  end

  describe "assosietion check" do
    it { is_expected.to be_embedded_in(:amazon_affiliate) }
  end
end
