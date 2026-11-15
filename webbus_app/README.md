# WebBus (Flutter: Android, iOS y web)

Un solo código para app móvil y web. La versión HTML original sigue en `../WebBus`.

## Primera vez (genera las carpetas android/, web/, etc.)
```
cd webbus_app
flutter create . --project-name webbus_app --org com.webbus
flutter pub get
```

### Permisos de Android (necesario para el mapa)
En `android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>` y antes de `<application>`:
```
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

## Ejecutar
- Web: `flutter run -d chrome`
- Android (emulador o celular con depuración USB): `flutter run`

## Generar
- Web: `flutter build web`
- APK: `flutter build apk`
