import 'package:flutter/material.dart';

class GPLLicensePage extends StatelessWidget {
  const GPLLicensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPL License Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'GPL License',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'This app uses the flutter_map_tile_caching package, which is licensed under the GPL (General Public License).',
              ),
              SizedBox(height: 10),
              Text(
                'The GPL License requires you to acknowledge the usage of open-source software in your project and comply with its terms. '
                'For more information, please refer to the GPL License documentation:',
              ),
              SizedBox(height: 10),
              Text(
                'https://www.gnu.org/licenses/gpl-3.0.en.html',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
