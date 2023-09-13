import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/components/text_styles.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';
import 'package:test_intern/presentation/home_bloc/home_state.dart';
import 'package:test_intern/presentation/pages/widget/image_grid_widget.dart';
import 'package:test_intern/presentation/pages/widget/language_switcher.dart';
import 'package:test_intern/presentation/pages/widget/text_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(LoadListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          LanguageSwitcher(),
        ],
      ),
      body: BlocBuilder<HomeBloc, PagState>(
        builder: (context, state) {
          if (!state.isLoading && state.result.isNotEmpty) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    _scrollController.position.extentAfter == 0) {
                  context.read<HomeBloc>().add(LoadNextPageEvent());
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(RefreshDataEvent());
                },
                child: Column(
                  children: [
                    TextFieldWidget(
                      controller: controller,
                    ),
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        itemCount: state.result.length + 1,
                        itemBuilder: (context, index) {
                          if (index < state.result.length) {
                            return ImageGridWidget(
                              imageUrl: state.result[index].image ?? '',
                              nameCard: state.result[index].name ?? '',
                            );
                          }
                          if (state.next.isEmpty) {
                            return  Center(
                              child: Text(
                                AppLocalizations.of(context)?.allDataLoadedString ?? '',
                                style: TextsStyles.allDataLoadedString,
                              ),
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
