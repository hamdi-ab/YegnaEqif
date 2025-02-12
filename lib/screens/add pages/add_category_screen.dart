import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/models/category.dart';
import 'package:yegna_eqif_new/screens/dashboard/dashboard_screen.dart';

import '../../providers/category_provider.dart';

class AddCategoryPage extends ConsumerStatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends ConsumerState<AddCategoryPage> {
  final TextEditingController _categoryNameController = TextEditingController();
  IconData? _selectedIcon;
  Color _selectedColor = Colors.blue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  IconPack _selectedIconPack = IconPack.material;
  final List<Map<String, dynamic>> _categories = [];  // Mock user ID, replace with Firebase Auth user ID later

  void _selectIcon(BuildContext context) async {
    IconData? icon = await showIconPicker(
      context,
      iconPackModes: [_selectedIconPack],
      adaptiveDialog: true,
    );
    if (icon != null) {
      setState(() {
        _selectedIcon = icon;
      });
    }
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  Future<void> _saveCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      String categoryName = _categoryNameController.text;
      IconData categoryIcon = _selectedIcon ?? Icons.question_mark;
      Color categoryColor = _selectedColor;

      // Add to local list immediately
      setState(() {
        _categories.add({
          'name': categoryName,
          'icon': categoryIcon,
          'color': categoryColor,
        });
      });

      // Add a new category and update the state
      await ref.read(categoryProvider.notifier).addCategory(
        Category(
          id: DateTime.now().toString(), // Generate a unique ID
          name: categoryName,
          icon: categoryIcon,
          color: categoryColor,
        ),
      );

      // Clear input fields after saving
      _categoryNameController.clear();
      _selectedIcon = null;
      _selectedColor = Colors.blue;
          // Optionally, show feedback
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Category saved successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ContainerWIthBoxShadow(width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      controller: _categoryNameController,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        hintText: 'Category Name',
                        border: InputBorder.none,
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Category name is required';
                        }
                        return null;
                      },
                    ),
                  )),
              ContainerWIthBoxShadow(margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Icon Type',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<IconPack>(
                          alignment: AlignmentDirectional.centerEnd,
                          value: _selectedIconPack,
                          onChanged: (IconPack? newValue) {
                            setState(() {
                              _selectedIconPack = newValue!;
                            });
                          },
                          items: IconPack.values.map<DropdownMenuItem<IconPack>>((IconPack value) {
                            return DropdownMenuItem<IconPack>(
                              value: value,
                              child: Text(value.toString().split('.').last),
                            );
                          }).toList(),
                        ),
                      )
                      ,
                    ],
                  )),
              ContainerWIthBoxShadow(margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 6.0),child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Select Icon:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(_selectedIcon ?? Icons.category),
                        color: _selectedColor,
                        onPressed: () {
                          _selectIcon(context);
                        },
                      ),
                    ],
                  )),
              ContainerWIthBoxShadow(margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Select Color:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    trailing: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: BlockPicker(
                                pickerColor: _selectedColor,
                                onColorChanged: _selectColor,
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Select'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(Icons.circle, color: _selectedColor),
                    ),
                  )),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _saveCategory,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: Size(double.infinity, 50), // Make the button cover the full width
                  ),
                  child: const Text(
                    'Save Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Categories:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(_categories[index]['icon'], color: _categories[index]['color']),
                    title: Text(_categories[index]['name']),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

