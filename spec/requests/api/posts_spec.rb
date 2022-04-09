require 'swagger_helper'

RSpec.describe 'api/v1/posts', type: :request do
  path '/api/v1/posts' do
    # You'll want to customize the parameter types...
    parameter name: 'X-Token', :in => :header, :type => :string

    get('list posts') do
      response(200, 'successful') do
        let(:'X-Token') { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post 'Create a post' do
      tags 'posts'
      consumes 'application/json'
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          text: { type: :string }
        },
        required: ['title','text']
      }

      response '201', 'post created' do
        let(:post) { { title: 'foo', text: 'bar' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:post) { { title: 'foo', text: 'bar' } }
        run_test!
      end
    end
    
  end
end
