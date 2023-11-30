import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_constants.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_format.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toshokan/models/transaction_model.dart';
import 'package:toshokan/providers/transaction_provider.dart';
import 'package:toshokan/services/transaction_service.dart';

class UserTransactionPage extends ConsumerStatefulWidget {
  const UserTransactionPage({super.key});

  @override
  ConsumerState<UserTransactionPage> createState() => _UserTransactionPageState();
}

class _UserTransactionPageState extends ConsumerState<UserTransactionPage> {
  getMyTransaction() {
    TransactionService.fetchMyTransactions().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setFetchMyTransaction(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setFetchMyTransaction(ref, 'Not Found');
              break;
            case ForbiddenFailure:
              setFetchMyTransaction(ref, 'You dont have an access');
              break;
            case BadRequestFailure:
              setFetchMyTransaction(ref, 'Bad Request');
              break;
            case UnauthorizedFailure:
              setFetchMyTransaction(ref, 'Unauthorized');
              break;
            default:
              setFetchMyTransaction(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setFetchMyTransaction(ref, 'success');
          List data = result['data'];
          List<TransactionModel> transactions = data.map((e) => TransactionModel.fromJson(e)).toList();
          ref.read(myTransactionListProvider.notifier).setData(transactions);
        },
      );
    });
  }

  @override
  void initState() {
    getMyTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header(),
            statusChip(),
            const Gap(30),
            myTransactions(),
          ],
        ),
      ),
    );
  }

  Consumer myTransactions() {
    return Consumer(
      builder: (_, wiRef, __) {
        String fetchStatus = wiRef.watch(fetchMyTransaction);
        String transactionStatus = wiRef.watch(myTransactionStatusProvider);
        List<TransactionModel> originList = wiRef.watch(myTransactionListProvider);
        if (fetchStatus == '') {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }
        List<TransactionModel> transactions = [];
        if (transactionStatus == 'All') {
          transactions = List.from(originList);
        } else {
          transactions = originList.where((element) => element.status!.toLowerCase() == transactionStatus.toLowerCase()).toList();
        }
        if (transactions.isEmpty) {
          return Center(
            child: Text(
              'No Transactions Data',
              style: AppFonts.darkTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              TransactionModel thx = transactions[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: thx.status == 'late'
                        ? Colors.red[200]!
                        : thx.status == 'done'
                            ? Colors.green[100]!
                            : Colors.amber[200]!,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction ID : ${thx.transactionId}',
                        style: AppFonts.darkTextStyle,
                      ),
                      const Gap(10),
                      Text(
                        'Duration : ${thx.duration} Days',
                        style: AppFonts.darkTextStyle,
                      ),
                      const Gap(10),
                      Text(
                        'Return Date : ${AppFormat.shortDate(thx.returnDate)}',
                        style: AppFonts.darkTextStyle.copyWith(
                          decoration: thx.status == 'done' ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      if (thx.fine != null) Gap(10),
                      if (thx.fine != null)
                        Text(
                          'Fine : Rp. ${thx.fine}',
                          style: AppFonts.darkTextStyle,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Consumer statusChip() {
    return Consumer(builder: (_, wiRef, __) {
      String statusSelected = wiRef.watch(myTransactionStatusProvider);
      return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: AppConstants.transactionStatus.length,
          itemBuilder: (context, index) {
            String status = AppConstants.transactionStatus[index];
            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 30 : 10,
                right: index == AppConstants.transactionStatus.length - 1 ? 30 : 10,
              ),
              child: InkWell(
                onTap: () {
                  setMyTransactionStatus(ref, status);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: status == statusSelected ? Colors.amber : Colors.grey[400]!,
                  ),
                  alignment: Alignment.center,
                  child: Text(status),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Align header() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(
          'My Transactions',
          style: AppFonts.darkTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
