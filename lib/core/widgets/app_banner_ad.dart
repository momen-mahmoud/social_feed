import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatelessWidget {
  final BannerAd _bannerAd = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ID
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (_) => debugPrint('Banner loaded'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('Ad failed to load: $error');
      },
    ),
  )..load();

  BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }
}
