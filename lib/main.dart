import 'package:caronas_utfpr/app.dart';
import 'package:caronas_utfpr/repositories/carona_repository.dart';
import 'package:caronas_utfpr/repositories/usuario_repository.dart';
import 'package:caronas_utfpr/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(
            create: (context) =>
                CaronaRepository(auth: context.read<AuthService>())),
        ChangeNotifierProvider(
            create: (context) =>
                UsuarioRepository(auth: context.read<AuthService>())),
      ],
      child: CaronasUTFPR(),
    ),
  );
}
