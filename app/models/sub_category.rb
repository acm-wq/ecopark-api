class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :categorizations

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end
