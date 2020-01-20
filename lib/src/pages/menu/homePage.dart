import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_app/src/pages/inicio/inicio.dart';
import 'package:student_app/src/pages/curso/curso.dart';
import 'package:student_app/src/pages/notificacion/notificacion.dart';
import 'package:student_app/src/pages/cerrar/cerrar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//import com.google.firebase.firestore.FirebaseFirestore

class HomePage extends StatefulWidget {
  @override
  //final DocumentSnapshot user;
  String user;
  HomePage(
    this.user
  );
  _HomePageState createState() => _HomePageState(this.user);
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  //user.data['matricula'];
  String matri; 
  String idd; 

  _HomePageState(this.matri);

  //FirebaseFirestore db = FirebaseFirestore.getInstance();

  Widget _showPage = new InicioPage();

  Widget _pageChooser(int page){
    switch(page){
      case 0:
        return InicioPage();
        break;
      case 1:
        var itemRef = Firestore.instance.collection("curso");
        var doc = itemRef.document().documentID;
        return CursoPage(this.matri,doc); 
        break;
        case 2:
          return NotificacionPage();
          break;
        case 3:
          return CerrarPage();
          break;
        default:
        return new Container(
          child: new Center(
            child: new Text(
              'Pagina no encontrada',
              style: new TextStyle(fontSize: 30)
            ),
          ),
        );
      }
    }
  
    @override
    Widget build(BuildContext context){
      return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: pageIndex,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.book, size: 30),
            Icon(Icons.notifications, size: 30),
            Icon(Icons.power_settings_new, size: 30),
          ],
          color: Colors.blue,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 5),
          
          onTap: (int tappedIndex){
            setState(() {
              _showPage = _pageChooser(tappedIndex);
            });
          },
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: _showPage,
          ),
        ),
      );
    }
                  
              
}