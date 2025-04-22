abstract class BaseModel<T> {
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return toJson().toString();
  }
}
