import 'package:flutter/material.dart';
import 'main.dart'; // For logging out
import 'secondpage.dart'; // For Start Talk
import 'medicine.dart'; // <--- ADDED: Import the new medicine file

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareConnect Home'),
        backgroundColor: const Color(0xFF00C9FF),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Removes the back arrow
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigate back to Login Screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      
      // GridView with 3 columns for smaller buttons
      body: GridView.count(
        crossAxisCount: 3, 
        padding: const EdgeInsets.all(15),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          // 1. "Start Talk" Card
          _buildDashboardCard(
            context: context,
            icon: Icons.chat_bubble_rounded,
            title: 'Start Talk',
            onTap: () {
              // Navigation to Voice Chat (SecondPage)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondPage()),
              );
            },
          ),
          
          // 2. "Medicine" Card (UPDATED)
          _buildDashboardCard(
            context: context,
            icon: Icons.medical_services_rounded,
            title: 'Medicine',
            onTap: () {
              // --- THIS NOW CONNECTS TO YOUR MEDICINE PAGE ---
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MedicinePage()),
              );
            },
          ),

          // 3. "Family" Card (Placeholder)
           _buildDashboardCard(
            context: context,
            icon: Icons.group_rounded,
            title: 'Family',
            onTap: () {},
          ),
          
          // 4. "Settings" Card (Placeholder)
           _buildDashboardCard(
            context: context,
            icon: Icons.settings_rounded,
            title: 'Settings',
            onTap: () {},
          ),

          // 5. "Reminders" Card (Placeholder)
           _buildDashboardCard(
            context: context,
            icon: Icons.alarm,
            title: 'Reminders',
            onTap: () {},
          ),

           // 6. "Profile" Card (Placeholder)
           _buildDashboardCard(
            context: context,
            icon: Icons.person_rounded,
            title: 'Profile',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGET ---
  Widget _buildDashboardCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: const Color(0xFF00C9FF)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}