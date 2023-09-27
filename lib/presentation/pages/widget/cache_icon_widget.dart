import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/components/color_style.dart';
import 'package:test_intern/components/text_styles.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CachedDataIcon extends StatelessWidget {
  const CachedDataIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, PagState>(
      builder: (context, state) {
        if (state.isCached) {
          return Row(
            children: [
              const Icon(
                Icons.cached,
                color: ColorStyle.favouriteIconCardColor,
                size: 28,
              ),
              Text(
                AppLocalizations.of(context)?.dataCache ?? '',
                style: TextsStyles.textNetworkorCache,
              )
            ],
          );
        } else {
          return Row(
            children: [
              const Icon(
                Icons.cached,
                color: ColorStyle.allDataLoadedColor,
                size: 28,
              ),
              Text(
                AppLocalizations.of(context)?.dataApi ?? '',
                style: TextsStyles.textNetworkorCache,
              )
            ],
          );
        }
      },
    );
  }
}
