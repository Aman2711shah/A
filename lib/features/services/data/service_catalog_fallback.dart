import '../models/service_catalog.dart';

/// Temporary fallback data used when Firestore does not yet contain the
/// services catalogue. This keeps the Services and Growth tabs functional
/// while the backend gets populated.
final List<ServiceCategory> fallbackServiceCatalog = [
  ServiceCategory(
    id: 'company_setup',
    name: 'Company Setup',
    subtitle: 'Mainland • Freezone • Offshore',
    overview:
        'End-to-end incorporation support including licensing, banking, and PRO assistance.',
    benefits: const [
      'Dedicated incorporation specialist',
      'Document preparation & submission',
      'Bank account opening support',
      'Visa processing assistance',
    ],
    requirements: const [
      'Shareholder documents',
      'Business activity selection',
      'Office space preference',
    ],
    types: const [
      ServiceType(
        name: 'Mainland Company',
        subServices: [
          SubService(
            name: 'LLC Formation',
            premiumCost: 14500,
            standardCost: 10999,
            premiumTimeline: '5-7 days',
            standardTimeline: '10-12 days',
            documents:
                'Passport copy, business plan, tenancy contract (if available)',
          ),
          SubService(
            name: 'Professional License',
            premiumCost: 12500,
            standardCost: 8999,
            premiumTimeline: '4-6 days',
            standardTimeline: '8-10 days',
            documents: 'Passport copy, qualification certificates',
          ),
        ],
      ),
      ServiceType(
        name: 'Freezone Company',
        subServices: [
          SubService(
            name: 'Flexi Desk Package',
            premiumCost: 10500,
            standardCost: 8200,
            premiumTimeline: '3-5 days',
            standardTimeline: '7-9 days',
            documents: 'Passport copy, digital photo, business activity list',
          ),
          SubService(
            name: 'Office Package',
            premiumCost: 16500,
            standardCost: 13200,
            premiumTimeline: '5-7 days',
            standardTimeline: '10-12 days',
            documents: 'Passport copy, tenancy contract, MOA draft',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'business_support',
    name: 'Business Support',
    subtitle: 'Banking • Accounting • Compliance',
    overview:
        'Keep your new company compliant with curated accounting and PRO services.',
    benefits: const [
      'Vetted accounting partners',
      'Monthly bookkeeping & VAT filing',
      'Corporate bank introductions',
      'Ongoing PRO assistance',
    ],
    requirements: const [
      'Trade license copy',
      'Passport copies of shareholders',
      'Corporate documents (MOA, AOA)',
    ],
    types: const [
      ServiceType(
        name: 'Accounting & VAT',
        subServices: [
          SubService(
            name: 'Starter Package',
            premiumCost: 6500,
            standardCost: 4800,
            premiumTimeline: 'Setup within 48h',
            standardTimeline: 'Setup within 5 days',
            documents: 'License copy, bank statements, invoices',
          ),
          SubService(
            name: 'Growth Package',
            premiumCost: 9500,
            standardCost: 7500,
            premiumTimeline: 'Setup within 72h',
            standardTimeline: 'Setup within 7 days',
            documents: 'Financial statements, payroll records',
          ),
        ],
      ),
      ServiceType(
        name: 'Corporate Banking',
        subServices: [
          SubService(
            name: 'Standard Account Opening',
            premiumCost: 4200,
            standardCost: 2800,
            premiumTimeline: '7-10 days',
            standardTimeline: '15-20 days',
            documents: 'License, MOA/AOA, passport copies, business plan',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    id: 'growth_services',
    name: 'Growth Services',
    subtitle: 'Marketing • Funding • Expansion',
    overview:
        'Strategic support to scale your company through marketing, funding, and market entry.',
    benefits: const [
      'Dedicated growth strategist',
      'Pitch deck & investor readiness',
      'Regional expansion playbooks',
      'Performance marketing management',
    ],
    requirements: const [
      'Company profile',
      'Financial projections',
      'Target market information',
    ],
    types: const [
      ServiceType(
        name: 'Funding Support',
        subServices: [
          SubService(
            name: 'Pitch Deck + Investor Outreach',
            premiumCost: 12000,
            standardCost: 8500,
            premiumTimeline: '3 weeks',
            standardTimeline: '5 weeks',
            documents: 'Business plan, financial model, pitch collateral',
          ),
        ],
      ),
      ServiceType(
        name: 'Marketing Launchpads',
        subServices: [
          SubService(
            name: 'Digital Launch',
            premiumCost: 7800,
            standardCost: 5900,
            premiumTimeline: '2 weeks',
            standardTimeline: '4 weeks',
            documents: 'Brand guidelines, product info, target personas',
          ),
        ],
      ),
    ],
  ),
];
