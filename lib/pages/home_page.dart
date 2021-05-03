import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_app/helpers/database_helper.dart';
import 'package:sqflite_app/models/contato.dart';
import 'package:sqflite_app/pages/contato_page.dart';

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

    // Contato c = Contato(1, "Lucas", "lucas@email.com", null);
    // db.insertContato(c);

    // Contato c1 = Contato(2, "Fernando", "fernando@email.com", null);
    // db.insertContato(c1);

    // // Retornando os contatos
    // db.getContatos().then((lista) {
    //   print(lista);
    // });

    _exibeTodosContatos();
  }

  void _exibeTodosContatos() {
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
        onPressed: () {
          _exibeContatoPage();
        },
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _confirmaExclusao(context, contatos[index].id, index);
                  }),
            ],
          ),
        ),
      ),
      onTap: () {
        _exibeContatoPage(contato: contatos[index]);
      },
    );
  }

  void _exibeContatoPage({Contato contato}) async {
    final contatoRecebido = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContatatoPage(
          contato: contato,
        ),
      ),
    );

    // Clicou no botão "salvar" e está realizando uma inclusão ou edição
    if (contatoRecebido != null) {
      // Atualizando os dados do contato
      if (contato != null) {
        await db.updateContato(contatoRecebido);
      }
      // Inserindo um novo contato
      else {
        await db.insertContato(contatoRecebido);
      }
      // Atualizando a lista de contato que será exibida
      _exibeTodosContatos();
    }
  }

  // Alerta para confirmação de exclusão do contato selecionado
  void _confirmaExclusao(BuildContext context, int contatoid, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Excluir contato"),
            content: new Text("Deseja excluir o contato ?"),
            actions: <Widget>[
              new TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("Cancelar"),
              ),
              new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    contatos.removeAt(index);
                    db.deleteContato(contatoid);
                  });
                  Navigator.of(context).pop();
                },
                child: new Text("Excluir"),
              )
            ],
          );
        });
  }
}
