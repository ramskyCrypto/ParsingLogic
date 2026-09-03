import 'dart:convert';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user_model.dart';

const String jsonString = '''
{
  "id": 1,
  "name": "Ramadhan Putra Wijaya",
  "username": "ramadhan",
  "email": "ramadhan@gmail.com",
  "phone": "081234567890"
}
''';

void main() {
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);

  final UserModel user = UserModel.fromJson(jsonData);

  print('ID: ${user.id}');
  print('Nama: ${user.name}');
  print('Username: ${user.username}');
  print('Email: ${user.email}');
  print('Phone: ${user.phone}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Pelanggan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserPage(),
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ApiService apiService = ApiService();

  late Future<List<UserModel>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = apiService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Pelanggan PT.Ramadhan Putra Wijaya',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Data pelanggan tidak ditemukan'),
            );
          }

          final users = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      user.name[0],
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text('@${user.username}'),
                      Text(user.email),
                      Text(user.phone),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}