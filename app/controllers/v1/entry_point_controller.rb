module V1
  class EntryPointController < ApplicationController
    def index
      render json: { message: "I'm Alive" }
    end
  end
end