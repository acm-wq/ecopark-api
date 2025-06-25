require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a duplicate email" do
      User.create(email: "testuser", password: "password")
      expect(subject).to_not be_valid
    end

    it "is not valid with an invalid email format" do
      subject.email = "invalid_email"
      expect(subject).to_not be_valid
    end

    it "is not valid if the password is too short" do
      subject.password = "short"
      expect(subject).to_not be_valid
    end
  end
end
