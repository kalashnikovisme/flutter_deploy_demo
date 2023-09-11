import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/presentation/pagination_bloc/pagination_bloc.dart';
import 'package:test_intern/presentation/pagination_bloc/pagination_event.dart';
import 'package:test_intern/presentation/pagination_bloc/pagination_state.dart';

class PaginatingPage extends StatefulWidget {
  const PaginatingPage({Key? key}) : super(key: key);

  @override
  State<PaginatingPage> createState() => _PaginatingPageState();
}

class _PaginatingPageState extends State<PaginatingPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<PagBloc>().add(LoadNextPageEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagBloc = BlocProvider.of<PagBloc>(context);
    pagBloc.add(LoadListEvent());
    return Scaffold(
      body: BlocBuilder<PagBloc, PagState>(
        builder: (context, state) {
          if (!state.isLoading && state.result.isNotEmpty) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    _scrollController.position.extentAfter == 0) {
                  pagBloc.add(LoadNextPageEvent());
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<PagBloc>().add(RefreshDataEvent());
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.result.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.result.length) {
                      return ListTile(
                        title: Text(state.result[index].name ?? ''),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            );
          } else if (state.result.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Opss...'));
          }
        },
      ),
    );
  }
}
