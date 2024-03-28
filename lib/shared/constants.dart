import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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

List<Color> kColors =  [
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
      case "publicLinks":
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

// Data
final Map<String, dynamic> kDefaultDesign = {};
const String kSocialLinks = '''
[
    {
      "name": "facebook",
      "link": "facebook.com/",
      "hint": "username",
      "id": null
    },
    {
      "name": "instagram",
      "link": "instagram.com/",
      "hint": "username",
      "id": null
    },
    {
      "name": "linkedin",
      "link": "linkedin.com/in/",
      "hint": "username",
      "id": null
    },
    {
      "name": "twitter",
      "link": "twitter.com/",
      "hint": "username",
      "id": null
    },
    {
      "name": "whatsapp",
      "link": "wa.me/",
      "hint": "+880 1812 345678",
      "id": null
    },
    {
      "name": "youtube",
      "link": "youtube.com/",
      "id": null
    },
    {
      "name": "snapchat",
      "link": "snapchat.com/add/",
      "id": null
    },
    {
      "name": "tiktok",
      "link": "tiktok.com/@",
      "id": null
    },
    {
      "name": "telegram",
      "link": "t.me/",
      "id": null
    },
    {
      "name": "pinterest",
      "link": "pinterest.com/",
      "id": null
    },
    {
      "name": "reddit",
      "link": "reddit.com/user/",
      "id": null
    },
    {
      "name": "github",
      "link": "github.com/",
      "id": null
    },
    {
      "name": "dribbble",
      "link": "dribbble.com/",
      "id": null
    },
    {
      "name": "behance",
      "link": "behance.net/",
      "id": null
    },
    {
      "name": "medium",
      "link": "medium.com/@",
      "id": null
    },
    {
      "name": "tumblr",
      "link": "tumblr.com/blog/",
      "id": null
    },
    {
      "name": "soundcloud",
      "link": "soundcloud.com/",
      "id": null
    },
    {
      "name": "spotify",
      "link": "open.spotify.com/user/",
      "id": null
    },
    {
      "name": "discord",
      "link": "discord.com/users/",
      "id": null
    },
    {
      "name": "skype",
      "link": "join.skype.com/invite/",
      "id": null
    },
    {
      "name": "viber",
      "link": "viber.com/add/",
      "id": null
    },
    {
      "name": "line",
      "link": "line.me/ti/p/",
      "id": null
    },
    {
      "name": "threads",
      "link": "threads.net/",
      "id": null
    }
  ]
''';
const String kAdditionalBlocks = '''
[
    {
        "block": "section",
        "label": "Link with Image",
        "settings": {
            "primary": false,
            "visible": true,
            "removable": true,
            "dragable": true
        },
        "data": {
            "fields": [
                {
                    "block": "background",
                    "label": "Background Image",
                    "settings": {
                        "primary": false,
                        "visible": true,
                        "removable": true
                    },
                    "data": {
                        "path": ""
                    }
                },
                {
                    "block": "text",
                    "label": "Text",
                    "settings": {
                        "primary": false,
                        "visible": true,
                        "removable": true
                    },
                    "data": {
                        "content": "",
                        "style": {
                            "text": {
                                "typography": null,
                                "fontSize": 32,
                                "color": "#FFFFFFFF",
                                "fontWeight": "reqular",
                                "alignment": "left"
                            },
                            "padding": {
                                "horizontal": 0,
                                "vertical": 0
                            },
                            "margin": {
                                "top": 0,
                                "bottom": 0,
                                "left": 0,
                                "right": 0
                            }
                        }
                    }
                },
                {
                    "block": "text",
                    "label": "Text",
                    "settings": {
                        "primary": false,
                        "visible": true,
                        "removable": true
                    },
                    "data": {
                        "content": "",
                        "style": {
                            "text": {
                                "typography": null,
                                "color": "#FFFFFFFF",
                                "fontSize": 19,
                                "fontWeight": "reqular",
                                "alignment": "left"
                            },
                            "padding": {
                                "horizontal": 0,
                                "vertical": 0
                            },
                            "margin": {
                                "top": 0,
                                "bottom": 0,
                                "left": 0,
                                "right": 0
                            }
                        }
                    }
                },
                {
                    "block": "button",
                    "label": "Button",
                    "settings": {
                        "primary": false,
                        "visible": true,
                        "removable": true,
                        "additional": {
                            "fullWidth": false,
                            "openInNewTab": true,
                            "disabled": false
                        }
                    },
                    "data": {
                        "text": "",
                        "link": "",
                        "style": {
                            "border": {
                                "color": "#FFFFFFFF",
                                "thickness": 1,
                                "radius": 4
                            },
                            "text": {
                                "typography": null,
                                "color": "#FFFFFFFF",
                                "fontSize": 16,
                                "fontWeight": "regular"
                            }
                        }
                    }
                }
            ],
            "style": {
                "padding": {
                    "horizontal": 0,
                    "vertical": 0
                },
                "margin": {
                    "top": 0,
                    "bottom": 0,
                    "left": 0,
                    "right": 0
                },
                "alignment": {
                    "vertical": "top",
                    "horizontal": "left"
                },
                "overlay": {
                    "color": "#00000000",
                    "opacity": 40
                },
                "additional": {
                    "altText": "",
                    "linkTo": "",
                    "openInNewTab": true
                }
            }
        }
    },
    {
        "block": "text",
        "label": "Text",
        "settings": {
            "primary": false,
            "visible": true,
            "removable": true
        },
        "data": {
            "content": "",
            "style": {
                "text": {
                    "typography": null,
                    "color": "#FFFFFFFF",
                    "fontSize": 16,
                    "fontWeight": "reqular",
                    "alignment": "center"
                },
                "padding": {
                    "horizontal": 0,
                    "vertical": 0
                },
                "margin": {
                    "top": 0,
                    "bottom": 0,
                    "left": 0,
                    "right": 0
                }
            }
        }
    },
    {
        "block": "video",
        "label": "Online Video",
        "settings": {
            "primary": false,
            "visible": true,
            "removable": true
        },
        "data": {
            "link": "",
            "configs": {
                "autoPlay": false,
                "loop": false,
                "showControls": false,
                "mute": false,
                "allowFullScreen": false,
                "startAt": null,
                "endAt": null
            },
            "style": {
                "aspectRatio": "21:9",
                "padding": {
                    "horizontal": 0,
                    "vertical": 0
                },
                "margin": {
                    "top": 0,
                    "bottom": 0,
                    "left": 0,
                    "right": 0
                }
            }
        }
    },
    {
        "block": "divider",
        "label": "Line Break",
        "settings": {
            "primary": false,
            "visible": true,
            "removable": true
        },
        "data": {
            "style": {
                "color": "#FFFFFFFF",
                "margin": {
                    "top": 0,
                    "bottom": 0
                }
            }
        }
    },
    {
        "block": "section",
        "label": "Section (Image Background)",
        "settings": {
            "primary": false,
            "visible": true,
            "dragable": true,
            "removable": true
        },
        "data": {
            "fields": [
                {
                    "block": "background",
                    "label": "Background Image",
                    "settings": {
                        "primary": false,
                        "visible": true,
                        "removable": true
                    },
                    "data": {
                        "path": ""
                    }
                }
            ]
        }
    },
    {
        "block": "section",
        "label": "Section",
        "settings": {
            "primary": false,
            "visible": true,
            "dragable": true,
            "removable": true
        },
        "style": {
            "backgroundColor": "#00000000",
            "fullWidth": true
        },
        "data": {
            "fields": [],
            "style": {
                "padding": {
                    "horizontal": 0,
                    "vertical": 0
                },
                "margin": {
                    "top": 0,
                    "bottom": 0,
                    "left": 0,
                    "right": 0
                }
            }
        }
    },
    {
        "block": "image",
        "label": "Image",
        "settings": {
            "primary": false,
            "visible": true,
            "removable": true
        },
        "data": {
            "path": ""
        }
    },
    {
        "block": "button",
        "label": "Button",
        "settings": {
            "primary": false,
            "visible": true,
            "removable": true,
            "additional": {
                "fullWidth": false,
                "openInNewTab": true,
                "disabled": false
            }
        },
        "data": {
            "text": "Button",
            "link": "",
            "style": {
                "border": {
                    "color": "#FFFFFFFF",
                    "thickness": 1,
                    "radius": 4
                },
                "text": {
                    "typography": null,
                    "color": "#FFFFFFFF",
                    "fontSize": 16,
                    "fontWeight": "regular"
                },
                "padding": {
                    "horizontal": 16,
                    "vertical": 8
                },
                "margin": {
                    "top": 8,
                    "bottom": 0,
                    "left": 0,
                    "right": 0
                }
            }
        }
    },
    {
        "block": "links",
        "label": "Social Media",
        "settings": {
            "primary": false,
            "visible": true,
            "dragable": true,
            "removable": true
        },
        "data": {
            "links": []
        }
    },
    {
        "block": "publicLinks",
        "label": "Public Social Media",
        "settings": {
            "primary": false,
            "visible": true,
            "dragable": true,
            "removable": true
        },
        "data": {
            "links": []
        }
    },
    {
        "block": "contact",
        "label": "Contact",
        "settings": {
            "primary": false,
            "visible": true,
            "dragable": true,
            "removable": true
        },
        "data": {
            "phoneNumbers": [
                {
                    "home": ""
                }
            ],
            "emails": [
                {
                    "home": ""
                }
            ],
            "websites": [
                {
                    "work": ""
                }
            ],
            "addresses": [
                {
                    "Home": ""
                }
            ]
        }
    },
    {
        "block": "actions",
        "label": "Save Contact/Contact",
        "settings": {
            "primary": false,
            "visible": true,
            "removable": true
        },
        "data": {
            "primary": "",
            "additional": "",
            "advancedSettings": {
                "showSaveToPhoneButton": true,
                "showPrimaryContactButton": true,
                "showAdditionalContactButton": true,
                "buttonFixedAtBottom": true
            }
        }
    },
    {
        "block": "additional",
        "label": "Additional Items",
        "settings": {
            "primary": false,
            "visible": true,
            "dragable": true,
            "removable": true
        },
        "data": {
            "items": [],
            "style":{
            "alignment": "left"
            }
        }
    },
    {
        "block": "space",
        "label": "Space",
        "settings": {
            "primary": false,
            "visible": true,
            "removable": true
        },
        "data": {
            "style": {
                "height": 20
            }
        }
    }
]
''';
