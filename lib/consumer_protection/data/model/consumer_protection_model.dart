import 'consumer_protection.dart';

class ConsumerProtectionModel {
  String? directorateSocialContact;
  String? directorateSubtitle;
  String? directorateTitle;
  String? header;
  String? orgEmail;
  String? orgPhone;
  String? orgTitle;

  ConsumerProtectionModel(
      {this.directorateSocialContact,
      this.directorateSubtitle,
      this.directorateTitle,
      this.header,
      this.orgEmail,
      this.orgPhone,
      this.orgTitle});

  ConsumerProtectionModel.fromJson(Map<String, dynamic> json) {
    directorateSocialContact = json['directorate_social_contact'];
    directorateSubtitle = json['directorate_subtitle'];
    directorateTitle = json['directorate_title'];
    header = json['header'];
    orgEmail = json['org_email'];
    orgPhone = json['org_phone'];
    orgTitle = json['org_title'];
  }

  ConsumerProtection toEntity() {
    return ConsumerProtection(
      directorateSocialContact:
          directorateSocialContact ?? 'WhatsApp : +62 853 1111 1010',
      directorateSubtitle: directorateSubtitle ??
          'Kementerian Perdagangan RI / Directorate General of Consumer Protection and Trade Compliance',
      directorateTitle: directorateTitle ??
          'Direktorat Jenderal Perlindungan Konsumen dan Tertib Niaga',
      header: header ?? 'Layanan Pengaduan Konsumen',
      orgEmail: orgEmail ?? 'help@klikit.io',
      orgPhone: orgPhone ?? '+62 812 8713 7048',
      orgTitle: orgTitle ?? 'klikit',
    );
  }
}
