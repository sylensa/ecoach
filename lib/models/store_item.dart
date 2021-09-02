class StoreItem {
  String name = "";
  double price = 0.0;
  String description = "";
  bool selected = false;
  String image = "";

  StoreItem(this.name, this.price,
      {this.description = "", this.selected = false, this.image = ""});
}
