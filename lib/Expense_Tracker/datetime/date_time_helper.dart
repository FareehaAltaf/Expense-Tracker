//convert DateTime object to a astring yyyymmdd
String convertDateTimeToString(DateTime dateTime) {
  // year in the format -> yyyy/mm/dd
  String year = dateTime.year.toString();

  String month = dateTime.month.toString();
  if (month.length == 1) {
    // to make a pretty format if month 1 -> 01
    month = '0' + month;
  }

  String day = dateTime.day.toString();
  if (day.length == 1) {
    // to make a pretty format if month 1 -> 01
    month = '0' + day;
  }

  // finalFormat -> yyyymmdd
  String yyyymmdd = year+"/"+ month+"/"+ day;

  return yyyymmdd;
}

