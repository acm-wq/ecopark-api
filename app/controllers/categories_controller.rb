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
    case params.require(:category).permit(:type)[:type]
    when 'category'
      @category = Category.new(category_params('category'))
      if @category.save
        render json: @category, status: :created
      else
        render json: @category.errors, status: :unprocessable_entity
      end
    when 'subcategory'
      @subcategory = SubCategory.new(category_params('subcategory'))
      if @subcategory.save
        render json: @subcategory, status: :created
      else
        render json: @subcategory.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid category type' }, status: :bad_request
    end
  end

  private

    def category_params(type)
      base_params = params.require(:category).permit(:name)
      if type == 'subcategory'
        base_params.merge(params.require(:category).permit(:category_id))
      else
        base_params
      end
    end
end
