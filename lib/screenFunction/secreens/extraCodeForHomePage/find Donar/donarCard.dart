import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorCard extends StatelessWidget {
  final String name;
  final String address;
  final String bloodGroup;
  final String phone;
  final bool isAvailable;

  const DonorCard({
    super.key,
    required this.name,
    required this.address,
    required this.bloodGroup,
    required this.phone,
    required this.isAvailable,
  });

  void showSMSOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text("SMS"),
            onTap: () async {
              final smsUri = Uri.parse("sms:$phone");
              if (await canLaunchUrl(smsUri)) {
                await launchUrl(smsUri, mode: LaunchMode.externalApplication);
              }
              Navigator.pop(context); // Close bottom sheet
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text("WhatsApp"),
            onTap: () async {
              final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
              final waUri = Uri.parse("https://wa.me/$cleanPhone");
              if (await canLaunchUrl(waUri)) {
                await launchUrl(waUri, mode: LaunchMode.externalApplication);
              }
              Navigator.pop(context); // Close bottom sheet
            },
          ),
        ],
      ),
    );
  }

  void dialPhone() async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(child: Text(name[0])),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(address),
                  const SizedBox(height: 4),
                  Text(
                    isAvailable
                        ? "🟢 Available for donation"
                        : "🔴 Not available",
                    style: TextStyle(
                      color: isAvailable ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(bloodGroup,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed:
                          isAvailable ? () => showSMSOptions(context) : null,
                      color: isAvailable ? Colors.redAccent : Colors.grey,
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: isAvailable ? dialPhone : null,
                      color: isAvailable ? Colors.red : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
