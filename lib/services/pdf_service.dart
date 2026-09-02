import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  Future<void> generateAndPrintReport({
    required String userName,
    required String userEmail,
    required List<Map<String, dynamic>> activeListings,
    required List<Map<String, dynamic>> orders,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    "Crop Connect - Farmer Report",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text("User: $userName"),
                pw.Text("Email: $userEmail"),
                pw.Text("Generated on: ${DateTime.now().toLocal()}"),
                pw.SizedBox(height: 20),

                pw.Text(
                  "Active Crop Listings",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Divider(),
                ...activeListings.map((item) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Text(
                      "- ${item['cropName'] ?? 'Crop'}: ${item['quantity'] ?? '0'} Qtl @ ₹${item['price'] ?? '0'}/Qtl (Location: ${item['location'] ?? 'N/A'})",
                    ),
                  );
                }),
                if (activeListings.isEmpty) pw.Text("No active listings."),

                pw.SizedBox(height: 20),
                pw.Text(
                  "Recent Orders",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Divider(),
                ...orders.map((order) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Text(
                      "- ${order['cropName'] ?? 'Crop'}: Status: ${order['status'] ?? 'Processing'}",
                    ),
                  );
                }),
                if (orders.isEmpty) pw.Text("No recent orders."),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
