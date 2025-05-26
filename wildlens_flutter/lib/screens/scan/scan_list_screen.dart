import 'package:flutter/material.dart';
import '../../widgets/app_routes.dart';
import '../../widgets/config.dart';
import '../../services/api_service.dart';

class ScanListScreen extends StatefulWidget {
  const ScanListScreen({Key? key}) : super(key: key);
  @override
  State<ScanListScreen> createState() => _ScanListScreenState();
}

class _ScanListScreenState extends State<ScanListScreen> {
  List<dynamic> _scans = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchScans();
  }

  Future<void> _fetchScans() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final scans = await ApiService().getScans();
      setState(() {
        _scans = scans;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des scans'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _scans.length,
                  itemBuilder: (context, index) {
                    final scan = _scans[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(scan['image'], width: 50, height: 50, fit: BoxFit.cover),
                        ),
                        title: Text(scan['name'], style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                        subtitle: Text(scan['date'], style: AppTextStyles.caption),
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.scanDetail, arguments: scan);
                        },
                      ),
                    );
                  },
                ),
    );
  }
} 