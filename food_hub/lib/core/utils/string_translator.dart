import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

extension StringTranslator on String {
  /// Synchronously translates some hardcoded categories and areas 
  /// (used for lists/chips where async is not ideal).
  String translateDynamic(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    
    if (lang == 'en') return this;

    final lower = toLowerCase();

    if (lang == 'uk') {
      return _ukrainianMap[lower] ?? this;
    } else if (lang == 'pl') {
      return _polishMap[lower] ?? this;
    }

    return this;
  }

  /// Asynchronously translates full text using Google Translate API.
  Future<String> translateAsync(BuildContext context) async {
    if (isEmpty) return this;
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'en') return this;

    try {
      final translator = GoogleTranslator();
      final translation = await translator.translate(this, to: lang);
      return translation.text;
    } catch (e) {
      // If network fails, return original English string.
      return this;
    }
  }

  static const _ukrainianMap = {
    // Categories
    'beef': 'Яловичина',
    'breakfast': 'Сніданок',
    'chicken': 'Курка',
    'dessert': 'Десерти',
    'goat': 'Козяче м\'ясо',
    'lamb': 'Баранина',
    'miscellaneous': 'Різне',
    'pasta': 'Паста',
    'pork': 'Свинина',
    'seafood': 'Морепродукти',
    'side': 'Гарніри',
    'starter': 'Закуски',
    'vegan': 'Веганське',
    'vegetarian': 'Вегетаріанське',
    
    // Areas (Popular ones)
    'american': 'Американська',
    'british': 'Британська',
    'canadian': 'Канадська',
    'chinese': 'Китайська',
    'croatian': 'Хорватська',
    'dutch': 'Нідерландська',
    'egyptian': 'Єгипетська',
    'filipino': 'Філіппінська',
    'french': 'Французька',
    'greek': 'Грецька',
    'indian': 'Індійська',
    'irish': 'Ірландська',
    'italian': 'Італійська',
    'jamaican': 'Ямайська',
    'japanese': 'Японська',
    'kenyan': 'Кенійська',
    'malaysian': 'Малайзійська',
    'mexican': 'Мексиканська',
    'moroccan': 'Марокканська',
    'polish': 'Польська',
    'portuguese': 'Португальська',
    'russian': 'Російська',
    'slovakian': 'Словацька',
    'slovakia': 'Словацька',
    'spanish': 'Іспанська',
    'thai': 'Тайська',
    'tunisian': 'Туніська',
    'turkish': 'Турецька',
    'united states': 'Американська',
    'vietnamese': 'В\'єтнамська',
    'unknown': 'Невідома',
  };

  static const _polishMap = {
    // Categories
    'beef': 'Wołowina',
    'breakfast': 'Śniadanie',
    'chicken': 'Kurczak',
    'dessert': 'Desery',
    'goat': 'Mięso kozie',
    'lamb': 'Jagnięcina',
    'miscellaneous': 'Różne',
    'pasta': 'Makaron',
    'pork': 'Wieprzowina',
    'seafood': 'Owoce morza',
    'side': 'Dodatki',
    'starter': 'Przystawki',
    'vegan': 'Wegańskie',
    'vegetarian': 'Wegetariańskie',

    // Areas
    'american': 'Amerykańska',
    'british': 'Brytyjska',
    'canadian': 'Kanadyjska',
    'chinese': 'Chińska',
    'croatian': 'Chorwacka',
    'dutch': 'Holenderska',
    'egyptian': 'Egipska',
    'filipino': 'Filipińska',
    'french': 'Francuska',
    'greek': 'Grecka',
    'indian': 'Indyjska',
    'irish': 'Irlandzka',
    'italian': 'Włoska',
    'jamaican': 'Jamajska',
    'japanese': 'Japońska',
    'kenyan': 'Kenijska',
    'malaysian': 'Malezyjska',
    'mexican': 'Meksykańska',
    'moroccan': 'Marokańska',
    'polish': 'Polska',
    'portuguese': 'Portugalska',
    'russian': 'Rosyjska',
    'slovakian': 'Słowacka',
    'slovakia': 'Słowacka',
    'spanish': 'Hiszpańska',
    'thai': 'Tajska',
    'tunisian': 'Tunezyjska',
    'turkish': 'Turecka',
    'united states': 'Amerykańska',
    'vietnamese': 'Wietnamska',
    'unknown': 'Nieznana',
  };
}
