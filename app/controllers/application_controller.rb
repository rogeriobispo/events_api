class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :uniq_record
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    unless @current_user
      render json: { errors: ['Not Authorized'] }, status: :unauthorized
    end
  end

  def record_not_found(error)
    render json: { errors: [error] }, status: 404
  end

  def uniq_record
    msg = ['Record Alread exists']
    render json: { errors: msg }, status: :unprocessable_entity
  end
end
