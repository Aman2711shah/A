import '../models/service_catalog.dart';

/// Temporary fallback data used when Firestore does not yet contain the
/// services catalogue. This keeps the Services and Growth tabs functional
/// while the backend gets populated.
final List<ServiceCategory> fallbackServiceCatalog = [
  ServiceCategory(
    id: 'visa_immigration',
    name: 'Visa and Immigration Service',
    subtitle: 'Residence • Employment • Visit Visas',
    overview:
        'Complete visa and immigration solutions for individuals and businesses seeking to relocate or work in the UAE.',
    benefits: const [
      'Expert visa consultants',
      'Fast-track processing',
      'Document preparation support',
      'Post-approval assistance',
    ],
    requirements: const [
      'Valid passport',
      'Employment contract (if applicable)',
      'Medical fitness certificate',
    ],
    types: const [
      ServiceType(
        name: 'Residence Visa',
        subServices: [
          SubService(
            name: 'Employment Visa Package',
            premiumCost: 3500,
            standardCost: 2200,
            premiumTimeline: '5-7 days',
            standardTimeline: '10-14 days',
            documents: 'Passport, employment contract, medical test',
          ),
          SubService(
            name: 'Investor Visa',
            premiumCost: 5000,
            standardCost: 3500,
            premiumTimeline: '7-10 days',
            standardTimeline: '12-15 days',
            documents: 'Investment proof, business plan, passport',
          ),
        ],
      ),
      ServiceType(
        name: 'Visit Visa',
        subServices: [
          SubService(
            name: 'Tourist Visa (30 days)',
            premiumCost: 500,
            standardCost: 350,
            premiumTimeline: '1-2 days',
            standardTimeline: '3-5 days',
            documents: 'Passport, sponsorship letter',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'federal_tax_authority',
    name: 'Federal Tax Authority',
    subtitle: 'FTA Registration • Tax Compliance • Refunds',
    overview:
        'Professional guidance on FTA registration, corporate tax compliance, and tax optimization strategies.',
    benefits: const [
      'FTA registration support',
      'Tax compliance management',
      'Refund claim assistance',
      'Audit preparation',
    ],
    requirements: const [
      'Trade license copy',
      'Financial records',
      'Business documentation',
    ],
    types: const [
      ServiceType(
        name: 'Corporate Tax',
        subServices: [
          SubService(
            name: 'FTA Registration & Setup',
            premiumCost: 2500,
            standardCost: 1500,
            premiumTimeline: '3-4 days',
            standardTimeline: '5-7 days',
            documents: 'License, financial statements, MOA',
          ),
          SubService(
            name: 'Annual Tax Filing',
            premiumCost: 3000,
            standardCost: 2000,
            premiumTimeline: '2-3 days',
            standardTimeline: '4-6 days',
            documents: 'Audited accounts, supporting documents',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'banking_services',
    name: 'Banking Services',
    subtitle: 'Account Opening • Financing • Payment Solutions',
    overview:
        'Comprehensive banking solutions including corporate accounts, credit facilities, and payment processing.',
    benefits: const [
      'Quick account opening',
      'Competitive financing rates',
      'Dedicated relationship manager',
      'Payment gateway integration',
    ],
    requirements: const [
      'Trade license',
      'Shareholder identification',
      'Business documentation',
    ],
    types: const [
      ServiceType(
        name: 'Corporate Banking',
        subServices: [
          SubService(
            name: 'Business Account Opening',
            premiumCost: 1200,
            standardCost: 800,
            premiumTimeline: '2-3 days',
            standardTimeline: '5-7 days',
            documents: 'License, MOA, passport copies',
          ),
          SubService(
            name: 'Business Loans & Credit',
            premiumCost: 5000,
            standardCost: 3000,
            premiumTimeline: '5-7 days',
            standardTimeline: '10-15 days',
            documents: 'Audited financials, business plan',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'accounting_bookkeeping',
    name: 'Accounting & Bookkeeping',
    subtitle: 'Monthly • Annual • VAT • Payroll',
    overview:
        'Full accounting and bookkeeping services to keep your business finances organized and compliant.',
    benefits: const [
      'Monthly financial reports',
      'VAT compliance',
      'Payroll management',
      'Year-end audits',
    ],
    requirements: const [
      'Business documents',
      'Financial records',
      'Bank statements',
    ],
    types: const [
      ServiceType(
        name: 'Monthly Accounting',
        subServices: [
          SubService(
            name: 'Basic Package',
            premiumCost: 2500,
            standardCost: 1800,
            premiumTimeline: 'Monthly',
            standardTimeline: 'Monthly',
            documents: 'Invoices, expenses, bank statements',
          ),
          SubService(
            name: 'Premium Package',
            premiumCost: 4000,
            standardCost: 3000,
            premiumTimeline: 'Monthly',
            standardTimeline: 'Monthly',
            documents: 'Complete financial records',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'attestation_legalization',
    name: 'Attestation & Legalization',
    subtitle: 'Document Attestation • Legalization • Notarization',
    overview:
        'Professional attestation and legalization of documents for UAE and international use.',
    benefits: const [
      'Fast processing',
      'Multi-level authentication',
      'International recognition',
      'Expert guidance',
    ],
    requirements: const [
      'Original documents',
      'Valid identification',
      'Purpose of attestation',
    ],
    types: const [
      ServiceType(
        name: 'Document Attestation',
        subServices: [
          SubService(
            name: 'Educational Certificate Attestation',
            premiumCost: 800,
            standardCost: 500,
            premiumTimeline: '3-4 days',
            standardTimeline: '6-8 days',
            documents: 'Certificate, identification copy',
          ),
          SubService(
            name: 'Commercial Document Attestation',
            premiumCost: 1200,
            standardCost: 800,
            premiumTimeline: '2-3 days',
            standardTimeline: '4-6 days',
            documents: 'Business documents, MOA, AOA',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'pro_services',
    name: 'PRO Services',
    subtitle: 'Licensing • Renewals • Government Services',
    overview:
        'Complete PRO services for licensing, renewals, and government transactions.',
    benefits: const [
      'Government relationship',
      'Fast-track approvals',
      'Complete documentation',
      'License renewals',
    ],
    requirements: const [
      'Trade license',
      'Passport copy',
      'Business details',
    ],
    types: const [
      ServiceType(
        name: 'License Management',
        subServices: [
          SubService(
            name: 'License Renewal',
            premiumCost: 2000,
            standardCost: 1200,
            premiumTimeline: '2-3 days',
            standardTimeline: '5-7 days',
            documents: 'Current license, MOA',
          ),
          SubService(
            name: 'Activity Amendment',
            premiumCost: 1500,
            standardCost: 1000,
            premiumTimeline: '1-2 days',
            standardTimeline: '3-5 days',
            documents: 'License, amendment request',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'third_party_approval',
    name: 'Third Party Approval',
    subtitle: 'Regulatory • Compliance • Certifications',
    overview:
        'Facilitation of third-party approvals and regulatory certifications from government authorities.',
    benefits: const [
      'Expert coordination',
      'Compliance assurance',
      'Expedited processing',
      'Regulatory expertise',
    ],
    requirements: const [
      'Business documentation',
      'Compliance records',
      'Regulatory requirements',
    ],
    types: const [
      ServiceType(
        name: 'Government Approvals',
        subServices: [
          SubService(
            name: 'Municipality Approval',
            premiumCost: 1500,
            standardCost: 1000,
            premiumTimeline: '3-4 days',
            standardTimeline: '6-8 days',
            documents: 'License, business plan, documentation',
          ),
          SubService(
            name: 'Health & Safety Certification',
            premiumCost: 2000,
            standardCost: 1300,
            premiumTimeline: '4-5 days',
            standardTimeline: '7-10 days',
            documents: 'Business details, facility plans',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'legal_service',
    name: 'Legal Service',
    subtitle: 'Contracts • Litigation • Compliance',
    overview:
        'Comprehensive legal services including contract drafting, litigation support, and legal compliance.',
    benefits: const [
      'Expert legal counsel',
      'Contract review & drafting',
      'Litigation support',
      'Legal compliance guidance',
    ],
    requirements: const [
      'Case details',
      'Relevant documents',
      'Legal authority',
    ],
    types: const [
      ServiceType(
        name: 'Business Legal',
        subServices: [
          SubService(
            name: 'Contract Drafting & Review',
            premiumCost: 3000,
            standardCost: 2000,
            premiumTimeline: '2-3 days',
            standardTimeline: '5-7 days',
            documents: 'Contract draft, specifications',
          ),
          SubService(
            name: 'Legal Compliance Audit',
            premiumCost: 4000,
            standardCost: 2500,
            premiumTimeline: '3-5 days',
            standardTimeline: '7-10 days',
            documents: 'Business documents, policies',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'payroll_hr_services',
    name: 'Payroll & HR Services',
    subtitle: 'Payroll Processing • HR Support • Compliance',
    overview:
        'Complete payroll and HR services including processing, compliance, and employee management.',
    benefits: const [
      'Accurate payroll processing',
      'HR compliance',
      'Employee documentation',
      'Labor law expertise',
    ],
    requirements: const [
      'Employee records',
      'Salary information',
      'Company policies',
    ],
    types: const [
      ServiceType(
        name: 'Payroll Management',
        subServices: [
          SubService(
            name: 'Monthly Payroll Processing',
            premiumCost: 2500,
            standardCost: 1500,
            premiumTimeline: 'Monthly',
            standardTimeline: 'Monthly',
            documents: 'Employee details, salary structure',
          ),
          SubService(
            name: 'HR Documentation & Compliance',
            premiumCost: 3000,
            standardCost: 2000,
            premiumTimeline: 'Setup 3-4 days',
            standardTimeline: 'Setup 5-7 days',
            documents: 'Company policies, employee contracts',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'advisory_services',
    name: 'Advisory Services',
    subtitle: 'Business • Financial • Strategic Consulting',
    overview:
        'Expert advisory services for business strategy, financial planning, and operational optimization.',
    benefits: const [
      'Strategic guidance',
      'Financial planning',
      'Business analysis',
      'Growth optimization',
    ],
    requirements: const [
      'Business information',
      'Financial data',
      'Strategic objectives',
    ],
    types: const [
      ServiceType(
        name: 'Business Consulting',
        subServices: [
          SubService(
            name: 'Business Strategy & Planning',
            premiumCost: 5000,
            standardCost: 3500,
            premiumTimeline: '5-7 days',
            standardTimeline: '10-14 days',
            documents: 'Business plan, financial statements',
          ),
          SubService(
            name: 'Financial Planning & Analysis',
            premiumCost: 4000,
            standardCost: 2500,
            premiumTimeline: '4-6 days',
            standardTimeline: '8-10 days',
            documents: 'Financial records, projections',
          ),
        ],
      ),
    ],
  ),
];
