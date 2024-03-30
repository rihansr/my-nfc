import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Data
late String kDefaultBlocks;
late String kSocialLinks;
late String kAdditionalBlocks;
final List<Map<String, dynamic>> kCountryCodes = [];

// Fonts
const String kFontFamily = "Inter";
List<String?> kFontFamilys = [
  GoogleFonts.montserrat().fontFamily,
  GoogleFonts.openSans().fontFamily,
  GoogleFonts.workSans().fontFamily,
  GoogleFonts.dmSans().fontFamily,
  GoogleFonts.roboto().fontFamily,
  GoogleFonts.bebasNeue().fontFamily,
  GoogleFonts.robotoCondensed().fontFamily,
  GoogleFonts.robotoSlab().fontFamily,
  GoogleFonts.lato().fontFamily,
  GoogleFonts.poppins().fontFamily,
  GoogleFonts.playfairDisplay().fontFamily,
  GoogleFonts.oswald().fontFamily,
  GoogleFonts.sourceSans3().fontFamily,
  GoogleFonts.lora().fontFamily,
  GoogleFonts.raleway().fontFamily,
  GoogleFonts.merriweather().fontFamily,
  GoogleFonts.rubik().fontFamily,
  GoogleFonts.firaSans().fontFamily,
  GoogleFonts.nunito().fontFamily,
  GoogleFonts.quicksand().fontFamily,
  GoogleFonts.ubuntu().fontFamily,
  GoogleFonts.alegreya().fontFamily,
  GoogleFonts.inter().fontFamily,
  GoogleFonts.ptSerif().fontFamily,
  GoogleFonts.leagueSpartan().fontFamily,
  GoogleFonts.titilliumWeb().fontFamily,
  GoogleFonts.alegreya().fontFamily,
  GoogleFonts.inconsolata().fontFamily,
];

List<String> kFontWeights = const [
  'thin',
  'light',
  'regular',
  'medium',
  'semi-bold',
  'bold',
  'extra bold',
];

List<String> kAlignments = const [
  'left',
  'right',
  'center',
];

List<Color> kColors = [
  Colors.white,
  Colors.black,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.brown
];

List<String> kAspectRatios = const ['21:9', '16:9', '1:1', '4:5', '9:16'];

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
      case "section-parent":
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
      case "links-public":
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
}
