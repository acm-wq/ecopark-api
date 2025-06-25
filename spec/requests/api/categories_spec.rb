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
  end
end
