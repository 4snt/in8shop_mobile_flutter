import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/components/product_filter.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/models/product.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/service/product_service.dart';

class SearchBarComponent extends StatefulWidget {
  final ValueChanged<List<Product>> onResult;

  const SearchBarComponent({super.key, required this.onResult});

  @override
  State<SearchBarComponent> createState() => _SearchBarComponentState();
}

class _SearchBarComponentState extends State<SearchBarComponent> {
  final ProductsService _service = ProductsService();
  final TextEditingController _controller = TextEditingController();

  // 🔥 Estado dos filtros
  String? currentCategory;
  String? currentProvider;
  double? currentMinPrice;
  double? currentMaxPrice;
  bool? currentHasDiscount;

  bool isLoading = false;

  // 🔎 Função de busca acumulando filtros
  Future<void> _search(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await _service.getProducts(
        query: query.isNotEmpty ? query : null,
        category: currentCategory,
        provider: currentProvider,
        minPrice: currentMinPrice,
        maxPrice: currentMaxPrice,
        hasDiscount: currentHasDiscount,
      );
      widget.onResult(results);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro na busca: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 🎯 Abre o modal de filtro acumulando com a busca
  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ProductFilter(
          onApply: (result, filters) {
            widget.onResult(result);

            // 🔥 Atualiza o estado dos filtros ativos
            setState(() {
              currentCategory = filters['category'];
              currentProvider = filters['provider'];
              currentMinPrice = filters['minPrice'];
              currentMaxPrice = filters['maxPrice'];
              currentHasDiscount = filters['hasDiscount'];
            });

            Navigator.pop(context);
          },
          onClose: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🔍 Campo de busca
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: _search,
            decoration: InputDecoration(
              hintText: 'Buscar produtos...',
              prefixIcon: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // 🎯 Botão de filtro
        OutlinedButton(
          onPressed: _openFilter,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            foregroundColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Icon(Icons.filter_list),
        ),
      ],
    );
  }
}
