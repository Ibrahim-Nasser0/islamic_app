class MuadhinOption {
  final String id;
  final String nameKey;
  final String location;

  const MuadhinOption({
    required this.id,
    required this.nameKey,
    required this.location,
  });

  static const List<MuadhinOption> defaultList = [
    MuadhinOption(
      id: 'makkah',
      nameKey: 'makkah_adhan',
      location: 'مكة المكرمة',
    ),
    MuadhinOption(
      id: 'madinah',
      nameKey: 'madinah_adhan',
      location: 'المدينة المنورة',
    ),
    MuadhinOption(
      id: 'abdulbaset',
      nameKey: 'abdulbaset_adhan',
      location: 'مصر',
    ),
    MuadhinOption(
      id: 'afasy',
      nameKey: 'afasy_adhan',
      location: 'الكويت',
    ),
    MuadhinOption(
      id: 'aqsa',
      nameKey: 'aqsa_adhan',
      location: 'القدس الشريف',
    ),
  ];
}
