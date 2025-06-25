class CategoriesController < ApplicationController
  include Pagy::Backend

  skip_before_action :authorized, only: [:index]

  VALID_TYPES = %w[category subcategory].freeze

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
      return_type_error
    end
  end

  # POST /api/categories
  def create
    type = params.require(:category).permit(:type)[:type]

    return return_type_error unless category_is_valid?

    resource = (type == 'category' ? Category : SubCategory).new(category_params(type))

    if resource.save
      render json: resource, serializer: "#{type.camelize}Serializer".constantize, status: :created
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/categories/:id
  def update
    type = params.require(:category).permit(:type)[:type]

    return return_type_error unless category_is_valid?

    resource = (type == 'category' ? Category : SubCategory).find(params[:id])

    if resource.update(category_params(type))
      render json: resource, serializer: "#{type.camelize}Serializer".constantize, status: :ok
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/categories/:id
  def destroy
    type = params.require(:category).permit(:type)[:type]

    return return_type_error unless category_is_valid?

    resource = (type == 'category' ? Category : SubCategory).find(params[:id])

    if resource.destroy
      render json: { message: "#{type.capitalize} deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete #{type}" }, status: :unprocessable_entity
    end
  end

  private

    def category_params(type)
      permitted = [ :name ]
      permitted << :category_id if type == 'subcategory'
      params.require(:category).permit(permitted)
    end

    def category_is_valid?
      VALID_TYPES.include?(params.require(:category).permit(:type)[:type])
    end

    def return_type_error
      render json: { error: 'Invalid category type' }, status: :bad_request
    end
end
