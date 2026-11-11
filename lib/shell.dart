part of 'app.dart';

class Shell extends StatefulWidget {
  const Shell({super.key, required this.store});

  final WalletStore store;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _tab = 0;

  void _openQrMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => QrMenu(
        store: widget.store,
        onTransfer: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransferPage(store: widget.store),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      WalletPage(
        store: widget.store,
        openMap: () => setState(() => _tab = 1),
        openProfile: () => setState(() => _tab = 2),
      ),
      MapPage(
        store: widget.store,
        onReturnHome: () => setState(() => _tab = 0),
      ),
      ProfilePage(
        store: widget.store,
        onReturnHome: () => setState(() => _tab = 0),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: KeyedSubtree(key: ValueKey(_tab), child: pages[_tab]),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 82,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 68,
              margin: const EdgeInsets.only(top: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Color(0x16000000), blurRadius: 12),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navButton(Icons.map_outlined, 'Mapa', 1),
                  const SizedBox(width: 76),
                  _navButton(Icons.person_outline_rounded, 'Perfil', 2),
                ],
              ),
            ),
            Semantics(
              label: 'Menú QR',
              button: true,
              child: InkWell(
                onTap: _openQrMenu,
                borderRadius: BorderRadius.circular(38),
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: _orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: _brown, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x44000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 31,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, String label, int index) {
    final selected = _tab == index;
    return InkWell(
      onTap: () => setState(() => _tab = index),
      child: SizedBox(
        width: 84,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? _orange : _brown),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? _brown : Colors.black54,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
