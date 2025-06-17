import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/components/product_search.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/models/product.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/pages/productpageitem.dart'
    as page;
import 'package:in8shop_mobile_flutter/src/modules/product/service/product_service.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchInitialProducts();
  }

  Future<void> fetchInitialProducts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await ProductsService().getProducts();
      setState(() {
        products = result;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            /// 🔥 AppBar que some ao rolar
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              floating: true,
              snap: true,
              elevation: 0,
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/logo-square-light.png',
                    height: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'In8Shop!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),

            /// 🔍 SearchBar Fixa no topo (não rola)
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarHeader(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: SearchBarComponent(
                    onResult: (result) {
                      setState(() {
                        products = result;
                      });
                    },
                  ),
                ),
              ),
            ),

            /// 🔄 Estados de carregamento, erro ou grid
            if (isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (error != null)
              SliverFillRemaining(child: Center(child: Text('Erro: $error')))
            else if (products.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('Nenhum produto encontrado.')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = products[index];
                    return ProductCard(
                      data: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                page.ProductPageItem(product: product),
                          ),
                        );
                      },
                    );
                  }, childCount: products.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 🔥 Header Delegate para SearchBar fixa
class _SearchBarHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarHeader({required this.child});

  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 70;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
