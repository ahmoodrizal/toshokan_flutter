import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/models/book_model.dart';
import 'package:toshokan/pages/book/book_detail.dart';
import 'package:toshokan/providers/search_book_provider.dart';
import 'package:toshokan/services/book_service.dart';

class SearchBookPage extends ConsumerStatefulWidget {
  final String query;
  const SearchBookPage({super.key, required this.query});

  @override
  ConsumerState<SearchBookPage> createState() => _SearchBookPageState();
}

class _SearchBookPageState extends ConsumerState<SearchBookPage> {
  final queryController = TextEditingController();

  execute() {
    BookService.searchBookByTitle(queryController.text).then((value) {
      setSearchBookStatus(ref, 'loading');
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setSearchBookStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setSearchBookStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setSearchBookStatus(ref, 'You don\'t have an access');
              break;
            case BadRequestFailure:
              setSearchBookStatus(ref, 'Bad Request');
              break;
            case UnauthorizedFailure:
              setSearchBookStatus(ref, 'Unauthorized');
              break;
            default:
              setSearchBookStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setSearchBookStatus(ref, 'success');
          List data = result['data'];
          List<BookModel> books = data.map((e) => BookModel.fromJson(e)).toList();
          ref.read(searchByTitleListProvider.notifier).setData(books);
        },
      );
    });
  }

  @override
  void initState() {
    if (widget.query != '') {
      queryController.text = widget.query;
      execute();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        titleSpacing: 0,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 40,
          child: Row(
            children: [
              const Text(
                'Title: ',
                style: TextStyle(
                  fontSize: 14,
                  height: 1,
                  color: Colors.black54,
                ),
              ),
              const Gap(4),
              Expanded(
                child: TextField(
                  controller: queryController,
                  decoration: InputDecoration.collapsed(hintText: queryController.text),
                  style: const TextStyle(height: 1),
                  onSubmitted: (value) => execute(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => execute(),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer(builder: (_, wiRef, __) {
        String status = wiRef.watch(searchBookByTitleProvider);
        List<BookModel> books = wiRef.watch(searchByTitleListProvider);
        if (status == '') {
          return Center(
            child: Text(
              'Try search someting',
              style: AppFonts.darkTextStyle,
            ),
          );
        }
        if (status == 'success') {
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              BookModel book = books[index];
              return ListTile(
                onTap: () => Navo.push(context, BookDetail(book: book)),
                leading: CircleAvatar(
                  backgroundColor: Colors.amber,
                  foregroundColor: AppColors.primaryColor,
                  radius: 18,
                  child: Text('${index + 1}'),
                ),
                title: Text(book.title!),
                subtitle: Text(book.author!.name!),
                trailing: const Icon(Icons.navigate_next),
              );
            },
          );
        }
        return Center(
          child: Text(
            'No Books Data',
            style: AppFonts.darkTextStyle,
          ),
        );
      }),
    );
  }
}
