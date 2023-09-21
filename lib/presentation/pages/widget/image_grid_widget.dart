import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/components/color_style.dart';
import 'package:test_intern/components/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_intern/domain/models/result_model.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_bloc.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_event.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';


class ImageGridWidget extends StatelessWidget {
  final ResultModel resultModel;
  final bool isFavourite;

  const ImageGridWidget({
   required this.resultModel,
    required this.isFavourite,

  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          width: double.infinity,
          color: ColorStyle.errorImageColor,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: resultModel.image ?? '',
                fit: BoxFit.contain,
                width: double.infinity,
                errorWidget: (context, url, error) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)?.errorImageString ?? '',
                      textAlign: TextAlign.center,
                      style: TextsStyles.errorImageCardString,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorStyle.homeCardColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      resultModel.name ?? '',
                      style: TextsStyles.nameOnCard,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: isFavourite
                      ? const Icon(
                    Icons.favorite_outline,
                    color: ColorStyle.favouriteIconCardColor,
                  )
                      : const Icon(
                    Icons.favorite,
                    color: ColorStyle.favouriteIconCardColor,
                  ),
                  onPressed: () {
                    context.read<FavoritesBloc>().add(AddToFavoritesEvent(resultModel));
                    context.read<HomeBloc>().add(AddToFavoritesHomeEvent(itemToAdd: resultModel));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
