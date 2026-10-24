import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'TouchTie'**
  String get appName;

  /// No description provided for @scanCard.
  ///
  /// In en, this message translates to:
  /// **'Scan Card'**
  String get scanCard;

  /// No description provided for @claimPageTitle.
  ///
  /// In en, this message translates to:
  /// **'The best way to say hi and stay in touch.'**
  String get claimPageTitle;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account for free'**
  String get createAnAccount;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set Your New Password'**
  String get setNewPassword;

  /// No description provided for @holdYourCard.
  ///
  /// In en, this message translates to:
  /// **'Hold your NFC card against the upper back of your phone'**
  String get holdYourCard;

  /// No description provided for @claimPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A beautiful digital profile in just a few taps. Share anything.'**
  String get claimPageSubtitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make an impression. Create your digital profile today.'**
  String get signInSubtitle;

  /// No description provided for @freeForever.
  ///
  /// In en, this message translates to:
  /// **'Free forever. No payment needed.'**
  String get freeForever;

  /// No description provided for @signUpAgreement.
  ///
  /// In en, this message translates to:
  /// **'By creating an account you are agreeing to our '**
  String get signUpAgreement;

  /// No description provided for @notHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Not yet have an account? '**
  String get notHaveAnAccount;

  /// No description provided for @passwordResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You’ll get a password reset email'**
  String get passwordResetSubtitle;

  /// No description provided for @havingTrouble.
  ///
  /// In en, this message translates to:
  /// **'Having trouble?'**
  String get havingTrouble;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @claimYourPage.
  ///
  /// In en, this message translates to:
  /// **'Claim your page'**
  String get claimYourPage;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInNow.
  ///
  /// In en, this message translates to:
  /// **'Sign In now'**
  String get signInNow;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createOne.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get createOne;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @signUpForFree.
  ///
  /// In en, this message translates to:
  /// **'Sign up for free'**
  String get signUpForFree;

  /// No description provided for @signUpWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign up with email'**
  String get signUpWithEmail;

  /// No description provided for @termsAndConditionas.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditionas;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @design.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get design;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @resize.
  ///
  /// In en, this message translates to:
  /// **'Resize'**
  String get resize;

  /// No description provided for @overlayColor.
  ///
  /// In en, this message translates to:
  /// **'Overlay Color'**
  String get overlayColor;

  /// No description provided for @overlayOpacity.
  ///
  /// In en, this message translates to:
  /// **'Overlay Opacity'**
  String get overlayOpacity;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String percent(Object percent);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @typography.
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get typography;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// No description provided for @textColor.
  ///
  /// In en, this message translates to:
  /// **'Text Color'**
  String get textColor;

  /// No description provided for @fontWeight.
  ///
  /// In en, this message translates to:
  /// **'Font Weight'**
  String get fontWeight;

  /// No description provided for @selectOne.
  ///
  /// In en, this message translates to:
  /// **'Select One'**
  String get selectOne;

  /// No description provided for @alignment.
  ///
  /// In en, this message translates to:
  /// **'Alignment'**
  String get alignment;

  /// No description provided for @contentVerticalAlignment.
  ///
  /// In en, this message translates to:
  /// **'Content vertical alignment'**
  String get contentVerticalAlignment;

  /// No description provided for @contentHorizontalAlignment.
  ///
  /// In en, this message translates to:
  /// **'Content horizontal alignment'**
  String get contentHorizontalAlignment;

  /// No description provided for @paddingAndMarginSettings.
  ///
  /// In en, this message translates to:
  /// **'Padding & Margin Settings'**
  String get paddingAndMarginSettings;

  /// No description provided for @horizontalPadding.
  ///
  /// In en, this message translates to:
  /// **'Horizontal Padding'**
  String get horizontalPadding;

  /// No description provided for @padding.
  ///
  /// In en, this message translates to:
  /// **'Padding'**
  String get padding;

  /// No description provided for @margin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get margin;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get middleName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @phoneNumbers.
  ///
  /// In en, this message translates to:
  /// **'Phone Numbers'**
  String get phoneNumbers;

  /// No description provided for @addANewRow.
  ///
  /// In en, this message translates to:
  /// **'Add a new row'**
  String get addANewRow;

  /// No description provided for @addANewLink.
  ///
  /// In en, this message translates to:
  /// **'Add a new link'**
  String get addANewLink;

  /// No description provided for @emails.
  ///
  /// In en, this message translates to:
  /// **'Emails'**
  String get emails;

  /// No description provided for @websites.
  ///
  /// In en, this message translates to:
  /// **'Websites'**
  String get websites;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @addANewBlock.
  ///
  /// In en, this message translates to:
  /// **'Add a new block'**
  String get addANewBlock;

  /// No description provided for @backgroungImage.
  ///
  /// In en, this message translates to:
  /// **'Background Image'**
  String get backgroungImage;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get backgroundColor;

  /// No description provided for @button.
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get button;

  /// No description provided for @buttonColor.
  ///
  /// In en, this message translates to:
  /// **'Button Color'**
  String get buttonColor;

  /// No description provided for @buttonText.
  ///
  /// In en, this message translates to:
  /// **'Button Text'**
  String get buttonText;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @linkTo.
  ///
  /// In en, this message translates to:
  /// **'Link To'**
  String get linkTo;

  /// No description provided for @buttonDesign.
  ///
  /// In en, this message translates to:
  /// **'Button Design'**
  String get buttonDesign;

  /// No description provided for @borderColor.
  ///
  /// In en, this message translates to:
  /// **'Border Color'**
  String get borderColor;

  /// No description provided for @borderThickness.
  ///
  /// In en, this message translates to:
  /// **'Border Thickness'**
  String get borderThickness;

  /// No description provided for @ratio.
  ///
  /// In en, this message translates to:
  /// **'{a}:{b}'**
  String ratio(int a, int b);

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'{size}'**
  String size(int size);

  /// No description provided for @pxSize.
  ///
  /// In en, this message translates to:
  /// **'{size}px'**
  String pxSize(int size);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @borderRadius.
  ///
  /// In en, this message translates to:
  /// **'Border Radius'**
  String get borderRadius;

  /// No description provided for @fullWidth.
  ///
  /// In en, this message translates to:
  /// **'Full width'**
  String get fullWidth;

  /// No description provided for @openInNewTab.
  ///
  /// In en, this message translates to:
  /// **'Open in new tab'**
  String get openInNewTab;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @removeBlock.
  ///
  /// In en, this message translates to:
  /// **'Remove block'**
  String get removeBlock;

  /// No description provided for @videoLink.
  ///
  /// In en, this message translates to:
  /// **'Video Link'**
  String get videoLink;

  /// No description provided for @videoLinkOptions.
  ///
  /// In en, this message translates to:
  /// **'(YouTube and Vimeo supported)'**
  String get videoLinkOptions;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @videoSetting.
  ///
  /// In en, this message translates to:
  /// **'Video Setting'**
  String get videoSetting;

  /// No description provided for @autoPlay.
  ///
  /// In en, this message translates to:
  /// **'Auto Play'**
  String get autoPlay;

  /// No description provided for @loop.
  ///
  /// In en, this message translates to:
  /// **'Loop'**
  String get loop;

  /// No description provided for @showControls.
  ///
  /// In en, this message translates to:
  /// **'Show Controls'**
  String get showControls;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @allowFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Allow Fullscreen'**
  String get allowFullscreen;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title {count}'**
  String title(int count);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description {count}'**
  String description(int count);

  /// No description provided for @iconColor.
  ///
  /// In en, this message translates to:
  /// **'Icon Color'**
  String get iconColor;

  /// No description provided for @lineBreakColor.
  ///
  /// In en, this message translates to:
  /// **'Line Break Color'**
  String get lineBreakColor;

  /// No description provided for @fromThemeSettings.
  ///
  /// In en, this message translates to:
  /// **'From Theme Settings'**
  String get fromThemeSettings;

  /// No description provided for @customLabelName.
  ///
  /// In en, this message translates to:
  /// **'Custom Label Name'**
  String get customLabelName;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @primaryConnectButton.
  ///
  /// In en, this message translates to:
  /// **'Primary connect button'**
  String get primaryConnectButton;

  /// No description provided for @additionalConnectButton.
  ///
  /// In en, this message translates to:
  /// **'Additional connect button'**
  String get additionalConnectButton;

  /// No description provided for @additionalConnectButtons.
  ///
  /// In en, this message translates to:
  /// **'Additional connect buttons'**
  String get additionalConnectButtons;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get advancedSettings;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get selectColor;

  /// No description provided for @selectColorShade.
  ///
  /// In en, this message translates to:
  /// **'Select color shade'**
  String get selectColorShade;

  /// No description provided for @selectedColor.
  ///
  /// In en, this message translates to:
  /// **'Selected color and its shades'**
  String get selectedColor;

  /// No description provided for @linkToHints.
  ///
  /// In en, this message translates to:
  /// **'https://google.com'**
  String get linkToHints;

  /// No description provided for @videoLinkHints.
  ///
  /// In en, this message translates to:
  /// **'(Youtube/Vimeo)'**
  String get videoLinkHints;

  /// No description provided for @durationHint.
  ///
  /// In en, this message translates to:
  /// **'00:00:00'**
  String get durationHint;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHint;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordHint;

  /// No description provided for @newConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password again'**
  String get newConfirmPasswordHint;

  /// No description provided for @networkNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'We could not establish an internet connection to our service at the moment. Please make sure that you are connected to your network and try again.'**
  String get networkNotAvailable;

  /// No description provided for @passwordFailed.
  ///
  /// In en, this message translates to:
  /// **'Sorry, password protection failed'**
  String get passwordFailed;

  /// No description provided for @nfcNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Your device does not support NFC or it is turned off'**
  String get nfcNotAvailable;

  /// No description provided for @notWritableNfc.
  ///
  /// In en, this message translates to:
  /// **'Sorry, this card is not writable'**
  String get notWritableNfc;

  /// No description provided for @noPasswordNfc.
  ///
  /// In en, this message translates to:
  /// **'Sorry, this card does not support password protection'**
  String get noPasswordNfc;

  /// No description provided for @notLockableNfc.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you can\'t lock this card'**
  String get notLockableNfc;

  /// No description provided for @nfcSizeExceeded.
  ///
  /// In en, this message translates to:
  /// **'Sorry, the data is too large for this card'**
  String get nfcSizeExceeded;

  /// No description provided for @wrongNfcCard.
  ///
  /// In en, this message translates to:
  /// **'Sorry, this card is not supported. Please use a different card'**
  String get wrongNfcCard;

  /// No description provided for @agreeUnsplashTerms.
  ///
  /// In en, this message translates to:
  /// **'By using images from Unsplash, you agree to their license and Terms of Service'**
  String get agreeUnsplashTerms;

  /// No description provided for @emptyField.
  ///
  /// In en, this message translates to:
  /// **'{field, select, null{Field} other {{field}}} is required'**
  String emptyField(String field);

  /// No description provided for @inputLengthError.
  ///
  /// In en, this message translates to:
  /// **'{field, select, null{Field must be {min}-{max} characters long} other {{field} must be {min}-{max} characters long}}'**
  String inputLengthError(String field, int min, int max);

  /// No description provided for @inputMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'{field, select, null{Field must have at least {min} characters} other {{field} must have at least {min} characters}}'**
  String inputMinLengthError(String field, int min);

  /// No description provided for @inputMaxLengthError.
  ///
  /// In en, this message translates to:
  /// **'{field, select, null{Field can contain upto {max} characters} other {{field} can contain upto {max} characters}}'**
  String inputMaxLengthError(String field, int max);

  /// No description provided for @inputMaxValueError.
  ///
  /// In en, this message translates to:
  /// **'{field, select, null{Field max limit {value} characters} other {{field} max limit {value}}}'**
  String inputMaxValueError(String field, String value);

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'You entered an old password'**
  String get oldPassword;

  /// No description provided for @fieldNotMatch.
  ///
  /// In en, this message translates to:
  /// **'{field, select, null{Field} other {{field}}} doesn\'t match'**
  String fieldNotMatch(String field);

  /// No description provided for @notValidField.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid {field, select, null{Field} other {{field}}}'**
  String notValidField(String field);

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid URL'**
  String get invalidUrl;

  /// No description provided for @someErrorOccured.
  ///
  /// In en, this message translates to:
  /// **'Some Error Occured!'**
  String get someErrorOccured;

  /// No description provided for @requestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out!'**
  String get requestTimeout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
