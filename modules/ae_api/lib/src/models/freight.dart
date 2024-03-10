// Define the model class for the response

class Freight {
  // Declare the fields
  final String? amount;
  final String? cent;
  final String? currencyCode;

  // Define the constructor
  Freight({this.amount, this.cent, this.currencyCode});

  // Define a factory method to create an instance from JSON
  factory Freight.fromJson(Map<String, dynamic> json) {
    return Freight(
      amount: json['amount'],
      cent: json['cent'],
      currencyCode: json['currency_code'],
    );
  }
}
