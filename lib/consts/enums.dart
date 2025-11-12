enum AppFonts {
  signora('Signora'),
  faugllinBalseyn('Faugllin Balseyn'),
  madamGhea('Madam Ghea'),
  kattyDiona('Katty Diona'),
  mallong('Mallong'),
  soulNoteDisplay('Soul Note Display'),
  playfairDisplay('Playfair Display'),
  quicksand('Quicksand'),
  sacramento('Sacramento');

  final String value;
  const AppFonts(this.value);
}

enum GiftRecipient {
  groom(
    bankName: 'TPBank',
    bankAccount: 'vuongs2trang',
    accountName: 'Phạm Văn Vương',
    qrCodePath: 'images/qr-vuongs2trang.png',
  ),
  bride(
    bankName: 'TPBank',
    bankAccount: 'trangs2vuong',
    accountName: 'Nguyễn Thị Phương Trang',
    qrCodePath: 'images/qr-trangs2vuong.png',
  );

  const GiftRecipient({
    required this.bankName,
    required this.bankAccount,
    required this.accountName,
    required this.qrCodePath,
  });

  final String bankName;
  final String bankAccount;
  final String accountName;
  final String qrCodePath;
}
