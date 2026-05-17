import 'package:flutter/material.dart';

extension StringTranslator on String {
  /// Translates category and area names dynamically.
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
    'spanish': 'Іспанська',
    'thai': 'Тайська',
    'tunisian': 'Туніська',
    'turkish': 'Турецька',
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
    'spanish': 'Hiszpańska',
    'thai': 'Tajska',
    'tunisian': 'Tunezyjska',
    'turkish': 'Turecka',
    'vietnamese': 'Wietnamska',
    'unknown': 'Nieznana',
  };
}
