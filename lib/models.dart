part of 'app.dart';

class WalletStore extends ChangeNotifier {
  final Map<String, double> balances = {'BOB': 5000, 'USD': 500, 'USDT': 250};
  final List<Movement> movements = [
    Movement(
      type: 'Saldo inicial',
      amount: 5000,
      currency: 'BOB',
      counterpart: 'Bienvenido a Tilka',
      status: 'Completada',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
  bool cashierMode = false;
  bool exchangerMode = false;
  bool cashierAvailable = true;
  bool notifications = true;
  final List<OperationRequest> requests = [
    OperationRequest(
      name: 'Sofía R.',
      type: 'Cambio Bs por USDT',
      amount: 700,
      currency: 'BOB',
      status: 'Nueva',
    ),
  ];

  bool hasFunds(String currency, double amount) =>
      (balances[currency] ?? 0) >= amount;

  String complete({
    required String type,
    required double amount,
    required String currency,
    required String counterpart,
    bool debit = true,
  }) {
    if (debit && !hasFunds(currency, amount)) {
      throw StateError('Saldo insuficiente en $currency');
    }
    balances[currency] = (balances[currency] ?? 0) + (debit ? -amount : amount);
    final movement = Movement(
      type: type,
      amount: amount,
      currency: currency,
      counterpart: counterpart,
      status: 'Completada',
      date: DateTime.now(),
    );
    movements.insert(0, movement);
    notifyListeners();
    return movement.id;
  }

  void setRequestStatus(OperationRequest request, String status) {
    request.status = status;
    notifyListeners();
  }

  void setMode({bool? cashier, bool? exchanger}) {
    cashierMode = cashier ?? cashierMode;
    exchangerMode = exchanger ?? exchangerMode;
    notifyListeners();
  }

  void setNotifications(bool value) {
    notifications = value;
    notifyListeners();
  }

  void setCashierAvailability(bool value) {
    cashierAvailable = value;
    notifyListeners();
  }
}

class Movement {
  Movement({
    required this.type,
    required this.amount,
    required this.currency,
    required this.counterpart,
    required this.status,
    required this.date,
  }) : id = 'TK-${100000 + Random().nextInt(899999)}';

  final String id;
  final String type;
  final double amount;
  final String currency;
  final String counterpart;
  final String status;
  final DateTime date;
}

class OperationRequest {
  OperationRequest({
    required this.name,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
  });

  final String name;
  final String type;
  final double amount;
  final String currency;
  String status;
}
