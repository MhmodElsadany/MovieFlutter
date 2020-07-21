
 class ModelReviews {
   String author;
   String content;
   String id;
   String url;

   ModelReviews(this.author, this.content);
   String get _author => author;
   String get _content => content;

   ModelReviews.fromJson(Map<String, dynamic> parsedJson) {
     author = parsedJson['author'];
     content = parsedJson['content'];
     id = parsedJson['id'];
     url = parsedJson['url'];
   }
 }
