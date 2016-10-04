﻿#encoding: utf-8
#language: ru

@tree
Функционал: Прием товаров
	Как Оператор
	Я хочу специальный документ
	Чтобы оформлять поступление товаров
	
Контекст:
	Дано Начальный остаток яблок = 0
	И Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: 
	Допустим поступило 100 яблок
		Когда В панели разделов я выбираю "Закупки"
		И     Я нажимаю кнопку командного интерфейса "Покупка"
		Тогда открылось окно "Покупка"
		И     я нажимаю на кнопку "Создать"
		Тогда открылось окно "Покупка (создание)"
		И     в ТЧ "Товары" я нажимаю на кнопку "Добавить"
		И     в ТЧ "Товары" в поле "Номенклатура" я ввожу текст "яблоко"
		И     в ТЧ "Товары" из выпадающего списка "Номенклатура" я выбираю "Яблоко (000000001)"
		И     я перехожу к следующему реквизиту
		И     в ТЧ "Товары" я активизирую поле "Количество"
		И     в ТЧ "Товары" в поле "Количество" я ввожу текст "100,000"
		И     я перехожу к следующему реквизиту
		И     в ТЧ "Товары" я активизирую поле "Цена"
		И     В форме "Покупка (создание)" в ТЧ "Товары" я завершаю редактирование строки
		И     я нажимаю на кнопку "Провести и закрыть" 
	Тогда остаток яблок на складе, после проведения документа, должен быть 100
	
