require "rails_helper"

RSpec.describe Movie do
    before(:all) do
        @json_data = {
            "id"=> "345",
            "title"=> "The Best movie EVER",
            "release_date"=> "2012-10-10",
            "vote_average"=> 9.99,
            "runtime"=> 921,
            "genres"=> [{"name"=> "mystery"}, {"name"=> "comedy"}],
            "overview"=> "One of the finest movies ever made, but no one has every heard of",
            "credits" =>{
                "cast"=> [
                    {"actor"=> "Steven Forest", "character"=> "Stone-Cold Austin"},
                    {"actor"=> "Clementine Jones", "character"=> "Mrs. Frazzle"},
                    {"actor"=> "Courtney Country", "character"=> "Cadaver #1"}
                ]},
            "reviews"=> {
                "totals_results"=> 829,
                "results"=> [
                    {"author"=> "Sir Author the auther", "content"=> "Bloody magnificent"},
                    {"author"=> "Bob", "content"=> "Was alright"},
                    {"author"=> "Mom with a claws", "content"=> "Not enough cats"},
                    {"author"=> "Joseph", "content"=> "I thought this was Batman, where is Batman?"}
                ]
            }

        }
    end
    it "processes json into an image object" do
        test_movie = Movie.new(@json_data)

        expect(test_movie).to be_a Movie
        expect(test_movie.id).to eq(@json_data["id"])
        expect(test_movie.title).to eq(@json_data["title"])
        expect(test_movie.release_year).to eq(@json_data["release_date"].split("-")[0])
        expect(test_movie.vote_average).to eq(@json_data["vote_average"])
        expect(test_movie.summary).to eq(@json_data["overview"])
        expect(test_movie.total_reviews).to eq(@json_data["reviews"]["total_results"])
    end

    it "can convert minutes into runtime correctly" do
        movie = Movie.new(@json_data)
        result = movie.time_convert(212)

        expect(result).to eq("3 hours, 32 minutes")
    end

    it "can clean up genres correctly" do
        movie = Movie.new(@json_data)
        genres_data = [
            {"name"=> "mystery", "id" => 12}, 
            {"name"=> "comedy", "id" => 13},
            {"name"=> "drama", "id"=> 2},
            {"name"=> "satire", "id"=> 4}
        ]

        result = movie.clean_genres(genres_data)
        expect(result.sort).to eq(["mystery", "comedy", "drama", "satire"].sort)
    end

    it "can clean up cast_data correctly, limit to 10" do
        movie = Movie.new(@json_data)
        cast_data = { "credits"=> {
                "cast"=> [
                    {"name"=> "Steven Forest", "character"=> "Stone-Cold Austin"},
                    {"name"=> "Clementine Jones", "character"=> "Mrs. Frazzle"},
                    {"name"=> "Courtney Country", "character"=> "Cadaver #1"},
                    {"name"=> "John", "character"=> "Slightly odd man"},
                    {"name"=> "Josesph", "character"=> "Saint Joe"},
                    {"name"=> "Sally", "character"=> "Octopus #2"},
                    {"name"=> "Yesenia", "character"=> "Not Austin"},
                    {"name"=> "Frank", "character"=> "Young Frazzle"},
                    {"name"=> "Nick", "character"=> "Soldier #4"},
                    {"name"=> "Tom", "character"=> "Hot Austin"},
                    {"name"=> "Tim", "character"=> "Mr. Frazzle"},
                    {"name"=> "James", "character"=> "Doctor #1"}
                ]}}

        result = movie.sift_cast(cast_data)
        expect(result.length).to eq(10)
        expect(result[9][:actor]).to eq("Tom")
        expect(result[9][:character]).to eq("Hot Austin")
    end

    it "can clean up review data correctly, limit to 5" do
        movie = Movie.new(@json_data)
        reviews_data = {"reviews"=> {
            "totals_results"=> 829,
            "results"=> [
                {"author"=> "Sir Author the auther", "content"=> "Bloody magnificent"},
                {"author"=> "Bob", "content"=> "Was alright"},
                {"author"=> "Mom with a claws", "content"=> "Not enough cats"},
                {"author"=> "Joseph", "content"=> "I thought this was Batman, where is Batman?"},
                {"author"=> "Sawyer", "content"=> "Best movie since sliced bread"},
                {"author"=> "Sawyer2", "content"=> "Second best movie since sliced bread"},
                {"author"=> "Sawyer3", "content"=> "Toast is better than sliced bread"}
            ]
            }}

        result = movie.sift_reviews(reviews_data)
        expect(result.length).to eq(5)
        expect(result[0][:author]).to eq("Sir Author the auther")
        expect(result[0][:review]).to eq("Bloody magnificent")
    end
end