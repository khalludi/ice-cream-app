/// The [Review] class describes an ice cream reviews.
/// 
/// Qualitative data
/// 
/// author: author of the review
/// title: what the author titled the review
/// date: date that the review was last edited. In format 'yyyy-mm-dd.'
/// text: content of the review.
/// 
/// Quantitative data
/// reviewStars: how the author ranks the review against other reviews. Range: 1-5 stars, inclusive.
/// helpfulYes: how many people marked this review as helpful.
/// helpfulNo: how many people marked this review as not helpful.

class Review {
  String author;
  String title;
  String date;
  String text;

  int reviewStars;
  int helpfulYes;
  int helpfulNo;

  Review({
    this.author,
    this.title,
    this.date,
    this.text,
    this.reviewStars,
    this.helpfulYes,
    this.helpfulNo
  });
}