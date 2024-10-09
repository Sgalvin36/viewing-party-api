class MovieSerializer
    include JSONAPI::Serializer
    attributes :title, :vote_average

    def self.format_movie_response(movies)
        json = JSON.parse(movies)
        # binding.pry
        { data:
            json["results"].map do |movie|
            {
                id: movie["id"].to_s,
                type: "movie",
                attributes: {
                    title: movie["title"],
                    vote_average: movie["vote_average"]
                }
            }
            end
        }
    end

    def self.format_movie(movie)
        json = JSON.parse(movie)
        binding.pry
        { data:
            {
                id: json["id"].to_s,
                type: "movie",
                attributes: {
                    title: json["title"],
                    release_year: json["release_date"],
                    vote_average: json["vote_average"],
                    runtime: json["runtime"],
                    genres: json["genres"],
                    summary: json["overview"]
            #         cast: json[""]
            #         total_reviews:
            #         reviews:

            #     }
            # }
        }
    end
end

