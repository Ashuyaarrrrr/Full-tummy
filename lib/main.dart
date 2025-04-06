import 'package:flutter/material.dart';

void main() {
  runApp(const FullTummyApp());
}

class FullTummyApp extends StatelessWidget {
  const FullTummyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Full Tummy',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const RegistrationPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: const Center(
        child: Text(
          'Full Tummy',
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String userType = 'Restaurant';

  void navigateBasedOnUserType() {
    if (userType == 'Restaurant') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RestaurantDashboard()),
      );
    } else if (userType == 'NGO/Shelter') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NGODashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DeliveryPartnerPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              "Register to Full Tummy",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            DropdownButtonFormField<String>(
              value: userType,
              decoration: const InputDecoration(labelText: 'Select Type'),
              items: const [
                DropdownMenuItem(value: 'Restaurant', child: Text('Restaurant')),
                DropdownMenuItem(value: 'NGO/Shelter', child: Text('NGO/Shelter')),
                DropdownMenuItem(
                    value: 'Delivery Partner', child: Text('Delivery Partner')),
              ],
              onChanged: (value) {
                setState(() {
                  userType = value!;
                });
              },
            ),
            if (userType == 'Restaurant')
              TextField(
                controller: gstinController,
                decoration: const InputDecoration(labelText: 'GSTIN'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: navigateBasedOnUserType,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantDashboard extends StatefulWidget {
  const RestaurantDashboard({super.key});

  @override
  State<RestaurantDashboard> createState() => _RestaurantDashboardState();
}

class _RestaurantDashboardState extends State<RestaurantDashboard> {
  final TextEditingController foodTypeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2024),
        lastDate: DateTime(2030));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: foodTypeController,
              decoration: const InputDecoration(labelText: 'Food Type'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                const Text("Manufactured Date: "),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => selectDate(context),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Save to Firebase
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Donation Submitted!")),
                );
              },
              child: const Text("Submit Donation"),
            ),
          ],
        ),
      ),
    );
  }
}



class NGODashboard extends StatelessWidget {
  const NGODashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyList = [
      {"type": "Bread", "quantity": "10 packs", "date": "2025-04-06"},
      {"type": "Rice", "quantity": "5kg", "date": "2025-04-06"},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Available Donations")),
      body: ListView.builder(
        itemCount: dummyList.length,
        itemBuilder: (context, index) {
          final item = dummyList[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(item["type"]!),
              subtitle: Text("Qty: ${item["quantity"]} | Date: ${item["date"]}"),
              trailing: const Icon(Icons.fastfood),
            ),
          );
        },
      ),
    );
  }
}

class DeliveryPartnerPage extends StatelessWidget {
  const DeliveryPartnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveries = [
      {"pickup": "Restaurant A", "drop": "Shelter X"},
      {"pickup": "Restaurant B", "drop": "NGO Y"},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Available Deliveries")),
      body: ListView.builder(
        itemCount: deliveries.length,
        itemBuilder: (context, index) {
          final delivery = deliveries[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("Pickup: ${delivery['pickup']}"),
              subtitle: Text("Drop: ${delivery['drop']}"),
              trailing: const Icon(Icons.delivery_dining),
            ),
          );
        },
      ),
    );
  }
}
