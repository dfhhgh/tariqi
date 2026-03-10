import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      /// AppBar
      appBar: AppBar(
        title: const Text("الإشعارات"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      /// Body
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .where("userId", isEqualTo: userId)
            .orderBy("createdAt", descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          /// Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// Error
          if (snapshot.hasError) {
            return const Center(
              child: Text("حدث خطأ أثناء تحميل الإشعارات"),
            );
          }

          /// No notifications
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "لا يوجد إشعارات",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];

              final data = doc.data() as Map<String, dynamic>;

              final title = data["title"] ?? "";
              final message = data["message"] ?? "";
              final isRead = data["isRead"] ?? false;

              /// التاريخ (اختياري)
              Timestamp? timestamp = data["createdAt"];
              String time = "";

              if (timestamp != null) {
                final date = timestamp.toDate();
                time = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
              }

              return GestureDetector(
                onTap: () async {
                  /// تعليم الإشعار كمقروء
                  await FirebaseFirestore.instance
                      .collection("notifications")
                      .doc(doc.id)
                      .update({
                    "isRead": true,
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isRead ? Colors.white : const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Icon
                      const Icon(
                        Icons.notifications,
                        color: Color(0xFF53B4E7),
                        size: 28,
                      ),

                      const SizedBox(width: 12),

                      /// Texts
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Title
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            /// Message
                            Text(
                              message,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),

                            if (time.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
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
