import 'package:flutter/material.dart';

class NoteTimeLineItemWidget extends StatelessWidget {
  const NoteTimeLineItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 2.0,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.green, Colors.yellow],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(children: const [
                      Text("Text...1"),
                      Text("Text...2"),
                      Text("Text...1"),
                      Text("Text...2")
                    ])
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
