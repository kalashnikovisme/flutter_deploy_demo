import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/components/color_style.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const TextFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        onChanged: (String name) {
          context.read<HomeBloc>().add(SearchNameEvent(name));
        },
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorStyle.enabledSearchBorderColor, width: 3.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorStyle.focusedSearchBorderColor, width: 3.0),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              context.read<HomeBloc>().add(ClearSearchEven());
            },
          ),
          prefixIcon: const Icon(Icons.search),
          hintText: AppLocalizations.of(context)?.searchByName ?? '',
        ),
      ),
    );
  }
}
