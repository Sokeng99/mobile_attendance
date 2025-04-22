import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/qr_controller.dart';
import '../models/attendance.dart';

class AttendanceListView extends StatefulWidget {
  const AttendanceListView({Key? key}) : super(key: key);

  @override
  State<AttendanceListView> createState() => _AttendanceListViewState();
}

class _AttendanceListViewState extends State<AttendanceListView> {
  final QrController controller = Get.find<QrController>();
  late Future<List<AttendanceModel>> _attendanceRecords;
  
  @override
  void initState() {
    super.initState();
    _loadAttendanceRecords();
  }
  
  void _loadAttendanceRecords() {
    _attendanceRecords = controller.getAttendanceRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Records'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loadAttendanceRecords();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AttendanceModel>>(
        future: _attendanceRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No attendance records found',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            return _buildAttendanceList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildAttendanceList(List<AttendanceModel> records) {
    // Group records by date
    final Map<String, List<AttendanceModel>> groupedRecords = {};
    
    for (final record in records) {
      final date = DateFormat('yyyy-MM-dd').format(record.checkInTime ?? DateTime.now());
      if (!groupedRecords.containsKey(date)) {
        groupedRecords[date] = [];
      }
      groupedRecords[date]!.add(record);
    }
    
    // Sort dates in descending order
    final sortedDates = groupedRecords.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dateRecords = groupedRecords[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _formatDateHeader(date),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dateRecords.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final record = dateRecords[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    record.userName ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${record.userId}'),
                  trailing: Text(
                    DateFormat('HH:mm:ss').format(record.checkInTime ?? DateTime.now()),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
            const Divider(thickness: 1),
          ],
        );
      },
    );
  }
  
  String _formatDateHeader(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today (${DateFormat('EEEE, MMMM d').format(date)})';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday (${DateFormat('EEEE, MMMM d').format(date)})';
    } else {
      return DateFormat('EEEE, MMMM d, y').format(date);
    }
  }
} 