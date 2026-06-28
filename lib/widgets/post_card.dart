import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/textstyles.dart';
import '../models/post_model.dart';

class PostCard extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final PostModel post;
  const PostCard({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: TextStyles.subHeading.copyWith(fontSize: 14,),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(post.body,style: TextStyles.caption,maxLines: 3, overflow: TextOverflow.ellipsis,),

          const SizedBox(height: 12),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete),
              ),
            ],
          )
        ],
      ),
    );
  }
}