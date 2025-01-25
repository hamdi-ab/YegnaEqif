import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _categoryNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  IconData? _selectedIcon;
  Color _selectedColor = Colors.blue;
  IconPack _selectedIconPack = IconPack.material; // Default icon pack
  List<Map<String, dynamic>> categories = []; // List to store categories

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

  void _saveCategory() {
    if (_formKey.currentState?.validate() ?? false) {
      String categoryName = _categoryNameController.text;
      IconData categoryIcon = _selectedIcon ?? Icons.category;
      Color categoryColor = _selectedColor;

      // Add the category to the list
      categories.add({
        'name': categoryName,
        'icon': categoryIcon,
        'color': categoryColor,
      });
      // Clear the input fields
      _categoryNameController.clear();
      setState(() {
        _selectedIcon = null;
        _selectedColor = Colors.blue;
      });
      print('Category Saved: $categoryName, $categoryIcon, $categoryColor');
    } else {
      // Handle invalid form state
      print('Please enter a category name.');
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
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      spreadRadius: -1,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
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
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      spreadRadius: -1,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Icon Type',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<IconPack>(
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
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      spreadRadius: -1,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
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
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      spreadRadius: -1,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ListTile(
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
                ),
              ),
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
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(categories[index]['icon'], color: categories[index]['color']),
                    title: Text(categories[index]['name']),
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

