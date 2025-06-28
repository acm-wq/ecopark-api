class LandmarkSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :description, :images

  def images
    object.images.map do |image|
      {
        id: image.id,
        url: rails_blob_url(image, only_path: true),
        thumbnail_url: rails_representation_url(
          image.variant(resize_to_limit: [100, 100]).processed, only_path: true
        )
      }
    end
  end
end
