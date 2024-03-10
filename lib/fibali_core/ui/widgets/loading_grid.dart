import 'package:flutter/material.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingGrid extends StatelessWidget {
  const LoadingGrid({
    Key? key,
    this.width,
  }) : super(key: key);
  final double? width;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
    );
    // return ListView(
    //   physics: NeverScrollableScrollPhysics(),
    //   children: [
    //     SpinKitCubeGrid(size: width, color: Colors.grey.shade300),
    //     SpinKitCubeGrid(size: width, color: Colors.grey.shade300),
    //     SpinKitCubeGrid(size: width, color: Colors.grey.shade300),
    //   ],
    // );
  }
}
