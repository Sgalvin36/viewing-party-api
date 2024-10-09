class MovieSerializer
    include JSONAPI::Serializer
    
    attributes :title, :vote_average
    # attribute :id do
    #     object.id
    # end
end