
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../model/pontoTuristico.dart';
import '../pages/mapa_interno.dart';

class ConteudoFormDialog extends StatefulWidget{
  final PontoTuristico? turismoAtual;

  ConteudoFormDialog({Key? key, this.turismoAtual}) : super (key: key);


  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();

}
class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  Position? _localizacaoAtual;
  final _controller = TextEditingController();

  String get _latitude => _localizacaoAtual?.latitude.toString() ?? '';

  String get _longitude => _localizacaoAtual?.longitude.toString() ?? '';

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaooController = TextEditingController();
  final _diferenciaisController = TextEditingController();
  final _dataController = TextEditingController();
  final _longetudeController = TextEditingController();
  final _latitudeController = TextEditingController();
 /* final _dateFormat = DateFormat('dd/MM/yyyy'); */


  @override
  void initState(){

    super.initState();
    if (widget.turismoAtual != null){
      _nomeController.text = widget.turismoAtual!.nome;
      _diferenciaisController.text = widget.turismoAtual!.diferenciais;
      _descricaooController.text = widget.turismoAtual!.descricaoo;
      _dataController.text = widget.turismoAtual!.dataCadastroFormatado;
      _longetudeController.text = widget.turismoAtual!.longetude;
      _latitudeController.text = widget.turismoAtual!.latitude;

     // horaControllerController.text =formattedDate;

    }
  }


  Widget build(BuildContext context){
    return Form(
        key: _formKey,
        child: SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe o Nome';
                }
                return null;
              },

            ),
            TextFormField(
              controller: _descricaooController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe a descrição';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _diferenciaisController,
              decoration: InputDecoration(labelText: 'Diferenciais'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe os Diferenciais';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _obterLocalizacaoAtual,
              child: Text('Obter Localização'),
            ),
           Text('Latitude: ${widget.turismoAtual?.latitude ?? _latitude}  |  Longitude: ${widget.turismoAtual?.longetude ?? _longitude}'
           ),

            ElevatedButton(
              onPressed: _abrirCoordenadasNoMapaExterno,
              child: Row(
                children: [
                  Icon(Icons.map),
                  SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                  Text('Mapa Externo'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _abrirCoordenadasNoMapaInterno,
              child: Row(
                children: [
                  Icon(Icons.map),
                  SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                  Text('Mapa Interno'),
                ],
              ),
            )
          ],
        )
        )
    );
    
    
  }

  bool dadosValidos() => _formKey.currentState?.validate() == true;

  PontoTuristico get novoTurismo => PontoTuristico(
      id: widget.turismoAtual?.id ?? 0,
      nome: _nomeController.text,
      descricaoo: _descricaooController.text,
      diferenciais: _diferenciaisController.text,
      latitude: _latitude,
      longetude: _longitude,
      dataCadastro: DateTime.now()
  );

  void _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await _servicoHabilitado();
    if(!servicoHabilitado){
      return;
    }
    bool permissoesPermitidas = await _permissoesPermitidas();
    if(!permissoesPermitidas){
      return;
    }
    _localizacaoAtual = await Geolocator.getCurrentPosition();
    setState(() {

    });

  }

  Future<bool> _permissoesPermitidas() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if(permissao == LocationPermission.denied){
      permissao = await Geolocator.requestPermission();
      if(permissao == LocationPermission.denied){
        _mostrarMensagem('Não será possível utilizar o recusro por falta de permissão');
        return false;
      }
    }
    if(permissao == LocationPermission.deniedForever){
      await _mostrarMensagemDialog(
          'Para utilizar esse recurso, você deverá acessar as configurações '
              'do appe permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;

  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilotado = await Geolocator.isLocationServiceEnabled();
    if(!servicoHabilotado){
      await _mostrarMensagemDialog('Para utilizar esse recurso, você deverá habilitar o serviço de localização '
          'no dispositivo');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  void _mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _mostrarMensagemDialog(String mensagem) async{
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  void _abrirCoordenadasNoMapaExterno() {
    if (_longitude.isEmpty || _latitude.isEmpty) {
      return;
    }
    MapsLauncher.launchCoordinates(double.parse(_latitude), double.parse(_longitude));
  }

  void _abrirCoordenadasNoMapaInterno(){
    if( _latitude == null || _longitude == null){
      return;
    }
    Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) => MapaPage(
          latitude: double.parse(_latitude), longitude: double.parse(_longitude)
      ),
      ),
    );
  }


}