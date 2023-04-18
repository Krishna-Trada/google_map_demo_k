import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../framework/controller/controller_providers.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final addressWatch = ref.watch(addressProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) => addressWatch.setAddressController(value),
                decoration:
                    const InputDecoration(hintText: 'Enter Your Location here.', border: OutlineInputBorder()),
              ),
            ),
            Expanded(child: ListView.builder(
              itemCount: addressWatch.placesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(addressWatch.placesList[index]['description']),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
