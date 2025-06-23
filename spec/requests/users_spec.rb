require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    get 'List all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'users found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   email: { type: :string, format: :email },
                   password_digest: { type: :string },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 },
                 required: ['id', 'email', 'password_digest', 'created_at', 'updated_at']
               }

        before do
                create_list(:user, 3)
              end

        run_test!
      end

      response '404', 'users not found' do
        run_test!
      end
    end
  end
end
