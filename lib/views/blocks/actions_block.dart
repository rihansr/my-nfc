import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:my_nfc/utils/debug.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../shared/constants.dart';
import '../../viewmodels/design_viewmodel.dart';
import 'components.dart';

class ActionsBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  final Map<String, dynamic> settings;
  final Map<String, dynamic> primary;
  final Map<String, dynamic> additional;

  ActionsBlock(this.configs, {this.sectionStyle, super.key})
      : settings =
            Map<String, dynamic>.from(configs['settings']?['advanced'] ?? {}),
        primary = Map<String, dynamic>.from(configs['data']?['primary'] ?? {}),
        additional =
            Map<String, dynamic>.from(configs['data']?['additional'] ?? {});

  Future<void> saveToPhone(BuildContext context) async {
    Map<String, dynamic> designStructure =
        Provider.of<DesignViewModel>(context, listen: false).designStructure;

    final names = designStructure
        .filterBy(const MapEntry('subBlock', 'image_avatar'))
        .where((element) =>
            element['first'] != null ||
            element['middle'] != null ||
            element['last'] != null)
        .toList();

    final avatars = designStructure
        .filterBy(const MapEntry('subBlock', 'image_avatar'))
        .where((element) => element['data']?['path'] != null)
        .toList();

    List? name;
    if (names.isNotEmpty) {
      name = names.first.values.where((element) => element != null).toList();
    }

    final works = designStructure
        .filterBy(const MapEntry('label', 'Work'))
        .where((element) =>
            element['data']?['title']?['text'] != null &&
            element['data']?['content']?['text'] != null)
        .toList();

    final phoneNumbers = designStructure
        .findBy('phoneNumbers')
        .where((element) =>
            element['prefix'] != null && element['content'] != null)
        .toList();

    final emails = designStructure
        .findBy('emails')
        .where((element) => element['content'] != null)
        .toList();

    final addresses = designStructure
        .findBy('addresses')
        .where((element) => element['content'] != null)
        .toList();

    final websites = designStructure
        .findBy('websites')
        .where((element) => element['content'] != null)
        .toList();

    final socialLinks = designStructure
        .findBy('links')
        .where((element) => element['id'] != null)
        .toList();

    debug.print(
      'Name:\n${name?.join(' ')}'
      '\n\nOrganization:\n${works.join('\n')}'
      '\n\nNumbers:\n${phoneNumbers.join('\n')}'
      '\n\nEmails:\n${emails.join('\n')}'
      '\n\nAddresses:\n${addresses.join('\n')}'
      '\n\nWebsites:\n${websites.join('\n')}'
      '\n\nSocial Links:\n${socialLinks.join('\n')}',
    );

    label(String key, String? label) =>
        key.contactLabels.contains(label) ? label!.toUpperCase() : 'CUSTOM';

    StringBuffer vCard = StringBuffer();

    vCard.writeln('BEGIN:VCARD');
    vCard.writeln('VERSION:3.0');
    if (name?.isNotEmpty ?? false) {
      vCard.writeln('FN:${name?.join(' ')}');
      vCard.writeln('N:${name?.reversed.join(';')};;;');
    }

    for (var avatar in avatars) {
      String? path = avatar['data']?['path'];
      if (path?.isEmpty ?? true) continue;
      if (Uri.tryParse(path!)?.isAbsolute ?? false) {
        vCard.writeln('PHOTO;TYPE=JPEG;VALUE=URI:$path');
      } else {
        vCard.writeln(
            'PHOTO;TYPE=JPEG;ENCODING=b:${base64Encode(File(path).readAsBytesSync())}');
      }
    }

    for (var work in works) {
      vCard.writeln('ORG:${work['data']?['title']?['text']}');
    }

    for (var number in phoneNumbers) {
      vCard.writeln(
          'TEL;TYPE=${label('phoneNUmbers', number['label'])}:${number['prefix']}${number['content']}');
    }

    for (var email in emails) {
      vCard.writeln(
          'EMAIL;TYPE=${label('emails', email['label'])}:${email['content']}');
    }

    for (var address in addresses) {
      vCard.writeln(
          'ADR;TYPE=${label('addresses', address['label'])}:;;${address['content']}');
    }

    for (var website in websites) {
      vCard.writeln(
          'URL;TYPE=${label('websites', website['label'])}:${website['content']}');
    }

    for (var link in socialLinks) {
      vCard.writeln(
          'X-SOCIALPROFILE:https://${link['link'] ?? ''}${link['id'] ?? ''}');
    }

    vCard.writeln('END:VCARD');

    debug.print(vCard.toString());

    if (Platform.isAndroid || Platform.isIOS) {
      if (await FlutterContacts.requestPermission()) {
        Contact contact = Contact.fromVCard(vCard.toString());
        debug.print(contact);
      }
    } else {
      //webExtension.saveVCard(name?.join(' '), vCard.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      minimumSize: const MaterialStatePropertyAll(Size.zero),
      padding: MaterialStatePropertyAll(
          padding(configs['style']?['spacing']?['padding'])),
      shape: const MaterialStatePropertyAll((StadiumBorder())),
    );

    return Container(
      width: double.infinity,
      transform: transform(configs['style']?['spacing']?['margin']),
      margin: margin(configs['style']?['spacing']?['margin']),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (settings['showSaveToPhoneButton'] == true)
            Expanded(
              child: TextButton(
                onPressed: () async => await saveToPhone(context),
                style: buttonStyle.copyWith(
                  backgroundColor: MaterialStatePropertyAll((() {
                    final style = Map<String, dynamic>.from(
                        configs['data']?['style']?['background'] ?? {});
                    return style['color'].toString().hexColor;
                  }())),
                ),
                child: Text(
                  configs['data']?['label']?['text'],
                  style: textStyle(
                    context,
                    Map<String, dynamic>.from(
                        configs['data']?['style']?['text'] ?? {}),
                  ).copyWith(
                      color: configs['data']?['style']?['text']?['labelColor']
                              ?.toString()
                              .hexColor ??
                          Provider.of<DesignViewModel>(context).theme.iconColor,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          if (settings['showPrimaryContactButton'] == true &&
              primary.isNotEmpty)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: settings['showSaveToPhoneButton'] == true ? 8 : 0),
                child: TextButton.icon(
                  onPressed: openUrl(
                    url: Uri.parse(
                        'https://${primary['link'] ?? ''}${primary['id'] ?? ''}'),
                  ),
                  style: buttonStyle.copyWith(
                    backgroundColor: MaterialStatePropertyAll(
                        '${primary['name']}'.socialIconColor),
                  ),
                  icon: Transform.scale(
                    scale: 1.5,
                    child: Icon(
                      '${primary['name']}'.socialIcon,
                      size: (configs['data']?['style']?['text']?['fontSize'] ??
                              14)
                          .toDouble(),
                      color: Colors.white,
                    ),
                  ),
                  label: Text(
                    string.connect,
                    style: textStyle(
                      context,
                      Map.from(configs['data']?['style']?['text'] ?? {}),
                    ).copyWith(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          if (settings['showAdditionalContactButton'] == true &&
              additional.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                  left: settings['showSaveToPhoneButton'] == true ||
                          (settings['showPrimaryContactButton'] == true &&
                              primary.isNotEmpty)
                      ? 8
                      : 0),
              child: IconButton.filled(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        '${additional['name']}'.socialIconColor)),
                onPressed: openUrl(
                  url: Uri.parse(
                      'https://${additional['link'] ?? ''}${additional['id'] ?? ''}'),
                ),
                padding: const EdgeInsets.all(22),
                icon: Transform.scale(
                  scale: 1.75,
                  child: Icon(
                    '${additional['name']}'.socialIcon,
                    size:
                        (configs['data']?['style']?['text']?['fontSize'] ?? 14)
                            .toDouble(),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
