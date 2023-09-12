import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';
import 'package:test_intern/presentation/home_bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(LoadListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.result.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.result.length) {
                      return ListTile(
                        title: Text(state.result[index].name ?? ''),
                      );
                    }
                    if (state.next.isEmpty) {
                      return const Center(child: Text('All data is loaded'));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
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
