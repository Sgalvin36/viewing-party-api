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
        # binding.pry
        { data:
            {
                id: json["id"].to_s,
                type: "movie",
                attributes: {
                    title: json["title"],
                    release_year: json["release_date"].split("-")[0],
                    vote_average: json["vote_average"],
                    runtime: time_convert(json["runtime"].to_i),
                    genres: clean_genres(json["genres"]),
                    summary: json["overview"],
                    cast: sift_cast(json),
                    total_reviews: json["reviews"]["total_results"],
                    reviews: sift_reviews(json)
                }
            }
        }
    end
end

private
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

def sift_reviews(data)
    results = data["reviews"]["results"].first(5).map do |each|
        {
            "author": each["author"],
            "review": each["content"]
        }
    end
end
