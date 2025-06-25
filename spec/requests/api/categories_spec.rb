require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  path '/api/categories' do
    get 'Returns categories and/or subcategories' do
      tags 'Categories'
      produces 'application/json'

      parameter name: 'category[type]', in: :query, schema: {
        type: :string,
        enum: ['all', 'category', 'subcategory']
      }
      parameter name: :page, in: :query, schema: {
        type: :integer,
        minimum: 1
      }

      response '200', 'categories or subcategories returned' do
        let('category[type]') { 'category' }
        let(:page) { 1 }

        before do
          create_list(:category, 2)
          create_list(:sub_category, 3)
        end

        run_test!
      end

      response '400', 'invalid type' do
        let('category[type]') { 'invalid' }
        let(:page) { 1 }

        run_test!
      end
    end

    post 'Creates a category or subcategory' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'
      
      security [ bearerAuth: [] ]

      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token', required: true
      parameter name: :category, in: :body, schema: {
        type: :object,
        required: ['type', 'name'],
        properties: {
          type: { type: :string, enum: ['category', 'subcategory'] },
          name: { type: :string },
          category_id: { type: :integer, nullable: true }
        }
      }


      response '201', 'category created' do
        let(:category) { { type: 'category', name: 'New Category' } }
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, 'hellomars1211', 'HS256')}" }

        before do
          post '/api/categories', params: { category: category }, headers: { 'Authorization' => Authorization }
        end

        it 'returns status 201' do
          expect(response).to have_http_status(:created)
        end
      end

      response '422', 'unprocessable entity' do
        let(:Authorization) { "Bearer #{generate_token_for_user}" }
        let(:category) { { type: 'category', name: '' } } # пустое имя

        run_test!
      end

      response '400', 'invalid type' do
        let(:Authorization) { "Bearer #{generate_token_for_user}" }
        let(:category) { { type: 'invalid', name: 'Name' } }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:category) { { type: 'category', name: 'New Category' } }

        run_test!
      end
    end

    put '/api/categories/{id}' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'

      security [ bearerAuth: [] ]

      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token', required: true
      parameter name: :id, in: :path, type: :integer, description: 'Category or Subcategory ID', required: true
      parameter name: :category, in: :body, schema: {
        type: :object,
        required: ['type', 'name'],
        properties: {
          type: { type: :string, enum: ['category', 'subcategory'] },
          name: { type: :string },
          category_id: { type: :integer, nullable: true }
        }
      }

      response '200', 'category updated' do
        let(:Authorization) { "Bearer #{generate_token_for_user}" }
        let(:id) { create(:category).id }
        let(:category) { { type: 'category', name: 'Updated Name' } }

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:Authorization) { "Bearer #{generate_token_for_user}" }
        let(:id) { create(:category).id }
        let(:category) { { type: 'category', name: '' } }

        run_test!
      end

      response '400', 'invalid type' do
        let(:Authorization) { "Bearer #{generate_token_for_user}" }
        let(:id) { create(:category).id }
        let(:category) { { type: 'invalid', name: 'Name' } }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { create(:category).id }
        let(:category) { { type: 'category', name: 'Updated Name' } }

        run_test!
      end

      response '404', 'not found' do
        let(:Authorization) { "Bearer #{generate_token_for_user}" }
        let(:id) { 0 }
        let(:category) { { type: 'category', name: 'Updated Name' } }

        run_test!
      end
    end

    delete '/api/categories/{id}' do
      tags 'Categories'
      produces 'application/json'

      security [ bearerAuth: [] ]

      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token', required: true
      parameter name: :id, in: :path, type: :integer, description: 'Category or Subcategory ID', required: true

      response '200', 'category deleted' do
        let(:Authorization) { "Bearer #{generate_token_for_user}" }
        let(:id) { create(:category).id }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { create(:category).id }

        run_test!
      end

      response '404', 'not found' do
        let(:Authorization) { "Bearer #{generate_token_for_user}" }
        let(:id) { 0 }

        run_test!
      end
    end
  end

  def generate_token_for_user
    user = create(:user)
    JWT.encode({ user_id: user.id }, 'hellomars1211', 'HS256')
  end
end
