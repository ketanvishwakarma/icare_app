import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import 'main.dart';

class blog extends StatefulWidget {
  @override
  _blogState createState() => _blogState();
}

class _blogState extends State<blog> {
  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> _likeMap = {};
    List likeList = [];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: Colors.white,
            child: new SafeArea(
              child: Column(
                children: <Widget>[
                  new TabBar(
                    tabs: [
                      Tab(
                          icon: Icon(
                        Icons.home,
                        color: Colors.deepPurpleAccent,
                      )),
                      Tab(
                          icon: Icon(Icons.whatshot_rounded,
                              color: Colors.deepPurpleAccent)),
                      Tab(
                          icon: Icon(Icons.favorite,
                              color: Colors.deepPurpleAccent)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('post')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      likeList =
                          snapshot.data.docs.elementAt(index).data()['counter'];
                      _likeMap.putIfAbsent(index, () => likeList);
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Link(
                          target: LinkTarget.defaultTarget,
                          uri: Uri.parse(snapshot.data.docs
                              .elementAt(index)
                              .data()['link']),
                          builder: (context, followLink) {
                            var _postData = snapshot.data.docs.elementAt(index).data();
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 10.0,
                                padding: EdgeInsets.all(0.0),
                              ),
                              onPressed: () async {
                                followLink();
                                await FirebaseFirestore.instance
                                    .collection('post')
                                    .doc(snapshot.data.docs
                                    .elementAt(index)
                                    .reference
                                    .id)
                                    .update({
                                  'views': _postData['views'] + 1,
                                });
                              },
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  ShaderMask(
                                      shaderCallback: (rect) {
                                        return LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black,
                                            Colors.transparent
                                          ],
                                        ).createShader(Rect.fromLTRB(
                                            0, 0, rect.width, rect.height));
                                      },
                                      blendMode: BlendMode.dstIn,
                                      child: Image(
                                        image: NetworkImage(snapshot.data.docs
                                            .elementAt(index)
                                            .data()['thumb']),
                                      )),
                                  ListTile(
                                    title: Text(
                                      snapshot.data.docs
                                              .elementAt(index)
                                              .data()['title'] +
                                          '\n ~ Dr. ' +
                                          snapshot.data.docs
                                              .elementAt(index)
                                              .data()['postby'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.deepPurpleAccent,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    subtitle: Text(snapshot.data.docs
                                        .elementAt(index)
                                        .data()['views'].toString() + ' Views \n' + likeList.length.toString() +
                                        ' People Found that this is helpful'),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color:
                                            likeList.contains(firebaseUser.uid)
                                                ? Colors.redAccent
                                                : null,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          likeList = snapshot.data.docs
                                              .elementAt(index)
                                              .data()['counter'];
                                          _likeMap.putIfAbsent(
                                              index, () => likeList);
                                        });

                                        if (likeList
                                            .contains(firebaseUser.uid)) {
                                          setState(() {
                                            likeList.removeWhere((element) =>
                                                element == firebaseUser.uid);
                                          });
                                          await FirebaseFirestore.instance
                                              .collection('post')
                                              .doc(snapshot.data.docs
                                                  .elementAt(index)
                                                  .reference
                                                  .id)
                                              .update({
                                            'counter': likeList,
                                          });
                                          setState(() {
                                            likeList.clear();
                                          });
                                        } else {
                                          setState(() {
                                            likeList.add(firebaseUser.uid);
                                          });

                                          await FirebaseFirestore.instance
                                              .collection('post')
                                              .doc(snapshot.data.docs
                                                  .elementAt(index)
                                                  .reference
                                                  .id)
                                              .update({
                                            'counter': likeList,
                                          });
                                          setState(() {
                                            likeList.clear();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('post')
              .orderBy('views', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  likeList =
                  snapshot.data.docs.elementAt(index).data()['counter'];
                  _likeMap.putIfAbsent(index, () => likeList);
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Link(
                      target: LinkTarget.defaultTarget,
                      uri: Uri.parse(snapshot.data.docs
                          .elementAt(index)
                          .data()['link']),
                      builder: (context, followLink) {
                        var _postData = snapshot.data.docs.elementAt(index).data();
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 10.0,
                            padding: EdgeInsets.all(0.0),
                          ),
                          onPressed: () async {
                            followLink();
                            await FirebaseFirestore.instance
                                .collection('post')
                                .doc(snapshot.data.docs
                                .elementAt(index)
                                .reference
                                .id)
                                .update({
                              'views': _postData['views'] + 1,
                            });
                          },
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              ShaderMask(
                                  shaderCallback: (rect) {
                                    return LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black,
                                        Colors.transparent
                                      ],
                                    ).createShader(Rect.fromLTRB(
                                        0, 0, rect.width, rect.height));
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Image(
                                    image: NetworkImage(snapshot.data.docs
                                        .elementAt(index)
                                        .data()['thumb']),
                                  )),
                              ListTile(
                                title: Text(
                                  snapshot.data.docs
                                      .elementAt(index)
                                      .data()['title'] +
                                      '\n ~ Dr. ' +
                                      snapshot.data.docs
                                          .elementAt(index)
                                          .data()['postby'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.deepPurpleAccent,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),

                                subtitle: Text(snapshot.data.docs
                                    .elementAt(index)
                                    .data()['views'].toString() + ' Views \n' + likeList.length.toString() +
                                    ' People Found that this is helpful'),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color:
                                    likeList.contains(firebaseUser.uid)
                                        ? Colors.redAccent
                                        : null,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      likeList = snapshot.data.docs
                                          .elementAt(index)
                                          .data()['counter'];
                                      _likeMap.putIfAbsent(
                                          index, () => likeList);
                                    });

                                    if (likeList
                                        .contains(firebaseUser.uid)) {
                                      setState(() {
                                        likeList.removeWhere((element) =>
                                        element == firebaseUser.uid);
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('post')
                                          .doc(snapshot.data.docs
                                          .elementAt(index)
                                          .reference
                                          .id)
                                          .update({
                                        'counter': likeList,
                                      });
                                      setState(() {
                                        likeList.clear();
                                      });
                                    } else {
                                      setState(() {
                                        likeList.add(firebaseUser.uid);
                                      });

                                      await FirebaseFirestore.instance
                                          .collection('post')
                                          .doc(snapshot.data.docs
                                          .elementAt(index)
                                          .reference
                                          .id)
                                          .update({
                                        'counter': likeList,
                                      });
                                      setState(() {
                                        likeList.clear();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
            StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                likeList =
                snapshot.data.docs.elementAt(index).data()['counter'];
                _likeMap.putIfAbsent(index, () => likeList);
                if(likeList.contains(firebaseUser.uid))
                  return Container(
                  padding: EdgeInsets.all(20),
                  child: Link(
                    target: LinkTarget.defaultTarget,
                    uri: Uri.parse(snapshot.data.docs
                        .elementAt(index)
                        .data()['link']),
                    builder: (context, followLink) {
                      var _postData = snapshot.data.docs.elementAt(index).data();
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 10.0,
                          padding: EdgeInsets.all(0.0),
                        ),
                        onPressed: () async {
                          followLink();
                          await FirebaseFirestore.instance
                              .collection('post')
                              .doc(snapshot.data.docs
                              .elementAt(index)
                              .reference
                              .id)
                              .update({
                            'views': _postData['views'] + 1,
                          });

                        },
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            ShaderMask(
                                shaderCallback: (rect) {
                                  return LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black,
                                      Colors.transparent
                                    ],
                                  ).createShader(Rect.fromLTRB(
                                      0, 0, rect.width, rect.height));
                                },
                                blendMode: BlendMode.dstIn,
                                child: Image(
                                  image: NetworkImage(snapshot.data.docs
                                      .elementAt(index)
                                      .data()['thumb']),
                                )),
                            ListTile(
                              title: Text(
                                snapshot.data.docs
                                    .elementAt(index)
                                    .data()['title'] +
                                    '\n ~ Dr. ' +
                                    snapshot.data.docs
                                        .elementAt(index)
                                        .data()['postby'],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepPurpleAccent,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(likeList.length.toString() +
                                  ' People Found that this is helpful'),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color:
                                  likeList.contains(firebaseUser.uid)
                                      ? Colors.redAccent
                                      : null,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    likeList = snapshot.data.docs
                                        .elementAt(index)
                                        .data()['counter'];
                                    _likeMap.putIfAbsent(
                                        index, () => likeList);
                                  });

                                  if (likeList
                                      .contains(firebaseUser.uid)) {
                                    setState(() {
                                      likeList.removeWhere((element) =>
                                      element == firebaseUser.uid);
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('post')
                                        .doc(snapshot.data.docs
                                        .elementAt(index)
                                        .reference
                                        .id)
                                        .update({
                                      'counter': likeList,
                                    });
                                    setState(() {
                                      likeList.clear();
                                    });
                                  } else {
                                    setState(() {
                                      likeList.add(firebaseUser.uid);
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('post')
                                        .doc(snapshot.data.docs
                                        .elementAt(index)
                                        .reference
                                        .id)
                                        .update({
                                      'counter': likeList,
                                    });
                                    setState(() {
                                      likeList.clear();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
                return SizedBox(height: 0,);
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
          ],
        ),
      ),
    );
  }
}
