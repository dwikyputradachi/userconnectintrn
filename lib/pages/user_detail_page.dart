import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../constants/colors.dart';
import '../constants/textstyles.dart';
import '../widgets/post_card.dart';
import '../models/user_model.dart';
import '../widgets/shimmer_user_card.dart';
import '../models/post_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../widgets/post_form_dialog.dart';

class UserDetailPage extends StatefulWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserDetailPage({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final ApiService apiService = ApiService();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  List<PostModel> posts = [];
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<void> loadPosts() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final fetchedPosts = await apiService.getPostsByUser(
        widget.user.id,
      );

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> showDeleteDialog(PostModel post) async {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Delete Post', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      content: const Text('Are You Sure Delete This Post?', style: TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.danger,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () async {
            await apiService.deletePost(post.id);
            setState(() => posts.removeWhere((p) => p.id == post.id));
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(backgroundColor: AppColors.danger, content: Text('Post berhasil dihapus')),
              );
            }
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
  void showEditPostDialog(PostModel post) {
    titleController.text = post.title;
    bodyController.text = post.body;

    showDialog(
      context: context,
      builder: (_) => PostFormDialog(
        dialogTitle: 'Edit Post',
        titleController: titleController,
        bodyController: bodyController,
        onSave: () => updatePost(post),
      ),
    );
  }
  Future<void> updatePost(PostModel oldPost) async {
    final updatedPost = await apiService.updatePost(
      id: oldPost.id,
      userId: oldPost.userId,
      title: titleController.text,
      body: bodyController.text,
    );

    final index = posts.indexWhere(
      (p) => p.id == oldPost.id,
    );

    setState(() {
      posts[index] = updatedPost;
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.blue,
        content: Text(
          'Post updated successfully',
        ),
      ),
    );
  }
  void showAddPostDialog() {
    titleController.clear();
    bodyController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return PostFormDialog(
          dialogTitle: 'Add Post',
          titleController: titleController,
          bodyController: bodyController,
          onSave: () async {
            if (titleController.text.trim().isEmpty ||
                bodyController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text(
                    'Title dan Body tidak boleh kosong',
                  ),
                ),
              );
              return;
            }
            try {
              final createdPost = await apiService.createPost(
                userId: widget.user.id,
                title: titleController.text,
                body: bodyController.text,
              );
              setState(() {
                posts.insert(0, createdPost);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    'Post created successfully',
                  ),
                ),
              );
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: showAddPostDialog,
      child: const Icon(Icons.add)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              bottom: false,
              child: Skeletonizer(
                enabled: isLoading,
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
                    color: AppColors.primary,
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.white),
                          ),
                          child: const Icon(
                            Icons.person, 
                            size: 40, 
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.user.name, 
                              style: TextStyles.subHeading.copyWith(color: AppColors.white, fontSize: 24),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.user.email, 
                              style: TextStyles.caption.copyWith(color: AppColors.white, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ))
                      ],
                    )),
              ),
            ),
            const SizedBox(height: 20),
            Skeletonizer(
              enabled: isLoading, 
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 20),
                        const SizedBox(width: 10),
                        Text('About', style: TextStyles.subHeading.copyWith(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Phone', style: TextStyles.subHeading.copyWith(fontSize: 14)),
                    Text(widget.user.phone, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),
                    Text('Company', style: TextStyles.subHeading.copyWith(fontSize: 14)),
                    Text(widget.user.companyName, style: TextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),
                    Text('Website', style: TextStyles.subHeading.copyWith(fontSize: 14)),
                    Text(widget.user.website, style: TextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.3),spreadRadius: 2,blurRadius: 5,),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.post_add, size: 20),
                      const SizedBox(width: 10),
                      Text('Post', style: TextStyles.subHeading.copyWith(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  isLoading
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return const ShimmerUserCard();
                          },
                        )
                      : posts.isEmpty
                          ? const Center(
                              child: Text('No posts found'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return PostCard(
                                  post: posts[index],
                                  onEdit: () {
                                    showEditPostDialog(
                                      posts[index],
                                    );
                                  },
                                  onDelete: () {
                                    showDeleteDialog(
                                      posts[index],
                                    );
                                  },
                                );
                              },
                            ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
