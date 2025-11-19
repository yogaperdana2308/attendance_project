import 'package:attendance_project/widget/info_row.dart';
import 'package:flutter/material.dart';

class AccountInformationCard extends StatelessWidget {
  final String username;
  final String training;
  final String batch;

  const AccountInformationCard({
    super.key,
    required this.username,
    required this.training,
    required this.batch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Information",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // Username
          InfoRow(label: "Username", value: username),
          Divider(height: 24),

          // Training
          InfoRow(label: "Kejuruan", value: training),
          Divider(height: 24),

          // Batch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Batch Pelatihan", style: TextStyle(fontSize: 16)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  batch,
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
