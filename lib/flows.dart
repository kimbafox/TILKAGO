part of 'app.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.store});

  final WalletStore store;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Historial de operaciones'),
      backgroundColor: _cream,
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: store.movements
          .map((item) => MovementTile(movement: item))
          .toList(),
    ),
  );
}

class SuccessPage extends StatefulWidget {
  const SuccessPage({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    required this.counterpart,
    required this.operationId,
    this.message,
  });

  final String title;
  final String currency;
  final String counterpart;
  final String operationId;
  final double amount;
  final String? message;

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late final ConfettiController _confettiController;
  late final DateTime _completedAt;
  bool _showReceipt = false;

  @override
  void initState() {
    super.initState();
    _completedAt = DateTime.now();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 2200),
    );
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() => _showReceipt = true);
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            child: _showReceipt ? _receipt(context) : _animation(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 22,
              gravity: .22,
              colors: const [_orange, _brown, Color(0xFFFFD54F), Colors.white],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _animation() => Center(
    key: const ValueKey('animation'),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/animacion.gif',
          width: 190,
          height: 190,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 18),
        const Text(
          '¡Transacción exitosa!',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: _brown,
          ),
        ),
        const SizedBox(height: 8),
        Text(widget.title),
      ],
    ),
  );

  Widget _receipt(BuildContext context) => SingleChildScrollView(
    key: const ValueKey('receipt'),
    padding: const EdgeInsets.fromLTRB(26, 34, 26, 24),
    child: Column(
      children: [
        const Icon(Icons.check_circle_rounded, color: _orange, size: 62),
        const SizedBox(height: 10),
        const Text(
          '¡Pago confirmado!',
          style: TextStyle(
            color: _brown,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF0D19D)),
            boxShadow: const [
              BoxShadow(color: Color(0x15000000), blurRadius: 12),
            ],
          ),
          child: Column(
            children: [
              Image.asset('assets/logo.png', width: 104, height: 46),
              const Divider(height: 28),
              Text(
                money(widget.amount, widget.currency),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: _brown,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (widget.message != null) ...[
                const SizedBox(height: 8),
                Text(widget.message!, textAlign: TextAlign.center),
              ],
              const Divider(height: 30),
              _receiptRow('De', 'Kimba Flores'),
              _receiptRow('Para', widget.counterpart),
              _receiptRow('Fecha y hora', formatDate(_completedAt)),
              _receiptRow('Operación', widget.operationId),
              _receiptRow('Estado', 'Completada', success: true),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Volver al inicio'),
          ),
        ),
      ],
    ),
  );

  Widget _receiptRow(String label, String value, {bool success = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(label, style: const TextStyle(color: Colors.black54)),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: success ? Colors.green.shade700 : _brown,
              ),
            ),
          ],
        ),
      );
}

class QrMenu extends StatelessWidget {
  const QrMenu({super.key, required this.store, required this.onTransfer});

  final WalletStore store;
  final VoidCallback onTransfer;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(12),
    padding: const EdgeInsets.all(23),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(26),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Tilka QR',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w900,
            color: _brown,
          ),
        ),
        const SizedBox(height: 17),
        _option(Icons.qr_code_2, 'Mostrar mi QR', () {
          showDialog<void>(context: context, builder: (_) => const _QrDialog());
        }),
        _option(Icons.qr_code_scanner, 'Escanear código QR', () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => QrScannerPage(store: store)),
          );
        }),
        _option(Icons.send_outlined, 'Transferir con QR', onTransfer),
      ],
    ),
  );

  Widget _option(IconData icon, String text, VoidCallback onTap) => ListTile(
    onTap: onTap,
    leading: CircleAvatar(
      backgroundColor: const Color(0xFFFFE5B1),
      child: Icon(icon, color: _brown),
    ),
    title: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    trailing: const Icon(Icons.chevron_right),
  );
}

class _QrDialog extends StatelessWidget {
  const _QrDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Mi QR Tilka'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QrImageView(
          data: 'tilka://pay/TK-0018273',
          version: QrVersions.auto,
          size: 210,
          embeddedImage: const AssetImage('assets/logo.png'),
          embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(54, 54)),
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: _brown,
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: _brown,
          ),
        ),
        const SizedBox(height: 14),
        const Text('TK-0018273', style: TextStyle(fontWeight: FontWeight.w800)),
        const Text(
          'Comparte este código para recibir pagos',
          textAlign: TextAlign.center,
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cerrar'),
      ),
    ],
  );
}

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key, required this.store});

  final WalletStore store;

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: const Text('Escanear código QR'),
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
    ),
    body: MobileScanner(
      onDetect: (capture) {
        if (_handled) return;
        final value = capture.barcodes.firstOrNull?.rawValue;
        if (value == null || value.isEmpty) return;
        _handled = true;
        final account = value.startsWith('tilka://pay/')
            ? value.replaceFirst('tilka://pay/', '')
            : value;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TransferPage(store: widget.store, initialAccount: account),
          ),
        );
      },
    ),
  );
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.text});
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 5),
      Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
      ),
    ],
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: status == 'Rechazada'
          ? const Color(0xFFFFE1DF)
          : const Color(0xFFE1F4E6),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      status,
      style: TextStyle(
        fontSize: 10,
        color: status == 'Rechazada'
            ? Colors.red.shade800
            : Colors.green.shade800,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

IconData _iconFor(String type) {
  if (type.contains('Depósito')) return Icons.add_circle_outline;
  if (type.contains('Transferencia')) return Icons.send_outlined;
  if (type.contains('Pago')) return Icons.receipt_long_outlined;
  if (type.contains('Cambio')) return Icons.currency_exchange;
  return Icons.remove_circle_outline;
}

String money(double value, String currency) =>
    '${currency == 'BOB' ? 'Bs' : currency} ${value.toStringAsFixed(2)}';
String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
