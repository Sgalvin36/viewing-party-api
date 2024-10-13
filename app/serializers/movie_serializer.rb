class MovieSerializer
    include JSONAPI::Serializer
    attributes :title, :vote_average

    def self.format_movie_response(movies)
        json = JSON.parse(movies)
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

    def self.format_movie(movie_object)
        { data:
            {
                id: movie_object.id,
                type: "movie",
                attributes: {
                    title: movie_object.title,
                    release_year: movie_object.release_year,
                    vote_average: movie_object.vote_average,
                    runtime: movie_object.runtime,
                    genres: movie_object.genres,
                    summary: movie_object.summary,
                    cast: movie_object.cast,
                    total_reviews: movie_object.total_reviews,
                    reviews: movie_object.reviews
                }
            }
        }
    end
end