class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; //Singleton DatabseHelper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??=
        DatabaseHelper._createInstance(); // Initialize only if null
    return _databaseHelper!;
  }
}
