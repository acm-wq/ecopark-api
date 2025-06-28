class Landmark < ApplicationRecord
  has_many :categorizations
  has_many :sub_categories, through: :categorizations

  has_many_attached :images
end
