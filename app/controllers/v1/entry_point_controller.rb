class V1::EntryPointController < ApplicationController
  def index
    render json: { message: "I'm Alive" }
  end
end
