import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart' hide Contact;
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';



class ContactScreen extends StatefulWidget {
  @override
  State<ContactScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ContactScreen> {

//Function to print all contacts
  void printData(var length, AsyncSnapshot snapshot) {
    for(int index = 0; index < length; index++) {
      print('${snapshot.data[index].displayName.toString()} : ${snapshot.data[index].phones.toString()}');
    }
  }
//Function to print all contacts ends

// Firebase work
//   final fireStore = FirebaseFirestore.instance.collection('users');

  bool store = false;


  void storeData(var length, AsyncSnapshot snapshot) {
    // print('Inside storedata');
    for(int index = 0; index < length; index++) {
      // print('$index of storedata, calling createData');
      createData(snapshot.data[index].displayName.toString(), snapshot.data[index].phones.toString());
    }
  }

// Firebase work ends

  createData(String name, String num) {
    // print('called store data for $name');
    DocumentReference documentReference = FirebaseFirestore.instance.collection("Contacts").doc(name);

    Map<String, dynamic> student = {
      "number": num,
      "name": name,
    };

    // readData(name);
    // print('Done');

    documentReference.set(student).whenComplete(() {
      print("$name created");
    });
  }

  // void readData(String id) {
  //   FirebaseFirestore.instance.collection('Contacts').doc(id).get().then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       print('Document data: ${documentSnapshot.data()}');
  //
  //     } else {
  //       print('Document does not exist on the database');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Contact List'),
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColorDark,
          onPressed: () async {
            try {
              await ContactsService.openContactForm();
              // setState(() {
              //
              // });

            } on FormOperationException catch (e) {
              switch (e.errorCode) {
                case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                  print(e.toString());
                  break;
              }
            }
          },
        ),

        body: Container(
          height: double.infinity ,
          child: FutureBuilder<List<Contact>>(
              future: getContacts(),
              builder: (context, AsyncSnapshot snapshot) {
                if(snapshot.data == null) {
                  return const Center(
                    child: SizedBox(
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

//Function to print all contacts
                if(snapshot.data != null) {
                  printData(snapshot.data.length, snapshot);
                }
//Function to print all contacts ends

// Function to store data in database
                if(store == false) {
                  // print('calling storedata');
                  storeData(snapshot.data.length, snapshot);
                  // print('calling storedata end');
                  store = true;
                }
// Function to store data in database

// Widget returning data and displaying contacts of database
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Contacts').snapshots(),
                    builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if(snapshot.hasError) {
                        return Text('Some Error');
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            // return ListTile(
                            //   title: Text(snapshot.data!.docs[index]['studentName'].toString()),
                            // );
                            return ListTile(
                              leading: Container(
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 7,
                                      color: Colors.white.withOpacity(0.1),
                                      offset: const Offset(-3, -3),
                                    ),
                                    BoxShadow(
                                      blurRadius: 7,
                                      color: Colors.black.withOpacity(0.7),
                                      offset: const Offset(3, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(6),
                                  color: Color(0xff262626),
                                ),
                                child: Text(
                                  // contact[index].givenName![0],
                                  snapshot.data!.docs[index]['name'][0].toString(),
                                  style: TextStyle(
                                    fontSize: 23,
                                    // color: Colors.primaries[
                                    //     Random().nextInt(Colors.primaries.length)],
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              title: Text(
                                snapshot.data!.docs[index]['name'].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // style: TextStyle(
                                //   fontSize: 16.sp,
                                //   color: Colors.cyanAccent,
                                //   fontFamily: "Poppins",
                                //   fontWeight: FontWeight.w500,
                                // ),
                              ),
                              subtitle: Text(
                                snapshot.data!.docs[index]['number'].toString(),
                                // style: TextStyle(
                                //   fontSize: 11.sp,
                                //   color: const Color(0xffC4c4c4),
                                //   fontFamily: "Poppins",
                                //   fontWeight: FontWeight.w400,
                                // ),
                              ),
                              horizontalTitleGap: 12,
                            );
                            // ListTile(
                            //   title: Text(snapshot.data!.docs[index]['name'].toString()),
                            //   subtitle: Text(snapshot.data!.docs[index]['number'].toString()),
                            // );
                          },
                        ),
                      );
                    },
                  );
// Widget returning data and displaying contacts of database ends
              }
          ),
        ),
      ),
    );
  }

  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if(!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }

    if(isGranted) {
      return await FastContacts.allContacts;
    }
    return [];
  }

}
