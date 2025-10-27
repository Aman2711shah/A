import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// Service to generate PDF documents for applications
class PDFGenerationService {
  static PDFGenerationService? _instance;
  static PDFGenerationService get instance {
    _instance ??= PDFGenerationService._();
    return _instance!;
  }

  PDFGenerationService._();

  final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
  final _currencyFormat =
      NumberFormat.currency(symbol: 'AED ', decimalDigits: 0);

  /// Generate Trade License application receipt
  Future<File> generateTradeLicenseReceipt({
    required String applicationId,
    required String companyName,
    required String freezoneName,
    required String packageName,
    required double priceAED,
    required int visasIncluded,
    required int tenureYears,
    required List<String> businessActivities,
    required String status,
    required DateTime submittedAt,
    String? applicantName,
    String? applicantEmail,
    String? applicantPhone,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Header
            _buildHeader('Trade License Application Receipt'),
            pw.SizedBox(height: 20),

            // Application Details
            _buildSectionTitle('Application Details'),
            _buildDetailRow('Application ID:', applicationId),
            _buildDetailRow('Status:', status),
            _buildDetailRow('Submitted:', _dateFormat.format(submittedAt)),
            pw.SizedBox(height: 20),

            // Company Information
            _buildSectionTitle('Company Information'),
            _buildDetailRow('Company Name:', companyName),
            _buildDetailRow('Freezone:', freezoneName),
            pw.SizedBox(height: 20),

            // Package Details
            _buildSectionTitle('Package Details'),
            _buildDetailRow('Package:', packageName),
            _buildDetailRow('Price:', _currencyFormat.format(priceAED)),
            _buildDetailRow('Visas Included:', visasIncluded.toString()),
            _buildDetailRow('License Tenure:', '$tenureYears year(s)'),
            pw.SizedBox(height: 20),

            // Business Activities
            _buildSectionTitle('Business Activities'),
            ...businessActivities.map(
              (activity) => pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16, bottom: 4),
                child: pw.Text('• $activity',
                    style: const pw.TextStyle(fontSize: 11)),
              ),
            ),
            pw.SizedBox(height: 20),

            // Applicant Information
            if (applicantName != null ||
                applicantEmail != null ||
                applicantPhone != null) ...[
              _buildSectionTitle('Applicant Information'),
              if (applicantName != null)
                _buildDetailRow('Name:', applicantName),
              if (applicantEmail != null)
                _buildDetailRow('Email:', applicantEmail),
              if (applicantPhone != null)
                _buildDetailRow('Phone:', applicantPhone),
              pw.SizedBox(height: 20),
            ],

            // Footer
            pw.Divider(),
            pw.SizedBox(height: 10),
            _buildFooter(),
          ],
        ),
      );

      return await _savePDF(pdf, 'Trade_License_Receipt_$applicationId.pdf');
    } catch (e) {
      debugPrint('❌ Error generating trade license receipt: $e');
      rethrow;
    }
  }

  /// Generate Visa application summary
  Future<File> generateVisaSummary({
    required String applicationId,
    required String visaType,
    required String fullName,
    required String nationality,
    required String passportNumber,
    required DateTime dateOfBirth,
    required String status,
    required DateTime submittedAt,
    String? position,
    String? sponsorCompany,
    String? sponsorId,
    double? processingFee,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Header
            _buildHeader('Visa Application Summary'),
            pw.SizedBox(height: 20),

            // Application Details
            _buildSectionTitle('Application Details'),
            _buildDetailRow('Application ID:', applicationId),
            _buildDetailRow('Visa Type:', visaType),
            _buildDetailRow('Status:', status),
            _buildDetailRow('Submitted:', _dateFormat.format(submittedAt)),
            pw.SizedBox(height: 20),

            // Applicant Information
            _buildSectionTitle('Applicant Information'),
            _buildDetailRow('Full Name:', fullName),
            _buildDetailRow('Nationality:', nationality),
            _buildDetailRow('Passport Number:', passportNumber),
            _buildDetailRow('Date of Birth:',
                DateFormat('dd MMM yyyy').format(dateOfBirth)),
            if (position != null) _buildDetailRow('Position:', position),
            pw.SizedBox(height: 20),

            // Sponsor Information
            if (sponsorCompany != null || sponsorId != null) ...[
              _buildSectionTitle('Sponsor Information'),
              if (sponsorCompany != null)
                _buildDetailRow('Company:', sponsorCompany),
              if (sponsorId != null) _buildDetailRow('Sponsor ID:', sponsorId),
              pw.SizedBox(height: 20),
            ],

            // Fees
            if (processingFee != null) ...[
              _buildSectionTitle('Fees'),
              _buildDetailRow(
                  'Processing Fee:', _currencyFormat.format(processingFee)),
              pw.SizedBox(height: 20),
            ],

            // Footer
            pw.Divider(),
            pw.SizedBox(height: 10),
            _buildFooter(),
          ],
        ),
      );

      return await _savePDF(pdf, 'Visa_Application_$applicationId.pdf');
    } catch (e) {
      debugPrint('❌ Error generating visa summary: $e');
      rethrow;
    }
  }

  /// Generate Company Setup report
  Future<File> generateCompanySetupReport({
    required String setupId,
    required String legalStructure,
    required String companyName,
    required List<Map<String, dynamic>> completedSteps,
    required DateTime startedAt,
    DateTime? completedAt,
    String? freezoneName,
    double? totalCost,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Header
            _buildHeader('Company Setup Report'),
            pw.SizedBox(height: 20),

            // Setup Details
            _buildSectionTitle('Setup Details'),
            _buildDetailRow('Setup ID:', setupId),
            _buildDetailRow('Company Name:', companyName),
            _buildDetailRow('Legal Structure:', legalStructure),
            if (freezoneName != null)
              _buildDetailRow('Freezone:', freezoneName),
            _buildDetailRow('Started:', _dateFormat.format(startedAt)),
            if (completedAt != null)
              _buildDetailRow('Completed:', _dateFormat.format(completedAt)),
            pw.SizedBox(height: 20),

            // Completed Steps
            _buildSectionTitle('Completed Steps'),
            ...completedSteps.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final step = entry.value;
              return pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16, bottom: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '$index. ${step['title']}',
                      style: pw.TextStyle(
                          fontSize: 11, fontWeight: pw.FontWeight.bold),
                    ),
                    if (step['description'] != null)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 16, top: 2),
                        child: pw.Text(
                          step['description'],
                          style: const pw.TextStyle(
                              fontSize: 10, color: PdfColors.grey700),
                        ),
                      ),
                  ],
                ),
              );
            }),
            pw.SizedBox(height: 20),

            // Cost Summary
            if (totalCost != null) ...[
              _buildSectionTitle('Cost Summary'),
              _buildDetailRow('Total Cost:', _currencyFormat.format(totalCost)),
              pw.SizedBox(height: 20),
            ],

            // Footer
            pw.Divider(),
            pw.SizedBox(height: 10),
            _buildFooter(),
          ],
        ),
      );

      return await _savePDF(pdf, 'Company_Setup_Report_$setupId.pdf');
    } catch (e) {
      debugPrint('❌ Error generating company setup report: $e');
      rethrow;
    }
  }

  /// Generate monthly applications report (for admins)
  Future<File> generateMonthlyReport({
    required DateTime startDate,
    required DateTime endDate,
    required int totalApplications,
    required int tradeLicenseCount,
    required int visaCount,
    required int companySetupCount,
    required double totalRevenue,
    required Map<String, int> statusBreakdown,
    required List<Map<String, dynamic>> topFreezones,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Header
            _buildHeader('Monthly Applications Report'),
            pw.SizedBox(height: 10),
            pw.Text(
              '${DateFormat('dd MMM yyyy').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}',
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 20),

            // Summary Statistics
            _buildSectionTitle('Summary Statistics'),
            _buildDetailRow(
                'Total Applications:', totalApplications.toString()),
            _buildDetailRow('Trade Licenses:', tradeLicenseCount.toString()),
            _buildDetailRow('Visa Applications:', visaCount.toString()),
            _buildDetailRow('Company Setups:', companySetupCount.toString()),
            _buildDetailRow(
                'Total Revenue:', _currencyFormat.format(totalRevenue)),
            pw.SizedBox(height: 20),

            // Status Breakdown
            _buildSectionTitle('Status Breakdown'),
            ...statusBreakdown.entries.map(
              (entry) =>
                  _buildDetailRow('${entry.key}:', entry.value.toString()),
            ),
            pw.SizedBox(height: 20),

            // Top Freezones
            _buildSectionTitle('Top Freezones'),
            pw.Table.fromTextArray(
              headers: ['Rank', 'Freezone', 'Applications'],
              data: topFreezones.asMap().entries.map((entry) {
                final rank = entry.key + 1;
                final freezone = entry.value;
                return [
                  rank.toString(),
                  freezone['name'].toString(),
                  freezone['count'].toString(),
                ];
              }).toList(),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
            ),
            pw.SizedBox(height: 20),

            // Footer
            pw.Divider(),
            pw.SizedBox(height: 10),
            _buildFooter(),
          ],
        ),
      );

      final fileName =
          'Monthly_Report_${DateFormat('MMM_yyyy').format(startDate)}.pdf';
      return await _savePDF(pdf, fileName);
    } catch (e) {
      debugPrint('❌ Error generating monthly report: $e');
      rethrow;
    }
  }

  /// Build header widget
  pw.Widget _buildHeader(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'WAZEET',
          style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Your Partner in UAE Business Setup',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 16),
        pw.Divider(thickness: 2, color: PdfColors.blue900),
        pw.SizedBox(height: 16),
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  /// Build section title
  pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900),
      ),
    );
  }

  /// Build detail row
  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  /// Build footer
  pw.Widget _buildFooter() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Generated on ${_dateFormat.format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Contact: info@wazeet.com | +971 XXX XXXXX',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
        pw.Text(
          'www.wazeet.com',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.blue700),
        ),
      ],
    );
  }

  /// Save PDF to file
  Future<File> _savePDF(pw.Document pdf, String fileName) async {
    try {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(await pdf.save());
      debugPrint('✅ PDF saved: ${file.path}');
      return file;
    } catch (e) {
      debugPrint('❌ Error saving PDF: $e');
      rethrow;
    }
  }

  /// Share PDF file
  Future<void> sharePDF(File pdfFile, {String? subject}) async {
    try {
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        subject: subject ?? 'Wazeet Document',
      );
      debugPrint('✅ PDF shared: ${pdfFile.path}');
    } catch (e) {
      debugPrint('❌ Error sharing PDF: $e');
      rethrow;
    }
  }

  /// Save PDF to downloads (Android) or documents (iOS)
  Future<String?> savePDFToDevice(File pdfFile) async {
    try {
      if (Platform.isAndroid) {
        // On Android, save to Downloads
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }
        final newPath = '${downloadsDir.path}/${pdfFile.path.split('/').last}';
        await pdfFile.copy(newPath);
        debugPrint('✅ PDF saved to: $newPath');
        return newPath;
      } else if (Platform.isIOS) {
        // On iOS, save to app documents (accessible via Files app)
        final appDocDir = await getApplicationDocumentsDirectory();
        final newPath = '${appDocDir.path}/${pdfFile.path.split('/').last}';
        await pdfFile.copy(newPath);
        debugPrint('✅ PDF saved to: $newPath');
        return newPath;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error saving PDF to device: $e');
      return null;
    }
  }
}
