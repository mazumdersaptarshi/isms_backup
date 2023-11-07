import 'package:flutter/material.dart';

class TestDetailsPage extends StatelessWidget {
  const TestDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://t3.ftcdn.net/jpg/04/26/27/90/360_F_426279020_ekx1cFOPJD0qtBIgXoctIakgWcYU9Cgd.jpg",
                  ),
                  radius: 100,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Exams',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Hi [Name], finish the exams below.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        color: Colors.orange[200],
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            'Exam ${index + 1}',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Row(
                            children: [
                              Icon(Icons.timer, color: Colors.black),
                              SizedBox(width: 8),
                              Text('20 mins', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}