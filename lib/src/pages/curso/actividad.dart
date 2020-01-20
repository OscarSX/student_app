import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class PantallaActividad extends StatelessWidget {
  String idmat, nombmat,docid,matri;
  PantallaActividad(this.idmat,this.nombmat,this.docid,this.matri);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.nombmat),
        backgroundColor: Colors.blue, 
      ),
      body: ListPage2(this.idmat,this.docid,this.matri),
    );
  }

List<String> obtenerCriterios(String docid){ 
    var lst = new List<String>();   
    final Stream<QuerySnapshot> result = Firestore.instance.collection('cursos').document(docid).collection("criterios").snapshots();
    result.listen((snapshot) {
      snapshot.documents.forEach((doc) {    
          lst.add(doc["nombre"]);
      });
    });
    return lst;
  }
}

class ListPage2 extends StatefulWidget {
  String idmat;
  String docid;
  String matri;
  ListPage2(this.idmat,this.docid,this.matri);
  @override
  _ListPageState2 createState() => _ListPageState2(this.idmat,this.docid,this.matri);
}

class _ListPageState2 extends State<ListPage2> {  
  String idmat;
  String docid;
  String matri;
  _ListPageState2(this.idmat,this.docid,this.matri);
  
  @override

  Widget build(BuildContext context) {
  print(idmat);
  return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('cursos').document(docid).collection("actividades").where("alumno", isEqualTo: this.matri).snapshots(),
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
        return new ListView(children: getActividad(snapshot));        
      }
    );
  }

getActividad(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new Card( child : 
          new ListTile(
            leading: FlutterLogo(),            
            //-----------------------------------------------------------
        
            title: new Text(doc["nombre"].toString()),
            subtitle: Column(                
                children: <Widget>[
                  new Text(doc["descripcion"].toString()),
                  new Text(doc["criterio"].toString()),
                  new Text(doc["alumno"].toString()), 
                  new Text(doc["fecha_inicio"].toString() +" - "+ doc["fecha_final"].toString()),                                            
                ],                                                                                                 
              ),
            //Visualizar calificaciones alumnos
            //-----------------------------------------------------------                      
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(doc["calificacion"].toString(),style: TextStyle(color: Colors.red.withOpacity(1.0))),
              ]
            ),
          ),
        )
      ).toList();
  }

}
