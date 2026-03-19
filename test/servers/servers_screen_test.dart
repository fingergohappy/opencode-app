import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:opencode_app/app_settings/providers.dart';
import 'package:opencode_app/servers/controller.dart';
import 'package:opencode_app/servers/model.dart';
import 'package:opencode_app/servers/providers.dart';
import 'package:opencode_app/servers/screen.dart';
import 'package:opencode_app/servers/widgets/server_health_badge.dart';
import 'package:opencode_app/servers/widgets/server_list_section.dart';
import 'package:opencode_app/servers/widgets/server_search_bar.dart';
import 'package:opencode_app/servers/widgets/server_tile.dart';
import 'package:opencode_app/servers/widgets/servers_empty_state.dart';

const _servers = <Server>[
  Server(url: 'http://localhost:4096', name: '本地开发', isDefault: true),
  Server(url: 'http://192.168.1.10:4096', name: '局域网服务器'),
  Server(url: 'https://api.opencode.dev', name: 'OpenCode 官方'),
  Server(url: 'https://staging.opencode.dev', name: 'Staging 环境'),
  Server(url: 'http://10.0.0.5:8080', name: '管理后台'),
  Server(url: 'https://prod-us-east.example.com', name: '美东生产'),
  Server(url: 'https://prod-eu-west.example.com', name: '欧西生产'),
  Server(url: 'http://dev-server-01.internal:4096', name: 'Dev-01'),
  Server(url: 'http://dev-server-02.internal:4096', name: 'Dev-02'),
  Server(url: 'https://test.opencode.internal', name: '测试环境'),
];

class _TestServersController extends ServersController {
  @override
  ServersState build() {
    return ServersState(servers: _servers, selectedServer: _servers.first);
  }
}

Future<void> _pumpServersScreen(
  WidgetTester tester, {
  Size surfaceSize = const Size(390, 844),
}) async {
  tester.view
    ..physicalSize = surfaceSize
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        serversControllerProvider.overrideWith(_TestServersController.new),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('服务器')),
          body: const ServersScreen(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpServersScreenWithPrefs(
  WidgetTester tester, {
  required SharedPreferences prefs,
  Size surfaceSize = const Size(390, 844),
}) async {
  tester.view
    ..physicalSize = surfaceSize
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MaterialApp(home: Scaffold(body: ServersScreen())),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows empty state when there are no saved servers', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await _pumpServersScreenWithPrefs(tester, prefs: prefs);

    expect(find.byType(ServersEmptyState), findsOneWidget);
    expect(find.text('暂无服务器'), findsOneWidget);
    expect(find.byKey(const ValueKey('servers-add-fab')), findsNothing);
  });

  testWidgets('renders without overflow in landscape', (
    WidgetTester tester,
  ) async {
    await _pumpServersScreen(tester, surfaceSize: const Size(844, 390));

    expect(find.byKey(const ValueKey('servers-search-bar')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps search bar around one third of the content height', (
    WidgetTester tester,
  ) async {
    await _pumpServersScreen(tester);

    final screenRect = tester.getRect(find.byType(ServersScreen));
    final searchBarRect = tester.getRect(
      find.byKey(const ValueKey('servers-search-bar')),
    );

    expect(
      searchBarRect.center.dy,
      moreOrLessEquals(screenRect.top + screenRect.height / 3, epsilon: 24),
    );
  });

  testWidgets('uses a hard-edge outlined search bar', (
    WidgetTester tester,
  ) async {
    await _pumpServersScreen(tester);

    final searchBar = tester.widget<SearchBar>(find.byType(SearchBar));
    final shape = searchBar.shape?.resolve(<WidgetState>{});
    final side = searchBar.side?.resolve(<WidgetState>{});
    final elevation = searchBar.elevation?.resolve(<WidgetState>{});

    expect(shape, isA<RoundedRectangleBorder>());
    expect(
      (shape! as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(10),
    );
    expect(side?.width, 1);
    expect(elevation, 0);
  });

  testWidgets('starts list scroll region below the fixed search bar', (
    WidgetTester tester,
  ) async {
    await _pumpServersScreen(tester);

    final searchBarRect = tester.getRect(
      find.byKey(const ValueKey('servers-search-bar')),
    );
    final scrollViewRect = tester.getRect(
      find.byKey(const ValueKey('servers-scroll-view')),
    );

    expect(scrollViewRect.top, greaterThanOrEqualTo(searchBarRect.bottom));
    expect(find.byType(ServerListSection), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('servers-scroll-view')),
        matching: find.byType(ServerSearchBar),
      ),
      findsNothing,
    );
  });

  testWidgets('keeps the last card above the add button', (
    WidgetTester tester,
  ) async {
    await _pumpServersScreen(tester);

    final scrollView = find.byKey(const ValueKey('servers-scroll-view'));
    await tester.fling(scrollView, const Offset(0, -2000), 3000);
    await tester.pumpAndSettle();

    final lastCard = find.ancestor(
      of: find.text('测试环境'),
      matching: find.byType(Card),
    );
    final fab = find.byKey(const ValueKey('servers-add-fab'));

    expect(lastCard, findsOneWidget);
    expect(fab, findsOneWidget);
    expect(tester.getRect(lastCard).bottom, lessThan(tester.getRect(fab).top));
  });

  testWidgets('uses stronger foreground color for pending health badge', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: ServerHealthBadge(health: null))),
      ),
    );

    final context = tester.element(find.text('未检测'));
    final text = tester.widget<Text>(find.text('未检测'));

    expect(text.style?.color, Theme.of(context).colorScheme.onSurface);
    expect(text.style?.fontWeight, FontWeight.w600);
  });

  testWidgets('keeps selected server tile background opaque', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ServerTile(
              server: _servers.first,
              selected: true,
              isCurrentHealthTarget: false,
              onTap: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      ),
    );

    final card = tester.widget<Card>(
      find.ancestor(of: find.text('本地开发'), matching: find.byType(Card)),
    );

    expect(card.color?.a, 1);
    expect(card.elevation, 0);
  });

  testWidgets('renders server url with monospace styling', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ServerTile(
              server: _servers.first,
              selected: false,
              isCurrentHealthTarget: false,
              onTap: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      ),
    );

    final urlText = tester.widget<Text>(find.text('http://localhost:4096'));

    expect(urlText.style?.fontFamily, 'monospace');
  });
}
