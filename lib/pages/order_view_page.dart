import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../const.dart';
import '../models/order_model.dart';
import '../service/Utilities.dart';
import '../utils/styles.dart';

class OrderViewPage extends StatefulWidget{
  const OrderViewPage({super.key});

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderViewPage>{
  List<Order> orders = [];
  final Utilities utilities = Utilities();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final fetchedOrders = await utilities.fetchOrders();
    setState(() {
      orders = fetchedOrders;
    });
  }

  Future<void> deleteOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String userId = prefs.getString("userId")!;
    Uri uri = Uri.parse("http://10.0.2.2:8080/api/v1/order/users/$userId/$orderId/deleteOrder");
    final response = await http.delete(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      setState(() {
        fetchOrders();
      });
    } else {
      throw Exception('Failed to delete order');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Styles.highlightColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: black.withOpacity(0.7),
            size: 18,
          ),
        ),
        title: Text(
          'Your Orders',
          style: poppin.copyWith(
              fontSize: 18, color: black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.only(top: 30,bottom: 10,),
                child: Column(
                  children: List.generate(
                      orders.length,
                          (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Container(
                          decoration: BoxDecoration(
                            color: grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Slidable(
                            endActionPane: ActionPane(
                              extentRatio: 0.15,
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                    onPressed: (context) {
                                      deleteOrder(orders[index].id!);
                                    },
                                    icon: Icons.delete,
                                    foregroundColor: Colors.red,
                                    autoClose: true,
                                    backgroundColor: grey.withOpacity(0.1),
                                    borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(20),
                                    ),
                                  )
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(3, 3),
                                          color: black.withOpacity(0.2),
                                          spreadRadius: 3,
                                          blurRadius: 2)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                orders[index].isCompleted==1? Icons.check_circle : orders[index].isCompleted==0? Icons.delivery_dining_rounded : orders[index].isCompleted==2? Icons.cancel : null,
                                                color: Colors.cyan,
                                              ),
                                              const Gap(5),
                                              Text(
                                                orders[index].isCompleted==1? 'Delivered' : orders[index].isCompleted==0? 'Delivering' : orders[index].isCompleted==2? 'Canceled' : '',
                                                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.cyan),
                                              ),
                                              Text(
                                                ' - ${orders[index].dateOrder!}',
                                                  style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.cyan),
                                              )
                                            ],
                                          ),
                                          const Gap(5),
                                          Row(
                                            children: [
                                              const Gap(5),
                                              Text(
                                                '${orders[index].address}, ${orders[index].city}, ${orders[index].country}',
                                                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                                              )
                                            ],
                                          ),
                                          const Gap(5),
                                          Row(
                                            children: [
                                              const Gap(5),
                                              Text(
                                                '\$${orders[index].orderPrice}',
                                              style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                ' - ${orders.length}',
                                                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                orders.length<2? ' item' : ' items',
                                                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}