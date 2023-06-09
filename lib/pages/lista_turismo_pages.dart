import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../model/pontoTuristico.dart';
import '../pages/detalhes_turismo_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dao/turismo_dao.dart';
import '../model/pontoTuristico.dart';
import '../widgets/conteudo_form_dialog.dart';
import 'detalhes_turismo_page.dart';
import 'filtro_page.dart';

class ListaTurismoPage extends StatefulWidget{

  @override
  _ListaTurismoPageState createState() => _ListaTurismoPageState();

}

class _ListaTurismoPageState extends State<ListaTurismoPage> {
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';
  static const ACAO_VISUALIZAR = 'visualizar';

  final _turismos = <PontoTuristico>[];
  final _dao = TurismoDao();
  var _carregando = false;

  @override
  void initState() {
   // super.initState();
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo Ponto Turístico',
        child: const Icon(Icons.add),
        onPressed: _abrirForm,

      ),
    );
  }

  //APP BAR
  AppBar _criarAppBar() {
    return AppBar(
      title: const Text('Gerenciador de Pontos Turísticos'),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filtro e Ordenação',
          onPressed: _abrirPaginaFiltro,
        ),
      ],
    );
  }

  // BODY
  Widget _criarBody() {
    if (_carregando) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Carregando seus pontos turisticos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme
                      .of(context)
                      .primaryColor
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (_turismos.isEmpty) {
      return Center(
        child: Text(
          'Nenhum Ponto Turistico cadastrado',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _turismos.length,
      itemBuilder: (BuildContext context, int index) {
        final turismo = _turismos[index];
        return PopupMenuButton<String>(
          child: ListTile(
         //   leading: Checkbox(
             // value: turismo.finalizada,
           //   onChanged: (bool? checked) {
               // setState(() {
                //  turismo.finalizada = checked == true;
              //  });
             //   _dao.salvar(turismo);
             // },
           // ),
            title: Text(
              '${turismo.id} - ${turismo.nome}',
            //  style: TextStyle(
            //    decoration:
               // turismo.finalizada ? TextDecoration.lineThrough : null,
              //  color: turismo.finalizada ? Colors.grey : null,
             // ),
            ),
            subtitle: Text(turismo.dataCadastro == null
                ? 'Tarefa sem data de inserção'
                : 'Data Cadastro - ${turismo.dataCadastroFormatado}',
              // style: TextStyle(
              //   decoration:
              //   turismo.finalizada ? TextDecoration.lineThrough : null,
              //   color: turismo.finalizada ? Colors.grey : null,
              // ),
            ),
          ),
          itemBuilder: (_) => _criarItensMenuPopup(),
          onSelected: (String valorSelecionado) {
            if (valorSelecionado == ACAO_EDITAR) {
              _abrirForm(turismo: turismo);
            } else if (valorSelecionado == ACAO_EXCLUIR) {
              _excluir(turismo);
            } else {
              _abrirPaginaDetalhesTurismo(turismo);
            }
          },
        );
      },
      separatorBuilder: (_, __) => Divider(),
    );
  }

  List<PopupMenuEntry<String>> _criarItensMenuPopup() => [
    PopupMenuItem(
      value: ACAO_EDITAR,
      child: Row(
        children: const [
          Icon(Icons.edit, color: Colors.black),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('Editar'),
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: ACAO_EXCLUIR,
      child: Row(
        children: const [
          Icon(Icons.delete, color: Colors.red),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('Excluir'),
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: ACAO_VISUALIZAR,
      child: Row(
        children: const [
          Icon(Icons.info, color: Colors.blue),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('Visualizar'),
          ),
        ],
      ),
    ),
  ];

  void _abrirForm({PontoTuristico? turismo}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          turismo == null ? 'Novo Ponto Turistico' : 'Alterar Ponto Turistico ${turismo.id}',
        ),
        content: ConteudoFormDialog(
          key: key,
          turismoAtual: turismo,
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Salvar'),
            onPressed: () {
              if (key.currentState?.dadosValidos() != true) {
                return;
              }
              Navigator.of(context).pop();
              final novoTurismo = key.currentState!.novoTurismo;
              _dao.salvar(novoTurismo).then((success) {
                if (success) {
                  _atualizarLista();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _excluir(PontoTuristico turismo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Atenção'),
            ),
          ],
        ),
        content: Text('Esse registro será removido definitivamente.'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              if (turismo.id == null) {
                return;
              }
              _dao.remover(turismo.id!).then((success) {
                if (success) {
                  _atualizarLista();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _abrirPaginaFiltro() async {
    final navigator = Navigator.of(context);
    final alterouValores = await navigator.pushNamed(FiltroPage.routeName);
    if (alterouValores == true) {
      _atualizarLista();
    }
  }

  void _abrirPaginaDetalhesTurismo(PontoTuristico turismo) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalhesTurismoPage(
            pontoturistico: turismo,
          ),
        ));
  }

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });
    //Carregar os valores do SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao =
        prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? PontoTuristico.campoId;
    final usarOrdemDecrescente =
        prefs.getBool(FiltroPage.chaveUsarOrdemDecrescente) == true;
    final filtroDescricao =
        prefs.getString(FiltroPage.chaveCampoDescricao) ?? '';
    final filtroDiferenciais =
        prefs.getString(FiltroPage.chaveCampoDiferenciais) ?? '';
    final filtroNome =
        prefs.getString(FiltroPage.chaveCampoNome) ?? '';
    final turismos = await _dao.listar(
      filtroDescricao: filtroDescricao,
      filtroDiferenciais: filtroDiferenciais,
      filtroNome: filtroNome,
      campoOrdenacao: campoOrdenacao,
      usarOrdemDecrescente: usarOrdemDecrescente,

    );
    setState(() {
      _turismos.clear();
      _carregando = false;
      if (turismos.isNotEmpty) {
        _turismos.addAll(turismos);
      }
    });
  }
}