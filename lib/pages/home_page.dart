import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_constants.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/models/book_model.dart';
import 'package:toshokan/pages/book/book_detail.dart';
import 'package:toshokan/pages/book/search_book_page.dart';
import 'package:toshokan/pages/user/profile_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toshokan/providers/home_provider.dart';
import 'package:toshokan/services/book_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static final searchController = TextEditingController();

  goToSearchPage() {
    Navo.push(context, SearchBookPage(query: searchController.text));
  }

  refresh() {
    getPopularBooks();
    getlatestBooks();
  }

  getPopularBooks() {
    BookService.fetchPopularBooks().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setPopularBookStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setPopularBookStatus(ref, 'Error not found');
              break;
            case ForbiddenFailure:
              setPopularBookStatus(ref, 'You don\'t have an access');
              break;
            case BadRequestFailure:
              setPopularBookStatus(ref, 'Bad request');
              break;
            case UnauthorizedFailure:
              setPopularBookStatus(ref, 'Unauthorized');
              break;
            default:
              setPopularBookStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setPopularBookStatus(ref, 'Success');
          List data = result['data'];
          List<BookModel> books = data.map((e) => BookModel.fromJson(e)).toList();
          ref.read(popularBooksListProvider.notifier).setData(books);
        },
      );
    });
  }

  getlatestBooks() {
    BookService.fetchLatestBooks().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setLatestBookStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setLatestBookStatus(ref, 'Error not found');
              break;
            case ForbiddenFailure:
              setLatestBookStatus(ref, 'You don\'t have an access');
              break;
            case BadRequestFailure:
              setLatestBookStatus(ref, 'Bad request');
              break;
            case UnauthorizedFailure:
              setLatestBookStatus(ref, 'Unauthorized');
              break;
            default:
              setLatestBookStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setLatestBookStatus(ref, 'Success');
          List data = result['data'];
          List<BookModel> books = data.map((e) => BookModel.fromJson(e)).toList();
          ref.read(latestBooksListProvider.notifier).setData(books);
        },
      );
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => refresh(),
        child: SafeArea(
          child: ListView(
            children: [
              header(context),
              searchBar(),
              popularBooks(),
              latestBooks(),
            ],
          ),
        ),
      ),
    );
  }

  Consumer latestBooks() {
    return Consumer(builder: (_, wiRef, __) {
      List<BookModel> latestBooks = wiRef.watch(latestBooksListProvider);
      return Column(
        children: [
          const Gap(30),
          Text(
            'Latest Books',
            style: AppFonts.darkTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          if (latestBooks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Text(
                  'Popular Books Data Not Found',
                  style: AppFonts.darkTextStyle.copyWith(fontSize: 16),
                ),
              ),
            ),
          if (latestBooks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 15, 30, 30),
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: latestBooks.length,
                  itemBuilder: (BuildContext ctx, index) {
                    BookModel latestItem = latestBooks[index];
                    return GestureDetector(
                      onTap: () => Navo.push(context, BookDetail(book: latestItem)),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200]!,
                          image: DecorationImage(
                            image: NetworkImage('${AppConstants.hostImage}/books/${latestItem.cover}'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  }),
            ),
        ],
      );
    });
  }

  Padding searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.amber[700]!),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => goToSearchPage(),
              icon: Icon(
                Icons.search,
                color: AppColors.primaryColor,
              ),
            ),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'harry potter . . .',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Consumer popularBooks() {
    return Consumer(builder: (_, wiRef, __) {
      List<BookModel> popularBooks = wiRef.watch(popularBooksListProvider);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              children: [
                Text(
                  'Popular Books',
                  style: AppFonts.darkTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          if (popularBooks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Center(
                  child: Text(
                'Popular Books Data Not Found',
                style: AppFonts.darkTextStyle.copyWith(fontSize: 16),
              )),
            ),
          if (popularBooks.isNotEmpty)
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularBooks.length,
                itemBuilder: (context, index) {
                  BookModel popularItem = popularBooks[index];
                  return GestureDetector(
                    onTap: () => Navo.push(context, BookDetail(book: popularItem)),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        index == 0 ? 30 : 20,
                        0,
                        index == popularBooks.length - 1 ? 30 : 10,
                        0,
                      ),
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200]!,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage('${AppConstants.hostImage}/books/${popularItem.cover}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      );
    });
  }

  Padding vider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Divider(
        color: AppColors.primaryColor,
        thickness: 0.75,
      ),
    );
  }

  Padding header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Folks',
                      style: AppFonts.darkTextStyle.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      'What kind of book will you read today?, Let\'s find something interesting!',
                      style: AppFonts.darkTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navo.push(context, const ProfilePage()),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryColor,
                  child: (const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 35,
                  )),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
