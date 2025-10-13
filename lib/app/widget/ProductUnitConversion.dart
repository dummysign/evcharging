import '../data/Product.dart';

extension ProductUnitConversion on Product {
  double convertToBaseUnit(double value) {
    switch (selectedUnit) {
      case 'kg':
      case 'l':
        return value * 1000; // convert to gm/ml
      case 'gm':
      case 'ml':
      case 'piece':
      default:
        return value;
    }
  }

  double convertFromBaseUnit(double value) {
    switch (selectedUnit) {
      case 'kg':
      case 'l':
        return value / 1000; // convert from gm/ml
      case 'gm':
      case 'ml':
      case 'piece':
      default:
        return value;
    }
  }
}
