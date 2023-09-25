import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:test_intern/components/color_style.dart';

class NoInternetBanner extends StatelessWidget {
  const NoInternetBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConnectivityWidget(
        showOfflineBanner: false,
        builder: (context, isOnline) {
          return isOnline
              ? const Icon(
                  Icons.wifi,
                  color: ColorStyle.allDataLoadedColor,
                  size: 32,
                )
              : const Icon(Icons.wifi_off_outlined,
                  color: ColorStyle.errorAuthColor, size: 32);
        },
      ),
    );
  }
}
