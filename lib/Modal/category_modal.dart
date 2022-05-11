class CategoriesModel {
  String categoriesName;
  String imgUrl;
  CategoriesModel({required this.categoriesName, required this.imgUrl});
}

List<CategoriesModel> categoryList = [
  CategoriesModel(
    categoriesName: 'Nature',
    imgUrl:
        'https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  ),
  CategoriesModel(
    categoriesName: 'Sports',
    imgUrl:
        'https://images.pexels.com/photos/46798/the-ball-stadion-football-the-pitch-46798.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  ),
  CategoriesModel(
    categoriesName: 'Wild Life',
    imgUrl:
        'https://images.pexels.com/photos/704320/pexels-photo-704320.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
  ),
  CategoriesModel(
    categoriesName: 'City',
    imgUrl:
        'https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
  ),
  CategoriesModel(
    categoriesName: 'Fitness',
    imgUrl:
        'https://images.pexels.com/photos/841135/pexels-photo-841135.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  ),
  CategoriesModel(
    categoriesName: 'Art',
    imgUrl:
        'https://images.pexels.com/photos/1183992/pexels-photo-1183992.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  ),
  CategoriesModel(
    categoriesName: 'Cars',
    imgUrl:
        'https://images.pexels.com/photos/404190/pexels-photo-404190.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  ),
];
