import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer();

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  String? _userName;
  String? _userAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final currentUser = await _googleSignIn.signInSilently();
      if (currentUser != null) {
        setState(() {
          _userName = currentUser.displayName;
          _userAvatarUrl = currentUser.photoUrl;
        });
      }
    } catch (e) {
      // Handle sign-in errors
      print('Error loading user info: $e');
    }
  }

  // ...

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _userAvatarUrl != null
                      ? NetworkImage(_userAvatarUrl!)
                      : null,
                ),
                SizedBox(height: 10),
                Text(
                  _userName ?? 'Guest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account Info'),
            onTap: () {
              // Navigate to account info page
              Navigator.pushNamed(context, '/account');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Logout functionality
              _googleSignIn.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
