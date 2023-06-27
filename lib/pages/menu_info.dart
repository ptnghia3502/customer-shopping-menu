import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:customer_shopping_menu/models/product_menu_model.dart';
import 'package:intl/intl.dart';

import '../../services/api_service.dart';
import '../models/group_model.dart';
import 'product_detail_page.dart';

const hardCodeGroupId = '3f2ad790-f0a7-4d28-95a9-a5031c121098';

Future<Group> _getGroupInfo() async {
  return await ApiService.getGroupById(hardCodeGroupId);
}

final groupInfoProvider = FutureProvider<Group>((ref) => _getGroupInfo());

final menuItemsProvider = FutureProvider<List<ProductMenu>>((ref) async {
  final group = await ref.watch(groupInfoProvider.future);
  return ApiService.fetchProductsInMenu(group.menuId!);
});

class MenuInfoPage extends ConsumerWidget {
  late Group group; // Declare group as an instance variable

  MenuInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final groupInfoAsyncValue = ref.watch(groupInfoProvider);

          return groupInfoAsyncValue.when(
            data: (groupData) {
              group =
                  groupData; // Assign the retrieved group data to the instance variable
              return Column(
                children: [
                  const Align(
                    alignment: Alignment(0, 0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Menu danh sách sản phẩm',
                        style: TextStyle(
                          color: Color(0xff202020),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: FutureBuilder<List<ProductMenu>>(
                        future: ref.watch(menuItemsProvider.future),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final cartItems = snapshot.data ?? [];

                          return cartItems.isEmpty
                              ? const Center(child: Text('Menu is empty'))
                              : SizedBox(
                                  child: ListView.builder(
                                    itemCount: cartItems.length,
                                    itemBuilder: (context, index) {
                                      final item = cartItems[index];
                                      return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailPage(
                                                  product: item,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            child: Container(
                                              color: Colors.white,
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Image.network(
                                                      item.images[0].fileURL,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 20,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.productName,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const Gap(6),
                                                          Text(
                                                            item.description
                                                                        .length >
                                                                    20
                                                                ? '${item.description.substring(0, 20)}...' // Truncate description if it exceeds 20 characters
                                                                : item
                                                                    .description,
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade500,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          const Gap(4),
                                                          Text(
                                                            '${item.supplierPrice} VND',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                          ),
                                                          const Gap(4),
                                                          Text(
                                                            '${item.actualPrice} VND',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                    },
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Menu này được áp dụng voucher bởi:'),
                          const Gap(12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFF843667),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${group.id}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(12),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Error retrieving group data'),
          );
        },
      ),
    );
  }
}
