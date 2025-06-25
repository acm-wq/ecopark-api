class Landmark < ApplicationRecord
  has_many :categorizations
  has_many :sub_categories, through: :categorizations
end
