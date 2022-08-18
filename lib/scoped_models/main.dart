import 'package:mallet_shop/scoped_models/products.dart';
import 'package:scoped_model/scoped_model.dart';
import 'auth.dart';
import 'connected_models.dart';

class MainModel extends Model with ConnectedModels, AuthModel,ProductModel{

}