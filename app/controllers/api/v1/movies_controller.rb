class Api::V1::MoviesController < ApplicationController
    
    def index
        if params["query"] != nil
            response = MovieDbService.fetch_data("search/movie", params)
        else
            response = MovieDbService.fetch_data("movie/top_rated", params)
        end

        render json: MovieSerializer.format_movie_response(response.body) if response.status == 200
    end

    def show
        return render json: ErrorSerializer.format_error(ErrorMessage.new("Movie id not found", 404)), status: :not_found if params["id"].nil?

        if params[:similar]
            response = MovieDbService.fetch_data("movie/#{params["id"]}/similar")
            render json: MovieSerializer.format_movie_response(response.body) if response.status == 200
        else    
            response = MovieDbService.fetch_data("movie/#{params["id"]}?append_to_response=reviews,credits")
            movie = Movie.new(JSON.parse(response.body))
            render json: MovieSerializer.format_movie(movie) if response.status == 200
        end
    end
end