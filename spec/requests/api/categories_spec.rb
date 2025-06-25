require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  path '/api/categories' do
    get 'Returns categories and/or subcategories' do
      tags 'Categories'
      produces 'application/json'
      parameter name: :category, in: :query, schema: {
        type: :object,
        properties: {
          type: { type: :string, enum: ['all', 'category', 'subcategory'] }
        },
        required: ['type']
      }

      response '200', 'categories or subcategories returned' do
        let(:category) { { type: 'all' } }

        before do
          create_list(:category, 2)
          create_list(:sub_category, 3)
        end

        run_test!
      end

      response '400', 'invalid type' do
        let(:category) { { type: 'invalid' } }

        run_test!
      end
    end
  end
end
