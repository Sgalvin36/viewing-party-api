# Viewing Part API - Solo Project

This is the base repo for the Viewing Party Solo Project for Module 3 in Turing's Software Engineering Program. 

## About this Application

Viewing Party is an application that allows users to explore movies and create a Viewing Party Event that invites users and keeps track of a host. Once completed, this application will collect relevant information about movies from an external API, provide CRUD functionality for creating a Viewing Party and restrict its use to only verified users. 

## Setup

1. Fork and clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{drop,create,migrate,seed}`

## Movie Endpoints
### Top Rated Movies

`GET /api/v1/movies/` **No authentication needed** <br>
To find a list of top 20 highest rated movies.
#### Parameters
No parameters needed outside of making the call to the endpoint.

### Finding Movies that match a Query
`GET /api/v1/movies/index` **No authentication needed** <br>
To find a list of movies that matches the search parameter.
#### Parameters
**"query"**: string, *required*
#### Example of Parameters
```
params = { "query": "Star Wars" }
```

### Getting detailed information on one Movie
`GET /api/v1/movies/:id` **No authentication needed** <br>
To find detailed information about a specific movie to include cast members and reviews of the movie.
#### Parameters
**"id"**: integer, *required*
#### Example of Parameters
```
params = { "id": 4 }
```

## Viewing Party Endpoints
### Creating a Viewing Party
`POST /api/v1/viewing_parties` **Authentication needed and should be included in header** <br>
To create a viewing party and invite other users to be a part of the event.
#### Parameters
**"name"**: string, *required* <br>
**"start_time"**: string, *required* <br>
**"end_time"**: string, *required*<br>
**"movie_id"**: integer, *required*<br>
**"movie_title"**: string, *required*<br>
**"user_id"**: integer, *required*<br>
**"api_key"**: string, *required*<br>
**"users"**: array of user IDs, *required*<br>
#### Example of Parameters
```
params = {
    name: "Friends for ever and ever",
    start_time: "2025-05-01 10:00:00",
    end_time: "2025-05-01 14:30:00",
    movie_id: 456,
    movie_title: "Princess Bride",
    api_key: <API_KEY>,
    user_id: 413,
    users: [647, 925]
}
```

### Adding more Users to a Viewing Party
`PATCH` or `PUT /api/v1/viewing_parties/:id` **Authentication needed and should be included in header** <br>
To update the list of a viewing party and invite additional users.
#### Parameters
**"id"**: integer of party ID, *required* <br>
**"users"**: array of user IDs, *required* <br>
#### Example of Parameters
```
params = {
    "id": 4,
    "users": [3412, 7665]
    }
```

## User Endpoints
### Getting detailed User information
`GET /api/v1/users/:id` **Authentication needed and should be included in header** <br>
To get a detailed record of the current users activity to include viewing parties that they have hosted and the parties they have been invited to.
#### Parameters
**"id"**: integer of user ID, *required* <br>
#### Example of Parameters
```
params = { "id": 0 }
```