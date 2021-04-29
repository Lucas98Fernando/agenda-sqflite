// Classe modelo
class Contato {
  int id;
  String nome;
  String email;
  String imagem;

  // Construtor
  Contato(this.id, this.nome, this.email, this.imagem);

  // Função para converter objeto modelo para Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nome': nome,
      'email': email,
      'imagem': imagem
    };
    return map;
  }

  // Função com o caminho inverso, convetendo de Map para um objeto
  Contato.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    email = map['email'];
    imagem = map['imagem'];
  }

  // Método para testar sem uma interface pronta, para poder ver os resultados, não é obrigatório
  @override
  String toString() {
    return 'Contato => (id: $id, nome: $nome, email: $email, imagem: $imagem)';
  }
}
