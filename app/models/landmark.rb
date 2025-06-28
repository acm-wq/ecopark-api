class Landmark < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :sub_categories, through: :categorizations

  has_many_attached :images

  validates :name, presence: true, uniqueness: true
  validates :description, length: { minimum: 10 }, allow_blank: true
end
