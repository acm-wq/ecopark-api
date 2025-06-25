class CategoriesController < ApplicationController
  include Pagy::Backend
  skip_before_action :authorized, only: [ :index ]

  VALID_TYPES = %w[category subcategory].freeze
  RESOURCE_CLASSES = { 'category' => Category, 'subcategory' => SubCategory }.freeze
  SERIALIZERS = { 'category' => CategorySerializer, 'subcategory' => SubCategorySerializer }.freeze

  before_action :set_type, only: [ :index, :create, :update, :destroy ]
  before_action :validate_type, only: [ :create, :update, :destroy ]
  before_action :set_resource, only: [ :update, :destroy ]

  def index
    case @type
    when 'all'
      pagy_cat, categories = pagy(Category.all, page_param: :categories_page)
      pagy_subcat, subcategories = pagy(SubCategory.all, page_param: :subcategories_page)
      render json: {
        categories: serialize(categories, CategorySerializer),
        categories_pagy: pagy_metadata(pagy_cat),
        subcategories: serialize(subcategories, SubCategorySerializer),
        subcategories_pagy: pagy_metadata(pagy_subcat)
      }, status: :ok
    when *VALID_TYPES
      pagy_obj, records = pagy(RESOURCE_CLASSES[@type].all)
      render json: {
        "#{@type}s".to_sym => serialize(records, SERIALIZERS[@type]),
        pagy: pagy_metadata(pagy_obj)
      }, status: :ok
    else
      render_type_error
    end
  end
  
  def create
    resource = RESOURCE_CLASSES[@type].new(category_params)
    if resource.save
      render json: resource, serializer: SERIALIZERS[@type], status: :created
    else
      render json: { error: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @resource.update(category_params)
      render json: @resource, serializer: SERIALIZERS[@type], status: :ok
    else
      render json: { error: @resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @resource.destroy
      render json: { message: "#{@type.capitalize} deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete #{@type}" }, status: :unprocessable_entity
    end
  end

  private

    def set_type
      @type = params.require(:category).permit(:type)[:type]
    end

    def validate_type
      render_type_error unless VALID_TYPES.include?(@type)
    end

    def set_resource
      @resource = RESOURCE_CLASSES[@type].find(params[:id])
    end

    def category_params
      permitted = [ :name ]
      permitted << :category_id if @type == 'subcategory'
      params.require(:category).permit(permitted)
    end

    def serialize(records, type)
      ActiveModelSerializers::SerializableResource.new(records, each_serializer: type)
    end

    def render_type_error
      render json: { error: 'Invalid category type' }, status: :bad_request
    end
end
