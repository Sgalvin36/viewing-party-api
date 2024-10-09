class Api::V1::MoviesController < ApplicationController
    # before_action: set_connection
    
    def index
        conn = Faraday.new(url: "https://api.themoviedb.org/3/")

        response = conn.get("discover/movie") do |req|
            req.params["sort_by"] = "popularity.desc"
            req.params["api_key"] = Rails.application.credentials.the_movie_db[:key]
        end
        
        render json: MovieSerializer.new(response) if response.status == 200
    end

end