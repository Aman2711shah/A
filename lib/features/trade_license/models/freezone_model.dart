import 'package:flutter/material.dart';

enum FreezoneType { freeZone, mainland }

class FreezoneModel {
  final String id;
  final String name;
  final String emirate;
  final FreezoneType type;
  final String description;
  final List<String> features;
  final List<String> benefits;
  final IconData icon;
  final Color color;
  final String? jsonName; // Name used in the freezone_packages.json file

  const FreezoneModel({
    required this.id,
    required this.name,
    required this.emirate,
    required this.type,
    required this.description,
    required this.features,
    required this.benefits,
    this.icon = Icons.business,
    this.color = Colors.blue,
    this.jsonName,
  });

  // Static list of all 30+ Free Zones and 7 Mainland DEDs
  static List<FreezoneModel> getAllFreezones() {
    return [
      // Dubai Free Zones
      FreezoneModel(
        id: 'ifza_dubai',
        name: 'IFZA (International Free Zone Authority)',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description:
            'Affordable packages, fast setup, remote registration available',
        features: [
          '100% foreign ownership',
          'Zero corporate and personal tax',
          'Quick online setup',
          'Flexible office solutions',
        ],
        benefits: [
          'Cost-effective packages starting from AED 8,000',
          'Setup within 2-3 days',
          'No physical presence required',
          'Multi-currency bank accounts',
        ],
        icon: Icons.business_center,
        color: Colors.blue,
        jsonName: 'IFZA Dubai',
      ),
      FreezoneModel(
        id: 'dmcc_dubai',
        name: 'DMCC (Dubai Multi Commodities Centre)',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description:
            'Global trading hub, premium location, gold/crypto friendly',
        features: [
          'Prime location in Jumeirah Lakes Towers',
          'Gold and diamond trading hub',
          'Crypto-friendly jurisdiction',
          'World-class infrastructure',
        ],
        benefits: [
          'Access to global markets',
          'Prestigious business address',
          'State-of-the-art facilities',
          'Strong networking community',
        ],
        icon: Icons.diamond,
        color: Color(0xFFFFD700),
        jsonName: 'DMCC',
      ),
      FreezoneModel(
        id: 'meydan_dubai',
        name: 'Meydan Free Zone',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description: 'Sports, hospitality, and entertainment businesses',
        features: [
          'Located at Meydan Racecourse',
          'Focus on sports and entertainment',
          'Flexible licensing options',
          'Modern office spaces',
        ],
        benefits: [
          'Strategic location near Downtown Dubai',
          'Access to premium facilities',
          'Networking opportunities',
          '100% ownership',
        ],
        icon: Icons.sports,
        color: Colors.purple,
        jsonName: 'Meydan Free Zone',
      ),
      FreezoneModel(
        id: 'dtec_dubai',
        name: 'Dubai Technology Entrepreneur Campus (DTEC)',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description:
            'Best for tech startups, innovation-focused, coworking spaces',
        features: [
          'Located in Dubai Silicon Oasis',
          'Focus on tech and innovation',
          'Coworking and flexible spaces',
          'Startup-friendly ecosystem',
        ],
        benefits: [
          'Lower setup costs',
          'Community of tech entrepreneurs',
          'Access to mentorship programs',
          'Networking events',
        ],
        icon: Icons.computer,
        color: Color(0xFF00BCD4),
      ),
      FreezoneModel(
        id: 'dubai_south',
        name: 'Dubai South Free Zone',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description: 'Near Al Maktoum Airport, logistics and aviation focus',
        features: [
          'Adjacent to Al Maktoum International Airport',
          'Logistics and aviation hub',
          'Large warehousing facilities',
          'Excellent connectivity',
        ],
        benefits: [
          'Strategic location for logistics',
          'Access to airport facilities',
          'Competitive pricing',
          'Growing business community',
        ],
        icon: Icons.local_airport,
        color: Colors.indigo,
        jsonName: 'Dubai South',
      ),
      FreezoneModel(
        id: 'jafza_dubai',
        name: 'JAFZA (Jebel Ali Free Zone)',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description: 'Largest free zone, manufacturing and logistics hub',
        features: [
          'Largest free zone in the region',
          'World-class port facilities',
          'Manufacturing capabilities',
          'Industrial infrastructure',
        ],
        benefits: [
          'Direct access to Jebel Ali Port',
          'Global trade connectivity',
          'Extensive warehousing',
          'Established business community',
        ],
        icon: Icons.factory,
        color: Colors.orange,
      ),
      FreezoneModel(
        id: 'duqe_dubai',
        name: 'DUQE Free Zone',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description: 'Affordable option near Dubai Investment Park',
        features: [
          'Cost-effective solutions',
          'Near Dubai Investment Park',
          'Flexible office options',
          'Quick setup process',
        ],
        benefits: [
          'Lower setup and renewal costs',
          'Good connectivity',
          'Growing business area',
          'Diverse business community',
        ],
        icon: Icons.account_balance,
        color: Colors.teal,
      ),
      FreezoneModel(
        id: 'dafza_dubai',
        name: 'DAFZA (Dubai Airport Free Zone)',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description: 'Near Dubai International Airport, trade and logistics',
        features: [
          'Adjacent to Dubai International Airport',
          'Focus on trade and logistics',
          'Modern office facilities',
          'Excellent air connectivity',
        ],
        benefits: [
          'Prime airport location',
          'Quick cargo access',
          'Global reach',
          'Premium business environment',
        ],
        icon: Icons.flight,
        color: Colors.red,
      ),
      FreezoneModel(
        id: 'dic_dubai',
        name: 'Dubai Internet City',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description: 'Tech giants and IT companies, innovation hub',
        features: [
          'Home to global tech companies',
          'IT and telecom focus',
          'Innovation ecosystem',
          'State-of-the-art facilities',
        ],
        benefits: [
          'Prestigious tech address',
          'Networking with tech leaders',
          'Access to talent pool',
          'Business support services',
        ],
        icon: Icons.wifi,
        color: Color(0xFF9C27B0),
      ),
      FreezoneModel(
        id: 'dso_dubai',
        name: 'Dubai Silicon Oasis',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description: 'Technology park, R&D facilities, education focus',
        features: [
          'Integrated technology park',
          'Focus on tech and education',
          'R&D facilities',
          'Academic partnerships',
        ],
        benefits: [
          'Innovation-driven environment',
          'Access to universities',
          'Cost-effective solutions',
          'Growing tech community',
        ],
        icon: Icons.school,
        color: Color(0xFF673AB7),
      ),
      FreezoneModel(
        id: 'difc_dubai',
        name: 'DIFC (Dubai International Financial Centre)',
        emirate: 'Dubai',
        type: FreezoneType.freeZone,
        description: 'Leading financial hub, banking and financial services',
        features: [
          'Financial services focus',
          'Independent legal system',
          'Common law framework',
          'Access to MENA markets',
        ],
        benefits: [
          'Prestigious financial address',
          'Regulatory excellence',
          'World-class infrastructure',
          'Tax advantages',
        ],
        icon: Icons.account_balance_wallet,
        color: Color(0xFF006064),
        jsonName: 'DIFC',
      ),

      // Sharjah Free Zones
      FreezoneModel(
        id: 'shams_sharjah',
        name: 'SHAMS (Sharjah Media City)',
        emirate: 'Sharjah',
        type: FreezoneType.freeZone,
        description: 'Best for media, tech, and freelancers with low costs',
        features: [
          'Media and creative industries',
          'Freelancer packages available',
          'Low setup costs',
          'Quick registration process',
        ],
        benefits: [
          'Most affordable free zone',
          'Ideal for freelancers',
          'Media-friendly licensing',
          'Flexible visa options',
        ],
        icon: Icons.camera,
        color: Color(0xFFE91E63),
        jsonName: 'SHAMS',
      ),
      FreezoneModel(
        id: 'spc_sharjah',
        name: 'SPC (Sharjah Publishing City)',
        emirate: 'Sharjah',
        type: FreezoneType.freeZone,
        description: 'Publishing, printing, and media businesses',
        features: [
          'Focus on publishing sector',
          'Printing and media facilities',
          'Intellectual property protection',
          'Modern infrastructure',
        ],
        benefits: [
          'Specialized for publishers',
          'Cost-effective packages',
          'Central location in Sharjah',
          'Cultural support',
        ],
        icon: Icons.book,
        color: Colors.brown,
        jsonName: 'SPC',
      ),
      FreezoneModel(
        id: 'hfza_sharjah',
        name: 'HFZA (Hamriyah Free Zone Authority)',
        emirate: 'Sharjah',
        type: FreezoneType.freeZone,
        description: 'Industrial and manufacturing businesses',
        features: [
          'Industrial focus',
          'Port facilities',
          'Manufacturing infrastructure',
          'Warehousing solutions',
        ],
        benefits: [
          'Deep-water port access',
          'Industrial plots available',
          'Competitive pricing',
          'Strategic location',
        ],
        icon: Icons.precision_manufacturing,
        color: Color(0xFF607D8B),
        jsonName: 'HFZA',
      ),
      FreezoneModel(
        id: 'srtip_sharjah',
        name: 'SRTIP (Sharjah Research Technology and Innovation Park)',
        emirate: 'Sharjah',
        type: FreezoneType.freeZone,
        description: 'Research, technology, and innovation businesses',
        features: [
          'Focus on R&D',
          'Technology innovation',
          'Academic collaboration',
          'Modern research facilities',
        ],
        benefits: [
          'Innovation ecosystem',
          'Research support',
          'Tech-friendly environment',
          'Networking opportunities',
        ],
        icon: Icons.science,
        color: Color(0xFF3F51B5),
        jsonName: 'SRTIP Accelerator',
      ),
      FreezoneModel(
        id: 'saif_sharjah',
        name: 'SAIF (Sharjah Airport International Free Zone)',
        emirate: 'Sharjah',
        type: FreezoneType.freeZone,
        description: 'Airport-based freezone, logistics and trade focus',
        features: [
          'Adjacent to Sharjah Airport',
          'Logistics hub',
          'Trading activities',
          'Modern warehousing',
        ],
        benefits: [
          'Airport connectivity',
          'Cost-effective solutions',
          'Trade facilitation',
          'Growing business community',
        ],
        icon: Icons.flight_takeoff,
        color: Color(0xFF00897B),
        jsonName: 'SAIF',
      ),
      FreezoneModel(
        id: 'ancfz_sharjah',
        name: 'ANCFZ (Al Nahda Creative Free Zone)',
        emirate: 'Sharjah',
        type: FreezoneType.freeZone,
        description: 'Creative businesses and e-commerce',
        features: [
          'E-commerce licenses',
          'Creative industries',
          'Flexible packages',
          'Digital business focus',
        ],
        benefits: [
          'E-commerce friendly',
          'Affordable rates',
          'Simple setup',
          'Virtual office options',
        ],
        icon: Icons.shopping_cart,
        color: Color(0xFFAB47BC),
        jsonName: 'ANCFZ',
      ),

      // Ajman Free Zone
      FreezoneModel(
        id: 'afz_ajman',
        name: 'Ajman Free Zone',
        emirate: 'Ajman',
        type: FreezoneType.freeZone,
        description: 'Cost-effective, flexible packages, quick setup',
        features: [
          'Affordable packages',
          'Quick setup process',
          'Flexible office solutions',
          'Easy access from Dubai',
        ],
        benefits: [
          'Lower costs than Dubai',
          'Simple procedures',
          'Good connectivity',
          'Growing business community',
        ],
        icon: Icons.payments,
        color: Colors.green,
      ),
      FreezoneModel(
        id: 'anv_ajman',
        name: 'Ajman New Venture',
        emirate: 'Ajman',
        type: FreezoneType.freeZone,
        description: 'New development, modern facilities',
        features: [
          'New free zone',
          'Modern infrastructure',
          'Competitive pricing',
          'Business support services',
        ],
        benefits: [
          'Fresh development',
          'Latest facilities',
          'Affordable packages',
          'Growth potential',
        ],
        icon: Icons.apartment,
        color: Color(0xFF009688),
      ),

      // Ras Al Khaimah Free Zones
      FreezoneModel(
        id: 'rakez',
        name: 'RAKEZ (Ras Al Khaimah Economic Zone)',
        emirate: 'Ras Al Khaimah',
        type: FreezoneType.freeZone,
        description:
            'Affordable packages, industrial options, growing business hub',
        features: [
          'Cost-effective solutions',
          'Industrial and commercial options',
          'Flexible licensing',
          'Good infrastructure',
        ],
        benefits: [
          'Lower operating costs',
          'Strategic RAK location',
          'Industrial capabilities',
          'Business-friendly environment',
        ],
        icon: Icons.inventory,
        color: Color(0xFF795548),
        jsonName: 'RAKEZ',
      ),
      FreezoneModel(
        id: 'rak_icc',
        name: 'RAK ICC (International Corporate Centre)',
        emirate: 'Ras Al Khaimah',
        type: FreezoneType.freeZone,
        description: 'Offshore companies, asset protection',
        features: [
          'Offshore company formation',
          'Asset protection',
          'Privacy and confidentiality',
          'No audit requirements',
        ],
        benefits: [
          'Offshore advantages',
          'Tax efficiency',
          'Simplified compliance',
          'Global business activities',
        ],
        icon: Icons.shield,
        color: Color(0xFF455A64),
      ),
      FreezoneModel(
        id: 'rak_dao',
        name: 'RAK DAO (Digital Assets Oasis)',
        emirate: 'Ras Al Khaimah',
        type: FreezoneType.freeZone,
        description: 'Crypto and blockchain businesses',
        features: [
          'Crypto-friendly zone',
          'Blockchain focus',
          'Virtual asset licenses',
          'Digital innovation hub',
        ],
        benefits: [
          'Crypto regulation clarity',
          'Blockchain ecosystem',
          'Innovation support',
          'Global crypto reach',
        ],
        icon: Icons.currency_bitcoin,
        color: Color(0xFFF57C00),
        jsonName: 'RAK DAO',
      ),
      FreezoneModel(
        id: 'rak_oasis',
        name: 'RAK OASIS Free Zone',
        emirate: 'Ras Al Khaimah',
        type: FreezoneType.freeZone,
        description: 'Manufacturing and industrial focus',
        features: [
          'Industrial zone',
          'Manufacturing facilities',
          'Warehousing options',
          'Port connectivity',
        ],
        benefits: [
          'Industrial infrastructure',
          'Cost-effective operations',
          'Logistics advantages',
          'Growing industrial hub',
        ],
        icon: Icons.warehouse,
        color: Color(0xFF8D6E63),
      ),

      // Fujairah Free Zones
      FreezoneModel(
        id: 'fcc_fujairah',
        name: 'Fujairah Creative City',
        emirate: 'Fujairah',
        type: FreezoneType.freeZone,
        description: 'Media, creative industries, and freelancers',
        features: [
          'Creative industries focus',
          'Media and arts',
          'Freelancer licenses',
          'Low setup costs',
        ],
        benefits: [
          'Affordable for creatives',
          'Media-friendly',
          'Flexible packages',
          'East coast location',
        ],
        icon: Icons.palette,
        color: Color(0xFFE91E63),
        jsonName: 'Creative City Fujairah',
      ),

      // Abu Dhabi Free Zones
      FreezoneModel(
        id: 'kizad_abudhabi',
        name: 'KIZAD (Khalifa Industrial Zone Abu Dhabi)',
        emirate: 'Abu Dhabi',
        type: FreezoneType.freeZone,
        description: 'Industrial hub, manufacturing and logistics',
        features: [
          'Large industrial zone',
          'Manufacturing focus',
          'Port facilities',
          'Extensive infrastructure',
        ],
        benefits: [
          'Industrial capabilities',
          'Port connectivity',
          'Strategic Abu Dhabi location',
          'Large-scale operations',
        ],
        icon: Icons.factory,
        color: Colors.deepOrange,
        jsonName: 'KEZAD',
      ),
      FreezoneModel(
        id: 'masdar_abudhabi',
        name: 'Masdar City',
        emirate: 'Abu Dhabi',
        type: FreezoneType.freeZone,
        description: 'Clean tech, renewable energy, sustainability focus',
        features: [
          'Focus on clean technology',
          'Renewable energy sector',
          'Sustainability initiatives',
          'Innovation-driven',
        ],
        benefits: [
          'Green technology ecosystem',
          'Research collaboration',
          'Sustainable development',
          'Future-focused business',
        ],
        icon: Icons.energy_savings_leaf,
        color: Colors.lightGreen,
      ),
      FreezoneModel(
        id: 'adgm_abudhabi',
        name: 'ADGM (Abu Dhabi Global Market)',
        emirate: 'Abu Dhabi',
        type: FreezoneType.freeZone,
        description: 'Financial services, banking, fintech',
        features: [
          'Financial free zone',
          'Banking and insurance',
          'Fintech focus',
          'English common law',
        ],
        benefits: [
          'Financial hub status',
          'Regulatory clarity',
          'Access to capital markets',
          'Prestigious address',
        ],
        icon: Icons.account_balance,
        color: Color(0xFF1976D2),
        jsonName: 'ADGM',
      ),

      // UAQ Free Zone
      FreezoneModel(
        id: 'uaq_ftz',
        name: 'UAQ FTZ (Umm Al Quwain Free Trade Zone)',
        emirate: 'Umm Al Quwain',
        type: FreezoneType.freeZone,
        description: 'Affordable packages, flexible business activities',
        features: [
          'Cost-effective options',
          'Flexible business licenses',
          'Quick setup',
          'Low renewal costs',
        ],
        benefits: [
          'Budget-friendly',
          'Simple procedures',
          'Multiple business activities',
          'Good value for money',
        ],
        icon: Icons.savings,
        color: Colors.cyan,
        jsonName: 'UAQ FTZ',
      ),

      // Mainland DED Options (7 Emirates)
      FreezoneModel(
        id: 'dubai_ded',
        name: 'Dubai DED (Department of Economic Development)',
        emirate: 'Dubai',
        type: FreezoneType.mainland,
        description:
            'Mainland license for trading within UAE, requires local sponsor or service agent',
        features: [
          'Trade anywhere in UAE',
          'Access to local market',
          'Government contracts eligible',
          'Wider business scope',
        ],
        benefits: [
          'No geographical restrictions',
          'Local market access',
          'Government tender participation',
          'Business with UAE entities',
        ],
        icon: Icons.location_city,
        color: Color(0xFFD32F2F),
      ),
      FreezoneModel(
        id: 'abudhabi_ded',
        name: 'Abu Dhabi DED',
        emirate: 'Abu Dhabi',
        type: FreezoneType.mainland,
        description: 'Mainland license for Abu Dhabi operations',
        features: [
          'Abu Dhabi mainland license',
          'Local market access',
          'Government projects',
          'UAE-wide operations',
        ],
        benefits: [
          'Capital city advantage',
          'Government contract access',
          'No restrictions',
          'Local partnerships',
        ],
        icon: Icons.location_city,
        color: Color(0xFF1976D2),
      ),
      FreezoneModel(
        id: 'sharjah_ded',
        name: 'Sharjah DED',
        emirate: 'Sharjah',
        type: FreezoneType.mainland,
        description: 'Cost-effective mainland option',
        features: [
          'Affordable mainland license',
          'Sharjah operations',
          'UAE market access',
          'Lower costs',
        ],
        benefits: [
          'More affordable than Dubai',
          'Good connectivity',
          'Growing business hub',
          'Proximity to Dubai',
        ],
        icon: Icons.location_city,
        color: Color(0xFF388E3C),
      ),
      FreezoneModel(
        id: 'ajman_ded',
        name: 'Ajman DED',
        emirate: 'Ajman',
        type: FreezoneType.mainland,
        description: 'Budget-friendly mainland license',
        features: [
          'Low-cost mainland option',
          'Simple procedures',
          'UAE operations',
          'Quick processing',
        ],
        benefits: [
          'Most affordable mainland',
          'Easy accessibility',
          'Fast setup',
          'Cost savings',
        ],
        icon: Icons.location_city,
        color: Color(0xFF00796B),
      ),
      FreezoneModel(
        id: 'fujairah_ded',
        name: 'Fujairah DED',
        emirate: 'Fujairah',
        type: FreezoneType.mainland,
        description: 'East coast mainland license',
        features: [
          'East coast location',
          'Port access',
          'Mainland benefits',
          'Competitive pricing',
        ],
        benefits: [
          'Strategic east coast',
          'Port connectivity',
          'Growing business area',
          'Affordable option',
        ],
        icon: Icons.location_city,
        color: Color(0xFFF57C00),
      ),
      FreezoneModel(
        id: 'rak_ded',
        name: 'RAK DED',
        emirate: 'Ras Al Khaimah',
        type: FreezoneType.mainland,
        description: 'Affordable RAK mainland license',
        features: [
          'RAK mainland operations',
          'Cost-effective',
          'UAE market access',
          'Northern emirates base',
        ],
        benefits: [
          'Lower operational costs',
          'Growing RAK economy',
          'Good connectivity',
          'Budget-friendly',
        ],
        icon: Icons.location_city,
        color: Color(0xFF5D4037),
      ),
      FreezoneModel(
        id: 'uaq_ded',
        name: 'UAQ DED',
        emirate: 'Umm Al Quwain',
        type: FreezoneType.mainland,
        description: 'Low-cost mainland option',
        features: [
          'Very affordable',
          'Mainland license',
          'UAE operations',
          'Simple setup',
        ],
        benefits: [
          'Lowest mainland costs',
          'Quick processing',
          'No restrictions',
          'Value for money',
        ],
        icon: Icons.location_city,
        color: Color(0xFF0097A7),
      ),
    ];
  }

  // Helper methods
  static List<FreezoneModel> getByEmirate(String emirate) {
    return getAllFreezones().where((fz) => fz.emirate == emirate).toList();
  }

  static List<FreezoneModel> getByType(FreezoneType type) {
    return getAllFreezones().where((fz) => fz.type == type).toList();
  }

  static List<FreezoneModel> getFreeZones() {
    return getAllFreezones()
        .where((fz) => fz.type == FreezoneType.freeZone)
        .toList();
  }

  static List<FreezoneModel> getMainlandOptions() {
    return getAllFreezones()
        .where((fz) => fz.type == FreezoneType.mainland)
        .toList();
  }

  static List<String> getAllEmirates() {
    return [
      'Dubai',
      'Abu Dhabi',
      'Sharjah',
      'Ajman',
      'Fujairah',
      'Ras Al Khaimah',
      'Umm Al Quwain',
    ];
  }

  static List<FreezoneModel> searchFreezones(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllFreezones().where((fz) {
      return fz.name.toLowerCase().contains(lowerQuery) ||
          fz.emirate.toLowerCase().contains(lowerQuery) ||
          fz.description.toLowerCase().contains(lowerQuery) ||
          fz.features.any((f) => f.toLowerCase().contains(lowerQuery)) ||
          fz.benefits.any((b) => b.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
