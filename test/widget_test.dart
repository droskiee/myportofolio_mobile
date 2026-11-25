import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('portfolio home keeps project and education actions', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio Mobile!'), findsOneWidget);
    expect(find.text('Your Portfolio'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
  });
}
