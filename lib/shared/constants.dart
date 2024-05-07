import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/theme_model.dart';

// Data
late String kDefaultBlocks;
late String kSocialLinks;
late String kAdditionalBlocks;
final List<Map<String, dynamic>> kCountryCodes = [];

// Fonts
const String kFontFamily = "Inter";

const List<String?> kFontFamilys = [
  'Roboto',
  'Open Sans',
  'Work Sans',
  'DM Sans',
  'Bebas Neue',
  'Roboto Condensed',
  'Roboto Slab',
  'Lato',
  'Poppins',
  'Playfair Display',
  'Oswald',
  'Source Sans 3',
  'Lora',
  'Raleway',
  'Merriweather',
  'Rubik',
  'Fira Sans',
  'Nunito',
  'Montserrat',
  'Quicksand',
  'Ubuntu',
  'Inter',
  'PT Serif',
  'League Spartan',
  'Titillium Web',
  'Alegreya',
  'Inconsolata',
];

const List<String> kFontWeights = [
  'thin',
  'light',
  'regular',
  'medium',
  'semi-bold',
  'bold',
  'extra bold',
];

const List<String> kVerticalAlignments = [
  'top',
  'center',
  'bottom',
];

const List<String> kHorizontalAlignments = [
  'left',
  'center',
  'right',
];

const List<Color> kColors = [
  Color(0xFF2D2D2D),
  Color(0xFF606060),
  Color(0xFF000000),
  Color(0xFFFFFFFF),
  Color(0xFFF8F0B3),
  Color(0xFFFBD8BE),
  Color(0xFFBA7C72),
  Color(0xFFD33211),
  Color(0xFF004A3B),
  Color(0xFF25E4B3),
  Color(0xFFC2E0EF),
  Color(0xFF053493),
  Color(0xFFEB8F00),
];

const List<String> kAspectRatios = ['21:9', '16:9', '1:1', '4:5', '9:16'];

const List<ThemeModel> kThemes = [
  ThemeModel(
    id: 1,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFefefee),
        Color(0xFFffffff),
        Color(0xFFf4f3f3),
      ],
      stops: [0, 54, 99],
    ),
    textColor: Color(0xFF606060),
    iconColor: Color(0xFF606060),
    dividerColor: Color(0xFF606060),
  ),
  ThemeModel(
    id: 2,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFfdfcfb),
        Color(0xFFE3D3C5),
      ],
      stops: [0, 100],
    ),
    textColor: Color(0xFF606060),
    iconColor: Color(0xFF606060),
    dividerColor: Color(0xFF606060),
  ),
  ThemeModel(
    id: 3,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF414141),
        Color(0xFF161616),
      ],
      stops: [0, 74],
    ),
    textColor: Color(0xFFFFFFFF),
    iconColor: Color(0xFFFFFFFF),
    dividerColor: Color(0xFFFFFFFF),
  ),
  ThemeModel(
    id: 4,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF000000),
        Color(0xFF615f5f),
        Color(0xFF331e10),
      ],
      stops: [0, 37, 100],
    ),
    textColor: Color(0xFFFFFFFF),
    iconColor: Color(0xFFBDBDBD),
    dividerColor: Color(0xFF606060),
  ),
  ThemeModel(
    id: 5,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFf7f7f3),
        Color(0xFFfdf1e3),
        Color(0xFFb9ceef),
      ],
      stops: [28, 53, 100],
    ),
    textColor: Color(0xFF3C32A7),
    iconColor: Color(0xFF796DFD),
    dividerColor: Color(0xFF796DFD),
  ),
  ThemeModel(
    id: 6,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFf0d5d5),
        Color(0xFFe2b4a7),
        Color(0xFFe4d9dc),
      ],
      stops: [4, 45, 92],
    ),
    textColor: Color(0xFF520000),
    iconColor: Color(0xFF520000),
    dividerColor: Color(0xFFFFFFFF),
  ),
  ThemeModel(
    id: 7,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF385138),
        Color(0xFF0d210d),
        Color(0xFF222b22),
      ],
      stops: [8, 54, 89],
    ),
    textColor: Color(0xFFF6F8D5),
    iconColor: Color(0xFFF6F8D5),
    dividerColor: Color(0xFF606060),
  ),
  ThemeModel(
    id: 8,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF78421b),
        Color(0xFF451f12),
        Color(0xFF3a1717),
        Color(0xFFae6b1e),
      ],
      stops: [0, 29, 62, 100],
    ),
    textColor: Color(0xFFFBD8BE),
    iconColor: Color(0xFFFBD8BE),
    dividerColor: Color(0xFFFBD8BE),
  ),
   ThemeModel(
    id: 9,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF000000),
        Color(0xFF990000),
        Color(0xFFCC0000),
        Color(0xFFFF0000),
      ],
      stops: [0, 28, 53, 100],
    ),
    textColor: Color(0xFFFFFFFF),
    iconColor: Color(0xFFFFFFFF),
    dividerColor: Color(0xFFFFFFFF),
  ),
  ThemeModel(
    id: 10,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFf9f8f8),
        Color(0xFFd6d6d6),
        Color(0xFFe7e2e2),
        Color(0xFFfefefd),
      ],
      stops: [13, 29, 46, 100],
    ),
    textColor: Color(0xFF053493),
    iconColor: Color(0xFF053493),
    dividerColor: Color(0xFF053493),
  ),
  ThemeModel(
    id: 11,
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF131e34),
        Color(0xFF020817),
        Color(0xFF83705d),
      ],
      stops: [0, 54, 100],
    ),
    textColor: Color(0xFFFFFFFF),
    iconColor: Color(0xFFFFFFFF),
    dividerColor: Color(0xFF606060),
  ),
];

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

extension IconExtensions on String {
  IconData get icon {
    switch (this) {
      case "section":
        return Icons.view_agenda;
      case "space":
        return Icons.zoom_out_map_rounded;
      case "divider":
        return Icons.remove_outlined;
      case "text":
        return Icons.title_outlined;
      case "image":
        return Icons.image_outlined;
      case "contact":
        return Icons.call_outlined;
      case "info":
        return Icons.info;
      case "links":
        return Icons.group_outlined;
      case "button":
        return Icons.add_circle_outline;
      case "video":
        return Icons.video_library_outlined;
      case "additional":
        return Icons.playlist_add_outlined;
      case "actions":
        return Icons.system_update_alt_outlined;
      default:
        return FontAwesomeIcons.info;
    }
  }

  IconData get socialIcon {
    switch (this) {
      case "facebook":
        return FontAwesomeIcons.facebook;
      case "instagram":
        return FontAwesomeIcons.instagram;
      case "linkedin":
        return FontAwesomeIcons.linkedin;
      case "twitter":
        return FontAwesomeIcons.twitter;
      case "whatsapp":
        return FontAwesomeIcons.whatsapp;
      case "youtube":
        return FontAwesomeIcons.youtube;
      case "snapchat":
        return FontAwesomeIcons.snapchat;
      case "tiktok":
        return FontAwesomeIcons.tiktok;
      case "telegram":
        return FontAwesomeIcons.telegram;
      case "pinterest":
        return FontAwesomeIcons.pinterest;
      case "reddit":
        return FontAwesomeIcons.reddit;
      case "github":
        return FontAwesomeIcons.github;
      case "dribbble":
        return FontAwesomeIcons.dribbble;
      case "behance":
        return FontAwesomeIcons.behance;
      case "medium":
        return FontAwesomeIcons.medium;
      case "tumblr":
        return FontAwesomeIcons.tumblr;
      case "soundcloud":
        return FontAwesomeIcons.soundcloud;
      case "spotify":
        return FontAwesomeIcons.spotify;
      case "discord":
        return FontAwesomeIcons.discord;
      case "skype":
        return FontAwesomeIcons.skype;
      case "viber":
        return FontAwesomeIcons.viber;
      case "line":
        return FontAwesomeIcons.line;
      case "threads":
        return FontAwesomeIcons.threads;
      default:
        return FontAwesomeIcons.link;
    }
  }

  Color get socialIconColor {
    switch (this) {
      case "facebook":
        return const Color(0xFF4267B2);
      case "instagram":
        return const Color(0xFFC13584);
      case "linkedin":
        return const Color(0xFF0077B5);
      case "twitter":
        return const Color(0xFF1DA1F2);
      case "whatsapp":
        return const Color(0xFF25D366);
      case "youtube":
        return const Color(0xFFFF0000);
      case "snapchat":
        return const Color(0xFFFFFC00);
      case "tiktok":
        return const Color(0xFF000000);
      case "telegram":
        return const Color(0xFF0088CC);
      case "pinterest":
        return const Color(0xFFBD081C);
      case "reddit":
        return const Color(0xFFFF4500);
      case "github":
        return const Color(0xFF333333);
      case "dribbble":
        return const Color(0xFFEA4C89);
      case "behance":
        return const Color(0xFF1769FF);
      case "medium":
        return const Color(0xFF00AB6C);
      case "tumblr":
        return const Color(0xFF36465D);
      case "soundcloud":
        return const Color(0xFFFF5500);
      case "spotify":
        return const Color(0xFF1DB954);
      case "discord":
        return const Color(0xFF7289DA);
      case "skype":
        return const Color(0xFF00AFF0);
      case "viber":
        return const Color(0xFF665CAC);
      case "line":
        return const Color(0xFF00C300);
      case "threads":
        return const Color(0xFF05A9D0);
      default:
        return const Color(
            0xFF000000); // Default color if none of the cases match
    }
  }

  IconData get contactIcon {
    switch (this) {
      case "phoneNumbers":
        return Icons.phone_outlined;
      case "emails":
        return Icons.email_outlined;
      case "addresses":
        return Icons.location_on_outlined;
      case "websites":
        return Icons.public_outlined;
      default:
        return FontAwesomeIcons.info;
    }
  }

  List<String> get contactLabels {
    switch (this) {
      case 'phoneNumbers':
        return PhoneLabel.values.map((e) => e.name.toLowerCase()).toList();
      case 'emails':
      return EmailLabel.values.map((e) => e.name.toLowerCase()).toList();
      case 'websites':
        return WebsiteLabel.values.map((e) => e.name.toLowerCase()).toList();
      case 'addresses':
        return AddressLabel.values.map((e) => e.name.toLowerCase()).toList();
      default:
        return ['other'];
    }
  }

  TextInputType? get keyboardType {
    switch (this) {
      case 'phone':
      case 'phoneNumbers':
        return TextInputType.phone;
      case 'email':
      case 'emails':
        return TextInputType.emailAddress;
      case 'website':
      case 'websites':
        return TextInputType.url;
      case 'address':
      case 'addresses':
        return TextInputType.streetAddress;
      default:
        return TextInputType.text;
    }
  }
}
