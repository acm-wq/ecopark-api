class SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :category_id, :category_name

  def category_name
    object.category.name
  end
end
