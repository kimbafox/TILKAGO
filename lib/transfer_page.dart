part of 'app.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key, required this.store, this.initialAccount});
  final WalletStore store;
  final String? initialAccount;
  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  late final TextEditingController account;
  final amount = TextEditingController();
  String currency = 'BOB';
  final contacts = const [
    ('Ana Torres', 'TK-0184291'),
    ('Diego Pérez', 'TK-6640921'),
    ('Sofía Rojas', 'TK-3318750'),
  ];
  @override
  void initState() {
    super.initState();
    account = TextEditingController(text: widget.initialAccount ?? 'TK-');
  }

  @override
  void dispose() {
    account.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Transferir'), backgroundColor: _cream),
    body: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text(
          'Envía dinero Tilka',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w900,
            color: _brown,
          ),
        ),
        const SizedBox(height: 7),
        const Text('Transferencias locales simuladas e instantáneas.'),
        const SizedBox(height: 22),
        const Text(
          'Contactos frecuentes',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 9),
        SizedBox(
          height: 86,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: contacts
                .map(
                  (contact) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () => account.text = contact.$2,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFFE2AA),
                            child: Text(
                              contact.$1.substring(0, 1),
                              style: const TextStyle(
                                color: _brown,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(contact.$1.split(' ').first),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: account,
          decoration: const InputDecoration(
            labelText: 'Número de cuenta Tilka',
            prefixIcon: Icon(Icons.account_circle_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: amount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Monto',
            prefixIcon: Icon(Icons.payments_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: currency,
          decoration: const InputDecoration(
            labelText: 'Moneda',
            border: OutlineInputBorder(),
          ),
          items: const ['BOB', 'USD', 'USDT']
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) => setState(() => currency = value!),
        ),
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: _transfer,
          icon: const Icon(Icons.send),
          label: const Text('Transferir ahora'),
        ),
      ],
    ),
  );
  void _transfer() {
    final value = double.tryParse(amount.text);
    if (account.text.trim().length < 5 || value == null || value <= 0) {
      return _error('Ingresa una cuenta y un monto válido.');
    }
    try {
      final id = widget.store.complete(
        type: 'Transferencia',
        amount: value,
        currency: currency,
        counterpart: account.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessPage(
            title: 'Transferencia realizada',
            amount: value,
            currency: currency,
            counterpart: account.text.trim(),
            operationId: id,
          ),
        ),
      );
    } on StateError catch (error) {
      _error(error.message);
    }
  }

  void _error(String message) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
  );
}
