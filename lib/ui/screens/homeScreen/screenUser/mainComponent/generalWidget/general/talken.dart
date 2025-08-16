import 'package:flutter/material.dart';

class Special extends StatelessWidget {
  const Special({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
              ),
              Text("Voting opinion",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,),
              const SizedBox(height: 10),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10,
                              left: 15,
                              right: 10,
                              bottom: 3),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight:
                                Radius.circular(20),
                                topLeft:
                                Radius.circular(20),
                                topRight:
                                Radius.circular(20)),
                            color: Color(0x6fa6a3a3),
                          ),
                          child: Text(
                            "A" * 10,
                            style: const TextStyle(
                                fontSize: 18),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 5,
                                  left: 15,
                                  right: 5,
                                  bottom: 3),
                              padding:
                              const EdgeInsets.all(5),
                              decoration:
                              const BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(
                                        20),
                                    bottomLeft:
                                    Radius.circular(
                                        20),
                                    topLeft:
                                    Radius.circular(
                                        0),
                                    topRight:
                                    Radius.circular(
                                        20)),
                                color: Color(0x6fa6a3a3),
                              ),
                              child: const Text(
                                "520",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration:
                              const BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(
                                        20),
                                    bottomLeft:
                                    Radius.circular(
                                        20),
                                    topLeft:
                                    Radius.circular(
                                        0),
                                    topRight:
                                    Radius.circular(
                                        20)),
                                color: Colors.green,
                              ),
                              child: const Center(
                                  child: Icon(
                                    Icons.lightbulb_outlined,
                                    color: Colors.white,
                                    size: 15,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10,
                              left: 15,
                              right: 10,
                              bottom: 3),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight:
                                Radius.circular(20),
                                topLeft:
                                Radius.circular(20),
                                topRight:
                                Radius.circular(20)),
                            color: Color(0x6fa6a3a3),
                          ),
                          child: Text(
                            "A" * 10,
                            style: const TextStyle(
                                fontSize: 18),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 5,
                                  left: 15,
                                  right: 5,
                                  bottom: 3),
                              padding:
                              const EdgeInsets.all(5),
                              decoration:
                              const BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(
                                        20),
                                    bottomLeft:
                                    Radius.circular(
                                        20),
                                    topLeft:
                                    Radius.circular(
                                        0),
                                    topRight:
                                    Radius.circular(
                                        20)),
                                color: Color(0x6fa6a3a3),
                              ),
                              child: const Text(
                                "520",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration:
                              const BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(
                                        20),
                                    bottomLeft:
                                    Radius.circular(
                                        20),
                                    topLeft:
                                    Radius.circular(
                                        0),
                                    topRight:
                                    Radius.circular(
                                        20)),
                                color: Colors.green,
                              ),
                              child: Center(
                                  child: Icon(
                                    Icons.lightbulb_outlined,
                                    color: Colors.white,
                                    size: 15,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10,
                              left: 15,
                              right: 10,
                              bottom: 3),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight:
                                Radius.circular(20),
                                topLeft:
                                Radius.circular(20),
                                topRight:
                                Radius.circular(20)),
                            color: Color(0x6fa6a3a3),
                          ),
                          child: Text(
                            "A" * 100,
                            style: const TextStyle(
                                fontSize: 18),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 5,
                                  left: 15,
                                  right: 5,
                                  bottom: 3),
                              padding:
                              const EdgeInsets.all(5),
                              decoration:
                              const BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(
                                        20),
                                    bottomLeft:
                                    Radius.circular(
                                        20),
                                    topLeft:
                                    Radius.circular(
                                        0),
                                    topRight:
                                    Radius.circular(
                                        20)),
                                color: Color(0x6fa6a3a3),
                              ),
                              child: const Text(
                                "520",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration:
                              const BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(
                                        20),
                                    bottomLeft:
                                    Radius.circular(
                                        20),
                                    topLeft:
                                    Radius.circular(
                                        0),
                                    topRight:
                                    Radius.circular(
                                        20)),
                                color: Colors.green,
                              ),
                              child: Center(
                                  child: Icon(
                                    Icons.lightbulb_outlined,
                                    color: Colors.white,
                                    size: 15,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10,
                              left: 15,
                              right: 10,
                              bottom: 3),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight:
                                Radius.circular(20),
                                topLeft:
                                Radius.circular(20),
                                topRight:
                                Radius.circular(20)),
                            color: Color(0x6fa6a3a3),
                          ),
                          child: Text(
                            "A" * 100,
                            style: const TextStyle(
                                fontSize: 18),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 5,
                                  left: 15,
                                  right: 5,
                                  bottom: 3),
                              padding:
                              const EdgeInsets.all(5),
                              decoration:
                              const BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(
                                        20),
                                    bottomLeft:
                                    Radius.circular(
                                        20),
                                    topLeft:
                                    Radius.circular(
                                        0),
                                    topRight:
                                    Radius.circular(
                                        20)),
                                color: Color(0x6fa6a3a3),
                              ),
                              child: const Text(
                                "520",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration:
                              const BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(
                                        20),
                                    bottomLeft:
                                    Radius.circular(
                                        20),
                                    topLeft:
                                    Radius.circular(
                                        0),
                                    topRight:
                                    Radius.circular(
                                        20)),
                                color: Colors.green,
                              ),
                              child: Center(
                                  child: Icon(
                                    Icons.lightbulb_outlined,
                                    color: Colors.white,
                                    size: 15,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(20),
                height: 4,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(20)),
                    color: Colors.red,
                  ),
                  child: const Center(
                    child: Text(
                      'Exist',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
