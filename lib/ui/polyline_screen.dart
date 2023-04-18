import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

import '../framework/controller/controller_providers.dart';

class PolylineScreen extends ConsumerStatefulWidget {
  const PolylineScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PolylineScreen> createState() => _PolylineScreenState();
}

class _PolylineScreenState extends ConsumerState<PolylineScreen> {
  ///Init
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  ///Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    final addressWatch = ref.watch(addressProvider);
    return Column(
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
    );
  }
}
