import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

part 'models.dart';
part 'shell.dart';
part 'wallet_page.dart';
part 'map_page.dart';
part 'services_page.dart';
part 'transfer_page.dart';
part 'profile_page.dart';
part 'flows.dart';

const _orange = Color(0xFFFF9800);
const _brown = Color(0xFF3B1A0A);
const _cream = Color(0xFFFFF7E8);

class TilkaApp extends StatefulWidget {
  const TilkaApp({super.key});

  @override
  State<TilkaApp> createState() => _TilkaAppState();
}

class _TilkaAppState extends State<TilkaApp> {
  final wallet = WalletStore();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: wallet,
      builder: (context, _) => MaterialApp(
        title: 'Tilka Go',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: _orange,
            primary: _orange,
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: _cream,
          fontFamily: 'Arial',
        ),
        home: Shell(store: wallet),
      ),
    );
  }
}
