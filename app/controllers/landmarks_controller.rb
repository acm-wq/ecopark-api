class LandmarksController < ApplicationController
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
      images: []
    )
  end
end
