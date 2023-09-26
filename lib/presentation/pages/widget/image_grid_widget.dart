import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/components/color_style.dart';
import 'package:test_intern/components/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_intern/domain/models/result_model.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_bloc.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_event.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_state.dart';
import 'package:collection/collection.dart';
class ImageGridWidget extends StatefulWidget {
  final ResultModel resultModel;

  const ImageGridWidget({
    Key? key,
    required this.resultModel,
  }) : super(key: key);

  @override
  State<ImageGridWidget> createState() => _ImageGridWidgetState();
}

class _ImageGridWidgetState extends State<ImageGridWidget> {
  final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  Widget build(BuildContext context) {
    print(widget.resultModel.id.toString() + widget.resultModel.name! + 'AAAAAAAAAAA');
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        print(state.favoriteItems.map((e) => e.name! + e.id.toString()));
        final isItemInFavorites =
            state.favoriteItems.firstWhereOrNull((e) => e.id == widget.resultModel.id ) != null;
        print(isItemInFavorites);

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
                    imageUrl: widget.resultModel.image ?? '',
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
                          widget.resultModel.name ?? '',
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
                      icon: isItemInFavorites
                          ? const Icon(
                              Icons.favorite,
                              color: ColorStyle.favouriteIconCardColor,
                            )
                          : const Icon(
                              Icons.favorite_outline,
                              color: ColorStyle.favouriteIconCardColor,
                            ),
                      onPressed: () {
                        if (isItemInFavorites) {
                          context.read<FavoritesBloc>().add(
                                RemoveFromFavoritesEvent(widget.resultModel),
                              );
                        } else {
                          context.read<FavoritesBloc>().add(
                                AddToFavoritesEvent(widget.resultModel),
                              );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
