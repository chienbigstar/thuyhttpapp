class ChapterModel {
  int id;
  String title;
  String content;
  int chapterNumber;

  ChapterModel(Map<String, dynamic> data) {
    this.id = data['id'];
    this.title = data['title'];
    this.content = data['content'];
    this.chapterNumber = data['chapterNumber'];
  }
}
