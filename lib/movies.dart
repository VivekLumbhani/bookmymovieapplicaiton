class MovieModel {
  String? imageAsset;
  String? movieName;
  String? movieRating;
  String? year;
  final List<Map>? cast;
  final List<Map>? comments;

  MovieModel({
    this.imageAsset,
    this.movieName,
    this.movieRating,
    this.year,
    this.comments,
    this.cast,
  });
}

// Data
final forYouImages = [
  MovieModel(imageAsset: "images/bloodydady.jpeg"),
  MovieModel(imageAsset: "images/godfather.jpeg"),
  MovieModel(imageAsset: "images/gorika.jpeg"),
  MovieModel(imageAsset: "images/joker.jpeg"),
];

final popularImages = [
  MovieModel(
      imageAsset: "images/bloodydady.jpeg",
      movieName: "Dune",
      cast: [
        {
          "name": "Timothee Chalamet",
          "role": "Paul Atreides",
          "image": "images/bloodydady.jpeg",
        },
        {
          "name": "Zendaya",
          "role": "Chani",
          "image": "images/bloodydady.jpeg",
        },
        {
          "name": "Rebecca Ferguson",
          "role": "Lady Jessica",
          "image": "images/bloodydady.jpeg",
        },
        {
          "name": "Rebecca Ferguson",
          "role": "Lady Jessica",
          "image": "images/bloodydady.jpeg",
        },
      ],
      comments: [
        {
          "name":"hello",
          "imageUrl":"images/godfather.jpeg",
          "date":"june 14,2023",
          "rating":"5.0",
          "comment":"good"
        },
        {
          "name":"hello",
          "imageUrl":"images/godfather.jpeg",
          "date":"june 14,2023",
          "rating":"5.0",
          "comment":"good"
        },
        {
          "name":"hello",
          "imageUrl":"images/godfather.jpeg",
          "date":"june 14,2023",
          "rating":"5.0",
          "comment":"good"
        },
        {
          "name":"hello",
          "imageUrl":"images/godfather.jpeg",
          "date":"june 14,2023",
          "rating":"5.0",
          "comment":"good"
        }
      ],
      year:"2021",
      movieRating:"8.3"
  ),
  MovieModel(
      imageAsset: "images/joker.jpeg",
      movieName: "movie",
      year: "2022",
      movieRating: "6.4"
  ),
  MovieModel(
      imageAsset: "images/joker.jpeg",
      movieName: "movie",
      year: "2022",
      movieRating: "6.4"
  ),
  MovieModel(
      imageAsset: "images/gorika.jpeg",
      movieName: "movie",
      year: "2022",
      movieRating: "6.4"
  ),
  MovieModel(
      imageAsset: "images/godfather.jpeg",
      movieName: "movie",
      year: "2022",
      movieRating: "6.4"
  )



  // Add more MovieModel instances as needed for other popular images
];

final legendaryImage=[
  MovieModel(
      imageAsset: "images/godfather.jpeg",
      movieName: "movie",
      year: "2022",
      movieRating: "6.4"
  ),
  MovieModel(
      imageAsset: "images/godfather.jpeg",
      movieName: "movie",
      year: "2022",
      movieRating: "6.4"
  ),
  MovieModel(
      imageAsset: "images/godfather.jpeg",
      movieName: "movie",
      year: "2022",
      movieRating: "6.4"
  ),
  MovieModel(
      imageAsset: "images/godfather.jpeg",
      movieName: "movie",
      year: "2022",
      movieRating: "6.4"
  ),
];

final genresList=[
  MovieModel(
    imageAsset: "images/scific.jpeg",
    movieName: "Sci-fic",
  ),
  MovieModel(
    imageAsset: "images/horror.jpeg",
    movieName: "Horror",
  ),
  MovieModel(
    imageAsset: "images/romance.jpeg",
    movieName: "Romance",
  ),
  MovieModel(
    imageAsset: "images/comedy.jpeg",
    movieName: "Comedy",
  ),

];