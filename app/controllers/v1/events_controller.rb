class V1::EventsController < ApplicationController
  before_action :set_event, only: :destroy
  def create
    event = CreateEvent.new(params_with_user['kind'])
    if (@evt = event.save(params_with_user))
      @evt
    else
      render json: { errors: event.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @event.user.id == current_user.id
        @event.destroy
    else
      msg =['Event does not belongs to current user']
      render json: {errors: msg }, status: :unprocessable_entity
    end
  end

  private

  def events_params
    params.permit(:kind, :time_zone, :occurred_on,
                  :location, :line_up_date, artist_ids: [])
  end

  def params_with_user
    param = events_params
    param[:user_id] = @current_user.id
    param
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
