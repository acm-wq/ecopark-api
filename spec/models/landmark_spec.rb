require 'rails_helper'

RSpec.describe Landmark, type: :model do
  subject { build(:landmark) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it 'is not valid with a duplicate name' do
      create(:landmark, name: 'Unique Landmark')
      subject.name = 'Unique Landmark'
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include('has already been taken')
    end

    it 'is valid if description is blank' do
      subject.description = ''
      expect(subject).to be_valid
    end

    it 'is not valid if description is shorter than 10 characters (when present)' do
      subject.description = 'Too short'
      expect(subject).not_to be_valid
      expect(subject.errors[:description]).to include('is too short (minimum is 10 characters)')
    end

    it 'is valid if description is at least 10 characters' do
      subject.description = 'Valid description'
      expect(subject).to be_valid
    end
  end

  describe 'associations' do
    it 'has many categorizations' do
      assoc = Landmark.reflect_on_association(:categorizations)
      expect(assoc).not_to be_nil
      expect(assoc.macro).to eq(:has_many)
    end

    it 'has many sub_categories through categorizations' do
      assoc = Landmark.reflect_on_association(:sub_categories)
      expect(assoc).not_to be_nil
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:categorizations)
    end
  end

  describe 'attachments' do
    it 'allows attaching multiple images' do
      subject.images.attach(
        [
          fixture_file_upload(
            Rails.root.join('spec/fixtures/files/image1.jpg'), 'image/jpg'
          ),
          fixture_file_upload(
            Rails.root.join('spec/fixtures/files/image2.jpg'), 'image/jpg'
          )
        ]
      )
      expect(subject.images.count).to eq(2)
    end
  end
end
