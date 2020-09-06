////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МножественныйВыбор = Ложь;
	ПрочитатьДеревоУзловОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекПараметры = УстановитьПараметрыФормы();
	РазвернутьУзлы(ТекПараметры.Отмеченные);
	Элементы.ДеревоУзловОбмена.ТекущаяСтрока = ТекПараметры.ТекущаяСтрока;
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	ТекПараметры = УстановитьПараметрыФормы();
	РазвернутьУзлы(ТекПараметры.Отмеченные);
	Элементы.ДеревоУзловОбмена.ТекущаяСтрока = ТекПараметры.ТекущаяСтрока;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДеревоУзлов
//

&НаКлиенте
Процедура ДеревоУзловОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПроизвестиВыборУзлов(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоУзловОбменаПометкаПриИзменении(Элемент)
	ИзменениеПометки(Элементы.ДеревоУзловОбмена.ТекущаяСтрока);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
//

// Выбирает узел и передает выбранные значения в вызывающую форму.
&НаКлиенте
Процедура ВыбратьУзел(Команда)
	ПроизвестиВыборУзлов(МножественныйВыбор);
КонецПроцедуры

// Открывает форму узла, заданную в конфигурации.
&НаКлиенте
Процедура ИзменитьУзел(Команда)
	КлючСсылка = Элементы.ДеревоУзловОбмена.ТекущиеДанные.Ссылка;
	Если КлючСсылка<>Неопределено Тогда
		ОткрытьФорму(ПолучитьИмяФормы(КлючСсылка) + "ФормаОбъекта", Новый Структура("Ключ", КлючСсылка));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьОбъект(Команда)
	УИ_ОбщегоНазначенияКлиент.РедактироватьОбъект(Элементы.ДеревоУзловОбмена.ТекущиеДанные.Ссылка);
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

&НаКлиенте
Процедура РазвернутьУзлы(Отмеченные) 
	Если Отмеченные<>Неопределено Тогда
		Для Каждого ТекИд Из Отмеченные Цикл
			ТекСтрока = ДеревоУзловОбмена.НайтиПоИдентификатору(ТекИд);
			ТекРодитель = ТекСтрока.ПолучитьРодителя();
			Если ТекРодитель<>Неопределено Тогда
				Элементы.ДеревоУзловОбмена.Развернуть(ТекРодитель.ПолучитьИдентификатор());
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура ПроизвестиВыборУзлов(ЭтоМножественныйВыбор)
	
	Если ЭтоМножественныйВыбор Тогда
		Данные = ВыбранныеУзлы();
		Если Данные.Количество()>0 Тогда
			ОповеститьОВыборе(Данные);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Данные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	Если Данные<>Неопределено И Данные.Ссылка<>Неопределено Тогда
		ОповеститьОВыборе(Данные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыбранныеУзлы(НовыеДанные=Неопределено)
	
	Если НовыеДанные<>Неопределено Тогда
		// Установка
		Отмеченные = Новый Массив;
		ВнутрУстановитьВыбранныеУзлы(ЭтотОбъект(), ДеревоУзловОбмена, НовыеДанные, Отмеченные);
		Возврат Отмеченные;
	КонецЕсли;
	
	// Получение
	Результат = Новый Массив;
	Для Каждого ТекПлан Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Для Каждого ТекСтрока Из ТекПлан.ПолучитьЭлементы() Цикл
			Если ТекСтрока.Пометка И ТекСтрока.Ссылка<>Неопределено Тогда
				Результат.Добавить(ТекСтрока.Ссылка);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ВнутрУстановитьВыбранныеУзлы(ТекущийОбъект, Данные, НовыеДанные, Отмеченные)
	Для Каждого ТекСтрока Из Данные.ПолучитьЭлементы() Цикл
		Если НовыеДанные.Найти(ТекСтрока.Ссылка)<>Неопределено Тогда
			ТекСтрока.Пометка = Истина;
			ТекущийОбъект.ПроставитьПометкиВверх(ТекСтрока);
			Отмеченные.Добавить(ТекСтрока.ПолучитьИдентификатор());
		КонецЕсли;
		ВнутрУстановитьВыбранныеУзлы(ТекущийОбъект, ТекСтрока, НовыеДанные, Отмеченные);
	КонецЦикла;
КонецПроцедуры

Функция ЭтотОбъект(ТекущийОбъект=Неопределено) 
	Если ТекущийОбъект=Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Функция ПолучитьИмяФормы(ТекущийОбъект=Неопределено)
	Возврат ЭтотОбъект().ПолучитьИмяФормы(ТекущийОбъект);
КонецФункции	

&НаСервере
Процедура ПрочитатьДеревоУзловОбмена()
	Дерево = ЭтотОбъект().СформироватьДеревоУзлов();
	ЗначениеВРеквизитФормы(Дерево,  "ДеревоУзловОбмена");
КонецПроцедуры

&НаСервере
Процедура ИзменениеПометки(СтрокаДанных)
	ЭлементДанных = ДеревоУзловОбмена.НайтиПоИдентификатору(СтрокаДанных);
	ЭтотОбъект().ИзменениеПометки(ЭлементДанных);
КонецПроцедуры

&НаСервере
Функция УстановитьПараметрыФормы()
	
	Результат = Новый Структура("ТекущаяСтрока, Отмеченные");
	
	// Множественный выбор
	Элементы.ДеревоУзловОбменаПометка.Видимость = Параметры.МножественныйВыбор;
	// Сбрасываем пометки только если выбор изменился
	Если Параметры.МножественныйВыбор<>МножественныйВыбор Тогда
		ТекущийОбъект = ЭтотОбъект();
		Для Каждого ТекСтрока Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
			ТекСтрока.Пометка = Ложь;
			ТекущийОбъект.ПроставитьПометкиВниз(ТекСтрока);
		КонецЦикла;
	КонецЕсли;
	МножественныйВыбор = Параметры.МножественныйВыбор;
	
	// Позиционирование
	Если МножественныйВыбор И ТипЗнч(Параметры.НачальноеЗначениеВыбора)=Тип("Массив") Тогда 
		Отмеченные = ВыбранныеУзлы(Параметры.НачальноеЗначениеВыбора);
		Результат.Отмеченные = Отмеченные;
		Если Отмеченные.Количество()>0 Тогда
			Результат.ТекущаяСтрока = Отмеченные[0];
		КонецЕсли;
			
	ИначеЕсли Параметры.НачальноеЗначениеВыбора<>Неопределено Тогда
		// Одиночный вариант
		Результат.ТекущаяСтрока = ИдентификаторСтрокиПоУзлу(ДеревоУзловОбмена, Параметры.НачальноеЗначениеВыбора);
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ИдентификаторСтрокиПоУзлу(Данные, Ссылка)
	Для Каждого ТекСтрока Из Данные.ПолучитьЭлементы() Цикл
		Если ТекСтрока.Ссылка=Ссылка Тогда
			Возврат ТекСтрока.ПолучитьИдентификатор();
		КонецЕсли;
		Результат = ИдентификаторСтрокиПоУзлу(ТекСтрока, Ссылка);
		Если Результат<>Неопределено Тогда 
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции
