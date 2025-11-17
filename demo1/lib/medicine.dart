import 'package:flutter/material.dart';

// --- UPDATED MODEL ---
// We now store the dose as a String for each time slot.
// An empty string means it's not taken.
class Medicine {
  final String name;
  final String morningDose;
  final String noonDose;
  final String nightDose;

  Medicine({
    required this.name,
    required this.morningDose,
    required this.noonDose,
    required this.nightDose,
  });
}

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  // --- UPDATED EXAMPLE DATA ---
  final List<Medicine> _medicines = [
    Medicine(name: "Paracetamol", morningDose: "1 pill", noonDose: "1 pill", nightDose: "1 pill"),
    Medicine(name: "Vitamin D", morningDose: "2 pills", noonDose: "", nightDose: ""),
  ];

  // --- UPDATED CONTROLLERS ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _morningDoseController = TextEditingController();
  final TextEditingController _noonDoseController = TextEditingController();
  final TextEditingController _nightDoseController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMedicineSheet,
        backgroundColor: const Color(0xFF00C9FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Medicine", style: TextStyle(color: Colors.white)),
      ),
      appBar: AppBar(
        title: const Text('Medicine Schedule'),
        backgroundColor: const Color(0xFF2C5364),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _medicines.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _medicines.length,
                itemBuilder: (context, index) {
                  return _buildMedicineCard(_medicines[index], index);
                },
              ),
      ),
    );
  }

  // --- WIDGET: The Card for each medicine (UPDATED) ---
  Widget _buildMedicineCard(Medicine med, int index) {
    // Build a list of time indicators that are NOT empty
    List<Widget> timeIndicators = [];
    if (med.morningDose.isNotEmpty) {
      timeIndicators.add(_buildTimeIndicator("Morning", med.morningDose, Icons.wb_sunny_outlined, const Color.fromRGBO(194, 189, 226, 1)));
    }
    if (med.noonDose.isNotEmpty) {
      timeIndicators.add(_buildTimeIndicator("Noon", med.noonDose, Icons.wb_sunny, const Color.fromARGB(255, 221, 201, 84)));
    }
    if (med.nightDose.isNotEmpty) {
      timeIndicators.add(_buildTimeIndicator("Night", med.nightDose, Icons.nights_stay, const Color.fromARGB(255, 30, 33, 53)));
    }

    return Dismissible(
      key: Key(med.name + index.toString()),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _medicines.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${med.name} removed')));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Name
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.medication_rounded,
                      color: Colors.teal, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    med.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            
            // Only show divider and times if there are any
            if (timeIndicators.isNotEmpty) ...[
              const SizedBox(height: 15),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 10),
              // Time Chips
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: timeIndicators,
              )
            ]
          ],
        ),
      ),
    );
  }

  // Helper to build the small time icons in the card
  Widget _buildTimeIndicator(String label, String dose, IconData icon, Color activeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: activeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: activeColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Make chip wrap content
        children: [
          Icon(icon, size: 16, color: activeColor),
          const SizedBox(width: 8),
          Text(
            "$label: $dose", // e.g., "Morning: 2 pills"
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: activeColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: Empty State (Unchanged) ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services_outlined,
              size: 80, color: Colors.white.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text(
            "No Medicines Added",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- FUNCTION: Show the "Add Medicine" Bottom Sheet (UPDATED) ---
  void _showAddMedicineSheet() {
    // Clear all controllers before opening
    _nameController.clear();
    _morningDoseController.clear();
    _noonDoseController.clear();
    _nightDoseController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          // Handle keyboard overlap
          padding: EdgeInsets.only(
            top: 25,
            left: 25,
            right: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Medication",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 20),
              
              // Name Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Medicine Name",
                  prefixIcon: const Icon(Icons.healing, color: Colors.teal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Dosage per Time",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),

              // --- NEW DOSE INPUT FIELDS ---
              TextField(
                controller: _morningDoseController,
                decoration: InputDecoration(
                  labelText: "Morning Dose",
                  hintText: "e.g., 1 pill (or leave blank)",
                  prefixIcon: const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _noonDoseController,
                decoration: InputDecoration(
                  labelText: "Noon Dose",
                  hintText: "e.g., 10 ml (or leave blank)",
                  prefixIcon: const Icon(Icons.wb_sunny, color: Color.fromARGB(255, 154, 223, 127)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _nightDoseController,
                decoration: InputDecoration(
                  labelText: "Night Dose",
                  hintText: "e.g., 2 pills (or leave blank)",
                  prefixIcon: const Icon(Icons.nights_stay, color: Colors.indigo),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              // -----------------------------

              const SizedBox(height: 25),
              
              // Add Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Only save if a name is given
                    if (_nameController.text.isNotEmpty) {
                      setState(() {
                        _medicines.add(Medicine(
                          name: _nameController.text,
                          morningDose: _morningDoseController.text,
                          noonDose: _noonDoseController.text,
                          nightDose: _nightDoseController.text,
                        ));
                      });
                      Navigator.pop(context); // Close the bottom sheet
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C9FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Save Schedule",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}