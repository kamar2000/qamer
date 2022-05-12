import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Shared/companents.dart';
import 'package:project/admin/Show.dart';
import 'package:project/admin/showRoad.dart';
import 'package:project/cubit/home/homestates.dart';
import 'package:project/models/direction/directionmodel.dart';
import 'package:project/models/direction/directionrep.dart';
import 'package:project/models/drivermodel.dart';
import 'package:project/models/driverusermodel.dart';
import 'package:project/models/requestmodel.dart';
import 'package:project/models/schoolmodel.dart';
import 'package:project/models/usermodel.dart';
import 'package:project/screens/contactus.dart';
import 'package:project/screens/feed.dart';
import 'package:project/screens/search.dart';
import 'package:project/screens/settings.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class homeCubit extends Cubit<HomeStates> {
  homeCubit() : super(InitialHomestate());
  static homeCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changeIcon(index) {
    if (index == 1) {
      getdrivers();
      FoundDriver = [];
      // runFilter('');
    }
    currentIndex = index;
    emit(Change_nav_index());
  }

  List<Widget> Screens = [feeds(), search()];
  List<String> titles = [
    "Home",
    "search",
  ];

  ImagePicker picker = ImagePicker();

  Future<void> getUserData() async {
    print("ahahahahshuasuhdfbdndjnjkcd");
    emit(Home_loding_state());
    FirebaseFirestore.instance.collection("users").doc(Uid).get().then((value) {
      print("qamer ${value.data()}");
      emit(Home_succ_state());
      u_model = usermodel.fromjson(value.data()!);
      // print("ya rab yetla3 sah ${u_model!.email}");
      // print(u_model!.email);
    }).catchError((onError) {
      emit(Home_eroor_state(onError.toString()));
    });
  }

//cChip Photo
  var c_chip;
  var c_chipurl;

  Future<void> getc_chip({required ImageSource i}) async {
    var pickedfile = await picker.pickImage(source: i);
    if (pickedfile != null) {
      c_chip = File(pickedfile.path);
      print(pickedfile.path);
    } else {
      print("No Image");
    }
  }

  void updatec_chip(context, ImageSource i) async {
    await getc_chip(i: i).then((value) {
      emit(c_chipPhotoLoading());
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(c_chip!.path).pathSegments.last}')
          .putFile(c_chip)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          c_chipurl = value;
          pn++;
          emit(c_chipPhotosucc());

          print("1${c_chipurl}");
        }).catchError((onError) {
          emit(c_chipPhotoeroor());

          print(onError);
        }).catchError((onError) {
          emit(c_chipPhotoeroor());

          print("eroor");
        });
      });
    });
  }

// Front Image

  var front;
  var fronturl;

  Future<void> getfront({required ImageSource i}) async {
    var pickedfile = await picker.pickImage(source: i);
    if (pickedfile != null) {
      front = File(pickedfile.path);
      print(pickedfile.path);
    } else {
      print("No Image");
      // emit(profileeditstateeroor());
    }
  }

  void updatefront(context, ImageSource i) async {
    await getfront(i: i).then((value) {
      emit(frontPhotoLoading());

      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(front!.path).pathSegments.last}')
          .putFile(front)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          fronturl = value;
          pn++;
          emit(frontPhotosucc());
          print("2${fronturl}");
        }).catchError((onError) {
          emit(frontPhotoeroor());

          print(onError);
        }).catchError((onError) {
          emit(frontPhotoeroor());

          print("eroor");
        });
      });
    });
  }

// Licence Image

  var licence;
  var licenceurl;

  Future<void> getLicence({required ImageSource i}) async {
    var pickedfile = await picker.pickImage(source: i);
    if (pickedfile != null) {
      licence = File(pickedfile.path);
      print(pickedfile.path);
      // emit(profileeditstatesucc());
    } else {
      print("No Image");
      // emit(profileeditstateeroor());
    }
  }

  void updatelicence(context, ImageSource i) async {
    await getLicence(i: i).then((value) {
      emit(licencePhotoLoading());
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(licence!.path).pathSegments.last}')
          .putFile(licence)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          licenceurl = value;
          pn++;

          emit(licencePhotosucc());

          print(licenceurl);
        }).catchError((onError) {
          emit(licencePhotoeroor());

          print(onError);
        }).catchError((onError) {
          emit(licencePhotoeroor());

          print("eroor");
        });
      });
    });
  }

// Back Image
  var back;
  var backurl;
  Future<void> getback({required ImageSource i}) async {
    var pickedfile = await picker.pickImage(source: i);
    if (pickedfile != null) {
      back = File(pickedfile.path);
      print(pickedfile.path);
      // emit(profileeditstatesucc());
    } else {
      print("No Image");
      // emit(profileeditstateeroor());
    }
  }

  void updateback(context, ImageSource i) async {
    await getback(i: i).then((value) {
      emit(backPhotoLoading());

      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(back!.path).pathSegments.last}')
          .putFile(back)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          emit(backPhotosucc());

          backurl = value;
          pn++;
        }).catchError((onError) {
          emit(backPhotoeroor());

          print(onError);
        }).catchError((onError) {
          print("eroor");
          emit(backPhotoeroor());
        });
      });
    });
  }

  void drivercreate({required bio, required int n_o_passengers}) {
    emit(adddriverLoading());
    drivermodel model = drivermodel(
        cuurent: 0,
        from: "",
        to: "",
        worker: false,
        isfull: false,
        name: u_model!.name,
        email: u_model!.email,
        phone: u_model!.phone,
        uId: u_model!.uId,
        back: backurl,
        c_chip: c_chipurl,
        front: fronturl,
        licence: licenceurl,
        bio: bio,
        isset: false,
        n_o_passengers: n_o_passengers,
        profile:
            "https://cdn.vectorstock.com/i/1000x1000/08/37/profile-icon-male-user-person-avatar-symbol-vector-20910837.webp");
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(Uid)
        .set(model.TOMap())
        .then((value) {
      UpdateuserToDriver();
      emit(adddriversucc());
    }).catchError((onError) {
      emit(adddrivereroor());
      print(onError.toString());
    });
  }

  void UpdateuserToDriver() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Uid)
        .update({'isdriver': true}).then((value) {
      u_model!.isdriver = true;
    });
  }

  ///MAp Ya Ragel YA Siuuuuuuuuuuuuuuuuuuuuuuuuuuuuuiasodasmdkl;askjf

  Future<void> DropdownButtonfunction(
      {required String select, required cont}) async {
    emit(DropdownButtonfunctionLoading());
    mark.forEach((element) async {
      if (element.infoWindow.title == select) {
        final GoogleMapController controller = await cont.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target:
                LatLng(element.position.latitude, element.position.longitude),
            zoom: 15)));
        destination = element;
        emit(DropdownButtonfunctionsucc());

        //  setState(() {});
      }
    });
  }

  Future<void> DropdownButtonfunction2(
      {required String select, required cont}) async {
    emit(DropdownButtonfunction2Loading());
    mark2.forEach((element) async {
      if (element.infoWindow.title == select) {
        final GoogleMapController controller = await cont.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target:
                LatLng(element.position.latitude, element.position.longitude),
            zoom: 15)));
        origin = element;
        emit(DropdownButtonfunction2succ());
        // setState(() {});
      }
    });
  }

  void getRoad({required cont}) async {
    final directions = await DirectionsRepository().getDirections(
        origin: origin!.position, destination: destination!.position);
    info = null;
    emit(getDirectionLoading());
    info = directions;
    print(info!.bounds);
    emit(getDirectionsucc());
    final GoogleMapController controller = await cont.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(info!.bounds, 100.0));
  }

  //profile
  Marker? profileor;
  Marker? profildi;
  Future<void> setprofil(drivermodel d) async {
    markes = [];
    emit(setprofilloading());
    FirebaseFirestore.instance
        .collection("drivers")
        .doc(d.uId)
        .collection('road')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element);
        profildi = Marker(
          markerId: MarkerId("profildi"),
          position: LatLng(element.data()['to_lat'], element.data()['to_long']),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: '${element.data()['to']}'),
        );
        profileor = Marker(
          markerId: MarkerId("profileor"),
          position:
              LatLng(element.data()['from_lat'], element.data()['from_long']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: '${element.data()['from']}'),
        );
      });
    }).then((value) {
      markes.add(profildi!);
      markes.add(profileor!);
      print("dasdkoaofjodfgdjijiggdjiofjid");
      print(markes.toString());
      emit(setprofilsucc());
    });
  }

  Future<void> getprofiledata(drivermodel m) async {
    drivers.forEach((element) {
      if (element.uId == m.uId) {
        m = element;
        print(m.cuurent);
        emit(getprofiledatasucc());
      }
    });
  }

  void getRoadofShowing({
    required cont,
  }) async {
    final directions = await DirectionsRepository().getDirections(
        origin: profileor!.position, destination: profildi!.position);
    infoo = null;
    emit(getDirectionLoading());
    infoo = directions;
    print(infoo!.bounds);
    emit(getDirectionsucc());
    final GoogleMapController controller = await cont.future;
    controller
        .animateCamera(CameraUpdate.newLatLngBounds(infoo!.bounds, 100.0));
  }

  Future<void> getschool(cont) async {
    emit(getMarksLoading());
    FirebaseFirestore.instance
        .collection('Schools')
        .snapshots()
        .listen((event) {
      mark = [];
      mark2 = [];
      emit(getschoolLoading());
      event.docs.forEach((element) {
        // titles!.add(element.data()['schoolname']);
        print("${element.data()['place']}");
        placeModel.fromjson(element.data());
        mark.add(Marker(
          markerId: MarkerId("${element.data()['place']}"),
          position:
              LatLng(element.data()['place_lat'], element.data()['place_long']),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: '${element.data()['schoolname']}'),
          onTap: () {
            destController.text = element.data()['schoolname'];
            DropdownButtonfunction(select: destController.text, cont: cont);
            emit(getschoolontap());
          },
        ));
      });
      emit(getschoolsucc());
    });
    FirebaseFirestore.instance
        .collection('sources')
        .snapshots()
        .listen((event) {
      emit(getsourceLoading());
      event.docs.forEach((element) {
        // titles!.add(element.data()['schoolname']);
        placeModel.fromjson(element.data());
        mark2.add(Marker(
          markerId: MarkerId("${element.data()['place']}"),
          position:
              LatLng(element.data()['place_lat'], element.data()['place_long']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: '${element.data()['schoolname']}'),
          onTap: () {
            sourController.text = element.data()['schoolname'];
            DropdownButtonfunction2(select: sourController.text, cont: cont);
            emit(getsourceontap());
          },
        ));
      });
      Allmark.addAll(mark);
      Allmark.addAll(mark2);

      emit(getsourcesucc());
    });

    emit(getMarkssucc());
  }

  List<drivermodel> drivers = [];
  Future<void> getdrivers() async {
    drivers = [];
    emit(getdriverloading());
    print("siu");
    drivers = [];
    FirebaseFirestore.instance
        .collection("drivers")
        .get()
        .then((value) => value.docs.forEach((element) {
              // print(element.data());
              if (element.data()['from'] == null) {}
              drivers.add(drivermodel.fromjson(element.data()));
              // print("aplsdoafjijisdfjiojiosdjiofjiosdfjiofjio");
              // print(drivers.length);
            }))
        .then((value) {
      drivers.toSet().toList();
      // print(drivers.length);
      // print();
    }).catchError((onError) {
      print(onError);
      emit(getdrivereroor());
    }).then((value) {
      emit(getdriversucc());
    });
  }

  List<drivermodel> driverOfPlace = [];
  Future<void> getDriverOfPlace(
      {required String from, required String to}) async {
    emit(getDriverOfPlaceloading());
    driverOfPlace = [];
    print('out${driverOfPlace.length}');
    print(drivers.length);
    drivers.forEach((element) {
      if (element.from == from &&
          element.to == to &&
          element.cuurent < element.n_o_passengers) {
        print("${from}          ${element.from} ");
        driverOfPlace.add(element);
        print('IN${driverOfPlace.length}');
      }
    });
    print('Out Out${driverOfPlace.length}');

    emit(getDriverOfPlacesucc());

//  getdrivers();
  }

  List<usermodel> userRegdriver = [];
  requestmodel? req;

  void requestTODriver(drivermodel m, context, int number) {
    int siu = 0;
    int x = 0;
    // print(m.uId);
    // print(u_model!.uId);
    print("siu ya Siu,${number}");
    req = requestmodel(number: number, uId: Uid);

    emit(requestdriverloading());
    if (m.cuurent < m.n_o_passengers &&
        number + m.cuurent <= m.n_o_passengers) {
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(m.uId)
          .collection('users')
          .doc(u_model!.uId)
          .set(req!.TOMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection('drivers')
            .doc(m.uId)
            .collection('users')
            .get()
            .then((value) {
          value.docs.forEach((element) {
            siu = element.data()['number'];
            x += siu;
          });
        }).then((value) {
          FirebaseFirestore.instance
              .collection('drivers')
              .doc(m.uId)
              .update({'cuurent': x}).then((value) {
            driverusermodel dm =
                driverusermodel(driverId: m.uId, number: number);
            FirebaseFirestore.instance
                .collection('users')
                .doc(Uid)
                .collection('drivers')
                .doc(m.uId)
                .set(dm.TOMap());
          });
        }).then((value) {
          getdrivers();
        });
        // print("object");
        // updateData(m);
        //  getdrivers();
        // updateData(m, context);
        // emit(requestdriversucc());
        ShowToastFun(msg: "Done Request ", Sort: toaststate.success);
      });
    } else {
      emit(requestdrivereroor());
      ShowToastFun(msg: "It is Full ", Sort: toaststate.error);
    }
  }

  int? NumOfUser;

  // void updateData(drivermodel m, context) {
  //   int s = 0;
  //   NumOfUser = 0;
  //   emit(updateDataloading());
  //   FirebaseFirestore.instance
  //       .collection('drivers')
  //       .doc(m.uId)
  //       .collection('users')
  //       .get()
  //       .then((value) {
  //     NumOfUser = value.docs.length;
  //   }).then((value) {
  //     FirebaseFirestore.instance
  //         .collection('drivers')
  //         .doc(m.uId)
  //         .update({'cuurent': NumOfUser}).then((value) {
  //       // ++m.cuurent;
  //       m.cuurent = NumOfUser;
  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(u_model!.uId)
  //           .collection('drivers')
  //           .doc(m.uId)
  //           .set(m.TOMap())
  //           .then((value) {
  //         FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(u_model!.uId)
  //             .collection('drivers')
  //             .get()
  //             .then((value) {
  //           s = value.docs.length;
  //         }).then((value) {
  //           FirebaseFirestore.instance
  //               .collection('users')
  //               .doc(u_model!.uId)
  //               .update({'driverNumber': s});
  //         });
  //       });
  //       getdrivers();
  //       runFilter('');
  //       emit(updateDatasucc());
  //     });
  //   });
  // }

  Future<void> canselRequest({required drivermodel m, context}) async {
    int siu = 0;
    int x = 0;
    print(m.uId);
    emit(canselRequestloading());
    if (m.cuurent > 0) {
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(m.uId)
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element['uId'] == u_model!.uId) {
            FirebaseFirestore.instance
                .collection('drivers')
                .doc(m.uId)
                .collection('users')
                .doc(u_model!.uId)
                .delete();
            print("delete done");
          }
        });
      }).then((value) {
        x = 0;
        FirebaseFirestore.instance
            .collection('drivers')
            .doc(m.uId)
            .collection('users')
            .get()
            .then((value) {
          value.docs.forEach((element) {
            siu = element.data()['number'];
            x += siu;
          });
        }).then((value) {
          FirebaseFirestore.instance
              .collection('drivers')
              .doc(m.uId)
              .update({'cuurent': x}).then((value) {
            getdrivers();
            emit(canselRequestsucc());
            ShowToastFun(msg: "Cansel done ", Sort: toaststate.success);
          });
        });
        // emit(canselRequestsucc());
        // ShowToastFun(msg: "Cansel done ", Sort: toaststate.success);
      });
    }
  }

  bool? isRequest;

  void checkRequest({required drivermodel m, context}) {
    emit(checkdriverloading());
    int x = 0;
//  isRequest=false;
    print(m.uId);
    if (m.cuurent > 0) {
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(m.uId)
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element['uId'] == u_model!.uId) {
            x = 1;
          }
        });
      }).then((value) {
        print("kam marah");

        if (x == 1) {
          isRequest = true;
        } else {
          isRequest = false;
        }
      });
      emit(checkdriversucc());
    }
    print("is req $isRequest");
  }

//search siu

  List<drivermodel> FoundDriver = [];
  void runFilter(String enteredKeyword) {
    // getdrivers();
    List<drivermodel> results = [];
    emit(searchdriverloading());

    if (enteredKeyword.isEmpty || enteredKeyword == '') {
      // if the search field is empty or only contains white-space, we'll display all users
      print("tatatatatatatatata");
      print(drivers.toList());
      results = drivers;
      emit(searchdriversucc());
    } else {
      results = drivers
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      print("Siu Siu Siu  ${results.length}");
      // emit(searchdriversucc());

      // we use the toLowerCase() method to make it case-insensitive
    }

    FoundDriver = results;
    emit(searchdriversucc());

    // });
  }

  void empty(String value) {
    if (value == '') {
      FoundDriver = [];
    }
    emit(emptysucc());
  }

  List<drivermodel>? UseroFdriver;
  void getDriverOfUSer() {
    UseroFdriver = [];
    emit(getDriverOfUSerloading());
    if (u_model!.driverNumber > 0) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(Uid)
          .collection('drivers')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          drivers.forEach((e) {
            if (e.uId == element.id) {
              UseroFdriver!.add(e);
            }
          });
          // UseroFdriver!.add(usermodel.fromjson(element.data()));
        });
      }).then((value) {
        emit(getDriverOfUSersucc());
      }).catchError((onError) {
        emit(getDriverOfUSereroor());
      });
    } else {
      emit(getDriverOfUSersucc2());
    }
  }

  var userprofile;

  Future<void> getuserprofile({required ImageSource i}) async {
    emit(getuserprofileLoading());
    var pickedfile = await picker.pickImage(source: i);
    if (pickedfile != null) {
      userprofile = File(pickedfile.path);
      emit(getuserprofilesucc());

      print(pickedfile.path);
    } else {
      print("No Image");
      emit(getuserprofileeroor());

      // emit(profileeditstateeroor());
    }
  }

  void updateuserprofile(
      {required context, required name, required phone, required bio}) async {
    emit(userprofilePhotoLoading());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user/profile/${Uri.file(userprofile!.path).pathSegments.last}')
        .putFile(userprofile)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateuser(name: name, phone: phone, bio: bio, profile: value);
        // pn++;
        emit(userprofilePhotosucc());
        // print("2${userprofileurl}");
      }).catchError((onError) {
        emit(userprofilePhotoeroor());

        print(onError);
      }).catchError((onError) {
        emit(userprofilePhotoeroor());

        // print("eroor");
      });
    });
  }

  Future<void> updateuser({
    required var name,
    required var phone,
    required var bio,
    var profile,
  }) async {
    emit(updateuserdataLoading());
    usermodel m = usermodel(
        name: name,
        phone: phone,
        bio: bio,
        profile: profile ?? u_model!.profile,
        uId: u_model!.uId,
        admin: u_model!.admin,
        driverNumber: u_model!.driverNumber,
        email: u_model!.email,
        gender: u_model!.gender,
        isdriver: u_model!.isdriver,
        isemailv: u_model!.isemailv);
    FirebaseFirestore.instance
        .collection("users")
        .doc(m.uId)
        .update(m.TOMap())
        .then((value) {
      getUserData();
    }).catchError((onError) {
      print("eroor");
      emit(updateuserdataeroor());
    });
  }
}