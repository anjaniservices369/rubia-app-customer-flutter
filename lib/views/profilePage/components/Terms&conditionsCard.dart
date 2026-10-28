// =============================================================================
// WHAT : Terms and conditions text.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../globalWidgets/legalDocumentPage.dart';

// >>> START: TermsConditionsCard - screen/widget shell (the visible part is in its State class)
class TermsConditionsCard extends StatefulWidget {
  const TermsConditionsCard({Key? key}) : super(key: key);

  @override
  State<TermsConditionsCard> createState() => _TermsConditionsCardState();
}
// <<< END: TermsConditionsCard - screen/widget shell (the visible part is in its State class)

// >>> START: _TermsConditionsCardState - the data and logic behind its screen
class _TermsConditionsCardState extends State<TermsConditionsCard> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
          color: tWhite,
          boxShadow: [tBackbtnBoxShadow],
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _policyItem(
            icon: Images.PRIVACT_POLICY,
            title: "Privacy_Policy".tr,
            onTap: () => LegalDocumentPage.open(
                context, LegalDocumentPage.privacy, "Privacy Policy"),
          ),
          const Divider(height: 1, indent: 52, endIndent: 12),
          _policyItem(
            icon: Images.TERMS_CONDITIONS,
            title: 'terms_conditions'.tr,
            onTap: () => LegalDocumentPage.open(
                context, LegalDocumentPage.terms, "Terms and Conditions"),
          ),
          const Divider(height: 1, indent: 52, endIndent: 12),
          _policyItem(
            icon: Images.REFUND_POLICY,
            title: "Cancellation & Refund Policy".tr,
            onTap: () => LegalDocumentPage.open(
                context, LegalDocumentPage.refund, "Refund Policy"),
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: _policyItem - policy item
  Widget _policyItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      minLeadingWidth: 32,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      visualDensity: const VisualDensity(vertical: 1),
      leading: Image.asset(icon, width: 24, height: 24, fit: BoxFit.contain),
      title: Text(
        title,
        style: TextStyle(
          color: tDarkNavyblue,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: tDarkNavyblue.withValues(alpha: 0.55),
        size: 16,
      ),
    );
  }
  // <<< END: _policyItem - policy item
}
// <<< END: _TermsConditionsCardState - the data and logic behind its screen
