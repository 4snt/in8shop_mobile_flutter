import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/models/product.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/service/product_service.dart';

class ProductFilter extends StatefulWidget {
  final Function(List<Product> result, Map<String, dynamic> filters) onApply;
  final VoidCallback onClose;

  const ProductFilter({
    super.key,
    required this.onApply,
    required this.onClose,
  });

  @override
  State<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  final _service = ProductsService();

  String category = '';
  String provider = '';
  double? minPrice;
  double? maxPrice;
  bool hasDiscount = false;
  bool isLoading = false;

  void _applyFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _service.getProducts(
        category: category,
        provider: provider,
        minPrice: minPrice,
        maxPrice: maxPrice,
        hasDiscount: hasDiscount,
      );

      widget.onApply(result, {
        'category': category,
        'provider': provider,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'hasDiscount': hasDiscount,
      });

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao aplicar filtros: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _clearFilters() {
    setState(() {
      category = '';
      provider = '';
      minPrice = null;
      maxPrice = null;
      hasDiscount = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtros',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    widget.onClose();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Categoria
            TextField(
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => category = value,
            ),
            const SizedBox(height: 12),

            // Provider
            TextField(
              decoration: const InputDecoration(
                labelText: 'Fornecedor',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => provider = value,
            ),
            const SizedBox(height: 12),

            // Preço mínimo e máximo
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min preço',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      minPrice = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max preço',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      maxPrice = double.tryParse(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Checkbox desconto
            Row(
              children: [
                Checkbox(
                  value: hasDiscount,
                  onChanged: (value) {
                    setState(() {
                      hasDiscount = value ?? false;
                    });
                  },
                ),
                const Text('Somente com desconto'),
              ],
            ),
            const SizedBox(height: 12),

            // Ações
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _applyFilters,
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Aplicar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading ? null : _clearFilters,
                    child: const Text('Limpar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
