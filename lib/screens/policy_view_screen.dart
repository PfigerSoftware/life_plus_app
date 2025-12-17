import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';
import '../providers/lifeplus_provider.dart';
import 'nb_register_screen.dart';
import 'sb_due_screen.dart';
import 'maturity_report_screen.dart';
import 'birthday_report_screen.dart';
import 'wedding_report_screen.dart';

class PolicyViewScreen extends ConsumerWidget {
  const PolicyViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final policyOptions = [
      {
        'title': 'NB Register',
        'icon': Icons.app_registration_outlined,
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'DUE Premium',
        'icon': Icons.payment_outlined,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Money Back',
        'icon': Icons.account_balance_wallet_outlined,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Lapse Re',
        'icon': Icons.refresh_outlined,
        'color': const Color(0xFFEF4444),
      },
      {
        'title': 'Maturity Report',
        'icon': Icons.arrow_circle_up,
        'color': const Color(0xFF06B6D4),
      },
      {
        'title': 'Birthday Report',
        'icon': Icons.cake_outlined,
        'color': const Color(0xFFEC4899),
      },
      {
        'title': 'Wedding Day Report',
        'icon': Icons.favorite_outlined,
        'color': const Color(0xFFF43F5E),
      },
      {
        'title': 'SB Dues',
        'icon': Icons.currency_rupee,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'DAB List',
        'icon': Icons.list_alt_outlined,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'title': 'Premium Calendar',
        'icon': Icons.calendar_month_outlined,
        'color': const Color(0xFF06B6D4),
      },
      {
        'title': 'Comprehensive Chart',
        'icon': Icons.bar_chart_outlined,
        'color': const Color(0xFF14B8A6),
      },
    ];

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Policy View',
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Report Type',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose from available policy reports',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // List of Policy Options
              Expanded(
                child: ListView.builder(
                  itemCount: policyOptions.length,
                  itemBuilder: (context, index) {
                    final option = policyOptions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: NeumorphicCustomCard(
                        onTap: () {
                          if (option['title'] == 'NB Register') {
                            _showDateFilterDialog(
                              context,
                              ref,
                              option['title'] as String,
                              option['color'] as Color,
                              (fromDate, toDate, agency) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NBRegisterScreen(
                                      fromDate: fromDate,
                                      toDate: toDate,
                                      agency: agency,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (option['title'] == 'SB Dues') {
                            _showDateFilterDialog(
                              context,
                              ref,
                              option['title'] as String,
                              option['color'] as Color,
                              (fromDate, toDate, agency) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SBDueScreen(
                                      fromDate: fromDate,
                                      toDate: toDate,
                                      agency: agency,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (option['title'] == 'Maturity Report') {
                            _showDateFilterDialog(
                              context,
                              ref,
                              option['title'] as String,
                              option['color'] as Color,
                              (fromDate, toDate, agency) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MaturityReportScreen(
                                      fromDate: fromDate,
                                      toDate: toDate,
                                      agency: agency,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (option['title'] == 'Birthday Report') {
                            _showDateFilterDialog(
                              context,
                              ref,
                              option['title'] as String,
                              option['color'] as Color,
                              (fromDate, toDate, agency) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BirthdayReportScreen(
                                      fromDate: fromDate,
                                      toDate: toDate,
                                      agency: agency,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (option['title'] == 'Wedding Day Report') {
                            _showDateFilterDialog(
                              context,
                              ref,
                              option['title'] as String,
                              option['color'] as Color,
                              (fromDate, toDate, agency) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WeddingReportScreen(
                                      fromDate: fromDate,
                                      toDate: toDate,
                                      agency: agency,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            _showDateFilterDialog(
                              context,
                              ref,
                              option['title'] as String,
                              option['color'] as Color,
                              (fromDate, toDate, agency) {
                                if (option['title'] == 'NB Register') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NBRegisterScreen(
                                        fromDate: fromDate,
                                        toDate: toDate,
                                        agency: agency,
                                      ),
                                    ),
                                  );
                                } else {
                                  _showPlaceholderDialog(
                                    context,
                                    option['title'] as String,
                                  );
                                }
                              },
                            );
                          }
                        },
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Neumorphic(
                              style: NeumorphicStyle(
                                depth: 6,
                                intensity: 0.65,
                                boxShape: const NeumorphicBoxShape.circle(),
                                color: option['color'] as Color,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                option['icon'] as IconData,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option['title'] as String,
                                style: NeumorphicTheme.currentTheme(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: NeumorphicAppTheme.getSecondaryTextColor(
                                  context),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlaceholderDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeumorphicTheme.baseColor(context),
        title: Text(
          title,
          style: NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
        ),
        content: Text(
          'This feature will display detailed $title information.',
          style: NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: NeumorphicTheme.accentColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDateFilterDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    Color themeColor,
    Function(DateTime fromDate, DateTime toDate, String? agency) onConfirm,
  ) {
    // Default dates: 8 months ago to 4 months in future
    DateTime? fromDate = DateTime.now().subtract(const Duration(days: 240));
    DateTime? toDate = DateTime.now().add(const Duration(days: 120));
    final fromController = TextEditingController(
        text: "${fromDate.day}/${fromDate.month}/${fromDate.year}");
    final toController = TextEditingController(
        text: "${toDate.day}/${toDate.month}/${toDate.year}");

    String? selectedAgency;

    // Fetch agencies
    Future<List<Map<String, dynamic>>> agenciesFuture =
        ref.read(lifePlusProvider.notifier).getAgencies();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: NeumorphicTheme.baseColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: themeColor.withValues(alpha: 0.5), width: 2),
              ),
              title: Text(
                'Select Filter Options',
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter $title by Risk Date',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    // From Date
                    TextField(
                      controller: fromController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'From Date',
                        suffixIcon:
                            Icon(Icons.calendar_today, color: themeColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: themeColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: themeColor, width: 2),
                        ),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: fromDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: themeColor,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            fromDate = picked;
                            fromController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // To Date
                    TextField(
                      controller: toController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'To Date',
                        suffixIcon:
                            Icon(Icons.calendar_today, color: themeColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: themeColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: themeColor, width: 2),
                        ),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: toDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: themeColor,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            toDate = picked;
                            toController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Agency Dropdown
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: agenciesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Assuming Agency table exists and has data. If empty or no table,
                        // we can either hide this or show empty.
                        final agencies = snapshot.data ?? [];

                        // Always show the dropdown, even if empty (to indicate feature exists)
                        List<DropdownMenuItem<String>> dropdownItems;
                        if (agencies.isEmpty) {
                          dropdownItems = [
                            const DropdownMenuItem<String>(
                              value: null,
                              enabled: false,
                              child: Text("No Agencies Found"),
                            )
                          ];
                        } else {
                          dropdownItems = agencies.map((agency) {
                            // Try to find name and code columns with multiple fallbacks
                            String label = agency['name']?.toString() ??
                                agency['agency_name']?.toString() ??
                                agency['aname']?.toString() ??
                                'Unknown Agency';

                            String value = agency['agno']?.toString() ??
                                agency['code']?.toString() ??
                                agency['id']?.toString() ??
                                label;

                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList();
                        }

                        return DropdownButtonFormField<String>(
                          key: ValueKey(selectedAgency),
                          initialValue: selectedAgency,
                          decoration: InputDecoration(
                            labelText: 'Agency (Optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: themeColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: themeColor, width: 2),
                            ),
                          ),
                          items: dropdownItems,
                          onChanged: agencies.isEmpty
                              ? null
                              : (val) {
                                  setState(() {
                                    selectedAgency = val;
                                  });
                                },
                          isExpanded: true,
                          disabledHint: const Text("No Agencies Found"),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (fromDate != null && toDate != null) {
                      if (fromDate!.isAfter(toDate!)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('From Date must be before To Date')),
                        );
                        return;
                      }
                      Navigator.of(context).pop();
                      onConfirm(fromDate!, toDate!, selectedAgency);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select both dates')),
                      );
                    }
                  },
                  child: const Text('View Report'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
