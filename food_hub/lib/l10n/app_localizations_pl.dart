// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'FoodHub';

  @override
  String get navHome => 'Główna';

  @override
  String get navFavorites => 'Ulubione';

  @override
  String get navAdd => 'Dodaj';

  @override
  String get navProfile => 'Profil';

  @override
  String get loginTitle => 'Witaj ponownie!';

  @override
  String get loginSubtitle => 'Zaloguj się, aby odkryć niesamowite przepisy';

  @override
  String get registerTitle => 'Utwórz konto';

  @override
  String get email => 'Email';

  @override
  String get password => 'Hasło';

  @override
  String get confirmPassword => 'Potwierdź hasło';

  @override
  String get login => 'Zaloguj się';

  @override
  String get register => 'Utwórz konto';

  @override
  String get forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get noAccount => 'Nie masz konta? ';

  @override
  String get hasAccount => 'Masz już konto? ';

  @override
  String get homeGreeting => 'Co chciałbyś dziś ugotować?';

  @override
  String get categories => 'Kategorie';

  @override
  String get mealOfDay => 'Przepis dnia';

  @override
  String get search => 'Szukaj przepisów...';

  @override
  String get favorites => 'Ulubione';

  @override
  String get noFavorites => 'Brak ulubionych';

  @override
  String get noFavoritesSubtitle =>
      'Zacznij odkrywać i zapisywać przepisy, które lubisz!';

  @override
  String get addRecipe => 'Dodaj przepis';

  @override
  String get recipeName => 'Nazwa przepisu';

  @override
  String get recipeDescription => 'Opis';

  @override
  String get ingredients => 'Składniki';

  @override
  String get instructions => 'Instrukcje';

  @override
  String get uploadPhoto => 'Prześlij zdjęcie';

  @override
  String get camera => 'Aparat';

  @override
  String get gallery => 'Galeria';

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Ustawienia';

  @override
  String get theme => 'Motyw';

  @override
  String get language => 'Język';

  @override
  String get logout => 'Wyloguj się';

  @override
  String get errorGeneral => 'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String get errorNetwork => 'Brak połączenia z internetem. Sprawdź sieć.';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get retry => 'Ponów próbę';

  @override
  String get watchOnYoutube => 'Obejrzyj na YouTube';

  @override
  String get addedToFavorites => 'Dodano do ulubionych';

  @override
  String get removedFromFavorites => 'Usunięto z ulubionych';
}
