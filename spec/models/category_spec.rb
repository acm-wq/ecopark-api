require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "validations" do
    subject { build(:category) }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a duplicate name" do
      create(:category, name: "Unique Category")
      subject.name = "Unique Category"
      expect(subject).to_not be_valid
    end

    it "is not valid with a name longer than 100 characters" do
      subject.name = "a" * 101
      expect(subject).to_not be_valid
    end
  end
end
