import 'package:flutter/material.dart';
import 'color.dart';

gradient1() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [sColor('#acb6e5'), sColor('#86fde8')]
      )
  );
}

decoMenuDashboardPage() {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C9869), Color(0xFF0C9869)]
      )
  );
}

decoAppbar() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C9869), Color(0xFF0C9869)]
      )
  );
}

decorationCategoryPage() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [sColor('#CB8383'), sColor('#b7b7b7')]
      )
  );
}

decorationBoxPlayer() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [sColor('#ff7272'), sColor('#b7b7b7')]
      )
  );
}