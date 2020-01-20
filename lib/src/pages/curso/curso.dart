import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'actividad.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class CursoPage extends StatefulWidget {
  String matri; 
  String idd; 
  CursoPage(this.matri,this.idd);
  @override
  _Lista_Cursos createState() => _Lista_Cursos(this.matri,this.idd);
}

class _Lista_Cursos extends State<CursoPage> {
  String ma;
  String idd;
  _Lista_Cursos(this.ma,this.idd);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de cursos'),
      ),
      body: ListPage(this.ma,this.idd),
);
  }
}

//--------------------Lista de Cursos-------------------------------

class ListPage extends StatefulWidget {
  @override
  String matri;
  String idd; 
  ListPage(this.matri,this.idd); 
  _ListPageState createState() => _ListPageState(this.matri,this.idd);
}

class _ListPageState extends State<ListPage> {  
  @override
  String ma;
  String idd; 
  _ListPageState(this.ma,this.idd);
  Widget build(BuildContext context) {

  return new StreamBuilder<QuerySnapshot>(
      //stream: Firestore.instance.collection('cursos').document('NKcLsS3fWrI8AGeY0FAg').collection('alumnos').where("matricula", isEqualTo: this.ma).snapshots(),
      stream: Firestore.instance.collection('cursos').snapshots(),
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
        return new ListView(children: getCourses(snapshot));        
      }
    );
  }
//---------------------Datos sobre los cursos-------------------
  getCourses(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => 
          new Card( child : 
          new ListTile(
            leading: FlutterLogo(),            
            title: new Text( doc["nombre_materia"].toString() ),
            subtitle: new Text( 
            doc["nrc"].toString() + '\n' + 
            doc["salon"].toString() + '\n' + 
            doc["hora"].toString() + '\n' + 
            doc["dias"].toString()
            ),
            onTap: () {
                    print("tapped");
                    Navigator.push(context,MaterialPageRoute(builder: (context) => PantallaActividad(doc["nrc"].toString(),doc["nombre_materia"].toString(),doc.documentID.toString(),this.ma)),);
                  },
          ),
        )
      ).toList();
  }
}