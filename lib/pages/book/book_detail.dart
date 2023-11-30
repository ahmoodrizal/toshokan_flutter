import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_constants.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/models/book_model.dart';
import 'package:toshokan/models/category_model.dart';
import 'package:toshokan/pages/transaction/create_transaction.dart';
import 'package:toshokan/widgets/info_line.dart';

class BookDetail extends StatelessWidget {
  final BookModel book;
  const BookDetail({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(30),
          children: [
            Container(
              width: double.infinity,
              height: 375,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: NetworkImage('${AppConstants.hostImage}/books/${book.cover}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(20),
            Text(
              book.title!.toUpperCase(),
              style: AppFonts.darkTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Gap(10),
            SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: book.categories!.length,
                itemBuilder: (context, index) {
                  CategoryModel item = book.categories![index];
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.amber,
                    ),
                    child: Text(
                      item.name!,
                      style: AppFonts.darkTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(10),
            Text(
              book.description!,
              style: AppFonts.darkTextStyle,
              textAlign: TextAlign.justify,
            ),
            const Gap(20),
            Text(
              'Book Information Detail',
              style: AppFonts.darkTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
            const Gap(15),
            InfoLine(title: 'ISBN', value: book.isbn ?? 'Error'),
            const Gap(10),
            InfoLine(title: 'Author', value: book.author!.name ?? 'Error'),
            const Gap(10),
            InfoLine(title: 'Publisher', value: book.publisher!.name ?? 'Error'),
            const Gap(10),
            InfoLine(title: 'Release Year', value: book.year ?? 'Error'),
            const Gap(10),
            InfoLine(title: 'Language', value: book.language ?? 'Error'),
            const Gap(10),
            InfoLine(title: 'Number of Page', value: book.pageNumber ?? 'Error'),
            const Gap(30),
            ElevatedButton(
              onPressed: () => Navo.push(context, CreateTransactiPage(book: book)),
              child: Text(
                'Rent a Book',
                style: AppFonts.subTextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
