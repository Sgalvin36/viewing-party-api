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
        viewing_party = ViewingParty.find_by(id: params[:id])
        return render json: ErrorSerializer.format_error(ErrorMessage.new("Viewing party not found", 404)), status: :not_found if viewing_party.nil?

        if viewing_party.api_key == request.headers["Authorization"]
            viewing_party.users = params[:users]
            render json: ViewingPartySerializer.new(viewing_party), status: :created
        else
            render json: ErrorSerializer.format_error(ErrorMessage.new("Not the host.", 401)), status: :unauthorized
        end
    end

    private
    def user_params
        params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, :user_id, :api_key, users: [])
    end
end