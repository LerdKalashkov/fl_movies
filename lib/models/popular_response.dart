// To parse this JSON data, do
//
//     final popularResponse = popularResponseFromMap(jsonString);

import 'dart:convert';
import 'package:fl_movies/models/models.dart';

class PopularResponse {
    PopularResponse({
        this.dates,
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    String? dates;
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    factory PopularResponse.fromJson(String str) => PopularResponse.fromMap(json.decode(str));

    factory PopularResponse.fromMap(Map<String, dynamic> json) => PopularResponse(
        dates: json['dates'],
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );
}


