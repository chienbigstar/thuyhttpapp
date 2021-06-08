class StoryModel {
  int id;
  String name;
  String authorName;
  String author;
  String image;
  int chaptersCount;
  String createdAt;
  String updatedAt;

  StoryModel(Map<String, dynamic> data) {
    this.id = data['id'];
    this.name = data['name'];
    this.authorName = data['authorName'];
    this.author = data['author'];
    this.image = data['image'];
    this.chaptersCount = data['chaptersCount'];
    this.createdAt = data['createdAt'];
    this.updatedAt = data['updatedAt'];
  }
  
  asMap() {
    return {
      "id": this.id,
      "name": this.name,
      "authorName": this.authorName,
      "image": this.image,
      "chaptersCount": this.chaptersCount,
      "createdAt": this.createdAt,
    };
  }
}
