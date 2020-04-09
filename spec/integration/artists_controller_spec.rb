require 'rails_helper'

RSpec.describe V1::ArtistsController, type: :request do
  before do
    genre = Genre.create(name: 'Rock')

    Artist.create({
                    name: 'The Beatles',
                    member_quantity: 4,
                    genre: genre,
                    note: 'they wanna drink wine'
                  })

    @artist = Artist.create({
                              name: 'AC/DC',
                              member_quantity: 5,
                              genre: genre,
                              note: 'they wanna caipirinha'
                            })

    user_body = {
      name: 'rogerio',
      email: 'rbispo@rbispo.com.br',
      time_zone: 'UTC-3',
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
    context 'when there is artist ' do
      it 'must return a list of artists' do
        get '/v1/artists', headers: { Authorization: "Bearer #{@token}" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(2)
        expect(response.status).to eq(200)
      end
    end

    context 'when there is no artists' do
      it 'must return an emptuy list' do
        Artist.destroy_all
        get '/v1/artists', headers: { Authorization: "Bearer #{@token}" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(0)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'get#show' do
    context 'when there is artist to show' do
      it 'must return the artist' do
        header = { Authorization: "Bearer #{@token}" }
        get "/v1/artists/#{@artist.id}", headers: header
        parsed_response = JSON.parse(response.body)
        artist_id = parsed_response['id']
        name = parsed_response['name']
        member_quantity = parsed_response['member_quantity']
        expect(artist_id).to eq(@artist.id)
        expect(name).to eq(@artist.name)
        expect(member_quantity).to eq(@artist.member_quantity)
        expect(response.status).to eq(200)
      end
    end

    context 'when theres no genre to show' do
      it 'must return status 404' do
        header = { Authorization: "Bearer #{@token}" }
        get '/v1/artists/100000', headers: header
        expect(response.status).to eq(404)
      end
    end
  end
  # remover
  describe 'put# update' do
    context 'when the artists exists' do
      it 'must update the artists' do
        genre = Genre.create(name: 'Pop')
        header = { Authorization: "Bearer #{@token}" }

        payload = {
          name: 'The doors',
          member_quantity: 4,
          genre: genre,
          note: 'they wanna drink wine'
        }

        put "/v1/artists/#{@artist.id}", params: payload, headers: header
        @artist.reload
        expect(@artist.name).to eq('The doors')
        expect(@artist.member_quantity).to eq(4)
        expect(@artist.genre.name).to eq('Rock')
        expect(@artist.note).to eq('they wanna drink wine')
        expect(response.status).to eq(200)
      end
    end

    context 'when the artists does not exists' do
      it 'must return not found' do
        header = { Authorization: "Bearer #{@token}" }
        payload = {
          name: 'Sepultura'
        }
        patch '/v1/artists/100000', params: payload, headers: header
        expect(response.status).to eq(404)
      end
    end

    context 'when the artist is already on database' do
      it 'must return unprocessable_entity' do
        genre = Genre.create(name: 'Pop')
        header = { Authorization: "Bearer #{@token}" }

        payload = {
          name: 'The Beatles',
          member_quantity: 4,
          genre: genre,
          note: 'they wanna drink wine'
        }

        put "/v1/artists/#{@artist.id}", params: payload, headers: header
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors'].first).to eq('Record Alread exists')
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'delete: destroy' do
    context 'when there is artists to destroy' do
      it 'must return 204' do
        header = { Authorization: "Bearer #{@token}" }
        delete "/v1/artists/#{@artist.id}", headers: header
        expect(response.status).to eq(204)
      end
    end

    context 'when there is no artists to destroy' do
      it 'must return 204' do
        header = { Authorization: "Bearer #{@token}" }
        delete '/v1/artists/10000', headers: header
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'post# create' do
    context 'when the payload is valid' do
      it 'must create an artist' do
        genre = Genre.create(name: 'Pop/Rock')
        payload = {
          name: 'Pink Floyd',
          member_quantity: 2,
          genre_id: genre.id.to_i,
          note: 'they wanna party hard'
        }
        header = { Authorization: "Bearer #{@token}" }
        post '/v1/artists', params: payload, headers: header
        parsed_response = JSON.parse(response.body)

        expect(parsed_response['name']).to eq('Pink Floyd')
        expect(parsed_response['member_quantity']).to eq(2)
        expect(response.status).to eq(200)
      end
    end

    context 'when the payload is invalid' do
      it 'must return 422' do
        payload = {
          invalid_name: 'Pink Floyd',
          invalid_member_quantity: 2,
          invalid_genre_id: 5,
          invalid_note: 'they wanna party hard'
        }
        header = { Authorization: "Bearer #{@token}" }
        post '/v1/artists', params: payload, headers: header
        parsed_response = JSON.parse(response.body)
        name = parsed_response['name'].first
        member_quantity = parsed_response['member_quantity'].first
        genre_id = parsed_response['genre_id'].first
        note = parsed_response['note'].first
        expect(name).to eq('can\'t be blank')
        expect(member_quantity).to eq('can\'t be blank')
        expect(genre_id).to eq('can\'t be blank')
        expect(note).to eq('can\'t be blank')
        expect(response.status).to eq(422)
      end
    end
  end
end
