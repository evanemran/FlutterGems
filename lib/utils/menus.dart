class MenuManager {

  static const List<DrawerMenu> drawerMenu = [
    DrawerMenu.home,
    DrawerMenu.blogs,
    DrawerMenu.projects,
    DrawerMenu.settings,
  ];
}

enum DrawerMenu {
  home("Home", "assets/home.png", "Find Packages"),
  blogs("Blogs", "assets/blogs.png", "Read Articles"),
  projects("Projects", "assets/projects.png", "Check Projects"),
  settings("Settings", "assets/settings.png", "App Settings");


  final String title;
  final String subtitle;
  final String icon;

  const DrawerMenu(this.title, this.icon, this.subtitle);
}