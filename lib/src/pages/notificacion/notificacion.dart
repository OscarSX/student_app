import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

enum ConfirmAction { CANCEL, ACCEPT }


//elementos globales
List<String> ids = new List<String>();
List<String> nomb = new List<String>();
List<String> clav = new List<String>();
List<bool> idb = new List<bool>();
String idd;

//clase principal de alertas
class NotificacionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),

      ),
      body: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override

  Widget build(BuildContext context) {

    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('alertas').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child:  new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)),
                      Text('  Cargando...',style: TextStyle(fontWeight: FontWeight.bold) )
                    ]));
          }
          return new ListView(children: getAlerts(snapshot));
        }
    );
  }
//---------------------Obtener Datos de Firebase-------------------------------
  getAlerts(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => GestureDetector(
        child: new Card( child :
        new ListTile(
          leading: FlutterLogo(),
          title: new Text(doc['titulo'].toString()),
          subtitle: new Text(
              doc["mensaje"].toString()
          ),
        ),
        ))
    ).toList();
  }
}