require 'rails_helper'

RSpec.describe V1::GenresController, type: :request do
  before do
    user_body = {
      name: 'rbispo',
      email: 'rbispo@rbispo.com.br',
      password: '123456',
      password_confirmation: '123456'
    }
    user = User.create!(user_body)

    payload = {
      user_id: user.id,
      exp: 158_629_588_4
    }
    @token = JsonWebToken.encode(payload)
  end

  describe 'get #index' do
    context 'when there is genres ' do
      it 'must return a list of genres' do
        Genre.create(name: 'Country')
        Genre.create(name: 'Rock')
        get '/v1/genres', headers: { Authorization: "Bearer #{@token}" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(2)
        expect(response.status).to eq(200)
      end
    end

    context 'when there is no genre' do
      it 'must return an emptuy list' do
        get '/v1/genres', headers: { Authorization: "Bearer #{@token}" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(0)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'get#show' do
    context 'when there is genre to show' do
      it 'must return the genre id and name' do
        genre = Genre.create(name: 'Rock')
        header = { Authorization: "Bearer #{@token}" }
        get "/v1/genres/#{genre.id}", headers: header
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(genre.id)
        expect(parsed_response['name']).to eq(genre.name)
        expect(response.status).to eq(200)
      end
    end

    context 'when theres no genre to show' do
      it 'must return status 404' do
        header = { Authorization: "Bearer #{@token}" }
        get '/v1/genres/100000', headers: header
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'post# create' do
    context 'when the payload is valid' do
      it 'must create an genre' do
        payload = {
          name: 'Rock'
        }
        header = { Authorization: "Bearer #{@token}" }
        post '/v1/genres', params: payload, headers: header
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq('Rock')
      end
    end

    context 'when the payload is invalid' do
      it 'must return 422' do
        payload = {
          song_style: 'Rock'
        }
        header = { Authorization: "Bearer #{@token}" }
        post '/v1/genres', params: payload, headers: header
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name'].first).to eq('can\'t be blank')
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'delete: destroy' do
    context 'when there is genre to destroy' do
      it 'must return 204' do
        header = { Authorization: "Bearer #{@token}" }
        genre = Genre.create(name: 'Rock')
        delete "/v1/genres/#{genre.id}", headers: header
        expect(response.status).to eq(204)
      end
    end

    context 'when there is no genre to destroy' do
      it 'must return 204' do
        header = { Authorization: "Bearer #{@token}" }
        delete '/v1/genres/10000', headers: header
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'put# update' do
    context 'when the genre exists' do
      it 'must update the genre' do
        genre = Genre.create(name: 'Rock')
        header = { Authorization: "Bearer #{@token}" }
        payload = {
          name: 'Samba'
        }
        put "/v1/genres/#{genre.id}", params: payload, headers: header
        genre.reload
        expect(genre.name).to eq('Samba')
        expect(response.status).to eq(200)
      end
    end

    context 'when the genre does not exists' do
      it 'must return not found' do
        header = { Authorization: "Bearer #{@token}" }
        payload = {
          name: 'Samba'
        }
        patch '/v1/genres/100000', params: payload, headers: header
        expect(response.status).to eq(404)
      end
    end
  end
end
