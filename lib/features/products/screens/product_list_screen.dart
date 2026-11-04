import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/status_badge.dart';
import '../controllers/product_controller.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('products.title'.tr(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => controller.fetchProducts(isRefresh: true),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: MaxWidthContainer(
                maxWidth: 800,
                child: AppTextField(
                  hint: 'products.search_hint'.tr(context),
                  controller: _searchController,
                  prefixIcon: Icons.search,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            controller.onSearchChanged('');
                            setState(() {});
                          },
                        )
                      : null,
                  onChanged: (val) {
                    controller.onSearchChanged(val);
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    !controller.isRefreshing.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.products.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            controller.errorMessage.value,
                            style: AppTypography.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => controller.fetchProducts(),
                            icon: const Icon(Icons.refresh),
                            label: Text('btn.retry'.tr(context)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.products.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => controller.fetchProducts(isRefresh: true),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 400,
                        child: Center(
                          child: EmptyStateWidget(
                            icon: Icons.inventory_2_outlined,
                            title: 'products.empty_title'.tr(context),
                            subtitle: 'products.empty_message'.tr(context),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchProducts(isRefresh: true),
                  color: AppColors.primary,
                  child: Center(
                    child: MaxWidthContainer(
                      maxWidth: 800,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.products.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = controller.products[index];
                          return _buildProductCard(context, product);
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductEntity product) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTypography.headingMedium.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(
                      status: product.isAvailable
                          ? 'status.available'.tr(context)
                          : 'status.out_of_stock'.tr(context),
                      customColor: product.isAvailable
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: AppTypography.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Text(
                        '${'products.stock'.tr(context)}: ${product.stockQuantity}',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
