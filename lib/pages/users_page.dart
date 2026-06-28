import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/textstyles.dart';
import '../widgets/user_card.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../widgets/shimmer_user_card.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key}); 

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ApiService apiService = ApiService();
  List<UserModel> users = []; List<UserModel> filteredUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      await Future.delayed(
        const Duration(seconds: 2)
      );
      debugPrint("Mulai fetch user");

      final fetchedUsers = await apiService.getUsers();

      debugPrint("Jumlah user: ${fetchedUsers.length}");

      setState(() {
        users = fetchedUsers;
        filteredUsers = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }
  void searchUsers(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        return user.name.toLowerCase().contains(
          query.toLowerCase(),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: AppBar(
            title: Text(
              'UserConnect',
              style: TextStyles.heading.copyWith(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: TextStyles.subHeading.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            Text(
              'Connect With Other People',
              style: TextStyles.heading.copyWith(
                color: AppColors.textPrimary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
           TextField(
              onChanged: searchUsers,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search User',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return const ShimmerUserCard();
                      },
                    )
                  : users.isEmpty
                      ? const Center(
                          child: Text('Users Not Found'),
                        )
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            return UsersCard(
                              user: filteredUsers[index],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
