part of 'app.dart';

final _laPazCenter = LatLng(-16.4897, -68.1193);
final _laPazBounds = LatLngBounds(
  const LatLng(-16.5850, -68.2050),
  const LatLng(-16.4250, -68.0400),
);

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.store, required this.onReturnHome});

  final WalletStore store;
  final VoidCallback onReturnHome;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  MapPoint? selected;
  final points = [
    MapPoint(
      'María L.',
      'Librecambista',
      'Sopocachi',
      'Compra USDT a Bs 6.96',
      'assets/librecambista.png',
      LatLng(-16.5088, -68.1261),
    ),
    MapPoint(
      'Punto Tilka Centro',
      'Cajero',
      'Av. Camacho',
      'Efectivo disponible: Bs 8.500',
      'assets/cajero.png',
      LatLng(-16.4965, -68.1331),
    ),
    MapPoint(
      'Lucía C.',
      'Librecambista',
      'Calacoto',
      'Venta USD a Bs 6.98',
      'assets/librecambista.png',
      LatLng(-16.5403, -68.0845),
    ),
    MapPoint(
      'Cajero Miraflores',
      'Cajero',
      'Miraflores',
      'Efectivo disponible: Bs 4.200',
      'assets/cajero.png',
      LatLng(-16.5014, -68.1180),
    ),
  ];

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _laPazCenter,
            initialZoom: 13,
            cameraConstraint: CameraConstraint.contain(bounds: _laPazBounds),
            onTap: (_, _) => setState(() => selected = null),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.tilkago',
            ),
            MarkerLayer(
              markers: [
                ...points.map(_markerFor),
                Marker(
                  point: _laPazCenter,
                  width: 42,
                  height: 42,
                  child: const Icon(
                    Icons.my_location,
                    color: Color(0xFF2176FF),
                    size: 34,
                  ),
                ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('© OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        top: 14,
        left: 18,
        right: 18,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(color: Color(0x18000000), blurRadius: 8),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.location_city_outlined, color: _brown),
              SizedBox(width: 8),
              Text(
                'Puntos Tilka en La Paz, Bolivia',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 78,
        right: 70,
        child: FloatingActionButton.small(
          heroTag: 'center-map',
          backgroundColor: _orange,
          onPressed: () => _mapController.move(_laPazCenter, 13),
          child: const Icon(Icons.my_location, color: Colors.white),
        ),
      ),
      Positioned(
        top: 78,
        right: 18,
        child: FloatingActionButton.small(
          heroTag: 'return-home',
          backgroundColor: Colors.white,
          onPressed: widget.onReturnHome,
          child: const Icon(Icons.home_rounded, color: _brown),
        ),
      ),
      Positioned(
        left: 18,
        right: 18,
        bottom: 22,
        child: selected == null
            ? const _MapLegend()
            : MapPointSheet(point: selected!, store: widget.store),
      ),
    ],
  );

  Marker _markerFor(MapPoint point) => Marker(
    point: point.position,
    width: 60,
    height: 70,
    child: InkWell(
      onTap: () => setState(() => selected = point),
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x44000000), blurRadius: 5)],
            ),
            child: Image.asset(point.assetPath),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              point.kind,
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    ),
  );
}

class MapPoint {
  const MapPoint(
    this.name,
    this.kind,
    this.zone,
    this.description,
    this.assetPath,
    this.position,
  );
  final String name, kind, zone, description, assetPath;
  final LatLng position;
}

class MapPointSheet extends StatelessWidget {
  const MapPointSheet({super.key, required this.point, required this.store});
  final MapPoint point;
  final WalletStore store;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 14)],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                point.assetPath,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  Text('${point.kind} • ${point.zone}'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(point.description),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => _request(context),
          icon: const Icon(Icons.handshake_outlined),
          label: Text(
            point.kind == 'Cajero' ? 'Solicitar efectivo' : 'Solicitar cambio',
          ),
        ),
      ],
    ),
  );

  void _request(BuildContext context) {
    final amount = point.kind == 'Cajero' ? 200.0 : 700.0;
    final type = point.kind == 'Cajero'
        ? 'Retiro por cajero'
        : 'Cambio Bs por USDT';
    final id = store.complete(
      type: type,
      amount: amount,
      currency: 'BOB',
      counterpart: point.name,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessPage(
          title: 'Solicitud confirmada',
          amount: amount,
          currency: 'BOB',
          counterpart: point.name,
          operationId: id,
          message: 'La solicitud queda pendiente de intercambio.',
        ),
      ),
    );
  }
}

class _MapLegend extends StatelessWidget {
  const _MapLegend();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 12)],
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _Legend(color: _orange, text: 'Librecambista'),
        _Legend(color: _brown, text: 'Cajero'),
        _Legend(color: Color(0xFF2176FF), text: 'Tu ubicación'),
      ],
    ),
  );
}
