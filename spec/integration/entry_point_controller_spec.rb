require 'rails_helper'

RSpec.describe V1::EntryPointController, type: :request do
  before do
    user_body = {
      name: 'rogerio',
      email: 'rbispo@rbispo.com.br',
      time_zone: 'UTC-3',
      password: '123456',
      password_confirmation: '123456'
    }

    @user = User.create!(user_body)
    @payload = {
      user_id: @user.id,
      exp: 158_629_588_4
    }

    @token = JsonWebToken.encode(@payload)
  end

  describe 'get #index' do
    context 'when there is no tokem' do
      it 'must return invalid tokem' do
        get '/v1/entry_point'
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors'].first).to eq('Not Authorized')
        expect(response.status).to eq(401)
      end
    end

    context 'when the tokem is valid' do
      it 'must be successfull' do
        get '/v1/entry_point', headers: { Authorization: "Bearer #{@token}" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('I\'m Alive')
        expect(response.status).to eq(200)
      end
    end

    context 'when the toke is invalid' do
      it 'must return 401 not authorized' do
        headers = { Authorization: 'Bearer xhabhdklak.bhlahdlkhb' }
        get '/v1/entry_point', headers: headers
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors'].first).to eq('Not Authorized')
        expect(response.status).to eq(401)
      end
    end
  end
end
