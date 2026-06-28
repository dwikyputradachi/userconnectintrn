import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/textstyles.dart';
import '../pages/user_detail_page.dart';
import '../models/user_model.dart';

class UsersCard extends StatelessWidget {
  final UserModel user;
  
  const UsersCard({
    super.key,
    required this.user,

    });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  UserDetailPage(
            user: user,
            onEdit: () {},  
            onDelete: () {},  
            )
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundColor: AppColors.primary,
              child: Text(
                user.name.substring(0,1), 
                style: TextStyles.subHeading.copyWith(color: AppColors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(user.name, style: TextStyles.subHeading.copyWith(color: AppColors.textPrimary, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(user.email, style: TextStyles.caption.copyWith(color: AppColors.textPrimary, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(user.companyName, style: TextStyles.caption.copyWith(color: AppColors.textPrimary, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  } 
}
