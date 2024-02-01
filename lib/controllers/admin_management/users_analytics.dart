class UsersAnalytics {
  static dynamic showAllUsersData({required Map allUsersData, required List allCoursesData}) {
    allUsersData.forEach((key, individualUserData) {
      print(individualUserData);
      print('_________________');
      individualUserData.forEach((key, value) {
        print(key);
        if (key == 'courses') {
          print(value);
        }
      });
    });
    return allUsersData;

    print(allUsersData);
  }
}
