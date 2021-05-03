import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_app/models/contato.dart';

class ContatatoPage extends StatefulWidget {
  final Contato contato;

  // Construtor com parâmetros nomeados entre {}
  ContatatoPage({this.contato});

  @override
  _ContatatoPageState createState() => _ContatatoPageState();
}

class _ContatatoPageState extends State<ContatatoPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomeFocus = FocusNode();

  // Variável para controlar se está modo de edição ou de inclusão
  bool editado = false;
  Contato _editaContato;

  @override
  void initState() {
    super.initState();

    // Se for contato for null, então será feito a inclusão, se não, será feito a edição
    if (widget.contato == null) {
      _editaContato = Contato(0, '', '', null);
    } else {
      _editaContato = Contato.fromMap(widget.contato.toMap());

      _nomeController.text = _editaContato.nome;
      _emailController.text = _editaContato.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
            _editaContato.nome == '' ? "Novo contato " : _editaContato.nome),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Verificando se existe dados nos inputs
          if (_editaContato.nome != null && _editaContato.email.isNotEmpty) {
            Navigator.pop(context, _editaContato);
          } else {
            _exibeAviso();
            FocusScope.of(context).requestFocus(_nomeFocus);
          }
        },
        child: Icon(Icons.save_alt_outlined),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editaContato.imagem != null
                        ? FileImage(File(_editaContato.imagem))
                        : AssetImage('assets/images/profile.png'),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nomeController,
              focusNode: _nomeFocus,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) {
                editado = true;
                setState(() {
                  _editaContato.nome = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "E-mail"),
              onChanged: (text) {
                editado = true;
                _editaContato.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }

  // Mensagem de aviso caso clique no botão de salvar com os inputs vazios
  void _exibeAviso() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Nome"),
            content: new Text("Informe o nome do contato"),
            actions: <Widget>[
              new ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("Fechar"),
              )
            ],
          );
        });
  }
}
