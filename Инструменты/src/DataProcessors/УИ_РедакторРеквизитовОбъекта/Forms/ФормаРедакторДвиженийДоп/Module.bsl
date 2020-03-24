&НаКлиенте
Перем мЗакрытьФормуБезВопросов;

&НаКлиенте
Перем мТекСтрокаТаблицыРегистров;

&НаКлиенте
Перем мТекСтрокаТаблицыРегистровСтарая;
&НаКлиенте
Процедура вПоказатьПредупреждение(ТекстСообщения)
	ПоказатьПредупреждение( , ТекстСообщения, 20);
КонецПроцедуры

&НаКлиенте
Процедура вПоказатьВопрос(ИмяПроцедуры, ТекстВопроса, ДопПараметры = Неопределено)
	ПоказатьВопрос(Новый ОписаниеОповещения(ИмяПроцедуры, ЭтаФорма, ДопПараметры), ТекстВопроса,
		РежимДиалогаВопрос.ДаНетОтмена, 20);
КонецПроцедуры
&НаСервере
Функция вПолучитьОбработку()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	_ОписаниеРазработки = Параметры.ОписаниеРазработки;

	мОбъектСсылка = Параметры.мОбъектСсылка;
	мОбъектСсылкаПредыдущий = Неопределено;
	Заголовок = Заголовок + " (" + _ОписаниеРазработки.НомерВерсии + " от " + _ОписаниеРазработки.ДатаВерсии + ")";

	ПутьКФормам = вПолучитьОбработку().Метаданные().ПолноеИмя() + ".Форма.";

	_БыстрыйВызовСервера = Истина;
	_ПриЗаполненииОбрабатыватьТолькоВыделенныеСтроки = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если мЗакрытьФормуБезВопросов = Истина Или _ЗадаватьВопросПриЗакрытии = Ложь Тогда
		Возврат;
	КонецЕсли;

	Если _ТабРегистры.НайтиСтроки(Новый Структура("Изменен", Истина)).Количество() <> 0 Тогда
		Если ЗавершениеРаботы = Неопределено Тогда
			// для старых версии платформы
			Отказ = Истина;
			вПоказатьВопрос("вЗакрытьФорму", "Редактор движений будет закрыт. Продолжить?");
			Возврат;
		КонецЕсли;

		Если ЗавершениеРаботы = Ложь Тогда
			Отказ = Истина;
			вПоказатьВопрос("вЗакрытьФорму", "Редактор движений будет закрыт. Продолжить?");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура вЗакрытьФорму(РезультатВопроса, ДопПараметры = Неопределено) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		мЗакрытьФормуБезВопросов = Истина;
		ЭтаФорма.Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	мТекСтрокаТаблицыРегистров = Неопределено;
	мТекСтрокаТаблицыРегистровСтарая = Неопределено;

	ПодключитьОбработчикОжидания("вПослеОткрытия", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура вПослеОткрытия() Экспорт
	_Обновить(Неопределено);
КонецПроцедуры
&НаКлиенте
Процедура мОбъектСсылкаПриИзменении(Элемент)
	_Обновить(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура мОбъектСсылкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если мОбъектСсылка = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		СтрукПарам = Новый Структура("ЗакрыватьПриЗакрытииВладельца, ПереченьРазделов", Истина, "Документы");
		ОткрытьФорму("ОбщаяФорма.УИ_ФормаВыбораТипаОбъекта", СтрукПарам, Элемент, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		Массив = Новый Массив;
		Массив.Добавить(ТипЗнч(мОбъектСсылка));
		Элемент.ОграничениеТипа = Новый ОписаниеТипов(Массив);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура мОбъектСсылкаОчистка(Элемент, СтандартнаяОбработка)
	Элемент.ОграничениеТипа = Новый ОписаниеТипов;
КонецПроцедуры
&НаКлиенте
Функция вПроверитьРегистратора()
	Если Не ЗначениеЗаполнено(мОбъектСсылка) Тогда
		вПоказатьПредупреждение("Не задан объект для записи движений!");
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура _ОткрытьВНовомОкне(Команда)
	СтрукПарам = Новый Структура("ПутьКФормам, мОбъектСсылка, ОписаниеРазработки", ПутьКФормам, мОбъектСсылка,
		_ОписаниеРазработки);
	ОткрытьФорму("Обработка.УИ_РедакторРеквизитовОбъекта.Форма.ФормаРедакторДвижений", СтрукПарам, , ТекущаяДата(), , , ,
		РежимОткрытияОкнаФормы.Независимый);
КонецПроцедуры

&НаКлиенте
Процедура _Обновить(Команда)
	мТекСтрокаТаблицыРегистров = Неопределено;
	мТекСтрокаТаблицыРегистровСтарая = Неопределено;

	вОчиститьНаборыЗаписей();

	вОбновить();

	Элементы.ГруппаРегистры.Заголовок = "Движения документа (" + _ТабРегистры.Количество() + ")";
КонецПроцедуры

&НаКлиенте
Процедура _Записать(Команда)
	Если Не вПроверитьРегистратора() Тогда
		Возврат;
	КонецЕсли;

	Значение = _ТабРегистры.НайтиСтроки(Новый Структура("Записать", Истина)).Количество();
	Если Значение = 0 Тогда
		вПоказатьПредупреждение("Не отмечены регистры для записи.");
		Возврат;
	КонецЕсли;

	вПоказатьВопрос("_ЗаписатьДалее", СтрШаблон("Отмеченные регистры (%1 шт) будут записаны в базу. Продолжить?",
		Значение));
КонецПроцедуры

&НаКлиенте
Процедура _ЗаписатьДалее(РезультатВопроса, ДопПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		вЗаписать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _СортироватьРегистрыСтандартно(Команда)
	_ТабРегистры.Сортировать("Изменен УБЫВ, Записать УБЫВ, ЧислоЗаписей УБЫВ, ПолноеИмя");
КонецПроцедуры

&НаКлиенте
Процедура _СнятьФлажки(Команда)
	Для Каждого Стр Из _ТабРегистры.НайтиСтроки(Новый Структура("Записать", Истина)) Цикл
		Стр.Записать = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура _УстановитьФлажки(Команда)
	Для Каждого Стр Из _ТабРегистры.НайтиСтроки(Новый Структура("Записать", Ложь)) Цикл
		Стр.Записать = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура _УстановитьФлажкиДляИзмененных(Команда)
	Для Каждого Стр Из _ТабРегистры.НайтиСтроки(Новый Структура("Записать, Изменен", Ложь, Истина)) Цикл
		Стр.Записать = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура _ОчиститьДвижения(Команда)
	Если Не вПроверитьРегистратора() Тогда
		Возврат;
	КонецЕсли;

	Значение = Элементы._ТабРегистры.ВыделенныеСтроки;
	Если Значение.Количество() = 0 Тогда
		вПоказатьПредупреждение("Не отмечены регистры для очистки.");
		Возврат;
	КонецЕсли;

	вПоказатьВопрос("_ОчиститьДвиженияДалее", СтрШаблон("Выбранные регистры (%1 шт) будут очищены. Продолжить?",
		Значение.Количество()));
КонецПроцедуры

&НаКлиенте
Процедура _ОчиститьДвиженияДалее(РезультатВопроса, ДопПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыделенныеСтроки = Элементы._ТабРегистры.ВыделенныеСтроки;
		Для Каждого Элем Из ВыделенныеСтроки Цикл
			СтрДанные = _ТабРегистры.НайтиПоИдентификатору(Элем);
			Если СтрДанные <> Неопределено Тогда
				ИмяРеквизита = вПолучитьИмяРеквизита(СтрДанные.ПолноеИмя);

				Попытка
					ТабДанные = ЭтаФорма[ИмяРеквизита];
					Если ТабДанные.Количество() <> 0 Тогда
						ТабДанные.Очистить();
						СтрДанные.Записать = Истина;
						СтрДанные.Изменен = Истина;
						СтрДанные.ЕстьЗаписи = Ложь;
						СтрДанные.ЧислоЗаписей = 0;
					КонецЕсли;
				Исключение
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура _ОбновитьНабор(Команда)
	ТекДанные = Элементы._ТабРегистры.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ИмяРеквизита = вПолучитьИмяРеквизита(ТекДанные.ПолноеИмя);

		Если _БыстрыйВызовСервера Тогда
			Массив = вПрочитатьНаборЗаписейВКоллекцию(мОбъектСсылка, ТекДанные.ВидРегистра, ТекДанные.Имя);

			Коллекция = ЭтаФорма[ИмяРеквизита];
			Коллекция.Очистить();

			Для Каждого Элем Из Массив Цикл
				ЗаполнитьЗначенияСвойств(Коллекция.Добавить(), Элем);
			КонецЦикла;
		Иначе
			вОбновитьНаборЗаписей(ТекДанные.ВидРегистра, ТекДанные.Имя);
		КонецЕсли;

		ТекДанные.Изменен = Ложь;
		ТекДанные.Записать = Ложь;
		ТекДанные.ЧислоЗаписей = ЭтаФорма[ИмяРеквизита].Количество();
		ТекДанные.ЕстьЗаписи = (ТекДанные.ЧислоЗаписей <> 0);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ЗаписатьНабор(Команда)
	Если Не вПроверитьРегистратора() Тогда
		Возврат;
	КонецЕсли;

	ТекДанные = Элементы._ТабРегистры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		вПоказатьПредупреждение("Не задан набор записей для сохранения");
		Возврат;
	КонецЕсли;
	вПоказатьВопрос("_ЗаписатьНаборДалее", "Набор записей будет записан в базу. Продолжить?");
КонецПроцедуры

&НаКлиенте
Процедура _ЗаписатьНаборДалее(РезультатВопроса, ДопПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ТекДанные = Элементы._ТабРегистры.ТекущиеДанные;
		Если ТекДанные <> Неопределено Тогда
			Если вЗаписатьНаборЗаписей(ТекДанные.ВидРегистра, ТекДанные.Имя) Тогда
				_ОбновитьНабор(Неопределено);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ПереключитьАктивностьЗаписей(Команда)
	ТекДанные = Элементы._ТабРегистры.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ИмяРеквизита = вПолучитьИмяРеквизита(ТекДанные.ПолноеИмя);
		Если ЭтаФорма[ИмяРеквизита].Количество() <> 0 Тогда

			Для Каждого Стр Из ЭтаФорма[ИмяРеквизита] Цикл
				Стр.Активность = Не Стр.Активность;
			КонецЦикла;

			НаборЗаписейПриИзменении(Элементы[ИмяРеквизита]);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ОткрытьОбъект(Команда)
	ТекДанные = Элементы._ТабРегистры.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ИмяРеквизита = вПолучитьИмяРеквизита(ТекДанные.ПолноеИмя);
		ТекТаб = ЭтаФорма[ИмяРеквизита];

		Если ТекТаб.Количество() > 0 Тогда
			ТекТабЭФ = Элементы[ИмяРеквизита];
			ТекПолеЭФ = ТекТабЭФ.ТекущийЭлемент;

			пПоле = Сред(ТекПолеЭФ.Имя, СтрДлина(ИмяРеквизита) + 2);
			Значение = ТекТабЭФ.ТекущиеДанные[пПоле];

			Если ЗначениеЗаполнено(Значение) Тогда

				Если ТипЗнч(Значение) = Тип("ХранилищеЗначения") Тогда
					вПоказатьЗначениеХЗ(Значение);

				ИначеЕсли вЭтоОбъектМетаданных(ТипЗнч(Значение)) Тогда
					УИ_ОбщегоНазначенияКлиент.РедактироватьОбъект(Значение);

				КонецЕсли;

			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ПоказатьТипЗначения(Команда)
	_ТипЗначенияТекущегоПоля = "";

	Значение = Неопределено;

	ТекДанные = Элементы._ТабРегистры.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ИмяРеквизита = вПолучитьИмяРеквизита(ТекДанные.ПолноеИмя);
		ТекТаб = ЭтаФорма[ИмяРеквизита];

		Если ТекТаб.Количество() > 0 Тогда
			ТекТабЭФ = Элементы[ИмяРеквизита];
			ТекПолеЭФ = ТекТабЭФ.ТекущийЭлемент;

			пПоле = Сред(ТекПолеЭФ.Имя, СтрДлина(ИмяРеквизита) + 2);
			Значение = ТекТабЭФ.ТекущиеДанные[пПоле];

		КонецЕсли;
	КонецЕсли;

	Если Значение = Неопределено Тогда
		ИмяТипа = "Неопределено";
	Иначе
		ИмяТипа = вСформироватьИмяТипаПоЗначению(Значение);
	КонецЕсли;

	_ТипЗначенияТекущегоПоля = ИмяТипа;
КонецПроцедуры

&НаКлиенте
Процедура вПоказатьЗначениеХЗ(Значение)
	СтрукПарам = Новый Структура("ПутьКФормам, ДанныеХЗ", ПутьКФормам, Значение);
	ОткрытьФорму("ОбщаяФорма.УИ_ФормаХранилищаЗначения", СтрукПарам, , ТекущаяДата());
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
Функция вПолучитьИмяРеквизита(Знач ПолноеИмя)
	Возврат СтрЗаменить(ПолноеИмя, ".", "_");
КонецФункции

&НаКлиенте
Процедура вОчиститьНаборыЗаписей()
	Для Каждого Стр Из _ТабРегистры.НайтиСтроки(Новый Структура("ЕстьРеквизитФормы", Истина)) Цикл
		ИмяРеквизита = вПолучитьИмяРеквизита(Стр.ПолноеИмя);
		ЭтаФорма[ИмяРеквизита].Очистить();
		Стр.ЕстьЗаписи = Ложь;
		Стр.ЧислоЗаписей = 0;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура вУдалитьРеквизитыНаборовЗаписей()
	МассивКСозданию = Новый Массив;
	МассивКУдалению = Новый Массив;

	Для Каждого Стр Из _ТабРегистры.НайтиСтроки(Новый Структура("ЕстьРеквизитФормы", Истина)) Цикл
		ИмяРеквизита = вПолучитьИмяРеквизита(Стр.ПолноеИмя);

		Если вПроверитьНаличиеРеквизита(ИмяРеквизита) Тогда
			МассивКУдалению.Добавить(ИмяРеквизита);
		КонецЕсли;
		Стр.ЕстьРеквизитФормы = Ложь;

		ЭФ = Элементы.Найти("Стр_" + ИмяРеквизита);
		Если ЭФ <> Неопределено Тогда
			Элементы.Удалить(ЭФ);
		КонецЕсли;
	КонецЦикла;

	ИзменитьРеквизиты(МассивКСозданию, МассивКУдалению);
КонецПроцедуры

&НаСервереБезКонтекста
Функция вЭтоОбъектМетаданных(Знач Тип)
	ОбъектМД = Метаданные.НайтиПоТипу(Тип);
	Возврат (ОбъектМД <> Неопределено И Не Метаданные.Перечисления.Содержит(ОбъектМД));
КонецФункции

&НаСервереБезКонтекста
Функция вСформироватьИмяТипаПоЗначению(Знач Значение)
	пТип = ТипЗнч(Значение);

	ОбъектМД = Метаданные.НайтиПоТипу(пТип);
	Если ОбъектМД <> Неопределено Тогда
		ИмяТипа = ОбъектМД.ПолноеИмя();
	Иначе
		ИмяТипа = Строка(пТип);
	КонецЕсли;

	Возврат ИмяТипа;
КонецФункции

&НаСервереБезКонтекста
Функция вПрочитатьНаборЗаписей(Регистратор, ВидРегистра, ИмяРегистра)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументРегистратор", Регистратор);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	т.*
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПланОплат КАК т
	|ГДЕ
	|	т.ДокументРегистратор = &ДокументРегистратор";

	Запрос.Текст = СтрЗаменить(Запрос.Текст, "РегистрНакопления.РасчетыСКлиентамиПланОплат", ВидРегистра + "."
		+ ИмяРегистра);

	ТабРезультат = Запрос.Выполнить().Выгрузить();

	Возврат ТабРезультат;
КонецФункции

&НаСервереБезКонтекста
Функция вСоздатьНаборЗаписей(Регистратор, ВидРегистра, ИмяРегистра)
	Если ВидРегистра = "РегистрСведений" Тогда
		Менеджер = РегистрыСведений[ИмяРегистра];
	ИначеЕсли ВидРегистра = "РегистрНакопления" Тогда
		Менеджер = РегистрыНакопления[ИмяРегистра];
	ИначеЕсли ВидРегистра = "РегистрРасчета" Тогда
		Менеджер = РегистрыРасчета[ИмяРегистра];
	ИначеЕсли ВидРегистра = "РегистрБухгалтерии" Тогда
		Менеджер = РегистрыБухгалтерии[ИмяРегистра];
	Иначе
		Менеджер = Неопределено;
	КонецЕсли;

	Набор = Менеджер.СоздатьНаборЗаписей();
	Набор.Отбор.Регистратор.Установить(Регистратор);

	Возврат Набор;
КонецФункции

&НаСервереБезКонтекста
Функция вПрочитатьНаборЗаписейВКоллекцию(Знач Регистратор, Знач ВидРегистра, Знач ИмяРегистра)
	ТабРезультат = вПрочитатьНаборЗаписей(Регистратор, ВидРегистра, ИмяРегистра);

	Струк = Новый Структура;

	Для Каждого Элем Из ТабРезультат.Колонки Цикл
		Струк.Вставить(Элем.Имя);
	КонецЦикла;

	Массив = Новый Массив;

	Для Каждого Стр Из ТабРезультат Цикл
		НС = Новый Структура;
		Для Каждого Элем Из Струк Цикл
			НС.Вставить(Элем.Ключ);
		КонецЦикла;

		ЗаполнитьЗначенияСвойств(НС, Стр);
		Массив.Добавить(НС);
	КонецЦикла;

	Возврат Массив;
КонецФункции

&НаСервере
Процедура вОбновитьНаборЗаписей(Знач ВидРегистра, Знач ИмяРегистра)
	ТабРезультат = вПрочитатьНаборЗаписей(мОбъектСсылка, ВидРегистра, ИмяРегистра);
	ЗначениеВРеквизитФормы(ТабРезультат, вПолучитьИмяРеквизита(ВидРегистра + "." + ИмяРегистра));
КонецПроцедуры

&НаСервере
Функция вЗаписатьНаборЗаписей(Знач ВидРегистра, Знач ИмяРегистра)
	пПолноеИмя = ВидРегистра + "." + ИмяРегистра;
	пИмяРеквизита = вПолучитьИмяРеквизита(пПолноеИмя);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", мОбъектСсылка);

	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
				   |	т.Дата КАК Дата
				   |ИЗ
				   |	" + _ПолноеИмяДокумента + " КАК т
												  |ГДЕ
												  |	т.Ссылка = &Ссылка";

	Выборка = Запрос.Выполнить().Выбрать();
	пПериод = ?(Выборка.Следующий(), Выборка.Дата, Неопределено);
	Если пПериод = Неопределено Тогда
		Сообщить("Не найден указанный документ!");
		Возврат Ложь;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументРегистратор", мОбъектСсылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	т.*
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПланОплат КАК т
	|ГДЕ
	|	т.ДокументРегистратор = &ДокументРегистратор";

	Запрос.Текст = СтрЗаменить(Запрос.Текст, "РегистрНакопления.РасчетыСКлиентамиПланОплат", пПолноеИмя);

	ТабЗаписиА = Запрос.Выполнить().Выгрузить();
	ТабРегистраторыА = ТабЗаписиА.Скопировать( , "Регистратор");
	ТабРегистраторыА.Свернуть("Регистратор");
	ТабЗаписиА.Индексы.Добавить("Регистратор");

	ТабЗаписиБ = РеквизитФормыВЗначение(пИмяРеквизита);
	ТабРегистраторыБ = ТабЗаписиБ.Скопировать( , "Регистратор");
	ТабРегистраторыБ.Свернуть("Регистратор");
	ТабЗаписиБ.Индексы.Добавить("Регистратор");

	ТабРегистраторыБ.Колонки.Добавить("Обработан", Новый ОписаниеТипов("Булево"));
	ТабРегистраторыБ.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));

	НачатьТранзакцию();

	Для Каждого СтрА Из ТабРегистраторыА Цикл
		Набор = вСоздатьНаборЗаписей(СтрА.Регистратор, ВидРегистра, ИмяРегистра);

		Набор.Прочитать();
		ТабНабор = Набор.Выгрузить();
		ТабНабор.Индексы.Добавить("ДокументРегистратор");

		Для Каждого Стр Из ТабНабор.НайтиСтроки(Новый Структура("ДокументРегистратор", мОбъектСсылка)) Цикл
			ТабНабор.Удалить(Стр);
		КонецЦикла;

		Для Каждого СтрБ Из ТабЗаписиБ.НайтиСтроки(Новый Структура("Регистратор", СтрА.Регистратор)) Цикл
			НС = ТабНабор.Добавить();
			ЗаполнитьЗначенияСвойств(НС, СтрБ);
			НС.Регистратор = СтрА.Регистратор;
			НС.ДокументРегистратор = мОбъектСсылка;
			НС.Период = пПериод;
		КонецЦикла;

		Набор.Загрузить(ТабНабор);

		СтрБ = ТабРегистраторыБ.Найти(СтрА.Регистратор, "Регистратор");
		Если СтрБ <> Неопределено Тогда
			СтрБ.Обработан = Истина;
		КонецЕсли;

		Попытка
			Если _ЗаписьВРежимеЗагрузки Тогда
				Набор.ОбменДанными.Загрузка = Истина;
			КонецЕсли;
			Набор.Записать();
		Исключение
			Сообщить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОтменитьТранзакцию();

			Возврат Ложь;
		КонецПопытки;
	КонецЦикла;

	Для Каждого СтрА Из ТабРегистраторыБ.НайтиСтроки(Новый Структура("Обработан", Ложь)) Цикл
		Набор = вСоздатьНаборЗаписей(СтрА.Регистратор, ВидРегистра, ИмяРегистра);

		Набор.Прочитать();
		ТабНабор = Набор.Выгрузить();

		Для Каждого СтрБ Из ТабЗаписиБ.НайтиСтроки(Новый Структура("Регистратор", СтрА.Регистратор)) Цикл
			НС = ТабНабор.Добавить();
			ЗаполнитьЗначенияСвойств(НС, СтрБ);
			НС.Регистратор = СтрА.Регистратор;
			НС.ДокументРегистратор = мОбъектСсылка;
			НС.Период = пПериод;
		КонецЦикла;

		Набор.Загрузить(ТабНабор);

		Попытка
			Если _ЗаписьВРежимеЗагрузки Тогда
				Набор.ОбменДанными.Загрузка = Истина;
			КонецЕсли;
			Набор.Записать();
		Исключение
			Сообщить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОтменитьТранзакцию();

			Возврат Ложь;
		КонецПопытки;
	КонецЦикла;

	ЗафиксироватьТранзакцию();

	Возврат Истина;
КонецФункции

&НаСервере
Функция вЗаписать()
	НайденныеСтроки = _ТабРегистры.НайтиСтроки(Новый Структура("Записать", Истина));
	пЕстьТранзакция = (НайденныеСтроки.Количество() > 1);

	Если пЕстьТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;

	Для Каждого Стр Из НайденныеСтроки Цикл
		Если Не вЗаписатьНаборЗаписей(Стр.ВидРегистра, Стр.Имя) Тогда
			Если пЕстьТранзакция Тогда
				ОтменитьТранзакцию();
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Если пЕстьТранзакция Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;

	Для Каждого Стр Из НайденныеСтроки Цикл
		ИмяРеквизита = вПолучитьИмяРеквизита(Стр.ПолноеИмя);

		вОбновитьНаборЗаписей(Стр.ВидРегистра, Стр.Имя);

		Стр.Изменен = Ложь;
		Стр.Записать = Ложь;
		Стр.ЧислоЗаписей = ЭтаФорма[ИмяРеквизита].Количество();
		Стр.ЕстьЗаписи = (Стр.ЧислоЗаписей <> 0);
	КонецЦикла;

	Возврат Истина;
КонецФункции
&НаСервере
Процедура вСоздатьРеквизитыНаборовЗаписей(НадоСоздаватьРеквизиты = Истина)
	ТипХЗ = Тип("ХранилищеЗначения");
	ТипТТ = Тип("Тип");
	ТипМВ = Тип("МоментВремени");

	СоотвДанные = Новый Соответствие;

	МассивКСозданию = Новый Массив;
	МассивКУдалению = Новый Массив;

	Для Каждого Стр Из _ТабРегистры Цикл
		Стр.ЕстьРеквизитФормы = Истина;

		ИмяРеквизита = вПолучитьИмяРеквизита(Стр.ПолноеИмя);

		Если НадоСоздаватьРеквизиты Тогда
			МассивКСозданию.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("ТаблицаЗначений"), ,
				Стр.ПолноеИмя, Ложь));
		КонецЕсли;

		ТабРезультат = вПрочитатьНаборЗаписей(мОбъектСсылка, Стр.ВидРегистра, Стр.Имя);
		СоотвДанные.Вставить(ИмяРеквизита, ТабРезультат);

		Стр.ЧислоЗаписей = ТабРезультат.Количество();
		Стр.ЕстьЗаписи = (Стр.ЧислоЗаписей <> 0);
		Стр.Изменен = Ложь;
		Стр.Записать = Ложь;

		Если НадоСоздаватьРеквизиты Тогда
			Для Каждого Колонка Из ТабРезультат.Колонки Цикл
				Если Колонка.ТипЗначения.СодержитТип(ТипХЗ) Тогда
					ТипЗначенияРеквизита = Новый ОписаниеТипов;
				ИначеЕсли Колонка.ТипЗначения.СодержитТип(ТипТТ) Тогда
					ТипЗначенияРеквизита = Новый ОписаниеТипов;
				ИначеЕсли Колонка.ТипЗначения.СодержитТип(ТипМВ) Тогда
					ТипЗначенияРеквизита = Новый ОписаниеТипов;
				Иначе
					ТипЗначенияРеквизита = Колонка.ТипЗначения;
				КонецЕсли;
				МассивКСозданию.Добавить(Новый РеквизитФормы(Колонка.Имя, ТипЗначенияРеквизита, ИмяРеквизита,
					Колонка.Заголовок, Ложь));
			КонецЦикла;
		КонецЕсли;

	КонецЦикла;

	Если НадоСоздаватьРеквизиты Тогда
		ИзменитьРеквизиты(МассивКСозданию, МассивКУдалению);
	КонецЕсли;

	_ТабРегистры.Сортировать("Изменен УБЫВ, ЧислоЗаписей УБЫВ, ПолноеИмя");
	
	// создание элементов формы
	//СтрукСпецКолонки = новый Структура("Регистратор, МоментВремени");
	СтрукСпецКолонки = Новый Структура("НомерСтроки, МоментВремени, ДокументРегистратор");

	Для Каждого Элем Из СоотвДанные Цикл
		ТабРезультат = Элем.Значение;
		ИмяРеквизита = СтрЗаменить(Элем.Ключ, ".", "_");

		ЗначениеВРеквизитФормы(Элем.Значение, Элем.Ключ);

		Если Не НадоСоздаватьРеквизиты Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтраница = Элементы.Добавить("Стр_" + ИмяРеквизита, Тип("ГруппаФормы"), Элементы.СтраницыНаборыЗаписей);
		НоваяСтраница.Вид = ВидГруппыФормы.Страница;
		НоваяСтраница.Заголовок = "";
		НоваяСтраница.Видимость = Истина;

		ЭлемТЗ = ЭтаФорма.Элементы.Добавить(ИмяРеквизита, Тип("ТаблицаФормы"), НоваяСтраница);
		ЭлемТЗ.ПутьКДанным = ИмяРеквизита;
		ЭлемТЗ.УстановитьДействие("ПриИзменении", "НаборЗаписейПриИзменении");

		Элем = ЭтаФорма.Элементы.Добавить("_" + ИмяРеквизита + "_ПереключитьАктивностьЗаписей", Тип("КнопкаФормы"),
			ЭлемТЗ.КоманднаяПанель);
		Элем.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
		Элем.ИмяКоманды = "_ПереключитьАктивностьЗаписей";
		Элем.Видимость = Ложь;

		Элем = ЭтаФорма.Элементы.Добавить("_" + ИмяРеквизита + "_ОткрытьОбъект", Тип("КнопкаФормы"),
			ЭлемТЗ.КоманднаяПанель);
		Элем.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
		Элем.ИмяКоманды = "_ОткрытьОбъект";

		Элем = ЭтаФорма.Элементы.Добавить("_" + ИмяРеквизита + "_ОбновитьНабор", Тип("КнопкаФормы"),
			ЭлемТЗ.КоманднаяПанель);
		Элем.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
		Элем.ИмяКоманды = "_ОбновитьНабор";

		Элем = ЭтаФорма.Элементы.Добавить("_" + ИмяРеквизита + "_ЗаписатьНабор", Тип("КнопкаФормы"),
			ЭлемТЗ.КоманднаяПанель);
		Элем.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
		Элем.ИмяКоманды = "_ЗаписатьНабор";

		Для Каждого Колонка Из ТабРезультат.Колонки Цикл
			Если СтрукСпецКолонки.Свойство(Колонка.Имя) Тогда
				Продолжить;
			КонецЕсли;

			Элем = ЭтаФорма.Элементы.Добавить(ИмяРеквизита + "_" + Колонка.Имя, Тип("ПолеФормы"), ЭлемТЗ);
			Элем.ПутьКДанным = ИмяРеквизита + "." + Колонка.Имя;
			Элем.Вид = ВидПоляФормы.ПолеВвода;
			Элем.ДоступныеТипы = Колонка.ТипЗначения;

			Если Колонка.ТипЗначения.СодержитТип(ТипХЗ) Тогда // версия 033
				Элем.ТолькоПросмотр = Истина;
			КонецЕсли;

			Если Колонка.Имя = "Активность" Тогда
				Элем.ТолькоПросмотр = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция вПроверитьНаличиеРеквизита(ИмяРеквизита)
	Струк = Новый Структура(ИмяРеквизита);
	ЗаполнитьЗначенияСвойств(Струк, ЭтаФорма);

	Возврат (Струк[ИмяРеквизита] <> Неопределено);
КонецФункции

&НаСервере
Процедура вОбновить()
	НадоСоздаватьРеквизиты = (ТипЗнч(мОбъектСсылка) <> ТипЗнч(мОбъектСсылкаПредыдущий));

	мОбъектСсылкаПредыдущий = мОбъектСсылка;

	Если НадоСоздаватьРеквизиты Тогда
		вУдалитьРеквизитыНаборовЗаписей();

		_ТабРегистры.Очистить();

		мТекСтрокаТаблицыРегистров = Неопределено;

		Если мОбъектСсылка <> Неопределено Тогда
			ОбъектМД = мОбъектСсылка.Метаданные();
			_ПолноеИмяДокумента = ОбъектМД.ПолноеИмя();

			пСтрук = вОпределитьДополнительныеРегистрыДокумента(_ПолноеИмяДокумента);
			Если пСтрук.ЕстьДанные Тогда
				Для Каждого Элем Из пСтрук.ДополнительныеРегистры Цикл
					НС = _ТабРегистры.Добавить();
					НС.Имя = Сред(Элем.Ключ, СтрНайти(Элем.Ключ, ".") + 1);
					НС.Представление = Элем.Значение;
					НС.ПолноеИмя = Элем.Ключ;
					НС.ВидРегистра = Лев(НС.ПолноеИмя, СтрНайти(НС.ПолноеИмя, ".") - 1);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		_ТабРегистры.Сортировать("ПолноеИмя");
	КонецЕсли;

	вСоздатьРеквизитыНаборовЗаписей(НадоСоздаватьРеквизиты);
КонецПроцедуры
&НаКлиенте
Процедура НаборЗаписейПриИзменении(Элемент)
	ТекДанные = Элементы._ТабРегистры.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ТекДанные.Изменен = Истина;
		ТекДанные.Записать = Истина;
		ТекДанные.ЧислоЗаписей = ЭтаФорма[Элемент.Имя].Количество();
		ТекДанные.ЕстьЗаписи = (ТекДанные.ЧислоЗаписей <> 0);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ТабРегистрыПриАктивизацииСтроки(Элемент)
	ТекСтрока = Элемент.ТекущаяСтрока;
	Если ТекСтрока <> мТекСтрокаТаблицыРегистров Тогда
		мТекСтрокаТаблицыРегистровСтарая = мТекСтрокаТаблицыРегистров;
		мТекСтрокаТаблицыРегистров = ТекСтрока;
		ПодключитьОбработчикОжидания("вПриАктивизацииСтрокиТаблицыРегистров", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура вПриАктивизацииСтрокиТаблицыРегистров() Экспорт
	Если мТекСтрокаТаблицыРегистровСтарая <> Неопределено Тогда
		ТекДанные = _ТабРегистры.НайтиПоИдентификатору(мТекСтрокаТаблицыРегистровСтарая);
		Если ТекДанные <> Неопределено Тогда
			ИмяРеквизита = вПолучитьИмяРеквизита(ТекДанные.ПолноеИмя);
		КонецЕсли;
	КонецЕсли;

	ТекДанные = Неопределено;
	Если мТекСтрокаТаблицыРегистров <> Неопределено Тогда
		ТекДанные = _ТабРегистры.НайтиПоИдентификатору(мТекСтрокаТаблицыРегистров);
		Если ТекДанные <> Неопределено Тогда
			ИмяРеквизита = вПолучитьИмяРеквизита(ТекДанные.ПолноеИмя);
			Элементы.СтраницыНаборыЗаписей.ТекущаяСтраница = Элементы["Стр_" + ИмяРеквизита];
		КонецЕсли;
	КонецЕсли;

	Если ТекДанные = Неопределено Тогда
		Элементы.СтраницыНаборыЗаписей.ТекущаяСтраница = Элементы.СтрПример;
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура _ЗаполнитьДанныеТекущейКолонки(Команда)
	ТекДанные = Элементы._ТабРегистры.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ИмяРеквизита = вПолучитьИмяРеквизита(ТекДанные.ПолноеИмя);
		ТекТаб = ЭтаФорма[ИмяРеквизита];

		Если ТекТаб.Количество() > 0 Тогда
			ТекДанные.Записать = Истина;
			ТекДанные.Изменен = Истина;

			ТекТабЭФ = Элементы[ИмяРеквизита];
			ТекПолеЭФ = ТекТабЭФ.ТекущийЭлемент;

			пПоле = Сред(ТекПолеЭФ.Имя, СтрДлина(ИмяРеквизита) + 2);

			Если _ПриЗаполненииОбрабатыватьТолькоВыделенныеСтроки Тогда
				Для Каждого Элем Из ТекТабЭФ.ВыделенныеСтроки Цикл
					Стр = ТекТаб.НайтиПоИдентификатору(Элем);
					Стр[пПоле] = _ЗначениеДляЗаполнения;
				КонецЦикла;
			Иначе
				Для Каждого Стр Из ТекТаб Цикл
					Стр[пПоле] = _ЗначениеДляЗаполнения;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ЗначениеДляЗаполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если _ЗначениеДляЗаполнения = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		СтрукПарам = Новый Структура("ЗакрыватьПриЗакрытииВладельца, ТипыДляЗаполненияЗначений", Истина, Истина);
		ОткрытьФорму("ОбщаяФорма.УИ_ФормаВыбораТипаОбъекта", СтрукПарам, Элемент, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ТипЗнч(_ЗначениеДляЗаполнения) = Тип("УникальныйИдентификатор") Тогда
		СтандартнаяОбработка = Ложь;
	Иначе
		Массив = Новый Массив;
		Массив.Добавить(ТипЗнч(_ЗначениеДляЗаполнения));
		Элемент.ОграничениеТипа = Новый ОписаниеТипов(Массив);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ЗначениеДляЗаполненияОчистка(Элемент, СтандартнаяОбработка)
	Элемент.ОграничениеТипа = Новый ОписаниеТипов;
КонецПроцедуры
&НаСервереБезКонтекста
Функция вОпределитьДополнительныеРегистрыДокумента(Знач пПолноеИмяДокумента)
	пСоотв = Новый Соответствие;

	пСтрук = Новый Структура;
	пСтрук.Вставить("ЕстьДанные", Ложь);
	пСтрук.Вставить("ДополнительныеРегистры", пСоотв);

	пРегистраторМД = Метаданные.Документы.Найти("РегистраторРасчетов");
	Если пРегистраторМД = Неопределено Тогда
		Возврат пСтрук;
	КонецЕсли;

	Если ТипЗнч(пПолноеИмяДокумента) <> Тип("Строка") Тогда
		пПолноеИмяДокумента = пПолноеИмяДокумента.Метаданные().ПолноеИмя();
		Если СтрНайти(пПолноеИмяДокумента, "Документ.") <> 1 Тогда
			Возврат пСтрук;
		КонецЕсли;
	КонецЕсли;

	Для Каждого ЭлемМД Из пРегистраторМД.Движения Цикл
		пРеквизитМД = ЭлемМД.Реквизиты.Найти("ДокументРегистратор");
		Если пРеквизитМД <> Неопределено Тогда
			пИмяРегистра = ЭлемМД.ПолноеИмя();

			Для Каждого пТип Из пРеквизитМД.Тип.Типы() Цикл
				пДокМД = Метаданные.НайтиПоТипу(пТип);

				Если пДокМД <> Неопределено Тогда
					пИмяДокумента = пДокМД.ПолноеИмя();

					Если пИмяДокумента = пПолноеИмяДокумента И пИмяДокумента <> "Документ.РегистраторРасчетов" Тогда
						пСоотв[пИмяРегистра] = ЭлемМД.Представление();
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

	пСтрук.ЕстьДанные = (пСоотв.Количество() <> 0);

	Возврат пСтрук;
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

КонецПроцедуры
