import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lifeplus_provider.dart';
import '../theme/neumorphic_theme.dart';

class CsvViewerScreen extends ConsumerWidget {
  final String tableName;
  final String title;

  const CsvViewerScreen({super.key, required this.tableName, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          title, // Display table name as title
          style: NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
        ),
        leading: NeumorphicButton(
          onPressed: () => Navigator.of(context).pop(),
          style: const NeumorphicStyle(
            depth: 4,
            intensity: 0.65,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(
            Icons.arrow_back,
            color: NeumorphicAppTheme.getTextColor(context),
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: ref.read(databaseServiceProvider).getTableData(tableName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                      'Error loading table: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                  ));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                      'No data found in this table.',
                      style: NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
                  ));
            }

            final data = snapshot.data!;
            
            // Get headers from the first row keys
            final headers = data.first.keys.toList();

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: headers
                      .map((header) => DataColumn(
                              label: Text(
                            header,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )))
                      .toList(),
                  rows: data.map((row) {
                    return DataRow(
                      cells: headers.map((header) => DataCell(Text(row[header]?.toString() ?? ''))).toList(),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
