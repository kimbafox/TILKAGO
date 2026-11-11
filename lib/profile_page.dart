part of 'app.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.store,
    required this.onReturnHome,
  });
  final WalletStore store;
  final VoidCallback onReturnHome;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onReturnHome,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Volver'),
            ),
          ),
          Image.asset(
            'assets/logo.png',
            width: 106,
            height: 52,
            fit: BoxFit.contain,
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          const CircleAvatar(
            radius: 31,
            backgroundColor: _orange,
            child: Icon(Icons.person, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 13),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kimba Flores',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19),
              ),
              Text('ID Tilka • TK-0018273'),
              Text(
                'Cuenta • 2170 8890 016',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 25),
      _profileCard([
        SwitchListTile(
          value: store.notifications,
          activeTrackColor: _orange,
          title: const Text('Notificaciones'),
          subtitle: const Text('Avisos y movimientos de Tilka'),
          onChanged: store.setNotifications,
        ),
        ListTile(
          leading: const Icon(Icons.history, color: _brown),
          title: const Text('Historial de operaciones'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HistoryPage(store: store)),
          ),
        ),
        const ListTile(
          leading: Icon(Icons.account_balance_wallet_outlined, color: _brown),
          title: Text('Monedas disponibles'),
          subtitle: Text('BOB • USD • USDT'),
        ),
      ]),
      const SizedBox(height: 18),
      const Text(
        'Modos especiales',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 18,
          color: _brown,
        ),
      ),
      const SizedBox(height: 8),
      _profileCard([
        SwitchListTile(
          value: store.cashierMode,
          activeTrackColor: _orange,
          title: const Text('Modo Cajero'),
          subtitle: Text(
            store.cashierMode
                ? 'Disponible para atender efectivo'
                : 'Desactivado',
          ),
          onChanged: (value) => store.setMode(cashier: value),
        ),
        if (store.cashierMode)
          ListTile(
            leading: const Icon(Icons.location_on_outlined, color: _orange),
            title: const Text('Ubicación: Av. Arce, La Paz'),
            subtitle: const Text('Efectivo disponible: Bs 5.000'),
            trailing: Switch(
              value: store.cashierAvailable,
              activeTrackColor: _orange,
              onChanged: store.setCashierAvailability,
            ),
          ),
        SwitchListTile(
          value: store.exchangerMode,
          activeTrackColor: _orange,
          title: const Text('Modo Librecambista'),
          subtitle: Text(
            store.exchangerMode ? 'Visible en el mapa Tilka' : 'Desactivado',
          ),
          onChanged: (value) => store.setMode(exchanger: value),
        ),
        if (store.exchangerMode)
          const ListTile(
            leading: Icon(Icons.currency_exchange, color: _orange),
            title: Text('Tasas simuladas'),
            subtitle: Text(
              'USDT Bs 6.96 • USD Bs 6.98 • Lun-Sáb 09:00 - 19:00',
            ),
          ),
      ]),
      if (store.cashierMode || store.exchangerMode) ...[
        const SizedBox(height: 18),
        const Text(
          'Solicitudes recibidas',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: _brown,
          ),
        ),
        const SizedBox(height: 8),
        ...store.requests.map(
          (request) => _RequestCard(store: store, request: request),
        ),
      ],
    ],
  );
  Widget _profileCard(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFF0DFC9)),
    ),
    child: Column(children: children),
  );
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.store, required this.request});
  final WalletStore store;
  final OperationRequest request;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFFFE2AA),
                child: Text(request.name.substring(0, 1)),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  request.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              _StatusChip(status: request.status),
            ],
          ),
          const SizedBox(height: 8),
          Text('${request.type} • ${money(request.amount, request.currency)}'),
          if (request.status == 'Nueva')
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => store.setRequestStatus(request, 'Rechazada'),
                  child: const Text('Rechazar'),
                ),
                FilledButton(
                  onPressed: () => store.setRequestStatus(
                    request,
                    'Pendiente de intercambio',
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}
