import 'package:barakaa/superadmin/theme/admin_colors.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/add_product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _chemicalController = TextEditingController();
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  String _selectedType = 'Tablet';

  final List<String> _types = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Cream',
    'Ointment',
    'Drops',
    'Powder',
    'Other',
  ];

  @override
  void dispose() {
    _brandController.dispose();
    _chemicalController.dispose();
    _medicineController.dispose();
    _descriptionController.dispose();
    _productIdController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final addProductProvider productProvider = context
        .read<addProductProvider>();

    await productProvider.pickImages();

    if (!mounted) {
      return;
    }

    if (productProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(productProvider.errorMessage!)));

      productProvider.clearError();
    }
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final quantity = int.tryParse(_quantityController.text.trim());

    final price = double.tryParse(_priceController.text.trim());

    final salePrice = double.tryParse(_salePriceController.text.trim());

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity.')),
      );
      return;
    }

    if (price == null || salePrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid price details.')),
      );
      return;
    }

    final productProvider = context.read<addProductProvider>();

    if (productProvider.selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product image.'),
        ),
      );
      return;
    }

    final product = await productProvider.addProduct(
      companyName: 'BARAKAA',
      brandName: _brandController.text.trim(),
      chemicalName: _chemicalController.text.trim(),
      medicineName: _medicineController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _selectedType,
      quantity: quantity,
      location: _locationController.text.trim(),
      price: price,
      salePrice: salePrice,
    );

    if (!mounted) {
      return;
    }

    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            productProvider.errorMessage ?? 'Failed to add product.',
          ),
        ),
      );
      return;
    }

    _productIdController.text = product.productId;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product ${product.productId} successfully added.'),
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(),

                  const SizedBox(height: 24),

                  _buildBasicInformationCard(),

                  const SizedBox(height: 20),

                  _buildDescriptionCard(),

                  const SizedBox(height: 20),

                  _buildProductLocationCard(),

                  const SizedBox(height: 20),

                  _buildRateCard(),

                  const SizedBox(height: 20),

                  _buildProductImagesCard(),

                  const SizedBox(height: 28),

                  _buildAddButton(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PAGE HEADER
  // ------------------------------------------------------------

  Widget _buildPageHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Product',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AdminColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Add a new medicine product to the pharmacy inventory.',
                style: TextStyle(
                  fontSize: 14,
                  color: AdminColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // BASIC INFORMATION
  // ------------------------------------------------------------

  Widget _buildBasicInformationCard() {
    return _buildSectionCard(
      title: 'Product Information',
      icon: Icons.medication_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 650;

          if (isMobile) {
            return Column(
              children: [
                _buildTextField(
                  controller: _brandController,
                  label: 'Brand Name',
                  hint: 'Enter brand name',
                  icon: Icons.business_outlined,
                ),
                const SizedBox(height: 18),
                _buildTextField(
                  controller: _chemicalController,
                  label: 'Chemical Name',
                  hint: 'Enter chemical name',
                  icon: Icons.science_outlined,
                ),
                const SizedBox(height: 18),
                _buildTextField(
                  controller: _medicineController,
                  label: 'Medicine Name',
                  hint: 'Enter medicine name',
                  icon: Icons.medication_outlined,
                ),
                const SizedBox(height: 18),
                _buildProductIdField(),
                const SizedBox(height: 18),
                _buildTypeDropdown(),
                const SizedBox(height: 18),
                _buildTextField(
                  controller: _quantityController,
                  label: 'Quantity',
                  hint: 'Enter available quantity',
                  icon: Icons.inventory_2_outlined,
                  keyboardType: TextInputType.number,
                ),
              ],
            );
          }

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _brandController,
                      label: 'Brand Name',
                      hint: 'Enter brand name',
                      icon: Icons.business_outlined,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _buildTextField(
                      controller: _chemicalController,
                      label: 'Chemical Name',
                      hint: 'Enter chemical name',
                      icon: Icons.science_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _medicineController,
                      label: 'Medicine Name',
                      hint: 'Enter medicine name',
                      icon: Icons.medication_outlined,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(child: _buildProductIdField()),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(child: _buildTypeDropdown()),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _buildTextField(
                      controller: _quantityController,
                      label: 'Quantity',
                      hint: 'Enter available quantity',
                      icon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // PRODUCT ID FIELD
  // ------------------------------------------------------------

  Widget _buildProductIdField() {
    return TextFormField(
      controller: _productIdController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Product ID',
        hintText: 'Generated automatically when saved',
        prefixIcon: Icon(Icons.tag_outlined),
        suffixIcon: Icon(Icons.lock_outline),
      ),
    );
  }

  // ------------------------------------------------------------
  // DESCRIPTION
  // ------------------------------------------------------------

  Widget _buildDescriptionCard() {
    return _buildSectionCard(
      title: 'Description',
      icon: Icons.description_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _descriptionController,
            maxLines: 6,
            maxLength: 3000,
            decoration: InputDecoration(
              hintText: 'Enter product description...',
              alignLabelWithHint: true,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 95),
                child: Icon(Icons.description_outlined),
              ),
              counterText: '',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter product description';
              }

              final wordCount = value
                  .trim()
                  .split(RegExp(r'\s+'))
                  .where((word) => word.isNotEmpty)
                  .length;

              if (wordCount > 500) {
                return 'Description cannot exceed 500 words';
              }

              return null;
            },
          ),

          const SizedBox(height: 8),

          const Text(
            'Maximum 500 words',
            style: TextStyle(fontSize: 12, color: AdminColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PRODUCT LOCATION
  // ------------------------------------------------------------

  Widget _buildProductLocationCard() {
    return _buildSectionCard(
      title: 'Product Location',
      icon: Icons.location_on_outlined,
      child: _buildTextField(
        controller: _locationController,
        label: 'Product Location',
        hint: 'Enter product location',
        icon: Icons.location_on_outlined,
      ),
    );
  }

  // ------------------------------------------------------------
  // PRODUCT RATE CARD
  // ------------------------------------------------------------

  Widget _buildRateCard() {
    return _buildSectionCard(
      title: 'Rate Card',
      icon: Icons.currency_rupee,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 650;

          if (isMobile) {
            return Column(
              children: [
                _buildPriceField(),
                const SizedBox(height: 18),
                _buildSalePriceField(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: _buildPriceField()),
              const SizedBox(width: 18),
              Expanded(child: _buildSalePriceField()),
            ],
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // PRODUCT PRICE
  // ------------------------------------------------------------

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Price',
        hintText: 'Enter product price',
        prefixIcon: Icon(Icons.currency_rupee),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter price';
        }

        final price = double.tryParse(value.trim());

        if (price == null) {
          return 'Please enter a valid price';
        }

        if (price <= 0) {
          return 'Price must be greater than 0';
        }

        return null;
      },
    );
  }

  // ------------------------------------------------------------
  // PRODUCT SALE PRICE
  // ------------------------------------------------------------
  Widget _buildSalePriceField() {
    return TextFormField(
      controller: _salePriceController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Sale Price',
        hintText: 'Enter sale price',
        prefixIcon: Icon(Icons.local_offer_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter sale price';
        }

        final salePrice = double.tryParse(value.trim());

        if (salePrice == null) {
          return 'Please enter a valid sale price';
        }

        if (salePrice <= 0) {
          return 'Sale price must be greater than 0';
        }

        final price = double.tryParse(_priceController.text.trim());

        if (price != null && salePrice > price) {
          return 'Sale price cannot be greater than price';
        }

        return null;
      },
    );
  }
  // ------------------------------------------------------------
  // PRODUCT IMAGES
  // ------------------------------------------------------------

  Widget _buildProductImagesCard() {
    return _buildSectionCard(
      title: 'Product Images',
      icon: Icons.image_outlined,
      child: Consumer<addProductProvider>(
        builder: (context, productProvider, child) {
          final List<XFile> images = productProvider.selectedImages;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upload up to 5 product images. The first image will be used as the cover image.',
                style: TextStyle(
                  fontSize: 13,
                  color: AdminColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Maximum 5 MB per image. Supported formats: JPG, JPEG, PNG, and WEBP.',
                style: TextStyle(
                  fontSize: 12,
                  color: AdminColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isMobile = constraints.maxWidth < 650;

                  final double itemWidth = isMobile
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 48) / 4;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (int index = 0; index < 5; index++)
                        _buildImageUploadBox(
                          width: itemWidth,
                          image: index < images.length ? images[index] : null,
                          imageIndex: index,
                          isCover: index == 0,
                          onRemove: index < images.length
                              ? () {
                                  productProvider.removeImage(index);
                                }
                              : null,
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageUploadBox({
    required double width,
    required XFile? image,
    required int imageIndex,
    required bool isCover,
    required VoidCallback? onRemove,
  }) {
    final bool hasImage = image != null;

    return SizedBox(
      width: width,
      height: 190,
      child: InkWell(
        onTap: hasImage ? null : _pickImages,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AdminColors.border),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: hasImage
                      ? FutureBuilder<Uint8List>(
                          future: image.readAsBytes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError || !snapshot.hasData) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            }

                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            );
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AdminColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.cloud_upload_outlined,
                                color: AdminColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isCover
                                  ? 'Cover Image'
                                  : 'Product Image ${imageIndex + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Click to upload',
                              style: TextStyle(
                                fontSize: 12,
                                color: AdminColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              if (hasImage)
                Positioned(
                  top: 6,
                  right: 6,
                  child: IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.close, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                    tooltip: 'Remove image',
                  ),
                ),
              if (hasImage && isCover)
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Cover Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ADD BUTTON
  // ------------------------------------------------------------

  Widget _buildAddButton() {
    return Consumer<addProductProvider>(
      builder: (context, productProvider, child) {
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 170,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: productProvider.isLoading ? null : _addProduct,
              icon: productProvider.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                productProvider.isLoading ? 'Saving...' : 'Add Product',
              ),
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // TEXT FIELD
  // ------------------------------------------------------------

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }

        return null;
      },
    );
  }

  // ------------------------------------------------------------
  // TYPE DROPDOWN
  // ------------------------------------------------------------

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedType,
      decoration: const InputDecoration(
        labelText: 'Type',
        prefixIcon: Icon(Icons.category_outlined),
      ),
      items: _types.map((type) {
        return DropdownMenuItem<String>(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedType = value;
        });
      },
    );
  }

  // ------------------------------------------------------------
  // SECTION CARD
  // ------------------------------------------------------------

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AdminColors.primary),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            child,
          ],
        ),
      ),
    );
  }
}
