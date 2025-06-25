class CategoriesController < ApplicationController
  include Pagy::Backend

  skip_before_action :authorized, only: [:index]

  # GET /api/categories
  def index
    case params.require(:category).permit(:type)[:type]
    when 'all'
      pagy_cat, categories = pagy(Category.all, page_param: :categories_page)
      pagy_subcat, subcategories = pagy(SubCategory.all, page_param: :subcategories_page)
      render json: {
        categories: ActiveModelSerializers::SerializableResource.new(
          categories,
          each_serializer: CategorySerializer
        ),
        categories_pagy: pagy_metadata(pagy_cat),
        subcategories: ActiveModelSerializers::SerializableResource.new(
          subcategories,
          each_serializer: SubCategorySerializer
        ),
        subcategories_pagy: pagy_metadata(pagy_subcat)
      }, status: :ok
    when 'category'
      render json: pagy(Category.all).then { |pagy_obj, categories|
        {
          categories: ActiveModelSerializers::SerializableResource.new(
            categories,
            each_serializer: CategorySerializer
          ),
          pagy: pagy_metadata(pagy_obj)
        }
      }, status: :ok
    when 'subcategory'
      render json: pagy(SubCategory.all).then { |pagy_obj, subcategories|
        {
          subcategories: ActiveModelSerializers::SerializableResource.new(
            subcategories, 
            each_serializer: 
            SubCategorySerializer
          ),
          pagy: pagy_metadata(pagy_obj)
        }
      }, status: :ok
    else
      render json: { error: 'Invalid category type' }, status: :bad_request
    end
  end

  # POST /api/categories
  def create
    case params.require(:category).permit(:type)[:type]
    when 'category'
      category = Category.new(category_params('category'))
      if category.save
        render json: category, serializer: CategorySerializer, status: :created
      else
        render json: category.errors, status: :unprocessable_entity
      end
    when 'subcategory'
      subcategory = SubCategory.new(category_params('subcategory'))
      if subcategory.save
        render json: subcategory, serializer: SubCategorySerializer, status: :created
      else
        render json: subcategory.errors, status: :unprocessable_entity
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
