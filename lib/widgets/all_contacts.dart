import '../contact_exports.dart';

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

  bool store = false;

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
    getContacts();
    return Scaffold(
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
        child: FutureBuilder<bool>(
            future: getContacts(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return Center(
                  child: Container(
                    color: Colors.pink,
                    height: 50,
                    child: CircularProgressIndicator(

                    ),
                  ),
                );
              }

              // if (snapshot.connectionState != ConnectionState.done)
              else return Container(
                height: 50,
                color: Colors.red,
              );
              // return StreamBuilder<QuerySnapshot>(
              //   stream: FirebaseFirestore.instance.collection('Contacts').snapshots(),
              //   builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if(snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     }
              //     if(snapshot.hasError) {
              //       return Text('Some Error');
              //     }
              //     return Expanded(
              //       child: ListView.builder(
              //         itemCount: snapshot.data!.docs.length,
              //         itemBuilder: (context, index) {
              //           // return ListTile(
              //           //   title: Text(snapshot.data!.docs[index]['studentName'].toString()),
              //           // );
              //           return ListTile(
              //             leading: Container(
              //               height: 30,
              //               width: 30,
              //               alignment: Alignment.center,
              //               decoration: BoxDecoration(
              //                 boxShadow: [
              //                   BoxShadow(
              //                     blurRadius: 7,
              //                     color: Colors.white.withOpacity(0.1),
              //                     offset: const Offset(-3, -3),
              //                   ),
              //                   BoxShadow(
              //                     blurRadius: 7,
              //                     color: Colors.black.withOpacity(0.7),
              //                     offset: const Offset(3, 3),
              //                   ),
              //                 ],
              //                 borderRadius: BorderRadius.circular(6),
              //                 color: Color(0xff262626),
              //               ),
              //               child: Text(
              //                 // contact[index].givenName![0],
              //                 snapshot.data!.docs[index]['name'][0].toString(),
              //                 style: TextStyle(
              //                   fontSize: 23,
              //                   // color: Colors.primaries[
              //                   //     Random().nextInt(Colors.primaries.length)],
              //                   color: Colors.white,
              //                   fontFamily: "Poppins",
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //               ),
              //             ),
              //             title: Text(
              //               snapshot.data!.docs[index]['name'].toString(),
              //               maxLines: 1,
              //               overflow: TextOverflow.ellipsis,
              //               // style: TextStyle(
              //               //   fontSize: 16.sp,
              //               //   color: Colors.cyanAccent,
              //               //   fontFamily: "Poppins",
              //               //   fontWeight: FontWeight.w500,
              //               // ),
              //             ),
              //             subtitle: Text(
              //               snapshot.data!.docs[index]['number'].toString(),
              //               // style: TextStyle(
              //               //   fontSize: 11.sp,
              //               //   color: const Color(0xffC4c4c4),
              //               //   fontFamily: "Poppins",
              //               //   fontWeight: FontWeight.w400,
              //               // ),
              //             ),
              //             horizontalTitleGap: 12,
              //           );
              //           // ListTile(
              //           //   title: Text(snapshot.data!.docs[index]['name'].toString()),
              //           //   subtitle: Text(snapshot.data!.docs[index]['number'].toString()),
              //           // );
              //         },
              //       ),
              //     );
              //   },
              // );
            }
        ),
      ),
    );
  }

  Future<bool> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if(!isGranted) {
     await Permission.contacts.request();
    }

    if(isGranted) {
      var cdata =  await FastContacts.allContacts;

      print("cdata.length");
      print(cdata.length);
      for(int index = 0; index < cdata.length; index++) {
        print(cdata[index].phones[0]);
        print("cdata[index].phones");
        print(cdata[index].displayName);
        print(cdata[index].displayName);
        DocumentReference documentReference = FirebaseFirestore.instance.collection("MyContacts").doc(cdata[index].displayName);

        Map<String, dynamic> student = {
          "number": cdata[index].phones[0],
          "name": cdata[index].displayName,
        };

        documentReference.set(student).whenComplete(() {

        });
      }
      return true;
    }
    return false;
  }

}
