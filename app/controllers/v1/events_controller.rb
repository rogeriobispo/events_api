class V1::EventsController < ApplicationController
  def create
    event = CreateEvent.new(params_with_user['kind'])
    if (@evt = event.save(params_with_user))
      @evt
    else
      render json: { errors: event.errors }, status: :unprocessable_entity
    end
  end

  private

  def events_params
    params.permit(:kind, :time_zone, :occurred_on, :location, :line_up_date, artist_ids: [])
  end

  def params_with_user
    param = events_params
    param[:user_id] = @current_user.id
    param
  end
end
