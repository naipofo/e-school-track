import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ferry/ferry.dart';

class ClientProvider extends InheritedWidget {
  final Client client;

  const ClientProvider({
    super.key,
    required this.client,
    required super.child,
  });

  static ClientProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClientProvider>()!;
  }

  @override
  bool updateShouldNotify(ClientProvider oldWidget) =>
      oldWidget.client != client;
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
      client: ClientProvider.of(context).client,
    );
  }
}
