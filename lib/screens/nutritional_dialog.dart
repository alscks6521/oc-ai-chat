import 'package:flutter/material.dart';

class NutritionalContainer extends StatelessWidget {
  final dynamic nutritionalItem;

  const NutritionalContainer({super.key, required this.nutritionalItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text(nutritionalItem['PRDLST_NM']),
                content: Column(
                  children: [
                    Text(
                      '주된 기능성: ${nutritionalItem["PRIMARY_FNCLTY"]}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      '섭취시 주의사항: ${nutritionalItem['IFTKN_ATNT_MATR_CN']}',
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('닫기'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 83,
        height: 83,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            nutritionalItem['PRDLST_NM'],
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
