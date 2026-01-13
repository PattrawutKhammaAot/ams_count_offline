import 'package:flutter/material.dart';

/// Custom QR/Barcode Scanner Page
/// Returns the scanned code as String when a QR/Barcode is successfully scanned
class QRCodeViewPage extends StatefulWidget {
  const QRCodeViewPage({Key? key}) : super(key: key);

  @override
  State<QRCodeViewPage> createState() => _QRCodeViewPageState();
}

class _QRCodeViewPageState extends State<QRCodeViewPage> {
  String? _scannedCode;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR/Barcode'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.black,
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.qr_code_2,
                                size: 80,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Point camera at QR/Barcode',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_scannedCode != null)
                      Column(
                        children: [
                          const Text(
                            'Scanned:',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _scannedCode!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    else
                      const Text(
                        'Waiting for scan...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _scannedCode != null ? _confirmScan : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Simulates QR code scanning (Replace with actual camera integration if needed)
  void _simulateScan() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate scanning delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
        // This is where you'd get the actual scanned data
        // For now, it's waiting for user input
      });
    }
  }

  void _confirmScan() {
    if (_scannedCode != null && _scannedCode!.isNotEmpty) {
      Navigator.pop(context, _scannedCode);
    }
  }

  @override
  void initState() {
    super.initState();
    _simulateScan();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
