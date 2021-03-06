# Swift5 API client for TmdbAPI

Developed as part of the 'Move to Movies' educational project on the \"iOS Developer professional\" course on the educational platform [Otus](https://otus.ru)

## Overview
This API client was generated by the [OpenAPI Generator](https://openapi-generator.tech) project.  By using the [openapi-spec](https://github.com/OAI/OpenAPI-Specification) from a remote server, you can easily generate an API client.

- API version: 0.0.21
- Package version: 
- Build package: org.openapitools.codegen.languages.Swift5ClientCodegen
For more information, please visit [https://github.com/vegiwoo](https://github.com/vegiwoo)

## Installation

### Carthage

Run `carthage update`

### CocoaPods

Run `pod install`

## Documentation for API Endpoints

All URIs are relative to *https://api.themoviedb.org/3*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*DefaultAPI* | [**genreMovieListGet**](docs/DefaultAPI.md#genremovielistget) | **GET** /genre/movie/list | Get the list of official genres for movies.
*DefaultAPI* | [**movieMovieIdGet**](docs/DefaultAPI.md#moviemovieidget) | **GET** /movie/{movie_id} | Get the primary information about a movie.
*DefaultAPI* | [**moviePopularGet**](docs/DefaultAPI.md#moviepopularget) | **GET** /movie/popular | Get a list of the current popular movies on TMDb. This list updates daily.


## Documentation For Models

 - [Genre](docs/Genre.md)
 - [InlineResponse200](docs/InlineResponse200.md)
 - [InlineResponse2001](docs/InlineResponse2001.md)
 - [InlineResponse401](docs/InlineResponse401.md)
 - [Movie](docs/Movie.md)
 - [MovieBelongsToCollection](docs/MovieBelongsToCollection.md)
 - [MovieListResultObject](docs/MovieListResultObject.md)
 - [ProductionCompany](docs/ProductionCompany.md)
 - [ProductionCountry](docs/ProductionCountry.md)
 - [SpokenLanguage](docs/SpokenLanguage.md)


## Documentation For Authorization

 All endpoints do not require authorization.


## Author

vegiwoo@protonmail.com

