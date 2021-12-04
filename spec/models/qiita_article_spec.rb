require "rails_helper"

RSpec.describe QiitaArticle, type: :model do
  describe "field check" do
    it { is_expected.to have_field(:title).of_type(String) }
    it { is_expected.to have_field(:lgtm_count).of_type(Integer).with_default_value_of(0) }
    it { is_expected.to have_field(:created_at).of_type(Time) }
  end

  describe "validation check" do
    it { is_expected.to validate_presence_of(:title) }

    it {
      expect(subject).to validate_numericality_of(:lgtm_count).
                           greater_than_or_equal_to(0).to_allow(only_integer: true)
    }

    it { is_expected.to validate_presence_of(:lgtm_count) }
    it { is_expected.to validate_presence_of(:created_at) }
  end

  describe "assosiation check" do
    context "reccomended_book" do
      it { is_expected.to belong_to(:reccomended_book) }
    end
  end
end
