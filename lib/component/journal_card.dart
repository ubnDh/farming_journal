import 'package:farming_journal/model/journal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalCard extends StatefulWidget {
  Journal journal;
  Function(Journal item)? onViewJournal;
  JournalCard({Key? key, required this.journal, this.onViewJournal}) : super(key: key);
  @override
  State<JournalCard> createState() => _JournalCardState();
}

class _JournalCardState extends State<JournalCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: GestureDetector(
        onTap: (){
          if (widget.onViewJournal != null) {
            widget.onViewJournal!(widget.journal);
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.radio_button_unchecked, size: 15,color: Colors.blue,),
                SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('날짜'),
                        SizedBox(width: 10,),
                        Text(DateFormat("yyyy년 MM월 dd일").format(widget.journal.date), style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Row(
                      children: [
                        Text('작업'),
                        SizedBox(width: 10,),
                        Container(
                          width: 270,
                          child: Text(widget.journal.category.join(', '), style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Container(
                        width: 270,
                        height: 40,
                        child: Text(widget.journal.content, overflow: TextOverflow.ellipsis,)
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
