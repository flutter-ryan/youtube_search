import 'package:bloc/bloc.dart';
import 'package:youtube_search/data/model/repository/youtube_repository.dart';
import 'package:youtube_search/data/model/search/youtube_search_error.dart';
import 'package:youtube_search/data/ui/search/search.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final YoutubeRepository _youtubeRepository;

  SearchBloc(this._youtubeRepository) : super();

  void onSearchInitiated(String query) {
    dispatch(SearchInitiated((b) => b..query = query));
  }

  @override
  SearchState get initialState => SearchState.initial();

  @override
  Stream<SearchState> mapEventToState(
    SearchState currentState,
    SearchEvent event,
  ) async* {
    if (event is SearchInitiated) {
      yield* mapSearchInitiated(event);
    }
  }

  Stream<SearchState> mapSearchInitiated(SearchInitiated event) async* {
    if (event.query.isEmpty) {
      yield SearchState.initial();
    } else {
      yield SearchState.loading();

      try {
        final searchResult = await _youtubeRepository.searchVideos(event.query);
        yield SearchState.success(searchResult);
      } on YoutubeSearchError catch (e) {
        yield SearchState.failure(e.message);
      }
    }
  }
}
