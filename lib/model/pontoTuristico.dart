import 'package:intl/intl.dart';

class PontoTuristico{

  static const nomeTabela = 'ponto turistico';
  static const campoId = 'id';
  static const campoNome = 'nome';
  static const campoDescricao = 'descricao';
  static const campoData = 'data';
  static const campoDiferenciais = 'diferenciais';

  int? id;
  String nome;
  String descricaoo;
  String diferenciais;
  DateTime? dataCadastro = DateTime.now();

  PontoTuristico({
    this.id,
    required this.nome,
    required this.descricaoo,
    required this.diferenciais,
    this.dataCadastro});

  String get dataCadastroFormatado{
    // if (horaCadastro == null){
    //   return ' ';
    // }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }

  Map<String, dynamic> toMap() => {
    campoId: id,
    campoNome: nome,
    campoDescricao: descricaoo,
    campoDiferenciais: diferenciais,
    campoData:
    dataCadastro == null ? null : DateFormat("yyyy-MM-dd").format(dataCadastro!)
  };

  factory PontoTuristico.fromMap(Map<String, dynamic> map) => PontoTuristico(
    id: map[campoId] is int ? map[campoId] : null,
    descricaoo: map[campoDescricao] is String ? map[campoDescricao] : '',
    diferenciais: map[campoDiferenciais] is String ? map[campoDiferenciais] : '',
    nome: map[campoNome] is String ? map[campoNome] : '',
    dataCadastro: map[campoData] is String
        ? DateFormat("yyyy-MM-dd").parse(map[campoData])
        : null,
  );






}