class LandmarksController < ApplicationController
  include Pagy::Backend

  skip_before_action :authorized, only: [:index]

  def index
    pagy_landmarks, landmarks = pagy(Landmark.all, page_param: :landmarks_page)
    render json: {
      landmarks: ActiveModelSerializers::SerializableResource.new(
        landmarks,
        each_serializer: LandmarkSerializer
      ),
      pagy: pagy_metadata(pagy_landmarks)
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Landmarks not found' }, status: :not_found
  end

  def create
    landmark = Landmark.new(landmark_params)
    if landmark.save
      render json: landmark, status: :created
    else
      render json: { errors: landmark.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def landmark_params
    params.require(:landmark).permit(
      :name,
      :description,
      images: []
    )
  end
end
