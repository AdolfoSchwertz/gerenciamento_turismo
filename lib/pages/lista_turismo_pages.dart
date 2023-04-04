
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_turismomd/model/pontoTuristico.dart';
import 'package:gerenciamento_turismomd/pages/filtro_page.dart';

import '../widgets/conteudo_form_dialog.dart';

class ListaTurismoPage extends StatefulWidget{

  @override
  _ListaTurismosPageState createState() => _ListaTurismosPageState();

}
class _ListaTurismosPageState extends State<ListaTurismoPage>{

  static const ACAO_EDITAR = 'Editar';
  static const ACAO_EXCLUIR = 'Excluir';
  static const ACAO_VISUALIZAR = 'visualizar';

  final turismos = <PontoTuristico>
  [
    //Tarefa(id: 1,
    // descricao: 'Fazer atividades da aula',
    // prazo: DateTime.now().add(Duration(days: 5)),
    // )
  ];

  var _ultimoId = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo ponto turistico',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _abrirForm({PontoTuristico? turismoAtual, int? index, bool? readonly}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(turismoAtual == null ? 'Nova Ponto Turistico' : 'Alterar o Ponto Turistico ${turismoAtual.id}'),
            content: ConteudoFormDialog(key: key, turismoAtual: turismoAtual),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
            if (readonly == null || readonly == false)
              TextButton(
                onPressed: () {
                  if (key.currentState != null && key.currentState!.dadosValidados()){
                    setState(() {
                      final novoTurismo = key.currentState!.novoTurismo;
                      if(index == null){
                        novoTurismo.id = ++_ultimoId;
                      }else{
                        turismos[index] = novoTurismo;
                      }
                      turismos.add(novoTurismo);
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          );
        }
    );
  }
  AppBar _criarAppBar(){
    return AppBar(
      title: const Text('Gerenciador de Pontos Turisticos'),
      actions: [
        IconButton(
            onPressed: _abrirPaginaFiltro,
            icon: const Icon(Icons.filter_list)),
      ],
    );
  }
  Widget _criarBody(){
    if( turismos.isEmpty){
      return const Center(
        child: Text('Nenhum ponto cadastrado',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.separated(
      itemCount: turismos.length,
      itemBuilder: (BuildContext context, int index){
        final turismo = turismos[index];
        return PopupMenuButton<String>(
            child: ListTile(
              title: Text('${turismo.id} - ${turismo.nome}'),
              subtitle: Text(turismo.dataCadastro == null ? 'Tarefa sem prazo definido' : 'Data de Cadastro - ${turismo.dataCadastroFormatado}'),
            ),
            itemBuilder: (BuildContext context) => _criarItensMenu(),
            onSelected: (String valorSelecinado){
              if(valorSelecinado == ACAO_EDITAR){
                _abrirForm(turismoAtual: turismo, index: index, readonly: false);
              }else if(valorSelecinado == ACAO_VISUALIZAR){
                _abrirForm(turismoAtual: turismo, index: index, readonly: true);
              }else{
                _excluir(index);
              }
            }
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
  void _excluir(int indice){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red,),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                )
              ],
            ),
            content: Text('Esse registro será deletado permanentemente'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      turismos.removeAt(indice);
                    });
                  },
                  child: Text('OK')
              )
            ],
          );
        }
    );

  }



  List<PopupMenuEntry<String>> _criarItensMenu(){
    return[
      PopupMenuItem(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('EDITAR'),
            )
          ],
        ),
      ),

      PopupMenuItem(
        value: ACAO_VISUALIZAR,
        child: Row(
          children: [
            Icon(Icons.visibility, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('visualizar'),
            )
          ],
        ),
      ),

      PopupMenuItem(
        value: ACAO_EXCLUIR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            )
          ],
        ),
      )
    ];
  }

  void _visualizar() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.routeName).then((alterouValores) {
      if (alterouValores == true) {
      }
    });
  }

  void _abrirPaginaFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.routeName).then((alterouValores){
      if( alterouValores == true){
        ///filtro
      }
    }

    );

  }

}
