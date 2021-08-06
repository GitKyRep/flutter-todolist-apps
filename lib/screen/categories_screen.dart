import 'package:crud_sqflite_example/models/category.dart';
import 'package:crud_sqflite_example/screen/home_screen.dart';
import 'package:crud_sqflite_example/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();
  var category;

  List<Category> _categoryList = [];

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = [];
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category["name"];
        categoryModel.description = category["description"];
        categoryModel.id = category["id"];

        _categoryList.add(categoryModel);
      });
    });
  }

  getCategoryById(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoriesById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]["name"] ?? "No name";
      _editCategoryDescriptionController.text =
          category[0]["description"] ?? "No Description";
    });

    _editDialog(context);
  }

  _showSnackbar(message) {
    var _snackbar = SnackBar(content: message);
    _globalKey.currentState?.showSnackBar(_snackbar);
  }

  _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _category = Category();
                _category.name = _categoryNameController.text;
                _category.description = _categoryDescriptionController.text;

                var result = await _categoryService.saveCategory(_category);
                if (result > 0) {
                  getAllCategories();
                  Navigator.pop(context);
                  _showSnackbar(Text("Saved Successfully"));
                  _categoryNameController.text = "";
                  _categoryDescriptionController.text = "";
                }
              },
              child: Text("Save"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            )
          ],
          title: Text("Add Category"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    hintText: "Write a category",
                    labelText: "Category",
                  ),
                ),
                TextField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a description",
                    labelText: "Description",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _editDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _category = Category();
                _category.id = category[0]["id"];
                _category.name = _editCategoryNameController.text;
                _category.description = _editCategoryDescriptionController.text;

                var result = await _categoryService.updateCategory(_category);
                if (result > 0) {
                  getAllCategories();
                  Navigator.pop(context);
                  _showSnackbar(Text("Updated Successfully"));
                }
              },
              child: Text("Update"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            )
          ],
          title: Text("Edit Category"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _editCategoryNameController,
                  decoration: InputDecoration(
                    hintText: "Write a category",
                    labelText: "Category",
                  ),
                ),
                TextField(
                  controller: _editCategoryDescriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a description",
                    labelText: "Description",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text("Category"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      getCategoryById(context, _categoryList[index].id);
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_categoryList[index].name.toString()),
                      IconButton(
                        onPressed: () {
                          _categoryService
                              .deleteCategory(_categoryList[index].id);
                          getAllCategories();
                          _showSnackbar(Text("Delete Successfully"));
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
