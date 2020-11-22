import 'package:chatty_flutter/constants/other.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLProvider extends ChangeNotifier {
  GraphQLClient _client;
  GraphQLClient get client => _client;
  String _token;
  String _userId;
  String get token => _token;
  String get userId => _userId;

  GraphQLProvider() {
    if (_client == null) {
      final HttpLink _httpLink = HttpLink(
        uri: graphQLEndPoint,
      );

      final AuthLink _authLink = AuthLink(
        getToken: () async => getToken(),
      );

      final WebSocketLink _socketLink = WebSocketLink(
        url: graphQLWsEndPoint,
        config: SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: Duration(seconds: 90),
        ),
      );

      final Link _link = _authLink.concat(_httpLink).concat(_socketLink);

      _client = GraphQLClient(
        cache: InMemoryCache(),
        link: _link,
      );
      notifyListeners();
    }
  }

  Future<String> getToken() async {
    if (_token == null) {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      _token = _prefs.getString('token');
      _userId = _prefs.getString('userId');
      notifyListeners();
    }
    return _token;
  }

  Future<String> getUserId() async {
    if (_userId == null) {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      _userId = _prefs.getString('userId');
      notifyListeners();
    }
    return _userId;
  }

  Future<void> setData(Map<String, dynamic> _data) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _userId = _data['userId'];
    _token = _data['token'];
    _prefs.setString('token', _token);
    _prefs.setString('userId', _userId);
    notifyListeners();
  }

  Future<void> clearData() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _userId = null;
    _token = null;
    _prefs.remove('token');
    _prefs.remove('userId');
    notifyListeners();
  }

  void mutate(
      {String mutation,
      Map<String, dynamic> variables,
      Function onUpdate,
      Function onCompleted,
      Function onError}) {
    final MutationOptions options = MutationOptions(
        documentNode:
            gql(mutation), // this is the mutation string you just created
        variables: variables,
        // you can update the cache based on results
//      update: (Cache cache, QueryResult result) {
//        return cache;
//      },
        update: onUpdate,
        onCompleted: onCompleted,
        onError: onError
        // or do something with the result.data on completion
//      onCompleted: (dynamic resultData) async {
//
//        if (resultData != null && resultData['login'] != null) {
//          final SharedPreferences _prefs =
//          await SharedPreferences.getInstance();
//          _prefs.setString(
//              'token', resultData['login']['token']);
//
//          Navigator.of(context).pushNamed('/conversations');
//        }
//      },
//      onError: (error) => print(error.toString()),
        );
    _client.mutate(options);
  }

  Future<QueryResult> query({String query, Map<String, dynamic> variables}) {
    final QueryOptions options =
        QueryOptions(documentNode: gql(query), variables: variables);

    return _client.query(options);
  }

  void subscribe(
      {String subscription,
      String operationName,
      Map<String, dynamic> variables,
      Function listener}) {
    final Stream result = _client.subscribe(Operation(
      operationName: operationName,
      variables: variables,
      documentNode: gql(subscription),
    ));

    result.listen(listener);
  }
}
