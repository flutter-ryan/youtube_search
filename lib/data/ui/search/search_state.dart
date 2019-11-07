library search_state;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:youtube_search/data/model/search/search_model.dart';

part 'search_state.g.dart';

abstract class SearchState implements Built<SearchState, SearchStateBuilder> {
  bool get isLoading;
  BuiltList<SearchItem> get searchResults;
  String get error;
  bool get hasReachEndOfResult;

  bool get isInitial => !isLoading && searchResults.isEmpty && error == '';
  bool get isSuccessful =>
      !isLoading && searchResults.isNotEmpty && error == '';

  SearchState._();

  factory SearchState([updates(SearchStateBuilder b)]) = _$SearchState;

  factory SearchState.initial() {
    return SearchState((b) => b
      ..isLoading = false
      ..searchResults.replace(BuiltList<SearchItem>())
      ..error = ''
      ..hasReachEndOfResult = false);
  }

  factory SearchState.loading() {
    return SearchState((b) => b
      ..isLoading = true
      ..searchResults.replace(BuiltList<SearchItem>())
      ..error = ''
      ..hasReachEndOfResult = false);
  }

  factory SearchState.failure(String error) {
    return SearchState((b) => b
      ..isLoading = false
      ..searchResults.replace(BuiltList<SearchItem>())
      ..error = error
      ..hasReachEndOfResult = false);
  }
  factory SearchState.success(BuiltList<SearchItem> resultList) {
    return SearchState((b) => b
      ..isLoading = false
      ..searchResults.replace(resultList)
      ..error = ''
      ..hasReachEndOfResult = false);
  }
}
