import 'package:crud_sqflite_example/models/category.dart';
import 'package:crud_sqflite_example/repositories/repository.dart';

class CategoryService {
  Repository? _repository;

  CategoryService() {
    _repository = Repository();
  }

  //create data
  saveCategory(Category category) async {
    return await _repository?.insertData("categories", category.categoryMap());
  }

  //read data from table
  readCategories() async {
    return await _repository?.readData("categories");
  }

  //read data from table
  readCategoriesById(categoryId) async {
    return await _repository?.readyDataById("categories", categoryId);
  }

  updateCategory(Category category) async {
    return await _repository?.updateData("categories", category.categoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository?.deleteData("categories", categoryId);
  }
}
