import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_constants.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_response.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/models/book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toshokan/pages/home_page.dart';
import 'package:toshokan/providers/transaction_provider.dart';
import 'package:toshokan/services/transaction_service.dart';
import 'package:toshokan/widgets/alert.dart';

class CreateTransactiPage extends ConsumerStatefulWidget {
  final BookModel book;
  const CreateTransactiPage({super.key, required this.book});

  @override
  ConsumerState<CreateTransactiPage> createState() => _CreateTransactiPageState();
}

class _CreateTransactiPageState extends ConsumerState<CreateTransactiPage> {
  String duration = '3';

  execute() {
    setTransactionStatus(ref, 'loading');

    TransactionService.createTransaction(
      bookId: widget.book.id.toString(),
      duration: duration,
    ).then((value) {
      String newStatus = '';
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              newStatus = 'Server Error';
              alert(context, 'Error', newStatus, ContentType.failure);
              break;
            case NotFoundFailure:
              newStatus = 'Error Not Found';
              alert(context, 'Error', newStatus, ContentType.failure);
              break;
            case ForbiddenFailure:
              newStatus = 'You don\'t have an access';
              alert(context, 'Error', newStatus, ContentType.failure);
              break;
            case BadRequestFailure:
              newStatus = 'Bad Request';
              alert(context, 'Error', newStatus, ContentType.failure);
              break;
            case InvalidInputFailure:
              newStatus = 'Invalid Input';
              AppResponse.invalidInput(context, failure.message ?? '{}');
              break;
            case UnauthorizedFailure:
              newStatus = 'Unauthorized';
              var message = jsonDecode(failure.message!) as Map<String, dynamic>;
              alert(context, 'Error', message['message'], ContentType.failure);
              break;
            default:
              newStatus = 'Request Error';
              alert(context, 'Error', newStatus, ContentType.failure);
              newStatus = failure.message ?? '-';
              break;
          }
          setTransactionStatus(ref, newStatus);
        },
        (result) {
          alert(context, 'Success', 'Create Transaction Success, Enjoy', ContentType.success);
          setTransactionStatus(ref, 'Create Transaction Success');
          Navo.replace(context, const HomePage());
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Create a Transaction',
                style: AppFonts.darkTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(30),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.amber,
                  ),
                ),
                child: Text(
                  'Please read the rules in the book rental mechanism, make sure your personal data is correct before making a transaction.',
                  style: AppFonts.darkTextStyle.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.justify,
                ),
              ),
              const Gap(20),
              Text(
                'Book Detail',
                style: AppFonts.darkTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image(
                        image: NetworkImage('${AppConstants.hostImage}/books/${widget.book.cover}'),
                        height: 120,
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book.title ?? 'Error',
                            style: AppFonts.darkTextStyle.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Gap(10),
                          Text(
                            widget.book.description ?? 'Error',
                            style: AppFonts.darkTextStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Gap(30),
              Text(
                'Select Duration',
                style: AppFonts.darkTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          duration = '3';
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: duration == '3' ? Colors.amber : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: duration == '3' ? Colors.deepOrangeAccent : Colors.amber,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '3 Days',
                            style: AppFonts.darkTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          duration = '7';
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: duration == '7' ? Colors.amber : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: duration == '7' ? Colors.deepOrangeAccent : Colors.amber,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '7 Days',
                            style: AppFonts.darkTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          duration = '14';
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: duration == '14' ? Colors.amber : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: duration == '14' ? Colors.deepOrangeAccent : Colors.amber,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '14 Days',
                            style: AppFonts.darkTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          duration = '30';
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: duration == '30' ? Colors.amber : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: duration == '30' ? Colors.deepOrangeAccent : Colors.amber,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '30 Days',
                            style: AppFonts.darkTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(60),
              Consumer(builder: (_, wiRef, __) {
                String status = wiRef.watch(transactionStatusProvider);
                if (status == 'loading') {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }
                return ElevatedButton(
                  onPressed: () => execute(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(25),
                  ),
                  child: Text(
                    'Confirm Order',
                    style: AppFonts.subTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
