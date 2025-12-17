import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lifeplus_provider.dart';

enum SortState { none, asc, desc }

class BirthdayReportScreen extends ConsumerStatefulWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? agency;

  const BirthdayReportScreen({
    super.key, 
    this.fromDate, 
    this.toDate,
    this.agency,
  });

  @override
  ConsumerState<BirthdayReportScreen> createState() => _BirthdayReportScreenState();
}

class _BirthdayReportScreenState extends ConsumerState<BirthdayReportScreen> {
  late Future<List<Map<String, dynamic>>> _dataFuture;
  List<Map<String, dynamic>> _allData = [];
  List<Map<String, dynamic>> _displayedData = [];
  
  String? _sortColumn;
  SortState _sortState = SortState.none;
  
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  final List<Map<String, dynamic>> _columns = [
    {'label': 'Name', 'key': 'name', 'width': 200.0},
    {'label': 'Birth Date', 'key': 'bd', 'width': 120.0},
    {'label': 'Actual BD', 'key': 'abd', 'width': 120.0},
    {'label': 'Years Completed', 'key': 'years_completed', 'width': 150.0},
  ];

  @override
  void initState() {
    super.initState();
    _dataFuture = ref.read(lifePlusProvider.notifier).getBirthdayData(
      fromDate: widget.fromDate,
      toDate: widget.toDate,
      agency: widget.agency,
    );
  }

  void _onSort(String key) {
    setState(() {
      if (_sortColumn == key) {
        if (_sortState == SortState.none) {
          _sortState = SortState.asc;
        } else if (_sortState == SortState.asc) {
          _sortState = SortState.desc;
        } else {
          _sortState = SortState.none;
          _sortColumn = null;
        }
      } else {
        _sortColumn = key;
        _sortState = SortState.asc;
      }
      _sortData();
    });
  }

  void _sortData() {
    if (_sortState == SortState.none) {
      _displayedData = List.from(_allData);
    } else {
      _displayedData.sort((a, b) {
        dynamic valA = a[_sortColumn];
        dynamic valB = b[_sortColumn];
        
        if (valA == null) return 1;
        if (valB == null) return -1;
        
        int comparison;
        if (valA is num && valB is num) {
            comparison = valA.compareTo(valB);
        } else {
            comparison = valA.toString().compareTo(valB.toString());
        }

        return _sortState == SortState.asc ? comparison : -comparison;
      });
    }
  }
  
  Widget _buildCell(String text, double width, {bool isHeader = false, bool isSorted = false}) {
    return Container(
      width: width,
      height: isHeader ? 50 : 40,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(
           right: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: isHeader 
        ? Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSorted)
                 Icon(
                  _sortState == SortState.asc ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: Colors.pink.shade800,
                 )
            ],
          )
        : Text(
            text,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = _columns.fold(0, (sum, col) => sum + (col['width'] as double));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthday Report'),
        backgroundColor: const Color(0xFFEC4899),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.red.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No records found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            if (_allData.isEmpty) {
              _allData = snapshot.data!;
              _displayedData = List.from(_allData);
            }

            return Stack(
              children: [
                Scrollbar(
                  controller: _horizontalController,
                  thumbVisibility: true,
                  thickness: 8.0,
                  radius: const Radius.circular(8.0),
                  child: SingleChildScrollView(
                    controller: _horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: totalWidth,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
                            ),
                            child: Row(
                              children: _columns.map((col) {
                                return InkWell(
                                  onTap: () => _onSort(col['key'] as String),
                                  child: _buildCell(
                                    col['label'] as String, 
                                    col['width'] as double,
                                    isHeader: true,
                                    isSorted: _sortColumn == col['key']
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: _verticalController,
                              itemCount: _displayedData.length,
                              itemBuilder: (context, index) {
                                final row = _displayedData[index];
                                final isEven = index % 2 == 0;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: isEven ? Colors.grey.shade200 : Colors.white,
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                  ),
                                  child: Row(
                                    children: _columns.map((col) {
                                      return _buildCell(
                                        row[col['key']]?.toString() ?? '', 
                                        col['width'] as double
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 50, 
                  bottom: 0,
                  child: Scrollbar(
                    controller: _verticalController,
                    thumbVisibility: true,
                    thickness: 10.0,
                    radius: const Radius.circular(10.0),
                    interactive: true,
                    child: Container(
                      width: 14,
                      color: Colors.transparent, 
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
