import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import '../../shared/strings.dart';
import '../../shared/constants.dart';
import '../../utils/debug.dart';
import '../../utils/extensions.dart';
//import '../../utils/web_extensions.dart';
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

    Contact contact = Contact();

    final name = designStructure
        .findBy('name')
        .where((element) =>
            element['first'] != null ||
            element['middle'] != null ||
            element['last'] != null)
        .firstOrNull;

    if (name != null) {
      contact.name = Name(
        first: name['first'] ?? '',
        middle: name['middle'] ?? '',
        last: name['last'] ?? '',
      );
    }

    await Future.forEach(
        designStructure
            .filterBy(const MapEntry('subBlock', 'image_avatar'))
            .where((element) => element['data']?['path'] != null),
        (element) async {
      contact.photo = await photoBytes(element['data']?['path']);
    });
    contact.notes = designStructure
        .filterBy(const MapEntry('label', 'Bio'))
        .where((element) => element['data']?['content'] != null)
        .map((e) => Note(e['data']?['content'] ?? ''))
        .toList();

    contact.organizations = designStructure
        .filterBy(const MapEntry('label', 'Work'))
        .where((element) =>
            element['data']?['title']?['text'] != null ||
            element['data']?['content']?['text'] != null)
        .map((e) => Organization(
              company: e['data']?['title']?['text'] ?? '',
              title: e['data']?['content']?['text'] ?? '',
            ))
        .toList();

    contact.phones = designStructure
        .findBy('phoneNumbers')
        .where((element) =>
            element['prefix'] != null && element['content'] != null)
        .map(
      (e) {
        PhoneLabel? label = PhoneLabel.values
            .firstWhereOrNull((label) => label.name == e['label']);
        return Phone(
          '${e['prefix']}${e['content']}',
          label: label ?? PhoneLabel.mobile,
          customLabel: label == null ? e['label'] ?? '' : '',
        );
      },
    ).toList();

    contact.emails = designStructure
        .findBy('emails')
        .where((element) => element['content'] != null)
        .map(
      (e) {
        EmailLabel? label = EmailLabel.values
            .firstWhereOrNull((label) => label.name == e['label']);
        return Email(
          e['content'],
          label: label ?? EmailLabel.home,
          customLabel: label == null ? e['label'] ?? '' : '',
        );
      },
    ).toList();

    contact.addresses = designStructure
        .findBy('addresses')
        .where((element) => element['content'] != null)
        .map(
      (e) {
        AddressLabel? label = AddressLabel.values
            .firstWhereOrNull((label) => label.name == e['label']);
        return Address(
          e['content'],
          label: label ?? AddressLabel.home,
          customLabel: label == null ? e['label'] ?? '' : '',
        );
      },
    ).toList();

    contact.websites = designStructure
        .findBy('websites')
        .where((element) => element['content'] != null)
        .map(
      (e) {
        WebsiteLabel? label = WebsiteLabel.values
            .firstWhereOrNull((label) => label.name == e['label']);
        return Website(
          e['content'],
          label: label ?? WebsiteLabel.home,
          customLabel: label == null ? e['label'] ?? '' : '',
        );
      },
    ).toList();

    contact.socialMedias = designStructure
        .findBy('links')
        .where((element) => element['id'] != null)
        .map((e) => SocialMedia('https://${e['link'] ?? ''}${e['id'] ?? ''}'))
        .toList();

    debug.print(contact.toVCard());

    if (kIsWeb) {
      //webExtension.saveVCard(contact.displayName, contact.toVCard());
    } else {
      if (await FlutterContacts.requestPermission()) {
        await contact.insert();
      }
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
