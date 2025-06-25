require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe "validations" do
    subject { build(:sub_category) }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a duplicate name" do
      create(:sub_category, name: "Unique SubCategory")
      subject.name = "Unique SubCategory"
      expect(subject).to_not be_valid
    end

    it "is not valid with a name longer than 100 characters" do
      subject.name = "a" * 101
      expect(subject).to_not be_valid
    end

    it "belongs to a category" do
      category = create(:category)
      subject.category = category
      expect(subject.category).to eq(category)
    end
  end
end
