import 'package:flutter/material.dart';
import 'package:flutter_5a/models/user_response_model.dart';
import 'package:flutter_5a/services/api_service.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final ApiService _apiService;
  late Future<List<User>> _userListFuture;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _userListFuture = _apiService.getListUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengguna (DummyJSON)'),
      ),
      body: FutureBuilder<List<User>>(
        future: _userListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.image),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                  trailing: Text(user.username), // tambahan info
                );
              },
            );
          }
          return const Center(child: Text('Tidak ada data pengguna.'));
        },
      ),
    );
  }
}
