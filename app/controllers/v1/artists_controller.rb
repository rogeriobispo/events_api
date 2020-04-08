class V1::ArtistsController < ApplicationController
  before_action :set_artist, only: [:destroy, :show, :update]

  def create
    artist = Artist.new(artist_params)
    if artist.save
      render json: artist
    else
      render json: artist.errors, status: :unprocessable_entity
    end
  end

  def update
    @artist.update(artist_params)
    render json: @artist.reload
  end

  def index
    render json: Artist.all
  end

  def show
    render json: @artist if @artist
  end

  def destroy
    @artist.destroy
  end

  private

  def artist_params
    params.permit(:name, :member_quantity, :genre_id, :note)
  end

  def set_artist
    @artist = Artist.find(params[:id])
  end
end
