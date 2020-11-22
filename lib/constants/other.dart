import 'dart:io' show Platform;

var graphQLEndPoint =
    'http://${Platform.isAndroid ? 'YOUR_IP_ADDRESS' : 'localhost'}: 4000';

var graphQLWsEndPoint =
    'ws://${Platform.isAndroid ? 'YOUR_IP_ADDRESS' : 'localhost'}: 4000';
