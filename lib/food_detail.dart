import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfd_flutter/food_item_model.dart';
import 'package:provider/provider.dart';

class FoodDetails extends StatefulWidget {
  final String foodImgPath;
  final String foodName;
  final List foodOption;
  final double foodPrice;

  const FoodDetails(
      {super.key,
      required this.foodImgPath,
      required this.foodName,
      required this.foodOption,
      required this.foodPrice});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  bool normalsize = true;
  int quantity = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9CF00),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9CF00),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            Navigator.pop(context);
          },
          child: Image.asset(
            'images/BackArrowBlack.png',
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: SizedBox(
                width: 340,
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1,
              decoration: const BoxDecoration(
                color: Color(0xFF272D2F),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      child: Image.asset(
                        widget.foodImgPath,
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFF9CF00),
                            width: 3,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical:
                                MediaQuery.of(context).size.height * 0.03),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Center(
                            child: Text(
                              widget.foodName,
                              style: const TextStyle(
                                  color: Color(0xFFF9CF00),
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Quantity of ${widget.foodOption[0]}",
                        style: const TextStyle(
                            color: Color(0xFFF9CF00),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: RadioListTile<bool>(
                      title: Text(
                        widget.foodOption[2],
                        style: const TextStyle(color: Color(0xFFF9CF00)),
                      ),
                      value: true,
                      groupValue: normalsize,
                      onChanged: (value) => setState(
                        () {
                          normalsize = true;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: RadioListTile(
                      title: Text(
                        widget.foodOption[1],
                        style: const TextStyle(color: Color(0xFFF9CF00)),
                      ),
                      value: false,
                      groupValue: normalsize,
                      onChanged: (value) => setState(
                        () {
                          normalsize = false;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: FloatingActionButton(
                              heroTag: "Remove Cups",
                              onPressed: () {
                                setState(() {
                                  if (quantity > 0) {
                                    quantity--;
                                  }
                                });
                              },
                              backgroundColor: const Color(0xFFF9CF00),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.remove,
                                size: MediaQuery.of(context).size.width * 0.06,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Center(
                              child: Text(
                                "x$quantity",
                                style: const TextStyle(
                                    color: Color(0xFFF9CF00), fontSize: 15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: FloatingActionButton(
                              heroTag: "Add Cups",
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              backgroundColor: const Color(0xFFF9CF00),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.add,
                                size: MediaQuery.of(context).size.width * 0.06,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF9CF00),
                                shape: const StadiumBorder()),
                            onPressed: () {
                              List Item = [];
                              Provider.of<FoodItemModel>(context, listen: false)
                                  .addItemsToCart(quantity, widget.foodName,
                                      widget.foodPrice);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Add to cart',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
