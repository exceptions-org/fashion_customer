import 'package:fashion_customer/model/cart_model.dart';
import 'package:fashion_customer/utils/spHelper.dart';

class CartController {
  SPHelper spHelper = SPHelper();
  List<CartModel> cartItems = [];

  void clearCart() {
    cartItems.clear();
    spHelper.setCart(cartItems);
  }

  void init() async {
    cartItems = await spHelper.getCart() ?? [];
  }

  double getTotal() {
    return cartItems.fold(0, (total, cartItem) {
      return total + cartItem.price * cartItem.quantity;
    });
  }

  int getIndex(String prodId, String size, int color) {
    return cartItems.indexOf(
      cartItems.firstWhere(
        (element) =>
            element.productId == prodId &&
            element.color == color &&
            element.selectedSize == size,
      ),
    );
  }

  CartModel getCart(String prodId, String size, int color) {
    return cartItems[getIndex(prodId, size, color)];
  }

  void increment(String prodId, String size, int color) {
    int index = getIndex(prodId, size, color);

    double singleProdPrice = cartItems[index].price / cartItems[index].quantity;

    cartItems[index].quantity++;
    cartItems[index].price = cartItems[index].price + singleProdPrice;

    spHelper.setCart(cartItems);
  }

  void decrement(String prodId, String size, int color) {
    int index = getIndex(prodId, size, color);
    if (cartItems[index].quantity > 1) {
      double singleProdPrice =
          cartItems[index].price / cartItems[index].quantity;

      cartItems[index].quantity--;
      cartItems[index].price = cartItems[index].price - singleProdPrice;
    } else {
      cartItems.removeAt(index);
    }
    spHelper.setCart(cartItems);
  }

  void addToCart(String prodId, String size, int color,
      List<String> selectedImage, String name, String price, String colorName) {
    cartItems.add(CartModel(
        image: selectedImage,
        name: name,
        colorName: colorName,
        price: double.parse(price),
        quantity: 1,
        productId: prodId,
        color: color,
        discountPrice: 100,
        selectedSize: size));
  }
}
