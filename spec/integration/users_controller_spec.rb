require 'rails_helper'

RSpec.describe V1::GenresController, type: :request do
  before do
    @user_body = {
      email: 'rbispo@rbispo.com.br',
      password: '123456',
      password_confirmation: '123456'
    }
    @user = User.create(@user_body)
    payload = {
      user_id: @user.id,
      exp: 158_629_588_4
    }
    @token = JsonWebToken.encode(payload)
  end

  describe 'post# create' do
    context 'when the payload is right' do
      it 'must return 204' do
        user_body = {
            email: 'sample@sample.com.br',
            password: '123456',
            password_confirmation: '123456'
        }

        header = { Authorization: "Bearer #{@token}" }
        post '/v1/users', params: user_body, headers: header
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['email']).to eq('sample@sample.com.br')
        expect(response.status).to eq(200)
      end
    end

    context 'when the payload is not right' do
      it 'must return 422' do
        user_body = {
            mail: 'sample@sample.com.br',
            pwd: '123456',
            pwd_conf: '123456'
        }

        header = { Authorization: "Bearer #{@token}" }
        post '/v1/users', params: user_body, headers: header
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['email'].first).to eq('can\'t be blank')
        expect(parsed_response['password'].first).to eq('can\'t be blank')
        expect(parsed_response['password_confirmation'].first).to eq('can\'t be blank')
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'put# update' do
    context 'when the user exists' do
      it 'must update user' do
        header = { Authorization: "Bearer #{@token}" }
        payload = {
            email: 'sample@sample.com.br',
            password: '123456',
            password_confirmation: '123456'
        }
        put "/v1/users/#{@user.id}", params: payload, headers: header
        @user.reload
        expect(@user.email).to eq('sample@sample.com.br')
        expect(response.status).to eq(200)
      end
    end

    context 'whe the user does not exists' do
      it 'must return not found' do
        header = { Authorization: "Bearer #{@token}" }
        payload = {
            email: 'sample@sample.com.br',
            password: '123456',
            password_confirmation: '123456'
        }
        put '/v1/users/1000', params: payload, headers: header
        expect(response.status).to eq(404)
      end
    end

  end
  describe 'get# index' do
    context 'when there is user to return' do
      it 'must return a list of users' do
        get '/v1/users', headers: { Authorization: "Bearer #{@token}" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(1)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'get# show' do
    context 'when the user exists' do
      it 'must return a user' do
        get "/v1/users/#{@user.id}", headers: { Authorization: "Bearer #{@token}" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(@user.id)
        expect(parsed_response['email']).to eq(@user.email)
        expect(response.status).to eq(200)
      end
    end

    context 'when the user does not exist' do
      it 'must return not found status code' do
        get '/v1/users/10000', headers: { Authorization: "Bearer #{@token}" }
        expect(response.status).to eq(404)
      end
    end
  end


  describe 'delete: destroy' do
    context 'when there is user to destroy' do
      it 'must return 204' do
        header = { Authorization: "Bearer #{@token}" }
        delete "/v1/users/#{@user.id}", headers: header
        expect(response.status).to eq(204)
      end
    end

    context 'when there is no  user to destroy' do
      it 'must return 204' do
        header = { Authorization: "Bearer #{@token}" }
        delete '/v1/users/10000', headers: header
        expect(response.status).to eq(404)
      end
    end
  end
end
