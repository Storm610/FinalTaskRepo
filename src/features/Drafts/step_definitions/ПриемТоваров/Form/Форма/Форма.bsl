﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-Behavior
Перем Ванесса;
 
&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;
 
&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-Behavior.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	
	ВсеТесты = Новый Массив;

	//описание параметров
	//Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ПоступилоЯблок(Парам01)","ПоступилоЯблок","Допустим поступило 100 яблок");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ОстатокЯблокНаСкладеПослеПроведенияДокументаДолженБыть(Парам01)","ОстатокЯблокНаСкладеПослеПроведенияДокументаДолженБыть","Тогда остаток яблок на складе, после проведения документа, должен быть 100");

	Возврат ВсеТесты;
КонецФункции
	
&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции
	
&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции



///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт
	
КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт
	
КонецПроцедуры



///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Допустим поступило 100 яблок
//@ПоступилоЯблок(Парам01)
Процедура ПоступилоЯблок(КоличествоПоступления) Экспорт
	//Ванесса.ПосмотретьЗначение(КоличествоПоступления);
	
	СоздатьДокументПоступления(КоличествоПоступления);
	
КонецПроцедуры

&НаКлиенте
//Тогда остаток яблок на складе, после проведения документа, должен быть 100
//@ОстатокЯблокНаСкладеПослеПроведенияДокументаДолженБыть(Парам01)
Процедура ОстатокЯблокНаСкладеПослеПроведенияДокументаДолженБыть(КонечныйОстаток) Экспорт
	//Ванесса.ПосмотретьЗначение(КонечныйОстаток,Истина);
	Если НЕ ОстатокВерный(КонечныйОстаток) Тогда
		ВызватьИсключение "Неверный остаток";
	КонецЕсли;
	
КонецПроцедуры


// Серверные процедуры и функции

&НаСервере
Процедура СоздатьДокументПоступления(КоличествоПоступления);
	
	ДокПоступление = Документы.Покупка.СоздатьДокумент();
	ДокПоступление.Дата = ТекущаяДата();
	СтрокаТЧ = ДокПоступление.Товары.Добавить();
	СтрокаТЧ.Номенклатура = ПолучитьНоменклатуру();
	СтрокаТЧ.Количество = КоличествоПоступления;
	ДокПоступление.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры
	
&НаСервере
Функция ПолучитьНоменклатуру()
	
	Возврат Справочники.Номенклатура.НайтиПоНаименованию("Яблоко");
	
КонецФункции

&НаСервере
Функция ОстатокВерный(КонечныйОстаток)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТоварыНаСкладахОстатки.Номенклатура,
		|	ТоварыНаСкладахОстатки.КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах.Остатки(&Дата, ) КАК ТоварыНаСкладахОстатки
		|ГДЕ
		|	ТоварыНаСкладахОстатки.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Дата", ТекущаяДата() + 1);
	Запрос.УстановитьПараметр("Номенклатура", Справочники.Номенклатура.НайтиПоНаименованию("Яблоко"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Если ВыборкаДетальныеЗаписи.КоличествоОстаток = КонечныйОстаток Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Иначе	
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

//окончание текста модуля