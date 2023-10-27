import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
  inputSpecFile: 'lib/openapi/schema.json',
  generatorName: Generator.dart,
  outputDirectory: 'dart_openapi_api',
)
class Api {}
