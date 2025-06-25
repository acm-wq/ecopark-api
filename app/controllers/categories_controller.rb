class CategoriesController < ApplicationController
  skip_before_action :authorized, only: [:index]

  # GET /api/categories
  def index
    case params.require(:category).permit(:type)[:type]
    when 'all'
      @categories = Category.all + SubCategory.all
      render json: @categories, status: :ok
    when 'category'
      @categories = Category.all
      render json: @categories, status: :ok
    when 'subcategory'
      @categories = SubCategory.all
      render json: @categories, status: :ok
    else
      render json: { error: 'Invalid category type' }, status: :bad_request
    end
  end

  # POST /api/categories
  def create
    # pass
  end
end
