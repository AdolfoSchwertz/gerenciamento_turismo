import 'package:intl/intl.dart';

class PontoTuristico{

  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAOO = 'descricao';
  static const CAMPO_DATA = 'data';
  static const CAMPO_DIFERENCIAIS = 'diferenciais';

  int id;
  String nome;
  String descricaoo;
  String diferenciais;
  DateTime? dataCadastro;

  PontoTuristico({required this.id, required this.nome, required this.descricaoo, required this.diferenciais, this.dataCadastro});

  String get dataCadastroFormatado{
    // if (horaCadastro == null){
    //   return ' ';
    // }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }






}