import 'asset_resolver/svg_image_resource.dart';

const String assetBasePath = 'assets';
const String fontBasePath = '$assetBasePath/fonts';
const String imageBasePath = '$assetBasePath/images';
const String iconBasePath = '$assetBasePath/icons';

class ImageResourceResolver {
  static SVGImageResource get logoutSVG => SVGImageResource('$iconBasePath/ic_logout.svg');

  static SVGImageResource get userSVG => SVGImageResource('$iconBasePath/ic_user.svg');

  static SVGImageResource get placeholderSVG => SVGImageResource('$iconBasePath/ic_default_placeholder.svg');

  static SVGImageResource get languageSVG => SVGImageResource('$iconBasePath/ic_language.svg');

  static SVGImageResource get rightArrowSVG => SVGImageResource('$iconBasePath/ic_right_arrow.svg');

  static SVGImageResource get printerSVG => SVGImageResource('$iconBasePath/ic_printer.svg');

  static SVGImageResource get phoneSVG => SVGImageResource('$iconBasePath/ic_phone.svg');

  static SVGImageResource get supportSVG => SVGImageResource('$iconBasePath/ic_contact_support.svg');

  static SVGImageResource get changePasswordSVG => SVGImageResource('$iconBasePath/ic_change_password.svg');

  static SVGImageResource get profileSVG => SVGImageResource('$iconBasePath/ic_profile.svg');

  static SVGImageResource get notificationSVG => SVGImageResource('$iconBasePath/ic_notification.svg');

  static SVGImageResource get unreadNotificationSVG => SVGImageResource('$iconBasePath/ic_unread_notification.svg');

  static SVGImageResource get notificationAlertSVG => SVGImageResource('$iconBasePath/ic_notification_alert.svg');

  static SVGImageResource get closeSVG => SVGImageResource('$iconBasePath/ic_close.svg');

  static SVGImageResource get whatsappSVG => SVGImageResource('$iconBasePath/ic_whatsapp.svg');

  static SVGImageResource get emailSVG => SVGImageResource('$iconBasePath/ic_email.svg');

  static SVGImageResource get deleteSVG => SVGImageResource('$iconBasePath/ic_delete.svg');

  static SVGImageResource get refreshSVG => SVGImageResource('$iconBasePath/ic_refresh.svg');

  static SVGImageResource get downloadSVG => SVGImageResource('$iconBasePath/ic_download.svg');

  static SVGImageResource get downArrowSVG => SVGImageResource('$iconBasePath/ic_down_arrow.svg');

  static SVGImageResource get infoSVG => SVGImageResource('$iconBasePath/ic_info.svg');
}
