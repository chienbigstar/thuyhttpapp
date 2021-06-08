class SCategory {
  int id;
  String name;

  SCategory(Map<String, dynamic> data) {
    this.id = data['id'];
    this.name = data['name'];
  }
}
