# Tilka Go

Tilka Go es una billetera digital Flutter con datos y operaciones simuladas
localmente durante la ejecución de la aplicación.

## Mapa de La Paz

La pantalla **Mapa** usa OpenStreetMap para mostrar calles y zonas reales de
La Paz, Bolivia. Se puede desplazar, ampliar y reducir sin una clave de API.
Los puntos Tilka usan los recursos locales `assets/cajero.png` y
`assets/librecambista.png`.

La aplicación necesita acceso a Internet solamente para cargar las teselas
cartográficas de OpenStreetMap; no consulta servicios bancarios, bases de datos
ni operaciones financieras reales.

## Ejecución

```bash
flutter pub get
flutter run
```
