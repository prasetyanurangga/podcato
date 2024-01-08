import 'package:flutter/material.dart';

class NoDataView extends StatelessWidget {
  const NoDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: SizedBox(
            width: 200, child: Image.asset('assets/images/no_data.png')),
      ),
    );
  }
}
