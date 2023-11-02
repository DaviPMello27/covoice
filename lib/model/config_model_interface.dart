
abstract class IConfigModel {
  Future<bool?> getBoolProperty(String property);
  Future setBoolProperty(String property, bool value);
}