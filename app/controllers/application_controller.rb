class ApplicationController < ActionController::API

    def authenticate_user
        key = request.headers["Authorization"]
        @user = User.find_by(api_key: key)

        render json: ErrorSerializer.format_error(ErrorMessage.new("Not logged in.", 405)), status: :method_not_allowed if @user.nil?
    end
end
