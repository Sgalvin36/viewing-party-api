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

    def show
        if params["id"] != nil
            response = MovieDbService.fetch_data("movie/#{params["id"]}?append_to_response=reviews,credits")
        end
        render json: MovieSerializer.format_movie(response.body) if response.status == 200
    end
end