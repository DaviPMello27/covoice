import 'package:covoice/controller/config_controller_inteface.dart';
import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  final IConfigController configController;
  final void Function() onFinish;
  final bool displayCheckbox;

  const TutorialPage({ required this.configController, required this.onFinish, this.displayCheckbox = true, Key? key }) : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  bool dontShowAgainChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instruções'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Text('Instruções', style: Theme.of(context).textTheme.headline3),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Seja bem vindo aos exercícios práticos de segunda voz. Nestes mini-jogos você irá exercitar a sua sensibilidade auditiva e aperfeiçoar a sua percepção musical!',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Na tela seguinte você verá dois botões principais: O botão de play reproduzirá a música que você deverá cantar, e o botão de microfone reproduzirá a música enquanto grava você cantando.',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.justify,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        width: 2
                      ),
                    ),
                    child: Image.asset('assets/tutorial/buttons_${Theme.of(context).brightness == Brightness.light ? 'light' : 'dark'}.jpeg'),
                  ),
                )
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Para pontuar, você deve cantar as notas corretas, fazendo o indicador branco (ou cinza, dependendo da oitava que você estará cantando) entrar em contato com as linhas destacadas que percorrem a tela da direita para a esquerda.',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.justify,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        width: 2
                      ),
                    ),
                    child: Image.asset('assets/tutorial/notes_${Theme.of(context).brightness == Brightness.light ? 'light' : 'dark'}.jpeg'),
                  ),
                )
              ),

              Visibility(
                child: GestureDetector(
                  onTap:() {
                    setState(() {
                      dontShowAgainChecked = !dontShowAgainChecked;
                    });
                  },
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: dontShowAgainChecked,
                          onChanged: (value){
                            setState(() {
                              dontShowAgainChecked = !dontShowAgainChecked;
                            });
                          }
                        ),
                        Text(
                          'Não mostrar estas instruções novamente',
                          style: Theme.of(context).textTheme.subtitle1
                        ),
                      ],
                    ),
                  ),
                ),
                visible: widget.displayCheckbox,
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: TextButton(
                  onPressed: () async {
                    bool dontShowExerciseTutorialAgainChecked = (await widget.configController.getBoolProperty('dontShowExerciseTutorialAgainChecked')) ?? false;
                    if(!dontShowExerciseTutorialAgainChecked){
                      widget.configController.setBoolProperty('dontShowExerciseTutorialAgainChecked', dontShowAgainChecked);
                    }
                    widget.onFinish();
                  },
                  child: const Text('Prosseguir')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}