require 'rails_helper'

RSpec.describe V1::AuthenticationController, type: :request do 
  before do
    @user = User.create!(email: 'rbispo@rbispo.com.br' , password: '123456' , password_confirmation: '123456')

    @valid_user = {
      email: 'rbispo@rbispo.com.br',
      password: '123456'
    }

    @invalid_user = {
      email: 'invalid@rinvalid.com.br',
      password: 'invalid'
    }
  end 
  describe 'post #authenticate' do
    context 'with valid user and email' do
      it 'must return a string token' do 
        post '/v1/authenticate', params: @valid_user
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["auth_token"]).to be_a(String)
      end

      it 'must return a valid token' do 
        post '/v1/authenticate', params: @valid_user
        decoded_token = JsonWebToken.decode(JSON.parse(response.body)['auth_token'])
        expect(decoded_token['user_id']).to eq(@user.id)
      end
    end

    context 'with invalid user and email' do
      it 'must return a string token' do
        post '/v1/authenticate', params: @invalid_user
        parsed_response = JSON.parse(response.body)['error']
        expect(parsed_response['user_authentication']).to eq('invalid credentials')
      end
    end
  end  
end