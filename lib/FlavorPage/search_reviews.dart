import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:ice_cream_social/FlavorPage/review.dart';
import 'package:ice_cream_social/FlavorPage/review_card.dart';

class SearchReviews extends StatelessWidget {
  const SearchReviews({
    Key key,
    @required this.reviews,
  }) : super(key: key);

  final List<Review> reviews;

  List<Review> searchReviews(String query) {
    // This line should be replaced with a SQL query for all the reviews
    // containing review_text %LIKE% query.
    return reviews.sublist(0, 2);
  }

  void undoSearchReviews() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: buildSearchBar(context),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text(
        'Search Reviews',
        style: TextStyle(
          fontFamily: 'Nexa',
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Colors.purple, Colors.blue],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSearchBar(BuildContext context) {
    return SearchBar(
      searchBarPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      listPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      shrinkWrap: true,
      suggestions: reviews,
      hintText: "Search review content!",
      onItemFound: (item, int index) {
        return ReviewCard(
          review: reviews[index],
          index: index,
          allowEditing: false,
        );
      },
      onSearch: (String text) {
        searchReviews(text);
      },
      onCancelled: () {
        undoSearchReviews();
      },
    );
  }
}
