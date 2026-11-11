part of 'app.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({
    super.key,
    required this.store,
    required this.openMap,
    required this.openProfile,
  });

  final WalletStore store;
  final VoidCallback openMap;
  final VoidCallback openProfile;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String _currency = 'BOB';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => setState(() {}),
              child: Image.asset(
                'assets/logo.png',
                width: 104,
                height: 52,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            _circleIcon(
              Icons.support_agent_outlined,
              () => _message('Soporte Tilka disponible 24/7'),
            ),
            const SizedBox(width: 8),
            _circleIcon(Icons.person_outline_rounded, widget.openProfile),
          ],
        ),
        const SizedBox(height: 18),
        BalanceCard(
          currency: _currency,
          balances: widget.store.balances,
          onCurrencyChanged: (value) => setState(() => _currency = value),
        ),
        const SizedBox(height: 22),
        const Text(
          'Operaciones rápidas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _brown,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.45,
          children: [
            _action(
              Icons.add_circle_outline,
              'Depósito',
              () => _showAmountSheet('Depósito', false),
            ),
            _action(
              Icons.remove_circle_outline,
              'Retiro',
              () => _showAmountSheet('Retiro', true),
            ),
            _action(
              Icons.send_outlined,
              'Transferir',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransferPage(store: widget.store),
                ),
              ),
            ),
            _action(
              Icons.receipt_long_outlined,
              'Servicios',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServicesPage(store: widget.store),
                ),
              ),
            ),
            _action(Icons.credit_card_outlined, 'Mi tarjeta', _showCardDetails),
          ],
        ),
        const SizedBox(height: 26),
        Row(
          children: [
            const Text(
              'Movimientos recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _brown,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryPage(store: widget.store),
                ),
              ),
              child: const Text('Ver todos'),
            ),
          ],
        ),
        ...widget.store.movements
            .take(4)
            .map((movement) => MovementTile(movement: movement)),
      ],
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(22),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFEEDAC0)),
      ),
      child: Icon(icon, color: _brown),
    ),
  );

  Widget _action(IconData icon, String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0DEC4)),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 8)],
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _JaguarSpotsPainter()),
          ),
          Row(
            children: [
              Container(
                width: 58,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: _orange,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(20),
                  ),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: _brown,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: _brown,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  void _showAmountSheet(String type, bool debit) {
    final amount = TextEditingController();
    String currency = _currency;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            24,
            22,
            MediaQuery.viewInsetsOf(context).bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$type simulado',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _brown,
                ),
              ),
              const SizedBox(height: 10),
              const Text('La operación se realiza solo dentro de Tilka.'),
              const SizedBox(height: 16),
              TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
              ),
              DropdownButton<String>(
                value: currency,
                isExpanded: true,
                items: const ['BOB', 'USD', 'USDT']
                    .map(
                      (currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setModalState(() => currency = value!),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  final value = double.tryParse(amount.text);
                  if (value == null || value <= 0) {
                    return _showError('Ingresa un monto válido.');
                  }
                  try {
                    final id = widget.store.complete(
                      type: type,
                      amount: value,
                      currency: currency,
                      counterpart: type == 'Depósito'
                          ? 'Punto Tilka'
                          : 'Retiro simulado',
                      debit: debit,
                    );
                    Navigator.pop(sheetContext);
                    _success(type, value, currency, id);
                  } on StateError catch (error) {
                    _showError(error.message);
                  }
                },
                child: Text('Confirmar $type'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCardDetails() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.credit_card, color: _orange, size: 46),
            const SizedBox(height: 8),
            const Text(
              'Tarjeta digital Tilka',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const ListTile(title: Text('Número'), trailing: Text('**** 7731')),
            const ListTile(
              title: Text('Titular'),
              trailing: Text('Kimba Flores'),
            ),
          ],
        ),
      ),
    );
  }

  void _success(String title, double value, String currency, String id) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessPage(
            title: title,
            amount: value,
            currency: currency,
            counterpart: title == 'Depósito' ? 'Punto Tilka' : 'Tilka Go',
            operationId: id,
          ),
        ),
      );
  void _showError(String text) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), backgroundColor: Colors.red.shade700),
  );
  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class BalanceCard extends StatefulWidget {
  const BalanceCard({
    super.key,
    required this.currency,
    required this.balances,
    required this.onCurrencyChanged,
  });

  final String currency;
  final Map<String, double> balances;
  final ValueChanged<String> onCurrencyChanged;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  static const _currencies = ['BOB', 'USD', 'USDT'];
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: _currencies.indexOf(widget.currency),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _move(int direction) {
    final current = _controller.page?.round() ?? 0;
    final next = (current + direction).clamp(0, _currencies.length - 1);
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 205,
    child: Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _controller,
          padEnds: false,
          itemCount: _currencies.length,
          onPageChanged: (index) =>
              widget.onCurrencyChanged(_currencies[index]),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: _CurrencyCard(
              currency: _currencies[index],
              amount: widget.balances[_currencies[index]] ?? 0,
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: _sideArrow(Icons.chevron_left_rounded, () => _move(-1)),
        ),
        Positioned(
          right: 0,
          child: _sideArrow(Icons.chevron_right_rounded, () => _move(1)),
        ),
      ],
    ),
  );

  Widget _sideArrow(IconData icon, VoidCallback onTap) => Material(
    color: Colors.white,
    elevation: 3,
    shape: const CircleBorder(),
    child: IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: _brown, size: 29),
      tooltip: icon == Icons.chevron_left_rounded
          ? 'Tarjeta anterior'
          : 'Tarjeta siguiente',
    ),
  );
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({required this.currency, required this.amount});

  final String currency;
  final double amount;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 2),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: currency == 'USDT'
            ? const [Color(0xFF075B4B), Color(0xFF0D8B70)]
            : currency == 'USD'
            ? const [Color(0xFF173B75), Color(0xFF2868A7)]
            : const [Color(0xFF572005), _brown, Color(0xFF8F3608)],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: _brown, width: 2),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -10,
          top: 3,
          child: Image.asset(
            'assets/logo.png',
            width: 93,
            height: 46,
            fit: BoxFit.contain,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Saldo disponible',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  currency,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              '${currency == 'BOB' ? 'Bs' : currency} ${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
            const Spacer(),
            const Text(
              'KIMBA FLORES  •  2170 8890 016',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _JaguarSpotsPainter extends CustomPainter {
  const _JaguarSpotsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x146B300D);
    for (final point in const [
      Offset(.76, .18),
      Offset(.86, .38),
      Offset(.72, .66),
      Offset(.91, .78),
    ]) {
      canvas.drawCircle(
        Offset(size.width * point.dx, size.height * point.dy),
        7,
        paint,
      );
      canvas.drawCircle(
        Offset(size.width * point.dx + 8, size.height * point.dy + 8),
        4,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MovementTile extends StatelessWidget {
  const MovementTile({super.key, required this.movement});
  final Movement movement;
  @override
  Widget build(BuildContext context) {
    final plus = movement.type == 'Depósito';
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFFE7BB),
          child: Icon(_iconFor(movement.type), color: _brown),
        ),
        title: Text(
          movement.type,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${movement.counterpart}\n${formatDate(movement.date)} • ${movement.id}',
          maxLines: 2,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${plus ? '+' : '-'}${money(movement.amount, movement.currency)}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: plus ? Colors.green.shade700 : _brown,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              movement.status,
              style: TextStyle(fontSize: 10, color: Colors.green.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
