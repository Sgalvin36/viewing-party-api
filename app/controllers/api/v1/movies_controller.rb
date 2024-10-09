class Api::V1::MoviesController < ApplicationController
    # before_action: set_connection
    
    def index
        conn = Faraday.new(url: "https://api.themoviedb.org/3/")
        if params["query"] != nil
            response = conn.get("search/movie") do |req|
                req.params["query"] = "#{params["query"]}"
                req["Authorization"] = "Bearer #{Rails.application.credentials.the_movie_db[:token]}"
            end
        else    
            response = conn.get("discover/movie") do |req|
                req.params["sort_by"] = "popularity.desc"
                req.params["api_key"] = Rails.application.credentials.the_movie_db[:key]
            end
        end

        render json: MovieSerializer.format_movie_response(response.body) if response.status == 200
    end

end