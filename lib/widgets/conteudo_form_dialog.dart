
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/pontoTuristico.dart';

class ConteudoFormDialog extends StatefulWidget{
  final PontoTuristico? turismoAtual;

  ConteudoFormDialog({Key? key, this.turismoAtual}) : super (key: key);


  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();

}
class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaooController = TextEditingController();
  final diferenciaisController = TextEditingController();
  final dataController = TextEditingController();
 /* final _dateFormat = DateFormat('dd/MM/yyyy'); */


  @override
  void initState(){

    super.initState();
    if (widget.turismoAtual != null){
      nomeController.text = widget.turismoAtual!.nome;
      diferenciaisController.text = widget.turismoAtual!.diferenciais;
      descricaooController.text = widget.turismoAtual!.descricaoo;
      dataController.text = widget.turismoAtual!.dataCadastroFormatado;

     // horaControllerController.text =formattedDate;

    }
  }


  Widget build(BuildContext context){
    return Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe o Nome';
                }
                return null;
              },

            ),
            TextFormField(
              controller: descricaooController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe a descrição';
                }
                return null;
              },
            ),
            TextFormField(
              controller: diferenciaisController,
              decoration: InputDecoration(labelText: 'Diferenciais'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe os Diferenciais';
                }
                return null;
              },
            ),
            // TextFormField(
            //   controller: prazoController,
            //   decoration: InputDecoration(labelText: 'Data',
            //     prefixIcon: IconButton(
            //       onPressed: _mostrarCalendario,
            //       icon: Icon(Icons.calendar_today),
            //     ),
            //     suffixIcon: IconButton(
            //       onPressed: () => prazoController.clear(),
            //       icon: Icon(Icons.close),
            //     ),
            //   ),
            //   readOnly: true,
            // ),
          ],
        )
    );
    
    
  }

  // void _mostrarCalendario(){
  //   final dataformatada = prazoController.text;
  //   var data = DateTime.now();
  //   if(dataformatada.isNotEmpty){
  //     data= _dateFormat.parse(dataformatada);
  //   }
  //   showDatePicker(
  //       context: context,
  //       initialDate:data,
  //       firstDate: data.subtract(Duration(days:365 * 5)),
  //       lastDate: data.add(Duration(days: 365 * 5)),
  //   ).then((DateTime? dataSelecionada) {
  //     if(dataSelecionada != null){
  //       setState(() {
  //         prazoController.text = _dateFormat.format(dataSelecionada);
  //       });
  //
  //     }
  //   });
  //
  //
  // }
  bool dadosValidados() => formKey.currentState?.validate() == true;

  PontoTuristico get novoTurismo => PontoTuristico(
      id: widget.turismoAtual?.id ?? 0,
      nome: nomeController.text,
      descricaoo: descricaooController.text,
      diferenciais: diferenciaisController.text,
      dataCadastro: DateTime.now()
  );

}