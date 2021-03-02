import 'package:http/http.dart' as http;
import 'dart:convert';

var url = 'https://api.coingecko.com/api/v3/coins/';

Future<double> getPrice(String id) async {
  try {
    var response =
        await http.get(url + id); // id can be bitcoin, tether, ethereum,
    var jsonResponse = jsonDecode(response.body);
    var marketPrice =
        jsonResponse['market_data']['current_price']['eur'].toString();
    return double.parse(marketPrice);
  } catch (e) {
    print(e.toString());
    return 0.0; // to see that something wrong happened
  }
}
