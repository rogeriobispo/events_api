require 'rails_helper'

RSpec.describe V1::EventsController, type: :request do
  before do
    genre = Genre.create(name: 'Rock')
    genre2 = Genre.create(name: 'Pop/Rock')

    @artist1 = Artist.create({
                               name: 'The Beatles',
                               member_quantity: 4,
                               genre: genre2,
                               note: 'they wanna drink wine'
                             })

    @artist2 = Artist.create({
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

    user_body2 = {
        name: 'rogerio2',
        email: 'rbispo2@rbispo.com.br',
        time_zone: 'UTC-3',
        password: '123456',
        password_confirmation: '123456'
    }
    user = User.create!(user_body)

    user2 = User.create!(user_body2)

    payload = {
      user_id: user.id,
      exp: 158_629_588_4
    }

    payload2 = {
        user_id: user2.id,
        exp: 158_629_588_4
    }

    @token = JsonWebToken.encode(payload)

    @token2 = JsonWebToken.encode(payload2)

    @event = Event.create({
                   'kind': 'festival',
                   'occurred_on': Date.today + 20.days,
                   'location': 'Morumbi',
                   'time_zone': 'UTC-3',
                   'line_up_date': '2020-07-11',
                   'user_id': user.id,
                   'artist_ids': [@artist1.id, @artist2.id]
                  })

  end

  describe 'post# create' do
    context 'create concert when everything ok' do
      it 'must be successefull' do
        header = { Authorization: "Bearer #{@token}" }
        payload = {
          'kind': 'concert',
          'occurred_on': Date.today + 20.days,
          'location': 'Morumbi',
          'time_zone': 'UTC-3',
          'line_up_date': '2020-07-11',
          'artist_ids': [@artist1.id]
        }

        post '/v1/events.json', params: payload, headers: header
        parsed_response = JSON.parse(response.body)
        genre = parsed_response['genres'].first['name']
        expect(genre).to eq(@artist1.genre.name)
        expect(response.status).to eq(200)
      end

      it 'must be successefull when artists is duplicated' do
        header = { Authorization: "Bearer #{@token}" }
        payload = {
          'kind': 'concert',
          'occurred_on': Date.today + 20.days,
          'location': 'Estadio pacaembu',
          'time_zone': 'UTC-3',
          'line_up_date': '2020-07-11',
          'artist_ids': [@artist2.id.to_i, @artist2.id.to_i]
        }

        post '/v1/events.json', params: payload, headers: header
        parsed_response = JSON.parse(response.body)
        genre = parsed_response['genres'].first['name']
        location = parsed_response['location']
        artists = parsed_response['artists']
        concert = parsed_response['kind']
        expect(genre).to eq(@artist2.genre.name)
        expect(location).to eq('Estadio pacaembu')
        expect(artists.count).to eq(1)
        expect(concert).to eq('concert')
        expect(response.status).to eq(200)
      end

      context 'when thereis erro on payload' do
        it 'must return that the concerte musta have one artist only' do
          header = { Authorization: "Bearer #{@token}" }
          payload = {
            'kind': 'concert',
            'occurred_on': Date.today + 20.days,
            'location': 'Estadio pacaembu',
            'line_up_date': '2020-07-11',
            'artist_ids': [@artist1.id.to_i, @artist2.id.to_i]
          }

          post '/v1/events.json', params: payload, headers: header
          parsed_response = JSON.parse(response.body)
          message = parsed_response['errors'].first['artists'].first
          expect(message).to eq('Artists must be single to concert')
          expect(response.status).to eq(422)
        end

        it 'artists must exist to create the event' do
          header = { Authorization: "Bearer #{@token}" }
          payload = {
            'kind': 'concert',
            'occurred_on': Date.today + 20.days,
            'location': 'Estadio pacaembu',
            'line_up_date': '2020-07-11',
            'artist_ids': [100_00]
          }

          post '/v1/events.json', params: payload, headers: header
          parsed_response = JSON.parse(response.body)
          message = parsed_response['errors'].first['artists'].first
          expect(message).to eq('Artists must exists')
          expect(response.status).to eq(422)
        end

        it 'when is missing fields' do
          header = { Authorization: "Bearer #{@token}" }
          payload = {
            'kind': 'concert',
            'artist_ids': [@artist1.id.to_i]
          }

          post '/v1/events.json', params: payload, headers: header
          parsed_response = JSON.parse(response.body)
          line_up_date = parsed_response['errors'].first['line_up_date']
          expect(line_up_date).to include('can\'t be blank')
          expect(response.status).to eq(422)
        end
      end
    end

    describe 'create  festival when everything ok' do
      context 'must create a festival' do
        it 'must be successefull' do
          header = { Authorization: "Bearer #{@token}" }
          payload = {
            'kind': 'festival',
            'occurred_on': Date.today + 20.days,
            'location': 'Morumbi',
            'time_zone': 'UTC-3',
            'line_up_date': '2020-07-11',
            'artist_ids': [@artist1.id, @artist2.id]
          }

          post '/v1/events.json', params: payload, headers: header
          parsed_response = JSON.parse(response.body)
          genre = parsed_response['genres'].last['name']
          location = parsed_response['location']
          artists = parsed_response['artists']
          concert = parsed_response['kind']
          expect(genre).to eq(@artist2.genre.name)
          expect(location).to eq('Morumbi')
          expect(artists.count).to eq(2)
          expect(concert).to eq('festival')
          expect(response.status).to eq(200)
        end
      end
    end

    describe 'when the payload is wrong' do
      context 'must fail on create event ' do
        it 'artists must exist to create the event' do
          header = { Authorization: "Bearer #{@token}" }
          payload = {
            'kind': 'festival',
            'occurred_on': Date.today + 20.days,
            'location': 'Estadio pacaembu',
            'line_up_date': '2020-07-11',
            'artist_ids': [100_00]
          }

          post '/v1/events.json', params: payload, headers: header
          parsed_response = JSON.parse(response.body)
          message = parsed_response['errors'].first['artists'].first
          expect(message).to eq('All Artists must exists')
          expect(response.status).to eq(422)
        end

        it 'when is missing fields' do
          header = { Authorization: "Bearer #{@token}" }
          payload = {
            'kind': 'festival',
            'artist_ids': [@artist1.id.to_i]
          }

          post '/v1/events.json', params: payload, headers: header
          parsed_response = JSON.parse(response.body)
          line_up_date = parsed_response['errors'].first['line_up_date']
          expect(line_up_date).to include('can\'t be blank')
          expect(response.status).to eq(422)
        end
        it 'when the kind is not implemented' do
          header = { Authorization: "Bearer #{@token}" }
          payload = {
            'kind': 'any',
            'artist_ids': [@artist1.id.to_i]
          }

          post '/v1/events.json', params: payload, headers: header
          parsed_response = JSON.parse(response.body)
          line_up_date = parsed_response['errors'].first['event'].first
          expect(line_up_date).to include('Kind not implemented')
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'delete# destroy' do
    context 'when there is event to destroy' do
      it 'must return 204' do
        header = { Authorization: "Bearer #{@token}" }
        delete "/v1/events/#{@event.id}", headers: header
        expect(response.status).to eq(204)
      end
    end

    context 'when there is no  event to destroy' do
      it 'must return 404' do
        header = { Authorization: "Bearer #{@token}" }
        delete '/v1/events/10000', headers: header
        expect(response.status).to eq(404)
      end
    end

    context 'when the event does not belong to current user' do
      it 'must return 404' do
        header = { Authorization: "Bearer #{@token2}" }
        delete "/v1/events/#{@event.id}", headers: header
        parsed_response = JSON.parse(response.body)
        line_up_date = parsed_response['errors'].first
        expect(line_up_date).to include('Event does not belongs to current user')
        expect(response.status).to eq(422)
      end
    end

  end
end
