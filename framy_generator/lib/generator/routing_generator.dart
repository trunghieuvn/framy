String generateRouting() => '''
Route onGenerateRoute(RouteSettings settings) {
  final routes = {
    '/typography': FramyFontsPage(),
    '/colors': FramyColorsPage(),
    '/appbar': FramyAppBarPage(),
    '/button': FramyButtonPage(),
  };
  final page = routes[settings.name] ?? FramyFontsPage();
  return PageRouteBuilder<dynamic>(
    pageBuilder: (_, __, ___) => FramyLayoutTemplate(child: page),
    settings: settings,
  );
}
''';
