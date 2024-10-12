class Api::V1::ViewingPartiesController < ApplicationController
    before_action :authenticate_user

    def create
        viewing_party = ViewingParty.new(user_params)
        if viewing_party.save
            render json: ViewingPartySerializer.new(viewing_party), status: :created
        else
            render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 400)), status: :bad_request
        end
    end

    def update
        # update viewing party, add/subtract viewers
    end

    def destroy
        # destroy viewing party, and associated party guest associations
    end

    private
    def user_params
        params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, :user_id, :api_key, users: [])
    end
    
    def authenticate_user
        key = request.headers["Authorization"]
        @user = User.find_by(api_key: key)

        render json: ErrorSerializer.format_error(ErrorMessage.new("Not logged in.", 405)), status: :method_not_allowed if @user.nil?
    end

    def params_error(exception)
        render json: ErrorSerializer.format_errors(exception), status: :unprocessable_entity
    end
end