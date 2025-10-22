import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/setup_state.dart';
import 'company_setup_tab.dart';

class CompanySetupTabScreen extends StatelessWidget {
  const CompanySetupTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SetupState(),
      child: const CompanySetupTab(),
    );
  }
}
