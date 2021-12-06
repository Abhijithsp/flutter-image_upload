import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carwash_flutter_app/Models/BranchModel.dart';
import 'package:carwash_flutter_app/Models/StockBranchDetailsModel.dart';
import 'package:carwash_flutter_app/Utils/Constants.dart';
import 'package:carwash_flutter_app/Utils/SharedPrefrence.dart';
import 'package:carwash_flutter_app/Utils/Urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../NavbarScreen.dart';
class AddStock extends StatefulWidget {
  const AddStock({Key key}) : super(key: key);

  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {

  bool isprocesscomplete=false;
  bool showkg=false;
  bool showlitre=false;
  bool showcountbale=false;
  bool showbranch=false;
  bool showicon=false;
 String user_selected_branch_name;
  String user_selected_branch_id;
  List<BranchModel> branch_model = [];
  List<StockBranchDetailsModel> list_branch_details = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int dropDownValue;
  int list_branch_details_count = 0;
  TextEditingController StocknameController = TextEditingController();
  TextEditingController kgController = TextEditingController();
  TextEditingController mgController = TextEditingController();
  TextEditingController litreController = TextEditingController();
  TextEditingController miliController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController branchcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future stationData = SharedPrefrence().getStationID();
    Future roleData = SharedPrefrence().getRoleId();
    Future tokenData = SharedPrefrence().getToken();
    Future LoginId = SharedPrefrence().getLoginId();
    roleData.then((roledata) async {
      stationData.then((data) async {
        tokenData.then((tokendata) async {
          LoginId.then((loginid) async {
            var stationid = data;
            var roleid = roledata;
            var token = tokendata;
            var login_id = loginid;
            if (stationid != "null") {
              getBranches(stationid, roleid, token);
            } else {
              getBranches(login_id, roleid, token);
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        drawer: NavbarScreen(),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Add Stocks",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: 'Roboto'),
          ),
          backgroundColor: Colors.blueAccent[200],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations
                    .of(context)
                    .openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(),
                  child: TextField(
                    controller: StocknameController,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Stocks Name",
                      fillColor: Colors.blueGrey[200],
                      labelStyle:
                      TextStyle(fontSize: 13, color: kPrimaryColor),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blueGrey)),
                  child: DropdownButton(
                    isExpanded: true,
                    itemHeight: 50,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 40,
                    underline: SizedBox(),
                    hint: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Select Unit"),
                    ),
                    value: dropDownValue,
                    onChanged: (int newVal){
                      print(newVal);
                      setState(() {
                        dropDownValue = newVal;
                        if(newVal==1){
                          showkg=true;
                          showbranch=true;
                          showicon=true;
                          showlitre=false;
                          showcountbale=false;

                        }else if(newVal==2){
                          showlitre=true;
                          showbranch=true;
                          showicon=true;
                          showkg=false;
                          showcountbale=false;
                        }else if(newVal==3){
                          showlitre=false;
                          showkg=false;
                          showcountbale=true;
                          showbranch=true;
                          showicon=true;
                        }else{
                          showkg=false;
                          showlitre=false;
                          showcountbale=false;
                          showbranch=false;
                          showicon=false;
                        }
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Kilogram | Gram'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Liter | Milli Liter'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Countable'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                width: 360,
                height: 65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Branch Details",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: GestureDetector(
                        onTap: () {
                          list_branch_details.add(StockBranchDetailsModel('select', '0', '0','0','0','0'));
                          setState(() {
                            list_branch_details_count=list_branch_details.length;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                          child: Row(
                            children: [
                              Image.asset("assets/images/plus-square.png"),
                              Text(
                                "Add New",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'Roboto'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                color: Colors.blueAccent[200],
                child: Row(
                  children: [
                    Visibility(visible:showbranch,child: Expanded(child: Center(child: Text('Branch', style: TextStyle(color: Colors.white),),), flex: 3,)),
                    Visibility(visible: showkg,child: Expanded(child: Center(child: Text('KG', style: TextStyle(color: Colors.white),),), flex: 3,)),
                    Visibility(visible: showkg,child: Expanded(child: Center(child: Text('GM', style: TextStyle(color: Colors.white),),), flex: 3,)),
                    Visibility(visible: showlitre,child: Expanded(child: Center(child: Text('LTR', style: TextStyle(color: Colors.white),),), flex: 3,)),
                    Visibility(visible: showlitre,child: Expanded(child: Center(child: Text('ML', style: TextStyle(color: Colors.white),),), flex: 3,)),
                    Visibility(visible: showcountbale,child: Expanded(child: Center(child: Text('Count', style: TextStyle(color: Colors.white),),), flex: 3,)),
                    Expanded(child: Center(child: Text('', style: TextStyle(color: Colors.white),),), flex: 1,),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: list_branch_details_count,
                itemBuilder: (context, position) {
                  return Padding(padding: EdgeInsets.only(top: 8),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        children: [

                          Visibility(
                            visible: showbranch,
                            child: Expanded(child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 35,
                                  decoration: BoxDecoration(),
                                  child: TextField(
                                    controller: branchcontroller,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Branch",
                                      fillColor: Colors.blueGrey[200],
                                      labelStyle:
                                      TextStyle(fontSize: 13, color: kPrimaryColor),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                showBrancheAlert(position);
                              },
                            ), flex: 5,),
                          ),

                          Visibility(
                            visible: showkg,
                            child: Expanded(child: GestureDetector(
                              child: Container(
                                width: double.infinity,
                                height: 35,
                                decoration: BoxDecoration(),
                                child: Text(list_branch_details[position].kg),
                              ),
                              onTap: () {
                                // showServiceTypeAlert(position);
                              },
                            ), flex: 2,),
                          ),
                          Visibility(
                            visible: showkg,
                            child: Expanded(child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(),
                                  child: Text(list_branch_details[position].mg),
                                ),
                              ),
                              onTap: () {
                                // showPriceInputAlert(position);
                              },
                            ), flex: 2,),
                          ),
                          Visibility(
                            visible: showlitre,
                            child: Expanded(child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(),
                                  child: Text(list_branch_details[position].litre),
                                ),
                              ),
                              onTap: () {
                                // showInputAlert(position);
                              },
                            ), flex: 2,),
                          ),
                          Visibility(
                            visible: showlitre,
                            child: Expanded(child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(),
                                  child: Text(list_branch_details[position].mlil),
                                ),
                              ),
                              onTap: () {
                                showInputAlert(position);
                              },
                            ), flex: 2,),
                          ),
                          Visibility(
                            visible: showcountbale,
                            child: Expanded(child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(),
                                  child: Text(list_branch_details[position].count),
                                ),
                              ),
                              onTap: () {
                                showInputAlert(position);
                              },
                            ), flex: 2,),
                          ),

                          Visibility(
                            visible: showicon,
                            child: Expanded(child: GestureDetector(
                              child: Container(
                                width: 25,
                                height: 25,
                                child: Icon(
                                  Icons.close, color: Colors.white, size: 15,),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueAccent[200]),
                              ),
                              onTap: () {
                                    setState(() {
                                      list_branch_details.removeAt(position);
                                      list_branch_details_count = list_branch_details.length;
                                      showkg=false;
                                      showlitre=false;
                                      showcountbale=false;
                                      showbranch=false;
                                      showicon=false;
                                    });
                              },
                            ), flex: 1,),
                          )
                        ],
                      ),
                    ),);
                },
              ),
              SizedBox(height: 45,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: GestureDetector(
                  child: Container(
                    height: 45,
                    width: 160,
                    child: Center(
                      child: _progressButton(),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: new LinearGradient(
                        colors: [
                          Color.fromARGB(255, 45, 120, 234),
                          Color.fromARGB(255, 89, 149, 240)
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Future stationData = SharedPrefrence().getStationID();
                    Future LoginId = SharedPrefrence().getLoginId();
                    Future tokenData = SharedPrefrence().getToken();
                      stationData.then((data) async {
                        tokenData.then((tokendata) async {
                          LoginId.then((loginid) async {
                            var stationid = data;
                            var token = tokendata;
                            var login_id = loginid;
                            if (stationid != "null") {
                              addstocks(stationid, dropDownValue.toString(),StocknameController.text.toString(), token, list_branch_details);
                            } else {
                              addstocks(stationid, dropDownValue.toString(),StocknameController.text.toString(), token, list_branch_details);
                            }
                          });
                        });
                      });

                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showInputAlert(int position){
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: Text('Country List'),
            content: Container(
                height: 150.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: Center(
                    child: Align(
                      alignment: Alignment.center,
                      child:  Column(
                        children: [
                          TextField(
                              onChanged: (value) {},
                              controller: _textFieldController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: "KG")),
                          SizedBox(height: 10,),
                          FlatButton(onPressed: (){
                            setState(() {
                              list_branch_details[position].kg = _textFieldController.text.toString();
                            });
                            Navigator.pop(context);
                          }, child: Text('OK',style: TextStyle(color: Colors.white),),color: Colors.blueAccent[200],)

                        ],
                      ),
                    )
                )
            ),
          );
        });
  }


  Widget showBrancheAlert(int position) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: Text('Country List'),
            content: Container(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: branch_model.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(branch_model[index].name),
                    onTap: (){
                      setState(() {
                        branchcontroller.text = branch_model[index].name;
                        user_selected_branch_id = branch_model[index].id;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        });
  }


  Future<void> addstocks(String station_id, String unit,String name, String token,List<StockBranchDetailsModel> list) async{

    var response = await http.post(Uri.parse(Urls.STOCKS),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          "station_id": station_id,
          "name": name,
          "unit": unit,
          "branches": list,
        }));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

  }

  Widget _progressButton() {
    if (isprocesscomplete != false) {
      return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    } else {
      return new Text(
        "Submit",
        style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto'),
      );
    }
  }


  Future<String> getBranches(String station_id, String role_id, String token) async {

    EasyLoading.show(status: 'loading...');
    try {
      var response = await http.get(
        Uri.parse(Urls.BRANCHS + "?role_id=$role_id&station_id=$station_id"),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token',
        },
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      EasyLoading.dismiss();
      Map<String, dynamic> value = json.decode(response.body);
      var message = value['message'];
      var branchObj = value['data']['stations']['data'];

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        if (branchObj.length > 0) {
          EasyLoading.dismiss();
          for (int i = 0; i < branchObj.length; i++) {
            var obj = branchObj[i];
            branch_model.add(BranchModel(
              obj['id'].toString(),
              obj['stationId'].toString(),
              obj['branchId'].toString(),
              obj['name'].toString(),
              obj['username'].toString(),
              obj['email'].toString(),
              obj['phone'].toString(),
              obj['location'].toString(),
              obj['address'].toString(),
              obj['emailVerifiedAt'].toString(),
              obj['roleId'].toString(),
              obj['planId'].toString(),
              obj['planValidity'].toString(),
              obj['planAccessory'].toString(),
              obj['planAndroid'].toString(),
              obj['planIos'].toString(),
              obj['planAddBranches'].toString(),
              obj['planStockManagement'].toString(),
              obj['planAmount'].toString(),
              obj['plannedDate'].toString(),
              obj['expireDate'].toString(),
              obj['planExpire'].toString(),
              obj['logo'].toString(),
            ));
          }
          setState(() {

            EasyLoading.dismiss();
          });
        } else {
          EasyLoading.dismiss();
          final snackBar = SnackBar(content: Text("No Data Available"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        EasyLoading.dismiss();
        final snackBar = SnackBar(
            content: Text("Failed to fetch data ${response.statusCode}"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      final snackBar = SnackBar(content: Text("No Internet connection 😑"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on TimeoutException catch (e) {
      EasyLoading.dismiss();
      final snackBar = SnackBar(content: Text("Timeout 😑"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {}
  }


}



class StockBranchDetailsModel{
  var branch,kg,mg,litre,mlil,count;

  StockBranchDetailsModel(this.branch, this.kg, this.mg,this.litre,this.mlil,this.count);
}
