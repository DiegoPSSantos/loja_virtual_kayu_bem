import 'package:flutter/cupertino.dart';

class PageManager extends ChangeNotifier {

  PageManager(this._pageController);

  final PageController _pageController;

  PageController get pageController => _pageController;

  int initPage = 0;

  void setPage(int page)  {
    if (initPage == page) return;
    initPage = page;
    _pageController.jumpToPage(page);
    notifyListeners();
  }
}