import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:my_nfc/shared/styles.dart';
import 'package:my_nfc/utils/web/web_extensions.dart';
import 'package:provider/provider.dart';
import '../../shared/strings.dart';
import '../../shared/constants.dart';
import '../../utils/extensions.dart';
//import '../../utils/web_extensions.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'components.dart';

class ActionsBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  final Map<String, dynamic> _settings;
  final Map<String, dynamic> _primary;
  final Map<String, dynamic> _additional;

  ActionsBlock(
    this.configs, {
    required this.path,
    required this.parent,
    this.sectionStyle,
    super.key,
  }) : _settings = Map<String, dynamic>.from(
         configs['settings']?['advanced'] ?? {},
       ),
       _primary = Map<String, dynamic>.from(configs['data']?['primary'] ?? {}),
       _additional = Map<String, dynamic>.from(
         configs['data']?['additional'] ?? {},
       );

  Future<void> saveToPhone(BuildContext context) async {
    final designStructure = Provider.of<DashboardViewModel>(
      context,
      listen: false,
    ).designStructure;

    String parse(dynamic value) => value?.toString().trim() ?? '';

    Label<T> contactLabel<T extends Enum>(
      List<T> values,
      dynamic rawLabel,
      T fallback,
    ) {
      final labelName = parse(rawLabel);
      final value = values.firstWhereOrNull((item) => item.name == labelName);

      return Label<T>(
        value ?? fallback,
        value == null && labelName.isNotEmpty ? labelName : null,
      );
    }

    // Name
    final nameData = designStructure
        .findBy('name')
        .firstWhereOrNull(
          (e) =>
              parse(e['first']).isNotEmpty ||
              parse(e['middle']).isNotEmpty ||
              parse(e['last']).isNotEmpty,
        );

    final name = nameData == null
        ? null
        : Name(
            first: parse(nameData['first']),
            middle: parse(nameData['middle']),
            last: parse(nameData['last']),
          );

    // Photo
    final photoBytes = designStructure
        .filterBy(const MapEntry('subBlock', 'image_avatar'))
        .map((e) => e['data']?['bytes'])
        .firstWhereOrNull((bytes) => bytes != null);

    // Notes
    final notes = designStructure
        .filterBy(const MapEntry('label', 'Bio'))
        .map((e) => parse(e['data']?['content']))
        .where((value) => value.isNotEmpty)
        .map((value) => Note(note: value))
        .toList();

    // Organizations
    final organizations = designStructure
        .filterBy(const MapEntry('label', 'Work'))
        .map((e) {
          final data = e['data'];
          final title = parse(data?['title']?['text']);
          final jobTitle = parse(data?['content']?['text']);

          if (title.isEmpty && jobTitle.isEmpty) return null;

          return Organization(name: title, jobTitle: jobTitle);
        })
        .whereType<Organization>()
        .toList();

    // Phones
    final phones = designStructure
        .findBy('phoneNumbers')
        .map((e) {
          final number = '${parse(e['prefix'])}${parse(e['content'])}';
          if (number.isEmpty) return null;

          return Phone(
            number: number,
            label: contactLabel(
              PhoneLabel.values,
              e['label'],
              PhoneLabel.mobile,
            ),
          );
        })
        .whereType<Phone>()
        .toList();

    // Emails
    final emails = designStructure
        .findBy('emails')
        .map((e) {
          final address = parse(e['content']);
          if (address.isEmpty) return null;

          return Email(
            address: address,
            label: contactLabel(EmailLabel.values, e['label'], EmailLabel.home),
          );
        })
        .whereType<Email>()
        .toList();

    // Addresses
    final addresses = designStructure
        .findBy('addresses')
        .map((e) {
          final formatted = parse(e['content']);
          if (formatted.isEmpty) return null;

          return Address(
            formatted: formatted,
            label: contactLabel(
              AddressLabel.values,
              e['label'],
              AddressLabel.home,
            ),
          );
        })
        .whereType<Address>()
        .toList();

    // Websites
    final websites = designStructure
        .findBy('websites')
        .map((e) {
          final url = parse(e['content']);
          if (url.isEmpty) return null;

          return Website(
            url: url,
            label: contactLabel(
              WebsiteLabel.values,
              e['label'],
              WebsiteLabel.home,
            ),
          );
        })
        .whereType<Website>()
        .toList();

    // Social media
    final socialMedias = designStructure
        .findBy('links')
        .map((e) {
          final id = parse(e['id']);
          if (id.isEmpty) return null;

          final baseUrl = parse(e['link']);
          if (baseUrl.isEmpty) return null;

          final url =
              baseUrl.startsWith('https://') || baseUrl.startsWith('http://')
              ? '$baseUrl$id'
              : 'https://$baseUrl$id';

          return SocialMedia(username: url);
        })
        .whereType<SocialMedia>()
        .toList();

    final contact = Contact(
      name: name,
      displayName: [
        parse(name?.first),
        parse(name?.middle),
        parse(name?.last),
      ].where((part) => part.isNotEmpty).join(' '),
      photo: photoBytes,
      notes: notes,
      organizations: organizations,
      phones: phones,
      emails: emails,
      addresses: addresses,
      websites: websites,
      socialMedias: socialMedias,
    );

    if (kIsWeb) {
      final vCard = FlutterContacts.vCard.export(contact);
      webExtension.saveVCard(contact.displayName, vCard);
      return;
    }

    final permission = await FlutterContacts.permissions.request(
      PermissionType.readWrite,
    );

    if (permission != PermissionStatus.granted) return;

    await FlutterContacts.create(contact);
    style.showToast('Saved to contact!');
  }

  @override
  Widget build(BuildContext context) {
    final key = parent.key('$path/');
    final buttonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.zero),
      padding: WidgetStatePropertyAll(
        padding(configs['style']?['spacing']?['padding']),
      ),
      shape: const WidgetStatePropertyAll((StadiumBorder())),
    );

    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(
        border: parent.isSelected(key) ? selectedBorder : null,
      ),
      transform: transform(configs['style']?['spacing']?['margin']),
      margin: margin(configs['style']?['spacing']?['margin']),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_settings['showSaveToPhoneButton'] == true)
            Expanded(
              child: TextButton(
                onPressed: () async => await saveToPhone(context),
                style: buttonStyle.copyWith(
                  backgroundColor: WidgetStatePropertyAll((() {
                    final style = Map<String, dynamic>.from(
                      configs['data']?['style']?['background'] ?? {},
                    );
                    return style['color'].toString().hexColor;
                  }())),
                ),
                child: Text(
                  configs['data']?['label']?['text'],
                  style:
                      textStyle(
                        context,
                        Map<String, dynamic>.from(
                          configs['data']?['style']?['text'] ?? {},
                        ),
                      ).copyWith(
                        color:
                            configs['data']?['style']?['text']?['labelColor']
                                ?.toString()
                                .hexColor ??
                            Provider.of<DashboardViewModel>(
                              context,
                            ).theme.iconColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ),
            ),
          if (_settings['showPrimaryContactButton'] == true &&
              _primary.isNotEmpty)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: _settings['showSaveToPhoneButton'] == true ? 8 : 0,
                ),
                child: TextButton.icon(
                  onPressed: openUrl(
                    url: Uri.parse(
                      'https://${_primary['link'] ?? ''}${_primary['id'] ?? ''}',
                    ),
                  ),
                  style: buttonStyle.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                      '${_primary['name']}'.socialIconColor,
                    ),
                  ),
                  icon: Transform.scale(
                    scale: 1.5,
                    child: Icon(
                      '${_primary['name']}'.socialIcon,
                      size:
                          (configs['data']?['style']?['text']?['fontSize'] ??
                                  14)
                              .toDouble(),
                      color: Colors.white,
                    ),
                  ),
                  label: Text(
                    string.connect,
                    style:
                        textStyle(
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
          if (_settings['showAdditionalContactButton'] == true &&
              _additional.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                left:
                    _settings['showSaveToPhoneButton'] == true ||
                        (_settings['showPrimaryContactButton'] == true &&
                            _primary.isNotEmpty)
                    ? 8
                    : 0,
              ),
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    '${_additional['name']}'.socialIconColor,
                  ),
                ),
                onPressed: openUrl(
                  url: Uri.parse(
                    'https://${_additional['link'] ?? ''}${_additional['id'] ?? ''}',
                  ),
                ),
                padding: kIsWeb
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.all(22),
                icon: Transform.scale(
                  scale: 1.75,
                  child: Icon(
                    '${_additional['name']}'.socialIcon,
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
