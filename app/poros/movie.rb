class Movie
    attr_reader :id, 
                :title, 
                :release_year, 
                :vote_average, 
                :runtime, 
                :genres, 
                :summary, 
                :cast, 
                :total_reviews, 
                :reviews

    def initialize(movie_data)
        @id = movie_data["id"]
        @title = movie_data["title"],
        @release_year = movie_data["release_date"].split("-")[0],
        @vote_average = movie_data["vote_average"],
        @runtime = time_convert(movie_data["runtime"].to_i),
        @genres = clean_genres(movie_data["genres"]),
        @summary = movie_data["overview"],
        @cast = sift_cast(movie_data),
        @total_reviews = movie_data["reviews"]["total_results"],
        @reviews = sift_reviews(movie_data)
    end

    def time_convert(minutes)

        hours = minutes / 60
        rest = minutes % 60
        "#{hours} hours, #{rest} minutes"
    end
    
    def clean_genres(genres)
        results = genres.map do |genre|
            genre["name"]
        end
    end
    
    def sift_cast(data)
        results = data["credits"]["cast"].first(10).map do |each|
            {
                "character": each["character"],
                "actor": each["name"]
            }
        end
    end
end