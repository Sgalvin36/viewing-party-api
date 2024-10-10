class MovieDbService
    def self.connection
        @connection = Faraday.new(
            url: "https://api.themoviedb.org/3/",
            headers: {"Authorization" => "Bearer #{Rails.application.credentials.the_movie_db[:token]}"}
            )
    end

    def self.fetch_data(path, params = {})
        response = connection.get(path) do |req|
            req.params = params unless params.empty?
        end
    end
end