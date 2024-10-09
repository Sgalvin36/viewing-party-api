class Api::V1::MoviesController < ApplicationController
    # before_action: set_connection
    
    def index
        if params["query"] != nil
            response = MovieDbService.fetch_data("search/movie", params)
        else
            params["sort_by"] = "popularity.desc"
            response = MovieDbService.fetch_data("discover/movie", params)
        end

        render json: MovieSerializer.format_movie_response(response.body) if response.status == 200
    end

    # def show
    #     conn = Faraday.new(url: "https://api.themoviedb.org/3/")
    #     response = conn.get("discover/movie") do |req|
    #         req.params["id"] = 
    #         req.params["api_key"] = Rails.application.credentials.the_movie_db[:key]
    #     end
    # end
end