class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, only: :show

  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def index
    render json: UserSerializer.format_user_list(User.all)
  end

  def show
    user = User.find(params[:id])
    if user.api_key == request.headers["Authorization"]
      render json: UserSerializer.format_detailed_user(user)
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new("Not the user.", 401)), status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :username, :password, :password_confirmation)
  end
end