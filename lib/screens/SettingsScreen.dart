import 'package:chatty_flutter/constants/other.dart';
import 'package:flutter/material.dart';
import 'package:chatty_flutter/providers/profile.dart';
import 'package:chatty_flutter/widgets/bottom_bar.dart';
import 'package:chatty_flutter/widgets/date_picker.dart';
import 'package:chatty_flutter/widgets/gender_picker.dart';
import 'package:chatty_flutter/widgets/phone_number.dart';
import 'package:chatty_flutter/widgets/user_name.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, provider, _) {
      final bool _hasPhoto =
          provider.profileUploadPhoto != null || provider.profilePhoto != null;
      return Scaffold(
          bottomNavigationBar: bottomBar(),
          floatingActionButton: provider.hasMadeChanges
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      SizedBox(
                        width: 48.0,
                        height: 48.0,
                        child: FloatingActionButton(
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                            onPressed: () {
                              provider.cancelAll();
                            },
                            child: Icon(Icons.clear),
                            backgroundColor: Colors.red),
                      ),
                      SizedBox(height: 8.0),
                      FloatingActionButton(
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        onPressed: () {
                          provider.saveProfile();
                        },
                        child: Icon(Icons.done),
                      )
                    ])
              : null,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  !_hasPhoto
                      ? InkWell(
                          child: circleAvatar(hasPhoto: false),
                          onTap: () => provider.pickProfilePhoto(),
                        )
                      : Stack(children: [
                          circleAvatar(hasPhoto: true, provider: provider),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(32.0)),
                                child: IconButton(
                                  constraints: BoxConstraints(maxWidth: 32.0),
                                  color: Colors.white,
                                  iconSize: 16.0,
                                  icon: Icon(Icons.edit),
                                  onPressed: () => provider.pickProfilePhoto(),
                                ),
                              ))
                        ]),
                  SizedBox(height: 16.0),
                  UserName(controller: provider.name),
                  PhoneNumber(controller: provider.phoneNumber),
                  DatePicker(
                    value: provider.formatBirthday(false),
                    onClear: () => provider.birthday = null,
                    onChanged: (date) => provider.birthday = date,
                  ),
                  GenderPicker(
                    value: provider.gender,
                    onChanged: (gender) => provider.gender = gender,
                  ),
                  RaisedButton(
                      color: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(32.0),
                      ),
                      onPressed: () {
                        provider.logout(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Log out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                ],
              )),
            ),
          ));
    });
  }
}

Widget circleAvatar({hasPhoto, provider}) {
  return CircleAvatar(
    radius: 48.0,
    child: hasPhoto
        ? null
        : Icon(
            Icons.camera_alt,
            size: 32.0,
          ),
    backgroundColor: hasPhoto ? Colors.transparent : Colors.blueGrey,
    backgroundImage: !hasPhoto
        ? null
        : (provider.profileLocalPhoto != null
            ? FileImage(provider.profileLocalPhoto)
            : NetworkImage('$graphQLEndPoint/${provider.profilePhoto}')),
  );
}
