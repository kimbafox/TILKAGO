part of 'app.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key, required this.store});
  final WalletStore store;
  static const services = [
    ('YPF', 'Combustible', Icons.local_gas_station_outlined),
    ('EPSAS', 'Agua y servicios básicos', Icons.water_drop_outlined),
    ('Electricidad', 'Agua y servicios básicos', Icons.bolt_outlined),
    ('Gas', 'Agua y servicios básicos', Icons.propane_tank_outlined),
    ('Netflix', 'Entretenimiento y streaming', Icons.movie_outlined),
    ('HBO Max', 'Entretenimiento y streaming', Icons.live_tv_outlined),
    ('Disney+', 'Entretenimiento y streaming', Icons.star_outline),
    ('Spotify', 'Entretenimiento y streaming', Icons.music_note_outlined),
    ('Entel', 'Internet y telecomunicaciones', Icons.phone_android_outlined),
    ('Tigo', 'Internet y telecomunicaciones', Icons.wifi_outlined),
    ('Viva', 'Internet y telecomunicaciones', Icons.phone_outlined),
    (
      'Internet residencial',
      'Internet y telecomunicaciones',
      Icons.router_outlined,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final categories = <String, List<(String, String, IconData)>>{};
    for (final service in services) {
      categories.putIfAbsent(service.$2, () => []).add(service);
    }
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        title: const Text('Pago de servicios'),
        backgroundColor: _cream,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Paga en segundos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: _brown,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Todos los pagos son simulados y se registran en tu historial.',
          ),
          const SizedBox(height: 18),
          ...categories.entries.map(
            (entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _brown,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: entry.value
                      .map(
                        (service) => SizedBox(
                          width: 164,
                          child: _ServiceCard(service: service, store: store),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.store});
  final (String, String, IconData) service;
  final WalletStore store;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServicePaymentPage(
          store: store,
          service: service.$1,
          icon: service.$3,
        ),
      ),
    ),
    borderRadius: BorderRadius.circular(18),
    child: Container(
      height: 112,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1DEC3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(service.$3, color: _orange),
          const Spacer(),
          Text(service.$1, style: const TextStyle(fontWeight: FontWeight.w800)),
          const Text(
            'Pagar ahora',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

class ServicePaymentPage extends StatefulWidget {
  const ServicePaymentPage({
    super.key,
    required this.store,
    required this.service,
    required this.icon,
  });
  final WalletStore store;
  final String service;
  final IconData icon;
  @override
  State<ServicePaymentPage> createState() => _ServicePaymentPageState();
}

class _ServicePaymentPageState extends State<ServicePaymentPage> {
  final reference = TextEditingController();
  final amount = TextEditingController();
  @override
  void dispose() {
    reference.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Confirmar pago'),
      backgroundColor: _cream,
    ),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: const Color(0xFFFFE6B7),
            child: Icon(widget.icon, size: 35, color: _brown),
          ),
          const SizedBox(height: 12),
          Text(
            widget.service,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: _brown,
            ),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: reference,
            decoration: const InputDecoration(
              labelText: 'Número de cliente o referencia',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monto en Bs',
              border: OutlineInputBorder(),
              prefixText: 'Bs ',
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _pay,
              child: const Text('Confirmar pago'),
            ),
          ),
        ],
      ),
    ),
  );
  void _pay() {
    final value = double.tryParse(amount.text);
    if (reference.text.trim().isEmpty || value == null || value <= 0) {
      return _error('Completa una referencia y monto válido.');
    }
    try {
      final id = widget.store.complete(
        type: 'Pago de servicio',
        amount: value,
        currency: 'BOB',
        counterpart: widget.service,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessPage(
            title: 'Pago realizado',
            amount: value,
            currency: 'BOB',
            counterpart: widget.service,
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
