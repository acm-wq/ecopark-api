class Category < ApplicationRecord
  has_many :sub_categories

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end
