import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:http/http.dart' as http;

class GoogleFitApi {
  final _googleSignIn = GoogleSignIn(
    scopes: [
      fitness.FitnessApi.fitnessActivityReadScope,
      fitness.FitnessApi.fitnessBodyReadScope,
    ],
  );

  Future<GoogleSignInAccount?> signIn() async {
    return await _googleSignIn.signIn();
  }

  Future<fitness.Dataset?> getStepsData() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleHttpClient(authHeaders);
    final fitnessApi = fitness.FitnessApi(authenticateClient);

    final startTime = DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch * 1000000;
    final endTime = DateTime.now().millisecondsSinceEpoch * 1000000;

    final datasetId = "$startTime-$endTime";
    final dataSourceId = "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps";

    return await fitnessApi.users.dataSources.datasets.get("me", dataSourceId, datasetId);
  }
}

class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
