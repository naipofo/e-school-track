import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ferry/ferry.dart';
import 'package:gql_websocket_link/gql_websocket_link.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

enum AccountType { guest, student, teacher, admin }

class ClientModel extends ChangeNotifier {
  ClientModel({required this.url}) : client = buildClient(url);

  final String url;
  Client client;
  AccountType type = AccountType.guest;

  void login(String jwt, {AccountType? role}) {
    client = buildClient(url, jwt: jwt);
    final claims = JwtDecoder.decode(jwt)["https://hasura.io/jwt/claims"];

    type = typeFromString(claims["x-hasura-default-role"] as String);
    if ((claims['x-hasura-allowed-roles'] as List<dynamic>)
        .map((e) => typeFromString(e))
        .contains(role)) {
      type = role!;
    }

    notifyListeners();
  }

  static typeFromString(String type) => switch (type) {
        "student" => AccountType.student,
        "teacher" => AccountType.teacher,
        "admin" => AccountType.admin,
        _ => AccountType.guest
      };

  static Client buildClient(String url, {String? jwt}) {
    return Client(
      link: WebSocketLink(
        "ws://localhost:8080/v1/graphql",
        autoReconnect: true,
        reconnectInterval: const Duration(seconds: 1),
        initialPayload: {
          if (jwt != null) 'headers': {'Authorization': "Bearer $jwt"}
        },
      ),
    );
  }
}

typedef GqlFetchBuilder<TData> = Widget Function(
  BuildContext context,
  TData data,
);

class GqlFetch<TData, TVars> extends StatelessWidget {
  const GqlFetch({
    super.key,
    required this.operationRequest,
    required this.builder,
  });

  final OperationRequest<TData, TVars> operationRequest;
  final GqlFetchBuilder<TData> builder;

  @override
  Widget build(BuildContext context) {
    return Operation(
      operationRequest: operationRequest,
      builder: (context, response, error) {
        if (response!.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (response.data != null) {
          return this.builder(context, response.data as TData);
        } else {
          return ErrorWidget(FlutterError('Data is null'));
        }
      },
      client: context.read<ClientModel>().client,
    );
  }
}
