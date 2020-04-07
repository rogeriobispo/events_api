module V1
  class GenresController < ApplicationController
    before_action :set_genre, only: [:destroy, :show, :update]

    def create
      genre = Genre.new(genre_params)
      if genre.save
        render json: genre
      else
        render json: genre.errors, status: :unprocessable_entity
      end
    end

    def update
      @genre.update(genre_params)
      render json: @genre.reload
    end

    def index
      render json: Genre.all
    end

    def show
      render json: @genre if @genre
    end

    def destroy
      @genre.destroy
    end

    private

    def genre_params
      params.permit(:name)
    end

    def set_genre
      @genre = Genre.find(params[:id])
    end
  end
end
