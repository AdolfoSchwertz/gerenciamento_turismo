import 'package:intl/intl.dart';

class PontoTuristico{

  static const nomeTabela = 'ponto_turistico';
  static const campoId = 'id';
  static const campoNome = 'nome';
  static const campoDescricao = 'descricao';
  static const campoData = 'data';
  static const campoDiferenciais = 'diferenciais';
 // static const campoFinalizada = 'finalizada';
  static const campoLongetude = 'longetude';
  static const campoLatitude = 'latitude';
  static const campoCep = 'cep';

  int? id;
  String nome;
  String descricaoo;
  String diferenciais;
  DateTime? dataCadastro = DateTime.now();
//  bool finalizada;
  String longetude;
  String latitude;
  String cep;

  PontoTuristico({
    required this.id,
    required this.nome,
    required this.descricaoo,
    required this.diferenciais,
    required this.latitude,
    required this.longetude,
    required this.cep,
    //this.finalizada = false,
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
    campoId: id == 0 ? null: id,
    campoNome: nome,
    campoDescricao: descricaoo,
    campoDiferenciais: diferenciais,
    campoData:
    dataCadastro == null ? null : DateFormat("yyyy-MM-dd").format(dataCadastro!),
    campoLatitude:latitude,
    campoLongetude:longetude,
    campoCep:cep

    //campoFinalizada: finalizada ? 1 : 0
  };

  factory PontoTuristico.fromMap(Map<String, dynamic> map) => PontoTuristico(
    id: map[campoId] is int ? map[campoId] : null,
    descricaoo: map[campoDescricao] is String ? map[campoDescricao] : '',
    diferenciais: map[campoDiferenciais] is String ? map[campoDiferenciais] : '',
    latitude: map[campoLatitude] is String ? map[campoLatitude] : '',
    longetude: map[campoLongetude] is String ? map[campoLongetude] : '',
    nome: map[campoNome] is String ? map[campoNome] : '',
    cep: map[campoCep] is String ? map[campoCep] : '',
    dataCadastro: map[campoData] is String
        ? DateFormat("yyyy-MM-dd").parse(map[campoData])
        : null,
   // finalizada: map[campoFinalizada] == 1,
  );






}