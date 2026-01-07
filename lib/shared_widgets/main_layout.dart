import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:genet_church_portal/shared_widgets/side_menu.dart';
import 'package:genet_church_portal/shared_widgets/command_palette.dart';
import 'header_bar.dart';

class MainLayout extends HookWidget {
  final Widget child;
  final List<String> breadcrumbs;

  const MainLayout({super.key, required this.child, required this.breadcrumbs});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final isMobile = MediaQuery.of(context).size.width < 900;
    final isCollapsed = useState(isMobile ? true : false);

    // FIX: Using CustomScrollView for the body content allows SliverAppBar to work correctly
    // without crashing inside a Column/Expanded setup.
    Widget buildBody(bool mobile) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          HeaderBar(
            breadcrumbs: breadcrumbs,
            onMenuPressed: () {
              if (mobile) {
                scaffoldKey.currentState?.openDrawer();
              } else {
                isCollapsed.value = !isCollapsed.value;
              }
            },
            pinned: false,
            floating: true,
            snap: true,
            stretch: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(mobile ? 16.0 : 32.0),
            sliver: SliverToBoxAdapter(child: child),
          ),
        ],
      );
    }

    if (isMobile) {
      return CommandPalette(
        child: Scaffold(
          key: scaffoldKey,
          drawer: const SideMenu(isCollapsed: false),
          body: buildBody(true),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
    }

    return CommandPalette(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIX: SideMenu needs to be outside the scroll view to stay fixed
            SideMenu(isCollapsed: isCollapsed.value),
            Expanded(child: buildBody(false)),
          ],
        ),
      ),
    );
  }
}
