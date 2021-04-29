import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_app/helpers/database_helper.dart';
import 'package:sqflite_app/models/contato.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper();

  // ignore: deprecated_member_use
  List<Contato> contatos = List<Contato>();

  @override
  void initState() {
    super.initState();

    // Contato c = Contato(1, "Lucas", "lucas@email.com", "lucas.png");
    // db.insertContato(c);

    // Contato c1 = Contato(2, "Fernando", "fernando@email.com", "fernando.png");
    // db.insertContato(c1);

    // // Retornando os contatos
    // db.getContatos().then((lista) {
    //   print(lista);
    // });

    // Obtendo a lista de contatos
    db.getContatos().then((lista) {
      setState(() {
        contatos = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          return _listaContatos(context, index);
        },
      ),
    );
  }

  // Método para listagem dos contatos
  _listaContatos(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contatos[index].imagem != null
                        ? FileImage(File(contatos[index].imagem))
                        : AssetImage('assets/images/profile.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Se for vazio... Exibe um espaço em branco
                    Text(
                      contatos[index].nome ?? "",
                      style: TextStyle(fontSize: 20),
                    ),
                    // Se for vazio... Exibe um espaço em branco
                    Text(
                      contatos[index].email ?? "",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
