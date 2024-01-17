import 'package:klikit/resources/asset_resolver/png_image_resource.dart';

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

  static SVGImageResource get filterSVG => SVGImageResource('$iconBasePath/ic_filter.svg');

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

  static PNGImageResource get emptyMenuPNG => const PNGImageResource('$imageBasePath/empty_menu.png');

  static SVGImageResource get refreshSVG => SVGImageResource('$iconBasePath/ic_refresh.svg');

  static SVGImageResource get downloadSVG => SVGImageResource('$iconBasePath/ic_download.svg');

  static SVGImageResource get downArrowSVG => SVGImageResource('$iconBasePath/ic_down_arrow.svg');

  static SVGImageResource get infoSVG => SVGImageResource('$iconBasePath/ic_info.svg');

  static SVGImageResource get successSVG => SVGImageResource('$iconBasePath/ic_success.svg');

  static SVGImageResource get appLogoSVG => SVGImageResource('$iconBasePath/ic_app_logo.svg');

  static SVGImageResource get appWordMarkSVG => SVGImageResource('$iconBasePath/ic_app_word_mark.svg');

  static SVGImageResource get cartSVG => SVGImageResource('$iconBasePath/ic_cart.svg');

  static SVGImageResource get incrementSVG => SVGImageResource('$iconBasePath/ic_increment.svg');

  static SVGImageResource get decrementSVG => SVGImageResource('$iconBasePath/ic_decrement.svg');

  static SVGImageResource get cancelSVG => SVGImageResource('$iconBasePath/ic_cancel.svg');

  static SVGImageResource get editSVG => SVGImageResource('$iconBasePath/ic_edit_pencil.svg');

  static SVGImageResource get deliveryCardSVG => SVGImageResource('$iconBasePath/ic_delivery_car.svg');

  static SVGImageResource get readyFoodSVG => SVGImageResource('$iconBasePath/ic_ready_food.svg');

  static SVGImageResource get copySVG => SVGImageResource('$iconBasePath/ic_copy.svg');
}
