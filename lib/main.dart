import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HomePageState());
}

class HomePageState extends StatefulWidget {
  const HomePageState({Key? key}) : super(key: key);

  @override
  State<HomePageState> createState() => _HomePageStateState();
}

class _HomePageStateState extends State<HomePageState> {
  final firestore = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

  // ignore: non_constant_identifier_names
  @override
  Widget build(BuildContext context) {
    CollectionReference moviesRef = firestore.collection('movies');
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 170, 158, 250),
        appBar: AppBar(
          title: const Text('FireStore CRUD Islemlerı'),
        ),
        body: Center(
          child: Container(
            child: Expanded(
              child: Column(
                children: [
                  /*ElevatedButton(
                    child: Text('Veriyi Getir'),
                    onPressed: () async {
                      var response = await moviesRef.get();
                      var list = response.docs;
                      print(list[1].data());
                    },
                  ),
                  
                  */
                  StreamBuilder<QuerySnapshot>(
                    stream: moviesRef.snapshots(),
                    builder: (context, AsyncSnapshot asyncSnapshot) {
                      if (!asyncSnapshot.hasData) {
                        return const Center(
                          child: Text("Loading..."),
                        );
                      }
                      List<DocumentSnapshot> listOfDocumentSnap =
                          asyncSnapshot.data.docs;
                      return Flexible(
                        child: ListView.builder(
                          itemCount: listOfDocumentSnap.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Color.fromARGB(255, 136, 199, 231),
                              child: ListTile(
                                title: Text(
                                  '${(listOfDocumentSnap[index].data() as Map)['name']}',
                                  style: TextStyle(fontSize: 19),
                                ),
                                subtitle: Text(
                                  '${(listOfDocumentSnap[index].data() as Map)['rating']}',
                                  style: TextStyle(fontSize: 19),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await listOfDocumentSnap[index]
                                        .reference
                                        .delete();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 50),
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration:
                                InputDecoration(hintText: "Film Adını Giriniz"),
                          ),
                          TextFormField(
                            controller: ratingController,
                            decoration:
                                InputDecoration(hintText: "Rating giriniz"),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text("Ekle"),
          onPressed: () async {
            print(nameController.text);
            print(ratingController.text);

            Map<String, dynamic> movieData = {
              'name': nameController.text,
              'rating': ratingController.text,
            };

            await moviesRef.doc(nameController.text).set(movieData);
          },
        ),
      ),
    );
  }
}


/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HomePageState());
}

class FireStoreApp extends StatefulWidget {
  const FireStoreApp({Key? key}) : super(key: key);
  @override
  State<FireStoreApp> createState() => _FireStoreAppState();
}

class _FireStoreAppState extends State<FireStoreApp> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference movies =
        FirebaseFirestore.instance.collection('movies');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: textController,
          ),
        ),
        body: Center(
          child: StreamBuilder(
              stream: movies.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapsot) {
                if (!snapsot.hasData) {
                  return Center(child: Text("Loading"));
                }
                return ListView(
                  children: snapsot.data!.docs.map((movies) {
                    return Center(
                      child: ListTile(
                        title: Text(movies['name']),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () {
            movies.add({
              'name': textController.text,
            });
          },
        ),
      ),
    );
  }
}
*/