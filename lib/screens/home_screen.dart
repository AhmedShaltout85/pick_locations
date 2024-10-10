import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:pick_locations/model/pick_locations_model.dart';

import '../repos/pick_locations_dio_repos.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  List data = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future getLocs;
  int id = 0;

  @override
  void initState() {
    super.initState();
    getLocs = PickLocationsDioRepos().getLoc();
    getLocs.then((value) => debugPrint(value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          getLocs = PickLocationsDioRepos().getLoc();
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      appBar: AppBar(
        title: const Text('Pick Map Locations',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder(
                  future: getLocs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                       widget.data = snapshot.data;
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Card(
                              child: ListTile(
                                title: Text(snapshot.data![index]['address']
                                    .toString()),
                                subtitle:
                                    Text("${snapshot.data![index]['latitude']},"
                                            "${snapshot.data![index]['longitude']}"
                                        .toString()),
                                leading: CircleAvatar(
                                  radius: 23,
                                  backgroundColor: Colors.blue,
                                  child: Text("${snapshot.data![index]['id']}"),
                                ),
                              ),
                            ),
                            onTap: () {
                              debugPrint("${widget.data[index]['id']}");
                              //CALL API TO UPDATE LOCATION
                              id = widget.data[index]['id'];
                              //copy to clipboard
                              Clipboard.setData(ClipboardData(
                                  // text: widget.data[index]['address']));
                                  text: widget.data[index]['address']));

                              // Show a SnackBar to notify the user that the text is copied
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.black26,
                                  content: Center(
                                    child: Text(
                                      'Text copied to clipboard!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            Expanded(
              flex: 2,
              child: OpenStreetMapSearchAndPick(
                buttonTextStyle:
                    const TextStyle(fontSize: 14, fontStyle: FontStyle.normal),
                buttonColor: Colors.blue,
                buttonText: 'Set Current Location',
                onPicked: (pickedData) async {
                  debugPrint(pickedData.latLong.latitude.toString());
                  debugPrint(pickedData.latLong.longitude.toString());
                  debugPrint(pickedData.address.toString());
                  debugPrint(pickedData.addressName);
                  debugPrint("before update: $id");

                  if (widget.data.isEmpty) {
                    debugPrint("data is empty");
                  } else {
                    await PickLocationsDioRepos().updateLoc(
                      id,
                      pickedData.latLong.latitude.toString(),
                      pickedData.latLong.longitude.toString(),
                      pickedData.addressName,                                 
                    );

                    debugPrint("after update: $id");
                    setState(() {
                      getLocs = PickLocationsDioRepos().getLoc();
                    });
                    // Retrieve the copied text from the clipboard
                    ClipboardData? data = await Clipboard.getData('text/plain');
                    // Paste the text into the TextField
                    if (data != null && data.text != null) {
                      debugPrint("Pasted text: ${data.text}");
                    }
                  }
                  //tost message not working
                },
                //CALL API TO UPDATE LOCATION

                locationPinText: "Pick Location",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
