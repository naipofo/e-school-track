import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/auth.req.gql.dart';

class QrLoginScannerDialog extends StatelessWidget {
  const QrLoginScannerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.scanQrCode),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ),
          body: MobileScanner(onDetect: (value) {
            final hash = value.barcodes[0].rawValue ?? "";
            if (hash.split('').where((e) => e == '\$').length != 3) return;
            context.pop();
            var clientModel = context.read<ClientModel>();
            clientModel.client
                .request(GInsertQrAuthReq(
                  (g) => g.vars
                    ..hash = hash
                    ..user_id = clientModel.userId,
                ))
                .listen((event) {});
          }),
        ),
      ),
    );
  }
}
