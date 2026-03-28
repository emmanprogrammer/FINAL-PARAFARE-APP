import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(instance != null, 'AppLocalizations not found in context');
    return instance!;
  }

  static const supportedLocales = [Locale('en'), Locale('fil')];

  static const Map<String, Map<String, String>> _v = {
    'en': {
      'appName': 'ParaFare',
      'getStarted': 'Get started',
      'selectRole': 'Select role',
      'driver': 'Driver',
      'passenger': 'Passenger',
      'admin': 'Admin',
      'driverRegistration': 'Driver registration',
      'name': 'Name',
      'tricycleId': 'Tricycle ID',
      'continueText': 'Continue',
      'confirmSeats': 'Confirm seats',
      'sixSeats': 'Your tricycle has 6 fixed passenger slots.',
      'confirm': 'Confirm',
      'driverDashboard': 'Driver dashboard',
      'slot': 'Slot',
      'empty': 'Empty',
      'tapToAddRide': 'Tap to add ride',
      'addRide': 'Add ride',
      'confirmRide': 'Confirm ride',
      'manageRide': 'Manage ride',
      'finishRide': 'Finish ride',
      'earningsHistory': 'Earnings & History',
      'dailyEarnings': 'Daily earnings',
      'totalTripsToday': 'Total trips today',
      'passengerDashboard': 'Passenger dashboard',
      'routeInfo': 'Route info',
      'nearbyTricyclesComingSoon': 'Nearby tricycles: Coming soon',
      'adminDashboard': 'Admin dashboard',
      'allTrips': 'All trips',
      'earningsReports': 'Earnings reports',
      'fareRulesManager': 'Fare rules manager',
      'settings': 'Settings',
      'switchRole': 'Switch role',
      'language': 'Language',
      'systemDefault': 'System default',
      'baseFare': 'Base fare',
      'baseDistance': 'Base distance',
      'perKm': 'Per km rate',
      'minFare': 'Minimum fare',
      'maxFare': 'Maximum fare',
      'updated': 'Updated',
      'save': 'Save',
      'tripDetail': 'Trip detail',
      'mapUnavailable': 'Offline map tiles unavailable. Add a valid gensan.pmtiles asset.',
    },
    'fil': {
      'appName': 'ParaFare',
      'getStarted': 'Magsimula',
      'selectRole': 'Piliin ang role',
      'driver': 'Driver',
      'passenger': 'Pasahero',
      'admin': 'Admin',
      'driverRegistration': 'Rehistro ng driver',
      'name': 'Pangalan',
      'tricycleId': 'ID ng tricycle',
      'continueText': 'Magpatuloy',
      'confirmSeats': 'Kumpirmahin ang upuan',
      'sixSeats': 'Ang tricycle mo ay may 6 na nakapirming puwesto.',
      'confirm': 'Kumpirmahin',
      'driverDashboard': 'Dashboard ng driver',
      'slot': 'Puwesto',
      'empty': 'Walang laman',
      'tapToAddRide': 'I-tap para magdagdag ng biyahe',
      'addRide': 'Magdagdag ng biyahe',
      'confirmRide': 'Kumpirmahin ang biyahe',
      'manageRide': 'Pamahalaan ang biyahe',
      'finishRide': 'Tapusin ang biyahe',
      'earningsHistory': 'Kita at Kasaysayan',
      'dailyEarnings': 'Kita ngayong araw',
      'totalTripsToday': 'Kabuuang biyahe ngayong araw',
      'passengerDashboard': 'Dashboard ng pasahero',
      'routeInfo': 'Impormasyon ng ruta',
      'nearbyTricyclesComingSoon': 'Malapit na tricycle: Parating pa lang',
      'adminDashboard': 'Dashboard ng admin',
      'allTrips': 'Lahat ng biyahe',
      'earningsReports': 'Ulat ng kita',
      'fareRulesManager': 'Tagapamahala ng fare rules',
      'settings': 'Settings',
      'switchRole': 'Palitan ang role',
      'language': 'Wika',
      'systemDefault': 'Default ng system',
      'baseFare': 'Base fare',
      'baseDistance': 'Base distance',
      'perKm': 'Rate kada km',
      'minFare': 'Pinakamababang pamasahe',
      'maxFare': 'Pinakamataas na pamasahe',
      'updated': 'Na-update',
      'save': 'I-save',
      'tripDetail': 'Detalye ng biyahe',
      'mapUnavailable': 'Walang offline map tiles. Maglagay ng valid na gensan.pmtiles asset.',
    }
  };

  String _t(String key) => _v[locale.languageCode]?[key] ?? _v['en']![key]!;

  String get appName => _t('appName');
  String get getStarted => _t('getStarted');
  String get selectRole => _t('selectRole');
  String get driver => _t('driver');
  String get passenger => _t('passenger');
  String get admin => _t('admin');
  String get driverRegistration => _t('driverRegistration');
  String get name => _t('name');
  String get tricycleId => _t('tricycleId');
  String get continueText => _t('continueText');
  String get confirmSeats => _t('confirmSeats');
  String get sixSeats => _t('sixSeats');
  String get confirm => _t('confirm');
  String get driverDashboard => _t('driverDashboard');
  String get slot => _t('slot');
  String get empty => _t('empty');
  String get tapToAddRide => _t('tapToAddRide');
  String get addRide => _t('addRide');
  String get confirmRide => _t('confirmRide');
  String get manageRide => _t('manageRide');
  String get finishRide => _t('finishRide');
  String get earningsHistory => _t('earningsHistory');
  String get dailyEarnings => _t('dailyEarnings');
  String get totalTripsToday => _t('totalTripsToday');
  String get passengerDashboard => _t('passengerDashboard');
  String get routeInfo => _t('routeInfo');
  String get nearbyTricyclesComingSoon => _t('nearbyTricyclesComingSoon');
  String get adminDashboard => _t('adminDashboard');
  String get allTrips => _t('allTrips');
  String get earningsReports => _t('earningsReports');
  String get fareRulesManager => _t('fareRulesManager');
  String get settings => _t('settings');
  String get switchRole => _t('switchRole');
  String get language => _t('language');
  String get systemDefault => _t('systemDefault');
  String get baseFare => _t('baseFare');
  String get baseDistance => _t('baseDistance');
  String get perKm => _t('perKm');
  String get minFare => _t('minFare');
  String get maxFare => _t('maxFare');
  String get updated => _t('updated');
  String get save => _t('save');
  String get tripDetail => _t('tripDetail');
  String get mapUnavailable => _t('mapUnavailable');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => const ['en', 'fil'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
