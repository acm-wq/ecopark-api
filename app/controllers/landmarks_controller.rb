class LandmarksController < ApplicationController
  include Pagy::Backend
  skip_before_action :authorized, only: [:index]

  before_action :set_landmark, only: %i[update destroy]

  def index
    pagy_landmarks, landmarks = pagy(Landmark.all, page_param: :landmarks_page)
    render json: {
      landmarks: ActiveModelSerializers::SerializableResource.new(
        landmarks,
        each_serializer: LandmarkSerializer
      ),
      pagy: pagy_metadata(pagy_landmarks)
    }, status: :ok
  end

  def create
    landmark = Landmark.new(landmark_params)
    if landmark.save
      render json: landmark, serializer: LandmarkSerializer, status: :created
    else
      render_errors(landmark)
    end
  end

  def update
    if @landmark.update(landmark_params)
      render json: @landmark, serializer: LandmarkSerializer, status: :ok
    else
      render_errors(@landmark)
    end
  end

  def destroy
    if @landmark.destroy
      render json: { message: 'Landmark deleted successfully' }, status: :ok
    else
      render json: { error: 'Failed to delete landmark' },
             status: :unprocessable_entity
    end
  end

  private

  def set_landmark
    @landmark = Landmark.find_by(id: params[:id])
    return if @landmark

    render json: { error: 'Landmark not found' },
           status: :not_found
  end

  def landmark_params
    params.require(:landmark).permit(:name, :description, images: [])
  end

  def render_errors(resource)
    render json: { errors: resource.errors.full_messages },
           status: :unprocessable_entity
  end
end
