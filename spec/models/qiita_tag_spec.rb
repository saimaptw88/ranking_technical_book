require "rails_helper"

RSpec.describe QiitaTag, type: :model do
  describe "field check" do
    it { is_expected.to have_field(:kind).of_type(String) }
    it { is_expected.to have_field(:kind_count).of_type(Integer).with_default_value_of(0) }
  end

  describe "validation check" do
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to validate_presence_of(:kind_count) }
    it { is_expected.to validate_numericality_of(:kind_count).greater_than_or_equal_to(0) }
  end

  describe "association check" do
    context "reccomended_book" do
      it { is_expected.to be_embedded_in(:reccomended_book) }
    end
  end
end
