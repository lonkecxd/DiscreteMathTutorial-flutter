import 'package:example_flutter/model/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../charts/vertical_bar.dart';

class AnswerSheetListView extends StatelessWidget {
  const AnswerSheetListView({
    @required this.answerSheetModels,
  });

  final List<AnswerSheetsModel> answerSheetModels;


  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final TextEditingController _textEditingController  = new TextEditingController();

    return ListView.builder(
        itemCount: answerSheetModels.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context,int index){
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Tooltip(
                      message: '判断本步骤是否正确'+(answerSheetModels[index].indicatorColor==Colors.green?'：正确':'：错误'),
                      child: Container(
                        alignment: Alignment.center,
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: VerticalFractionBar(
                          color: answerSheetModels[index].indicatorColor,
                          fraction: answerSheetModels[index].indicatorFraction,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CupertinoTextField(
                                controller: TextEditingController()..text = answerSheetModels[index].answer,
                                onChanged: (text)=>{
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(text),
                                  ))
                                },
                              ),
                              //Another description
                            ],
                          ),
                          //Another text
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(minWidth: 32),
                      padding: EdgeInsetsDirectional.only(start: 12),
                      child: answerSheetModels[index].suffix,
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Colors.black12,
              ),
            ],
          );
          },);
    }
}



/// Data model for [AnswerSheetListView].
class AnswerSheetsModel {
  AnswerSheetsModel({
    this.indicatorColor,
    this.indicatorFraction,
    this.answer,
    this.subtitle,
    this.suffix,
  });

  final Color indicatorColor;
  final double indicatorFraction;
  final String answer;
  final String subtitle;
  final Widget suffix;
  //后面分配给问题
  int problem_id;

  attachToProblemId(int pid){
    this.problem_id = pid;
  }
}



List<AnswerSheetsModel> getDefaultAnswerSheetModelFromData(List<AnswerData> answers,) {
  return List<AnswerSheetsModel>.generate(
    answers.length,
        (i) => AnswerSheetsModel(
          indicatorColor: answers[i].isCorrect?Colors.green:Colors.red,
          indicatorFraction: 1.0,
          answer: answers[i].description,
          subtitle: '',
          suffix: Icon(Icons.playlist_add_check)
        ),
  );
}

