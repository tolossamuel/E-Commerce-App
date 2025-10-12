



import 'package:ecommerce/feature/auth/data/data_source/auth_data_source.dart';
import 'package:ecommerce/feature/auth/domain/repo/auth_repo.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
@GenerateMocks(
  [
    AuthRepo,
    AuthDataSource
  ]
)
@GenerateMocks([
  http.Client
])
void main() {}