DECLARE SUB WritePutter ()
DECLARE SUB WriteShoter ()
DECLARE FUNCTION GetYesNo! (mess AS STRING, m!)
DECLARE SUB WriteThrower ()
DECLARE SUB MakeFiles (m!)
DECLARE SUB GetExternData ()
DECLARE SUB PrepareFiles ()
DECLARE FUNCTION GetRetry! ()
DECLARE SUB Greet ()
DECLARE FUNCTION GetData! (inx!)
DECLARE SUB Worm (x!, y!)
DECLARE SUB DrawTheWeapon ()
DECLARE SUB PrepareAll (tp!)
ON ERROR GOTO 10101
CLS
SCREEN 12
WINDOW (0, 0)-(640, 480)
CONST FALSE = 0, TRUE = NOT FALSE
CONST NumOfTemplates = 3
CONST NumOfOptInForm = 5
CONST NumOfSteps = 4
DIM SHARED DB$(n)
REDIM DB$(6)
'1 = type of ammo
'2 = name of ammo
DIM SHARED DB(n)
REDIM DB(10)
'==========================================================
'// Приветствия и всё такое...
Greet
'// Процесс пошёл
GetExternData
PrepareAll 1
PrepareAll 2
MakeFiles 0
PrepareAll 3
MakeFiles 1
DrawTheWeapon
MakeFiles 2
MakeFiles 3

121
i = GetRetry
SELECT CASE i
CASE 1: CLS : PrepareAll 1
'// Удаление старого шаблона
        KILL DB$(5)
'// Регистрация
        MakeFiles 1
'// Создание нового шаблона
        MakeFiles 3

CASE 2: CLS
'// Файлы просто переименовываются. ..., Ватсон!
        oldname1$ = DB$(4)
        oldname2$ = DB$(5)
        oldname3$ = DB$(6)
        PrepareAll 2
        IF LEN(DB$(2)) > 8 THEN WeapName$ = LEFT$(DB$(2), 8) ELSE WeapName$ = DB$(2)
        name$ = "User\Weap_" + RTRIM$(LTRIM$(STR$(DB(2) + 1))): '// Оружие ТО_ЧТО_ЕСТЬ+1 !!!

        name1$ = name$ + "\" + WeapName$ + ".pic"
        DB$(4) = name1$
        NAME oldname1$ AS DB$(4)
        name2$ = name$ + "\" + WeapName$ + ".txt"
        DB$(5) = name2$
        KILL oldname2$
        name3$ = name$ + "\" + WeapName$ + ".dat"
        DB$(6) = name3$
        KILL oldname3$: OPEN DB$(5) FOR OUTPUT AS #1: CLOSE #1
        MakeFiles 1
        MakeFiles 3

CASE 3: CLS : PrepareAll 3: MakeFiles 1
        KILL DB$(5)
'// Перенаписание шаблона
        MakeFiles 3

CASE 4: CLS : DrawTheWeapon: MakeFiles 2
        KILL DB$(5)
'// Перенаписание шаблона
        MakeFiles 3
END SELECT
IF i <> NumOfSteps + 1 THEN 121


10101 RESUME NEXT
CLS
i = GetYesNo("Вернуться к игре?", 2)
IF i = 1 THEN RUN "warlife.bas"
END

SUB DrawTheWeapon
22
CLS
Worm 460, 100
LINE (5, 55)-(635, 475), 10, B
LINE (4, 54)-(636, 476), 2, B
LOCATE 2, 30: COLOR 10: PRINT "Мастер Оружия: ШАГ 4"
LINE (10, 445)-(630, 445), 2
COLOR 11
LOCATE 4, 5: PRINT "Нарисуйте Ваше Оружие на пикселовой карте"
LINE (20, 415)-(380, 415), 9

'// Подготовка карты 24x24
FOR n = 1 TO 25
LINE (99 + (n - 1) * 11, 99)-(99 + (n - 1) * 11, 363), 1
LINE (99, 99 + (n - 1) * 11)-(363, 99 + (n - 1) * 11), 1
NEXT n

'// Подготовка индикатора цвета
LOCATE 10, 50: COLOR 15: PRINT "Цвет:"
LINE (440, 320)-(580, 337), 15, B
LOCATE 10, 61: PRINT "ФОНОВЫЙ"

col = 0
oldc = 0
xp = 12
yp = 12
xs = 510: ys = 100
LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), 15, BF

'// Отслеживаем клаву
DO
A$ = INKEY$
SELECT CASE A$
CASE CHR$(32)
        IF col = 15 THEN col = 0 ELSE col = col + 1
        IF col = 0 THEN
                LINE (441, 321)-(579, 336), 0, BF
                LOCATE 10, 61: PRINT "ФОНОВЫЙ"
        ELSE
                LINE (441, 321)-(579, 336), col, BF
        END IF
CASE CHR$(0) + CHR$(75)
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), oldc, BF
        IF xp > 1 THEN xp = xp - 1 ELSE xp = 24
        oldc = POINT(101 + (xp - 1) * 11 + 3, 101 + (yp - 1) * 11 + 3)
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), 15, BF
CASE CHR$(0) + CHR$(77)
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), oldc, BF
        IF xp > 23 THEN xp = 1 ELSE xp = xp + 1
        oldc = POINT(101 + (xp - 1) * 11 + 3, 101 + (yp - 1) * 11 + 3)
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), 15, BF
CASE CHR$(0) + CHR$(80)
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), oldc, BF
        IF yp > 1 THEN yp = yp - 1 ELSE yp = 24
        oldc = POINT(101 + (xp - 1) * 11 + 3, 101 + (yp - 1) * 11 + 3)
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), 15, BF
CASE CHR$(0) + CHR$(72)
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), oldc, BF
        IF yp > 23 THEN yp = 1 ELSE yp = yp + 1
        oldc = POINT(101 + (xp - 1) * 11 + 3, 101 + (yp - 1) * 11 + 3)
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), 15, BF
CASE CHR$(13)
        '// Дублируем в уменьшенном виде неподалеку от Цевря
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), 0, BF
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), col, BF
        oldc = col
        LINE (101 + (xp - 1) * 11, 101 + (yp - 1) * 11)-(101 + xp * 11 - 4, 101 + yp * 11 - 4), 15, BF
        PSET (xs + xp, ys + yp), col
CASE CHR$(0) + CHR$(79)
        i = GetYesNo("Вы закончили?", 1)
        IF i = 1 THEN 33
CASE CHR$(8)
        i = GetYesNo("Очистить?", 1)
        IF i = 1 THEN 22
END SELECT
LOOP WHILE A$ <> CHR$(27)

33
'// Сохраняем в виде операторов
LOCATE 28, 34: COLOR 4: PRINT "Сохранение..."
MakeFiles 2
END SUB

FUNCTION GetData (inx)
'////////////////////////////////////////////////////////////////////////////
'// Строка высчитывается в зависимости от переданного индекса
s = 5 + 2 * inx
c = 33

DO
A$ = INPUT$(1)
IF A$ = CHR$(13) THEN EXIT DO
IF A$ = CHR$(27) THEN
        LOCATE s, 33: PRINT "          "
        c = 33
        dat = 0
        GOTO 201
END IF
'// Только буквы. И только Lатiнскiе
IF ASC(A$) < 48 OR ASC(A$) > 57 THEN 201
IF c < 42 THEN c = c + 1
IF dat > 999999999 THEN dat = 999999999
LOCATE s, c: PRINT A$: dat = dat * 10 + VAL(A$)
201
LOOP
'////////////////////////////////////////////////////////////////////////////
GetData = dat
END FUNCTION

SUB GetExternData
OPEN "status.dat" FOR INPUT AS #1
INPUT #1, DB(1), DB(2), DB(10)
CLOSE #1
END SUB

FUNCTION GetRetry
'// Запрос на повтор какого-либо этапа
'////////////////////////////////////////////////////////////////////////////
CLS
LINE (5, 55)-(635, 475), 10, B
LINE (4, 54)-(636, 476), 2, B
LOCATE 2, 28: COLOR 10: PRINT "Хотите что-нибудь исправить?"
LINE (10, 445)-(630, 445), 2
COLOR 11
LOCATE 4, 5: PRINT "Выберите шаг, который желаете повторить, или  нажмите " + CHR$(34) + "Далее" + CHR$(34)
LINE (20, 415)-(530, 415), 9
COLOR 15
'// Опять селектор!..
LOCATE 7, 25: PRINT "ШАГ 1: выбор шаблона Оружия"
LOCATE 9, 25: PRINT "ШАГ 2: определение имени Оружия"
LOCATE 11, 25: PRINT "ШАГ 3: анкета Оружия"
LOCATE 13, 25: PRINT "ШАГ 4: рисование Оружия"
LOCATE 15, 25: PRINT "Далее..."

ix = 1
y = 364
LINE (180, y)-(480, y + 25), 14, B
DO
A$ = INKEY$
IF A$ = CHR$(0) + CHR$(72) THEN
IF ix = 1 THEN ix = NumOfSteps + 1 ELSE ix = ix - 1
LINE (180, y)-(480, y + 25), 0, B
y = 364 - (ix - 1) * 32
LINE (180, y)-(480, y + 25), 14, B
ELSEIF A$ = CHR$(0) + CHR$(80) THEN
IF ix = NumOfSteps + 1 THEN ix = 1 ELSE ix = ix + 1
LINE (180, y)-(480, y + 25), 0, B
y = 364 - (ix - 1) * 32
LINE (180, y)-(480, y + 25), 14, B
END IF
LOOP WHILE A$ <> CHR$(13)
'////////////////////////////////////////////////////////////////////////////
GetRetry = ix
END FUNCTION

FUNCTION GetYesNo (mess AS STRING, m)
IF LEN(mess) > 20 THEN EXIT FUNCTION
IF m = 1 THEN
        cc = 62
        c1 = 55: c2 = 67
        LINE (400, 220)-(584, 310), 9, B
        LINE (410, 270)-(574, 270), 9
        x1 = 420: x2 = 518: add = 44
ELSEIF m = 2 THEN
        cc = 40
        c1 = 33: c2 = 46
        LINE (228, 220)-(412, 310), 9, B
        LINE (238, 270)-(402, 270), 9
        x1 = 240: x2 = 350: add = 50
END IF
        COLOR 11
        c = INT(cc - LEN(mess) / 2)
        LOCATE 13, c: PRINT mess
        LOCATE 15, c1: PRINT "ДА"
        LOCATE 15, c2: PRINT "НЕТ"
        rese = 1: '// Yes
        LINE (x1, 240)-(x1 + add, 260), 14, B
        DO
        B$ = INKEY$
        IF B$ = CHR$(0) + CHR$(75) THEN
                IF rese = 1 THEN
                        rese = 2
                        LINE (x1, 240)-(x1 + add, 260), 0, B
                        LINE (x2, 240)-(x2 + add, 260), 14, B
                ELSE
                        rese = 1
                        LINE (x1, 240)-(x1 + add, 260), 14, B
                        LINE (x2, 240)-(x2 + add, 260), 0, B
                END IF
        ELSEIF B$ = CHR$(0) + CHR$(77) THEN
                IF rese = 2 THEN
                        rese = 1
                        LINE (x1, 240)-(x1 + add, 260), 14, B
                        LINE (x2, 240)-(x2 + add, 260), 0, B
                ELSE
                        rese = 2
                        LINE (x1, 240)-(x1 + add, 260), 0, B
                        LINE (x2, 240)-(x2 + add, 260), 14, B
                END IF
        END IF
        LOOP WHILE B$ <> CHR$(13)
IF m = 1 THEN LINE (400, 220)-(584, 310), 0, BF
IF m = 2 THEN LINE (228, 220)-(412, 310), 0, BF

GetYesNo = rese
END FUNCTION

SUB Greet
'// Приветствия
'////////////////////////////////////////////////////////////////////////////
CLS
LINE (5, 55)-(635, 475), 10, B
LINE (4, 54)-(636, 476), 2, B
LOCATE 2, 25: COLOR 10: PRINT "Мастер Оружия приветствует Вас"
LINE (10, 445)-(630, 445), 2
COLOR 11
LOCATE 4, 7
PRINT "Мастер создания Оружия предложит Вам заполнить анкету Вашего Оружия,"
LOCATE 5, 3
PRINT " ввести некоторые переменные, а также нарисовать Ваше Оружие на пикселовой"
LOCATE 6, 7
PRINT "карте. Следуйте указаниям Мастера; если возникнут трудности, обрати-"
LOCATE 7, 7
PRINT "    тесь к руководству по игре WARLIFE(tm) или к разработчику."
LOCATE 9, 23
COLOR 14
PRINT "Спасибо за то, что Вы выбрали нас!"
COLOR 9
LOCATE 25, 70: PRINT "mr.Dovzh": COLOR 15
DO
LOOP WHILE INKEY$ <> CHR$(13)
CLS
'////////////////////////////////////////////////////////////////////////////
END SUB

SUB MakeFiles (m)
SELECT CASE m
CASE 0
'// Заносим изменения в реестр status.dat
OPEN "status.dat" FOR OUTPUT AS #1
PRINT #1, DB(1) + 1, DB(2) + 1, DB(10)
CLOSE #1

name$ = "User\Weap_" + RTRIM$(LTRIM$(STR$(DB(2) + 1))): '// Оружие ТО_ЧТО_ЕСТЬ+1 !!!
DB$(3) = name$

MKDIR name$
WeapName$ = ""
IF LEN(DB$(2)) > 8 THEN WeapName$ = LEFT$(DB$(2), 8) ELSE WeapName$ = DB$(2)

name1$ = name$ + "\" + WeapName$ + ".pic"
DB$(4) = name1$
OPEN name1$ FOR OUTPUT AS #1: CLOSE #1

name2$ = name$ + "\" + WeapName$ + ".txt"
DB$(5) = name2$
OPEN name2$ FOR OUTPUT AS #1: CLOSE #1

name3$ = name$ + "\" + WeapName$ + ".dat"
DB$(6) = name3$
OPEN name3$ FOR OUTPUT AS #1: CLOSE #1


CASE 1
OPEN DB$(6) FOR OUTPUT AS #1
PRINT #1, DB$(1)
PRINT #1, DB$(2)
PRINT #1, DB(3)
PRINT #1, DB(4)
PRINT #1, DB(7)
PRINT #1, DB(5)
PRINT #1, DB(6)
CLOSE #1

CASE 2
acc = 0
OPEN DB$(4) FOR OUTPUT AS #1
FOR x = 511 TO 511 + 23
FOR y = 101 TO 101 + 23
col = POINT(x, y)
IF col <> 0 THEN acc = acc + 1
NEXT y
NEXT x

PRINT #1, acc

FOR x = 511 TO 511 + 23
FOR y = 101 TO 101 + 23
col = POINT(x, y)
IF col <> 0 THEN
st$ = "PSET (x + " + STR$(x - 511) + ", y + " + STR$(y - 101) + "), " + STR$(col)
PRINT #1, st$
END IF
NEXT y
NEXT x
CLOSE #1

CASE 3
'// Собственно шаблон
IF LTRIM$(RTRIM$(DB$(1))) = "1" THEN WriteThrower
IF LTRIM$(RTRIM$(DB$(1))) = "2" THEN WriteShoter
IF LTRIM$(RTRIM$(DB$(1))) = "3" THEN WritePutter

END SELECT
END SUB

SUB PrepareAll (tp)
'// Мастер оружия. Первичная подготовка
'////////////////////////////////////////////////////////////////////////////
'// ШАГ 1
IF tp = 1 THEN
'// Препаратор
LINE (5, 55)-(635, 475), 10, B
LINE (4, 54)-(636, 476), 2, B
LOCATE 2, 30: COLOR 10: PRINT "Мастер Оружия: ШАГ 1"
LINE (10, 445)-(630, 445), 2
COLOR 11
LOCATE 4, 5: PRINT "Выберите шаблон типа оружия:"
LINE (20, 415)-(270, 415), 9
COLOR 15

'// Определяйте имя своего шаблона здесь (шаг в 2 строки)
LOCATE 7, 25: PRINT "Кидалка (типа Граната)"
LOCATE 9, 25: PRINT "Стрелялка (типа Пистолет)"
LOCATE 11, 25: PRINT "Ставилка (типа Динамит)"

'// Выбираем шаблон
'// Если вставляете свой, то увеличте константу NumOfTemplates на 1 и
'// не трогайте, ради Бога, селектор, если он нормально работает...
ix = 1
y = 364
LINE (180, y)-(420, y + 25), 14, B
DO
A$ = INKEY$
IF A$ = CHR$(0) + CHR$(72) THEN
IF ix = 1 THEN ix = NumOfTemplates ELSE ix = ix - 1
LINE (180, y)-(420, y + 25), 0, B
y = 364 - (ix - 1) * 32
LINE (180, y)-(420, y + 25), 14, B
ELSEIF A$ = CHR$(0) + CHR$(80) THEN
IF ix = NumOfTemplates THEN ix = 1 ELSE ix = ix + 1
LINE (180, y)-(420, y + 25), 0, B
y = 364 - (ix - 1) * 32
LINE (180, y)-(420, y + 25), 14, B
END IF
LOOP WHILE A$ <> CHR$(13)
DB$(1) = LTRIM$(RTRIM$(STR$(ix)))
'//////////////////////////////////////////////////////////////////////////
'// ШАГ 2
ELSEIF tp = 2 THEN
440
CLS
LINE (5, 55)-(635, 475), 10, B
LINE (4, 54)-(636, 476), 2, B
LOCATE 2, 30: COLOR 10: PRINT "Мастер Оружия: ШАГ 2"
LINE (10, 445)-(630, 445), 2

COLOR 11
LOCATE 4, 5: PRINT "Введите имя Вашего Оружия:"
LINE (20, 415)-(250, 415), 9

COLOR 15
LINE (220, 317)-(410, 340), 9, B
LINE (219, 316)-(411, 341), 1, B
LOCATE 10, 30: '// 21 symbol max
c = 29
name$ = ""
DO
A$ = INPUT$(1)
IF A$ = CHR$(13) THEN EXIT DO
IF A$ = CHR$(27) THEN
        LOCATE 10, 30: PRINT "                     "
        c = 29
        name$ = ""
        GOTO 200
END IF
'// Только буквы. И только Lатiнскiе
IF ASC(A$) < 65 OR (ASC(A$) > 90 AND ASC(A$) < 97) OR ASC(A$) > 122 THEN 200
IF c < 50 THEN c = c + 1
IF LEN(name$) > 21 THEN name$ = MID$(name$, 1, 20) + A$
LOCATE 10, c: PRINT A$: name$ = name$ + A$
200
LOOP
IF LTRIM$(RTRIM$(name$)) = "" THEN
        LOCATE 8, 30: COLOR 4: PRINT "Название не введено!":
        COLOR 15: SLEEP
        GOTO 440
END IF
DB$(2) = name$
PRINT name$

'// ШАГ 3
ELSEIF tp = 3 THEN
CLS
LINE (5, 55)-(635, 475), 10, B
LINE (4, 54)-(636, 476), 2, B
LOCATE 2, 30: COLOR 10: PRINT "Мастер Оружия: ШАГ 3"
LINE (10, 445)-(630, 445), 2
COLOR 11
LOCATE 4, 5: PRINT "Заполните анкету Вашего Оружия - " + DB$(2)
LINE (20, 415)-(480, 415), 9

'// Будете вставлять свои опции - измените константу NumOfOptInForm
COLOR 7: LOCATE 7, 10: PRINT "Выстрелов за 1 раз"
COLOR 8
LOCATE 9, 10: PRINT "MAX повреждение"
LOCATE 11, 10: PRINT "MAX скорость"
LOCATE 13, 10: PRINT "Радиус поражения"
LOCATE 15, 10: PRINT "Радиус воронки"
LOCATE 17, 10: PRINT "Готово...                  Ok"
FOR y = 364 TO 364 - (NumOfOptInForm) * 32 STEP -32
        LINE (255, y)-(345, y + 25), 1, B
NEXT y
'// (Входит 9 знаков) Locate n,34
y = 364
LINE (50, y)-(250, y + 25), 9, B
LINE (250, y - 3)-(350, y + 28), 9, B
LINE (250, y)-(250, y + 25), 0
LINE (255, y)-(345, y + 25), 9, B
ix = 1
oldix = 1
555
DO
A$ = INKEY$

IF A$ = CHR$(0) + CHR$(72) THEN
IF ix = 1 THEN ix = NumOfOptInForm + 1 ELSE ix = ix - 1
flag = TRUE
LINE (50, y)-(250, y + 25), 0, B
LINE (250, y - 3)-(350, y + 28), 0, B
LINE (255, y)-(345, y + 25), 1, B
y = 364 - (ix - 1) * 32
LINE (50, y)-(250, y + 25), 9, B
LINE (250, y - 3)-(350, y + 28), 9, B
LINE (250, y)-(250, y + 25), 0
LINE (255, y)-(345, y + 25), 9, B

ELSEIF A$ = CHR$(0) + CHR$(80) THEN
flag = TRUE
IF ix = NumOfOptInForm + 1 THEN ix = 1 ELSE ix = ix + 1
LINE (50, y)-(250, y + 25), 0, B
LINE (250, y - 3)-(350, y + 28), 0, B
LINE (255, y)-(345, y + 25), 1, B
y = 364 - (ix - 1) * 32
LINE (50, y)-(250, y + 25), 9, B
LINE (250, y - 3)-(350, y + 28), 9, B
LINE (250, y)-(250, y + 25), 0
LINE (255, y)-(345, y + 25), 9, B
END IF
IF flag = TRUE THEN
SELECT CASE oldix
CASE 6
        COLOR 8: LOCATE 17, 10: PRINT "Готово...": LOCATE 17, 37: PRINT "Ok"
CASE 1
        COLOR 8: LOCATE 7, 10: PRINT "Выстрелов за 1 раз"
CASE 2
        COLOR 8: LOCATE 9, 10: PRINT "MAX повреждение"
CASE 3
        COLOR 8: LOCATE 11, 10: PRINT "MAX скорость"
CASE 4
        COLOR 8: LOCATE 13, 10: PRINT "Радиус поражения"
CASE 5
        COLOR 8: LOCATE 15, 10: PRINT "Радиус воронки"
END SELECT
SELECT CASE ix
CASE 1
        COLOR 7: LOCATE 7, 10: PRINT "Выстрелов за 1 раз"
        oldix = 1
CASE 2
        COLOR 7: LOCATE 9, 10: PRINT "MAX повреждение"
        oldix = 2
CASE 3
        COLOR 7: LOCATE 11, 10: PRINT "MAX скорость"
        oldix = 3
CASE 4
        COLOR 7: LOCATE 13, 10: PRINT "Радиус поражения"
        oldix = 4
CASE 5
        COLOR 7: LOCATE 15, 10: PRINT "Радиус воронки"
        oldix = 5
CASE 6
        COLOR 7: LOCATE 17, 10: PRINT "Готово...": LOCATE 17, 37: PRINT "Ok"
        oldix = 6
END SELECT
flag = FALSE
END IF

LOOP WHILE A$ <> CHR$(13)
SELECT CASE ix
CASE 1
        COLOR 15: LOCATE 7, 10: PRINT "Выстрелов за 1 раз"
CASE 2
        COLOR 15: LOCATE 9, 10: PRINT "MAX повреждение"
CASE 3
        COLOR 15: LOCATE 11, 10: PRINT "MAX скорость"
CASE 4
        COLOR 15: LOCATE 13, 10: PRINT "Радиус поражения"
CASE 5
        COLOR 15: LOCATE 15, 10: PRINT "Радиус воронки"
CASE 6
        COLOR 15: LOCATE 17, 10: PRINT "Готово...": LOCATE 17, 37: PRINT "Ok"
        FOR n = 1 TO 8000: NEXT n
END SELECT
556
LINE (50, y)-(250, y + 25), 11, B
LINE (250, y - 3)-(350, y + 28), 11, B
LINE (250, y)-(250, y + 25), 0
LINE (255, y)-(345, y + 25), 11, B

IF ix = NumOfOptInForm + 1 THEN 559
i = GetData(ix)
SELECT CASE ix
CASE 1
        IF i <= 0 THEN
        LOCATE 20, 10: COLOR 4: PRINT "Не задано количество зарядов"
        SLEEP: LOCATE 20, 10: PRINT "                            "
        COLOR 15: GOTO 556
        END IF
CASE 4
        IF i < DB(6) THEN
        LOCATE 20, 10: COLOR 4: PRINT "Чудным образом общий радиус < радиуса воронки"
        SLEEP: LOCATE 20, 10: PRINT "                                              "
        COLOR 15: GOTO 556
        END IF
CASE 5
        IF i > DB(5) THEN
        LOCATE 20, 10: COLOR 4: PRINT "Чудным образом радиус воронки > общего радиуса"
        SLEEP: LOCATE 20, 10: PRINT "                                               "
        COLOR 15: GOTO 556
        END IF
CASE 3
        IF i < 0 THEN
        LOCATE 20, 10: COLOR 4: PRINT "Скорость у Вас дюже большая получилась..."
        SLEEP: LOCATE 20, 10: PRINT "                                          "
        COLOR 15: GOTO 556
        END IF
END SELECT
LINE (50, y)-(250, y + 25), 9, B
LINE (250, y - 3)-(350, y + 28), 9, B
LINE (250, y)-(250, y + 25), 0
LINE (255, y)-(345, y + 25), 9, B
COLOR 7
SELECT CASE ix
CASE 1: LOCATE 7, 10: PRINT "Выстрелов за 1 раз": DB(3) = i
CASE 2: LOCATE 9, 10: PRINT "MAX повреждение": DB(4) = i
CASE 3: LOCATE 11, 10: PRINT "MAX скорость": DB(7) = i
CASE 4: LOCATE 13, 10: PRINT "Радиус поражения": DB(5) = i
CASE 5: LOCATE 15, 10: PRINT "Радиус воронки": DB(6) = i
CASE 6: LOCATE 17, 10: PRINT "Готово...                  Ok"
END SELECT

IF ix <> NumOfOptInForm + 1 THEN 555
END IF
559
'////////////////////////////////////////////////////////////////////////////
END SUB

SUB Worm (x, y)
'// Червяк нарисован для сравнения размеров оружия с Цеврём
RED = 6: DGREY = 8: GREY = 7: BLACK = 0: WHITE = 15
PSET (x + 2, y + 0), RED
PSET (x + 3, y + 0), DGREY
PSET (x + 8, y + 0), RED
PSET (x + 9, y + 0), DGREY
PSET (x + 10, y + 0), DGREY
PSET (x + 11, y + 0), RED
PSET (x + 1, y + 1), GREY
PSET (x + 2, y + 1), GREY
PSET (x + 3, y + 1), RED
PSET (x + 4, y + 1), RED
PSET (x + 5, y + 1), RED
PSET (x + 7, y + 1), GREY
PSET (x + 8, y + 1), GREY
PSET (x + 9, y + 1), RED
PSET (x + 10, y + 1), GREY
PSET (x + 11, y + 1), RED
PSET (x + 12, y + 1), RED
PSET (x + 0, y + 2), DGREY
PSET (x + 1, y + 2), RED
PSET (x + 2, y + 2), GREY
PSET (x + 3, y + 2), GREY
PSET (x + 4, y + 2), GREY
PSET (x + 5, y + 2), RED
PSET (x + 6, y + 2), RED
PSET (x + 7, y + 2), GREY
PSET (x + 8, y + 2), GREY
PSET (x + 9, y + 2), GREY
PSET (x + 10, y + 2), GREY
PSET (x + 11, y + 2), GREY
PSET (x + 12, y + 2), RED
PSET (x + 13, y + 2), RED
PSET (x + 1, y + 3), RED
PSET (x + 2, y + 3), RED
PSET (x + 3, y + 3), GREY
PSET (x + 4, y + 3), GREY
PSET (x + 5, y + 3), GREY
PSET (x + 6, y + 3), GREY
PSET (x + 7, y + 3), GREY
PSET (x + 8, y + 3), GREY
PSET (x + 9, y + 3), GREY
PSET (x + 10, y + 3), GREY
PSET (x + 11, y + 3), GREY
PSET (x + 12, y + 3), GREY
PSET (x + 0, y + 4), DGREY
PSET (x + 2, y + 4), RED
PSET (x + 3, y + 4), GREY
PSET (x + 4, y + 4), GREY
PSET (x + 5, y + 4), GREY
PSET (x + 6, y + 4), GREY
PSET (x + 7, y + 4), GREY
PSET (x + 8, y + 4), GREY
PSET (x + 9, y + 4), GREY
PSET (x + 10, y + 4), GREY
PSET (x + 11, y + 4), GREY
PSET (x + 12, y + 4), RED
PSET (x + 13, y + 4), RED
PSET (x + 2, y + 5), DGREY
PSET (x + 3, y + 5), RED
PSET (x + 4, y + 5), GREY
PSET (x + 5, y + 5), GREY
PSET (x + 6, y + 5), GREY
PSET (x + 7, y + 5), GREY
PSET (x + 8, y + 5), GREY
PSET (x + 9, y + 5), GREY
PSET (x + 10, y + 5), GREY
PSET (x + 11, y + 5), GREY
PSET (x + 12, y + 5), GREY
PSET (x + 3, y + 6), GREY
PSET (x + 4, y + 6), GREY
PSET (x + 5, y + 6), GREY
PSET (x + 6, y + 6), GREY
PSET (x + 7, y + 6), RED
PSET (x + 8, y + 6), GREY
PSET (x + 9, y + 6), GREY
PSET (x + 10, y + 6), GREY
PSET (x + 11, y + 6), RED
PSET (x + 12, y + 6), RED
PSET (x + 3, y + 7), DGREY
PSET (x + 4, y + 7), RED
PSET (x + 5, y + 7), RED
PSET (x + 6, y + 7), GREY
PSET (x + 7, y + 7), DGREY
PSET (x + 8, y + 7), GREY
PSET (x + 9, y + 7), GREY
PSET (x + 10, y + 7), DGREY
PSET (x + 11, y + 7), GREY
PSET (x + 12, y + 7), RED
PSET (x + 13, y + 7), RED
PSET (x + 14, y + 7), DGREY
PSET (x + 5, y + 8), DGREY
PSET (x + 6, y + 8), RED
PSET (x + 7, y + 8), GREY
PSET (x + 8, y + 8), GREY
PSET (x + 9, y + 8), GREY
PSET (x + 10, y + 8), GREY
PSET (x + 11, y + 8), GREY
PSET (x + 12, y + 8), GREY
PSET (x + 13, y + 8), DGREY
PSET (x + 14, y + 8), DGREY
PSET (x + 6, y + 9), DGREY
PSET (x + 7, y + 9), RED
PSET (x + 8, y + 9), GREY
PSET (x + 9, y + 9), GREY
PSET (x + 10, y + 9), GREY
PSET (x + 11, y + 9), WHITE
PSET (x + 12, y + 9), GREY
PSET (x + 13, y + 9), GREY
PSET (x + 14, y + 9), RED
PSET (x + 6, y + 10), RED
PSET (x + 7, y + 10), GREY
PSET (x + 8, y + 10), GREY
PSET (x + 9, y + 10), GREY
PSET (x + 10, y + 10), WHITE
PSET (x + 11, y + 10), GREY
PSET (x + 12, y + 10), GREY
PSET (x + 13, y + 10), WHITE
PSET (x + 14, y + 10), DGREY
PSET (x + 15, y + 10), GREY
PSET (x + 6, y + 11), RED
PSET (x + 7, y + 11), GREY
PSET (x + 8, y + 11), GREY
PSET (x + 9, y + 11), GREY
PSET (x + 10, y + 11), WHITE
PSET (x + 12, y + 11), WHITE
PSET (x + 13, y + 11), WHITE
PSET (x + 15, y + 11), RED
PSET (x + 16, y + 11), GREY
PSET (x + 5, y + 12), RED
PSET (x + 6, y + 12), RED
PSET (x + 7, y + 12), GREY
PSET (x + 8, y + 12), GREY
PSET (x + 9, y + 12), GREY
PSET (x + 10, y + 12), DGREY
PSET (x + 12, y + 12), DGREY
PSET (x + 13, y + 12), RED
PSET (x + 15, y + 12), DGREY
PSET (x + 5, y + 13), RED
PSET (x + 6, y + 13), GREY
PSET (x + 7, y + 13), GREY
PSET (x + 8, y + 13), GREY
PSET (x + 9, y + 13), WHITE
PSET (x + 10, y + 13), WHITE
PSET (x + 11, y + 13), RED
PSET (x + 12, y + 13), WHITE
PSET (x + 13, y + 13), WHITE
PSET (x + 14, y + 13), DGREY
PSET (x + 15, y + 13), RED
PSET (x + 16, y + 13), RED
PSET (x + 5, y + 14), RED
PSET (x + 6, y + 14), RED
PSET (x + 7, y + 14), GREY
PSET (x + 8, y + 14), GREY
PSET (x + 9, y + 14), GREY
PSET (x + 10, y + 14), WHITE
PSET (x + 11, y + 14), WHITE
PSET (x + 12, y + 14), WHITE
PSET (x + 13, y + 14), WHITE
PSET (x + 14, y + 14), WHITE
PSET (x + 15, y + 14), WHITE
PSET (x + 16, y + 14), DGREY
PSET (x + 5, y + 15), RED
PSET (x + 6, y + 15), GREY
PSET (x + 7, y + 15), GREY
PSET (x + 8, y + 15), GREY
PSET (x + 9, y + 15), GREY
PSET (x + 10, y + 15), GREY
PSET (x + 11, y + 15), RED
PSET (x + 12, y + 15), GREY
PSET (x + 13, y + 15), GREY
PSET (x + 14, y + 15), RED
PSET (x + 15, y + 15), RED
PSET (x + 16, y + 15), RED
PSET (x + 5, y + 16), RED
PSET (x + 6, y + 16), RED
PSET (x + 7, y + 16), GREY
PSET (x + 8, y + 16), GREY
PSET (x + 9, y + 16), GREY
PSET (x + 12, y + 16), RED
PSET (x + 13, y + 16), GREY
PSET (x + 14, y + 16), RED
PSET (x + 15, y + 16), RED
PSET (x + 16, y + 16), DGREY
PSET (x + 6, y + 17), RED
PSET (x + 7, y + 17), DGREY
PSET (x + 8, y + 17), GREY
PSET (x + 9, y + 17), GREY
PSET (x + 10, y + 17), GREY
PSET (x + 11, y + 17), GREY
PSET (x + 12, y + 17), GREY
PSET (x + 13, y + 17), GREY
PSET (x + 14, y + 17), DGREY
PSET (x + 15, y + 17), RED
PSET (x + 6, y + 18), DGREY
PSET (x + 7, y + 18), RED
PSET (x + 8, y + 18), RED
PSET (x + 9, y + 18), DGREY
PSET (x + 10, y + 18), GREY
PSET (x + 11, y + 18), RED
PSET (x + 12, y + 18), GREY
PSET (x + 13, y + 18), DGREY
PSET (x + 14, y + 18), RED
PSET (x + 15, y + 18), RED
PSET (x + 16, y + 18), GREY
PSET (x + 6, y + 19), DGREY
PSET (x + 8, y + 19), DGREY
PSET (x + 9, y + 19), RED
PSET (x + 10, y + 19), RED
PSET (x + 11, y + 19), RED
PSET (x + 12, y + 19), RED
PSET (x + 13, y + 19), GREY
PSET (x + 15, y + 19), GREY
'/////////////////////////////////////

END SUB

SUB WritePutter
'// Пишем Ставилку
'////////////////////////////////////////////////////////////////////////////
OPEN DB$(5) FOR OUTPUT AS #1
'///////////////////////////
PRINT #1, "'// НАЧАЛО ШАБЛОНА ТИПА СТАВИЛКА"
PRINT #1, "'//========================================================================"
PRINT #1, "'// Поместите эти две строки (ниже) в основную пргм. в раздел МАССИВЫ ОРУЖИЯ"
PRINT #1, "DIM SHARED " + DB$(2) + "A(n)"
PRINT #1, "REDIM " + DB$(2) + "A(4)"
PRINT #1, "'// УКАЗАНИЕ. Увеличте второе измерение массива Holder() на 1"
PRINT #1, "'// Оно должно стать равным " + STR$(DB(1) + 1)
PRINT #1, "'// Вставьте строки с SUB " + DB$(2) + " по END SUB в основную пргм. (ниже)"
PRINT #1, "SUB " + DB$(2) + "(numofw)"
PRINT #1, "'////////////////////////////////////////////////////////////////////////////"
PRINT #1, "'// Проверяем наличие ставилок"
PRINT #1, "IF Holder(numofw, " + STR$(DB(1) + 1) + ") = 0 THEN"
PRINT #1, "        '// Обновляем Цевря"
PRINT #1, "        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "        '// Ваше Сообщение об отсутствии оружия"
PRINT #1, "        'LOCATE 2, 27: PRINT <Сообщение...>"
PRINT #1, "EXIT SUB"
PRINT #1, "ELSEIF Holder(numofw, " + STR$(DB(1) + 1) + ") > 0 THEN"
PRINT #1, "        Holder(numofw, " + STR$(DB(1) + 1) + ") = Holder(numofw, " + STR$(DB(1) + 1) + ") - 1"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "'// Пододвигаем чуть, чтобы не замочить своего Цевря сразу"
PRINT #1, "IF Holder(numofw, 1) = RIGHT THEN"
PRINT #1, "        x0 = WormPos(numofw, 1) + 23"
PRINT #1, "ELSEIF Holder(numofw, 1) = LEFT THEN"
PRINT #1, "        x0 = WormPos(numofw, 1) - 7"
PRINT #1, "END IF"
PRINT #1, "y0 = WormPos(numofw, 2)"
PRINT #1, "'// Нужно для вывода спрайта при следующем вызове"
PRINT #1, "oldx = x0: oldy = y0"
PRINT #1, " "
PRINT #1, "'// Коэффициент дальновидности динамита (поиск твердой зоны)"
PRINT #1, "d = 2"
PRINT #1, " "
PRINT #1, "'// Радиус дырки от пули из массива " + DB$(2) + "A()"
PRINT #1, "R = " + DB$(2) + "A(4)"
PRINT #1, ""
PRINT #1, "'// Убираем крестик-мушку, а то её неправильно поймут, как твердую зону"
PRINT #1, "i = SetTarget(numofw, " + CHR$(34) + " - " + CHR$(34) + ", FALSE)"
PRINT #1, " "
PRINT #1, "flag = FALSE"
PRINT #1, " "
PRINT #1, "'// Ставим"
PRINT #1, "x = x0: y = y0"
PRINT #1, "IF POINT(x, y - 2) = 0 AND POINT(x + 1, y - 2) = 0 AND POINT(x + 2, y - 2) = 0 THEN"
PRINT #1, "        FOR t = 0 TO 1000 STEP .1"
PRINT #1, "  "
PRINT #1, "        flag = TRUE"
PRINT #1, " "
PRINT #1, "УКАЗАНИЕ. Здесь и далее замените слова <метка_n> на Ваши уникальные"
PRINT #1, "метки соответственно."
PRINT #1, "        IF t > 0 THEN"
PRINT #1, "        IF POINT(x, y - 2) <> 0 THEN GOTO <метка_1>"
PRINT #1, "        END IF"
PRINT #1, " "
PRINT #1, "'// Если полёт динамита (домкрата :)) только начался, спрайт не выводится"
PRINT #1, "        IF t > 0 THEN PUT (oldx - 12, oldy - 12), Weapon(1), PSET"
PRINT #1, " "
PRINT #1, "        IF t > 0 THEN"
PRINT #1, "                y = y - 1"
PRINT #1, "        END IF"
PRINT #1, " "
PRINT #1, "'// Переопределение " + CHR$(34) + "старья" + CHR$(34)
PRINT #1, "        oldx = x: oldy = y"
PRINT #1, ""
PRINT #1, "'// Координаты бабахалки - в массив"
PRINT #1, "        Holder(numofw, 7) = x"
PRINT #1, "        Holder(numofw, 8) = y"
PRINT #1, " "
PRINT #1, "'// Берём образ, что впереди"
PRINT #1, "        GET (x - 12, y + 12)-(x + 12, y - 12), Weapon(1)"
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Это Ваш Рисунок. Вам повезло, если Вы догадались, что"
PRINT #1, "'// нужно было рисовать не само Оружие, а его снаряд/патрон :)"
OPEN DB$(4) FOR INPUT AS #2
        INPUT #2, n$
        FOR acc = 1 TO VAL(n$)
        INPUT #2, A$, B$, c$
        st$ = A$ + "," + B$ + "," + c$
        PRINT #1, st$
        st$ = ""
        NEXT acc
CLOSE #2
PRINT #1, "'// Лётаем в Worm#Active. Дело в том, что пока фитиль горит (или что там"
PRINT #1, "у Вас...), Цеврь должен быренько тихой сапой слинять оттеда, чтоб его не"
PRINT #1, "похоронило случайно."
PRINT #1, "        IF numofw = 1 THEN i$ = Worm1Active$(" + CHR$(34) + "THRU" + CHR$(34) + ") ELSE i$ = Worm2Active(" + CHR$(34) + "THRU" + CHR$(34) + ")"
PRINT #1, "      "
PRINT #1, "        NEXT t"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Это Ваш Рисунок. Вам повезло, если Вы догадались, что"
PRINT #1, "'// нужно было рисовать не само Оружие, а его снаряд/патрон :)"
OPEN DB$(4) FOR INPUT AS #2
        INPUT #2, n$
        FOR acc = 1 TO VAL(n$)
        INPUT #2, A$, B$, c$
        st$ = A$ + "," + B$ + "," + c$
        PRINT #1, st$
        st$ = ""
        NEXT acc
CLOSE #2
PRINT #1, " "
PRINT #1, "УКАЗАНИЕ. А это бабахалка уже в стадии стабильной. "
PRINT #1, "FOR t = 1 TO 2000"
PRINT #1, "'// Лётаем в Worm#Active"
PRINT #1, "        IF numofw = 1 THEN i$ = Worm1Active$(" + CHR$(34) + "THRU" + CHR$(34) + ") ELSE i$ = Worm2Active(" + CHR$(34) + "THRU" + CHR$(34) + ")"
PRINT #1, "'// Перерисовываем"
OPEN DB$(4) FOR INPUT AS #2
        INPUT #2, n$
        FOR acc = 1 TO VAL(n$)
        INPUT #2, A$, B$, c$
        st$ = A$ + "," + B$ + "," + c$
        PRINT #1, st$
        st$ = ""
        NEXT acc
CLOSE #2
PRINT #1, "NEXT t"
PRINT #1, " "
PRINT #1, "'// Обработка дырени"
PRINT #1, "'// Стираем картинку, - не стало её больше!.."
PRINT #1, "ПРИМЕЧАНИЕ. Если у Вас картинка побольше, значит, и прямоугольник черной"
PRINT #1, "закраски (ниже) должен быть больше."
PRINT #1, "        LINE (x - 3, y - 3)-(x + 3, y + 11), 0, BF"
PRINT #1, " "
PRINT #1, "'// Обнуление тайма"
PRINT #1, "        t = 0"
PRINT #1, " "
PRINT #1, "'// Вроде как звук, что ли..."
PRINT #1, "        SOUND 40, 2"
PRINT #1, " "
PRINT #1, "'// Дырка"
PRINT #1, "        CIRCLE (x, y), R, 0: PAINT (x, y), 0"
PRINT #1, " "
PRINT #1, "'// Цикл закраски крайних областей окружности (улучшение закраски)"
PRINT #1, "        FOR A = 0 TO 360 STEP 5"
PRINT #1, "        PAINT (x + (R - 4) * COS(A * dcoef), y + (R - 4) * SIN(A * dcoef)), 0"
PRINT #1, "        NEXT A"
PRINT #1, " "
PRINT #1, "'// Проверяем, не прибило ли Цевря"
PRINT #1, "        FOR n = 1 TO 2"
PRINT #1, "        i = CheckWorm(x, y, n, " + CHR$(34) + UCASE$(DB$(2)) + CHR$(34) + ", " + CHR$(34) + "CHECK" + CHR$(34) + ")"
PRINT #1, "        IF i = TRUE THEN"
PRINT #1, "                IF num = 1 THEN"
PRINT #1, "                PUT (WormPos(num, 1), WormPos(num, 2)), W1Pic, PSET"
PRINT #1, "                ELSEIF num = 2 THEN"
PRINT #1, "                PUT (WormPos(num, 1), WormPos(num, 2)), W2Pic, PSET"
PRINT #1, "                END IF"
PRINT #1, "                xc = WormPos(num, 1)"
PRINT #1, "                yc = WormPos(num, 2)"
PRINT #1, "        IF num = 1 THEN GET (xc, yc + 20)-(xc + 17, yc), W1Pic"
PRINT #1, "        IF num = 2 THEN GET (xc, yc + 20)-(xc + 17, yc), W2Pic"
PRINT #1, "        END IF"
PRINT #1, "        i = CheckWorm(x, y, n, +chr$(34)+"; "DYNAMITE" + CHR$(34) + ", " + CHR$(34) + "REAL" + CHR$(34) + ")"
PRINT #1, "      "
PRINT #1, "        IF i = TRUE THEN"
PRINT #1, "                WormDead n"
PRINT #1, "                WormPos(n, 1) = -1"
PRINT #1, "        END IF"
PRINT #1, "        NEXT n"
PRINT #1, " "
PRINT #1, "'// Поправляем графику"
PRINT #1, "        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "        UpdateGraphics 0"
PRINT #1, " "
PRINT #1, "'////////////////////////////////////////////////////////////////////////////"
PRINT #1, "END SUB"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Вставьте следующие 4 строки в функцию Worm1Active в самый"
PRINT #1, "'// последний переключатель SELECT CASE Holder(1,3) (почти в самом низу)."
PRINT #1, "'// " + STR$(DB(1) + 1) + " - это индекс Вашего Оружия, проверяемый CASE       "
PRINT #1, "        CASE " + STR$(DB(1) + 1)
PRINT #1, "                ret$ = " + CHR$(34) + "CALL " + UCASE$(DB$(2)) + CHR$(34)
PRINT #1, "                Worm1Active$ = ret$"
PRINT #1, "                EXIT SUB"
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Вставьте следующие 4 строки в функцию Worm2Active в самый"
PRINT #1, "'// последний переключатель SELECT CASE Holder(2,3) (почти в самом низу)."
PRINT #1, "        CASE " + STR$(DB(1) + 1)
PRINT #1, "                ret$ = " + CHR$(34) + "CALL " + UCASE$(DB$(2)) + CHR$(34)
PRINT #1, "                Worm2Active$ = ret$"
PRINT #1, "                EXIT SUB"
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. В основной пргм. после метки 998 находятся 2 переключателя,"
PRINT #1, "'// очень похожих, но обрабатывающих разных червей. Вставьте 2 строки,"
PRINT #1, "'// находящиеся ниже, в ОБА переключателя, заменяя слово <Номер Цевря>"
PRINT #1, "'// соответственно переключателям на цифры: 1 - для обработчика"
PRINT #1, "'// первого Цевря, 2 - для второго"
PRINT #1, "        CASE " + CHR$(34) + "CALL " + UCASE$(DB$(2)) + CHR$(34)
PRINT #1, "                " + DB$(2) + " <Номер Цевря>"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. В функции CheckWorm после комментария '// Чем стреляли?"
PRINT #1, "'// находится переключатель, обрабатывающий переменную wep. Вставьте"
PRINT #1, "'// следующие 27 строк в этот переключатель. Эти строки определяют,"
PRINT #1, "'// сколько единиц энергии нужно отнять, при попадании патона, у Цевря в"
PRINT #1, "'// зависимости от дальности нахождения Цевря от эпицентра. Рассматриваются"
PRINT #1, "'// промежутки до 1/3, 2/3, и 1 от общего радиуса поражения"
PRINT #1, " "
PRINT #1, "CASE " + CHR$(34) + UCASE$(DB$(2)) + CHR$(34)
num4$ = DB$(2) + "A(4)"
num1$ = DB$(2) + "A(1)"
PRINT #1, "        IF x < WormPos(numofw, 1) + " + num4$ + " / 3 AND x > WormPos(numofw, 1) - " + num4$ + " / 3 AND y > WormPos(numofw, 2) - " + num4$ + " / 3 AND y < WormPos(numofw, 2) + " + num4$ + " / 3 THEN"
PRINT #1, "                IF fl = " + CHR$(34) + "CHECK" + CHR$(34) + " THEN ret = TRUE"
PRINT #1, "                IF fl = " + CHR$(34) + "REAL" + CHR$(34) + " AND Holder(numofw, 10) > 0 THEN"
PRINT #1, "                Holder(numofw, 10) = Holder(numofw, 10) - " + name1$
PRINT #1, "                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, DAMAGE)"
PRINT #1, "                END IF"
PRINT #1, "        ELSEIF x < WormPos(numofw, 1) + 2 * " + num4$ + " / 3 AND x > WormPos(numofw, 1) - 2 * " + num4$ + " / 3 AND y > WormPos(numofw, 2) - 2 * " + num4$ + " / 3 AND y < WormPos(numofw, 2) + 2 * " + num4$ + " / 3 THEN"
PRINT #1, "                IF fl = " + CHR$(34) + "CHECK" + CHR$(34) + " THEN ret = TRUE"
PRINT #1, "                IF fl = " + CHR$(34) + "REAL" + CHR$(34) + " AND Holder(numofw, 10) > 0 THEN"
PRINT #1, "                Holder(numofw, 10) = Holder(numofw, 10) - 2 * " + num1$ + " / 3"
PRINT #1, "                IF Holder(numofw, 10) > 0 THEN"
PRINT #1, "                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "                END IF"
PRINT #1, "                Holder(numofw, 9) = TRUE"
PRINT #1, "        ELSEIF x < WormPos(numofw, 1) + k * " + num4$ + " / 3 AND x > WormPos(numofw, 1) - k * " + num4$ + " / 3 AND y > WormPos(numofw, 2) - k * " + num4$ + " / 3 AND y < WormPos(numofw, 2) + k * " + num4$ + " / 3 THEN"
PRINT #1, "                IF fl = " + CHR$(34) + "CHECK" + CHR$(34) + " THEN ret = TRUE"
PRINT #1, "                IF fl = " + CHR$(34) + "REAL" + CHR$(34) + " AND Holder(numofw, 10) > 0 THEN"
PRINT #1, "                Holder(numofw, 10) = Holder(numofw, 10) - " + num1$ + " / 3"
PRINT #1, "                IF Holder(numofw, 10) > 0 THEN"
PRINT #1, "                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "                END IF"
PRINT #1, "        END IF"
PRINT #1, " "
PRINT #1, "'// Подсчёт убытков"
PRINT #1, "Holder(numofw, 10) = INT(Holder(numofw, 10))"
PRINT #1, "IF Holder(numofw, 10) <= 0 THEN Holder(numofw, 10) = 0: ret = TRUE"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. В подпрограмме SetWeapon увеличте переменную NumOfWep"
PRINT #1, "'// на 1. Затем, в раздел Рисунки, вставьте следующие операторы:  "
PRINT #1, " "
PRINT #1, "'// " + DB$(2)
PRINT #1, "x = 5 + (NumOfWep - 1) * 30 + 3 * (NumOfWep - 1) + 15: y = 460"
OPEN DB$(4) FOR INPUT AS #2
        INPUT #2, n$
        FOR acc = 1 TO VAL(n$)
        INPUT #2, A$, B$, c$
        st$ = A$ + "," + B$ + "," + c$
        PRINT #1, st$
        st$ = ""
        NEXT acc
CLOSE #2
PRINT #1, "IF Holder(numofw, " + STR$(DB(1)) + ") = 0 THEN"
PRINT #1, "        LINE (x - 15, 445)-(x + 30, 475), 4"
PRINT #1, "        LINE (x - 15, 475)-(x + 30, 445), 4"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "w = Holder(numofw, 3)"
PRINT #1, "LINE (x - 16, 444)-(x + 16, 476), 15, B"
PRINT #1, " "
PRINT #1, "'// СОВЕТ. Если хотите, чтоб у Цевря после выбора Оружия появлялось"
PRINT #1, "'// нечто похожее, нарисуйте  это нечто в виде операторов и вставьте в"
PRINT #1, "'// переключатель, обрабатывающий элемент массива: Holder(numofw, 3)"
PRINT #1, "'// При этом CASE должен проверять идентификатор Вашего Оружия."
PRINT #1, "'// Если Вы не напортачили, то он равен " + STR$(DB(1))
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Вставьте инициализацию массива Вашего Оружия в основную пргм."
PRINT #1, "'// в раздел Инициализация. Здесь элементы: 1). МАХ повреждение, 2). Радиус поражения,"
PRINT #1, "'// 3). МАХ скорость и 4). Радиус воронки."
PRINT #1, " "
PRINT #1, DB$(2) + "A(1) = " + STR$(DB(4))
PRINT #1, DB$(2) + "A(2) = " + STR$(DB(5))
PRINT #1, DB$(2) + "A(3) = " + STR$(DB(7))
PRINT #1, DB$(2) + "A(4) = " + STR$(DB(6))
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Инициализируйте также элемент массива Holder() с индексом"
PRINT #1, "'// во втором измерении, обозначающим Ваше Оружие. Он должен быть ра-"
PRINT #1, "'// вен по идее " + STR$(DB(1)) + ". Вы должны задать начальное количество"
PRINT #1, "'// боеприпасов. Если Вы приравняете элемент к отрицательному числу, это"
PRINT #1, "'// будет означать, что припасов бесконечно много."
PRINT #1, " "
PRINT #1, "Holder(1, " + STR$(DB(1)) + ") = ..."
PRINT #1, "Holder(2, " + STR$(DB(1)) + ") = ..."
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// КОНЕЦ ШАБЛОНА. С вопросами и предложениями обращайтесь по адресу:"
PRINT #1, "'// 309512, г. Старый Оскол Белгородской обл., м-н Жукова, 4-28,"
PRINT #1, "'// Довженко Егор. Или по телефону: (0725) 42-59-59"
PRINT #1, "'//========================================================================"
'///////////////////////////
CLOSE #1
'////////////////////////////////////////////////////////////////////////////
END SUB

SUB WriteShoter
'// Пишем Стрелялку
'////////////////////////////////////////////////////////////////////////////
OPEN DB$(5) FOR OUTPUT AS #1
'///////////////////////////
PRINT #1, "'// НАЧАЛО ШАБЛОНА ТИПА СТРЕЛЯЛКА"
PRINT #1, "'//========================================================================"
PRINT #1, "'// Поместите эти две строки (ниже) в основную пргм. в раздел МАССИВЫ ОРУЖИЯ"
PRINT #1, "DIM SHARED " + DB$(2) + "A(n)"
PRINT #1, "REDIM " + DB$(2) + "A(4)"
PRINT #1, "'// УКАЗАНИЕ. Увеличте второе измерение массива Holder() на 1"
PRINT #1, "'// Оно должно стать равным " + STR$(DB(1) + 1)
PRINT #1, "'// Вставьте строки с SUB " + DB$(2) + " по END SUB в основную пргм. (ниже)"

PRINT #1, "SUB " + DB$(2) + "(numofw)"
PRINT #1, "'////////////////////////////////////////////////////////////////////////////"
PRINT #1, "'// Проверяем наличие кидалок"
PRINT #1, "IF Holder(numofw, " + STR$(DB(1) + 1) + ") = 0 THEN"
PRINT #1, "        '// Обновляем Цевря"
PRINT #1, "        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "        '// Ваше Сообщение об отсутствии оружия"
PRINT #1, "        'LOCATE 2, 27: PRINT <Сообщение...>"
PRINT #1, "EXIT SUB"
PRINT #1, "ELSEIF Holder(numofw, " + STR$(DB(1) + 1) + ") > 0 THEN"
PRINT #1, "        Holder(numofw, " + STR$(DB(1) + 1) + ") = Holder(numofw, " + STR$(DB(1) + 1) + ") - 1"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "'// Пододвигаем чуть, чтобы не замочить своего Цевря сразу"
PRINT #1, "IF Holder(numofw, 1) = RIGHT THEN"
PRINT #1, " x0 = WormPos(numofw, 1) + 20"
PRINT #1, "ELSE"
PRINT #1, "        x0 = WormPos(numofw, 1) - 3"
PRINT #1, "END IF"
PRINT #1, "y0 = WormPos(numofw, 2) + 10"
PRINT #1, "'// Нужно для вывода спрайта при следующем вызове"
PRINT #1, "oldx = x0: oldy = y0"
PRINT #1, " "
PRINT #1, "'// Коэффициент дальновидности патронов (поиск твердой зоны)"
PRINT #1, "d = 2"
PRINT #1, " "
PRINT #1, "v = " + DB$(2) + "A(3)"
PRINT #1, " "
PRINT #1, "'// Получаем угол броска (от -90 до 270 градусов)"
PRINT #1, "A = Holder(numofw, 4)"
PRINT #1, " "
PRINT #1, "'// Радиус дырки от пули из массива " + DB$(2) + "A()"
PRINT #1, "R = " + DB$(2) + "A(4)"
PRINT #1, " "
PRINT #1, "'// Убираем крестик-мушку, а то её неправильно поймут, как твердую зону"
PRINT #1, "i = SetTarget(numofw, " + CHR$(34) + " - " + CHR$(34) + ", FALSE)"
PRINT #1, " "
PRINT #1, "'// Стреляем. Число 5 означает, что будет произведено 5 выстрелов"
PRINT #1, "FOR n = 1 TO 5"
PRINT #1, "FOR t = 1 TO 1000"
PRINT #1, " "
PRINT #1, "IF t > 3 THEN"
PRINT #1, "'// ПРИМЕЧАНИЕ. Замените здесь и далее слова <метка_n> на Ваши уникальные"
PRINT #1, "'// метки соответственно."
PRINT #1, "IF POINT(x + 2 * COS(A * dcoef), y + 2 * SIN(A * dcoef)) <> 0 THEN <метка_1>"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "'// Если полёт пулищи только начался, спрайт не выводится"
PRINT #1, "IF t > 1 THEN PUT (oldx - 12, oldy - 12), Weapon(1), PSET"
PRINT #1, " "
PRINT #1, "IF t = 0 THEN"
PRINT #1, "        x = x0"
PRINT #1, "        y = y0"
PRINT #1, "ELSE"
PRINT #1, "'// СОВЕТ. Если делаете Базуку какую-нибудь, задайте траекторию полёта"
PRINT #1, "'// квадратным уравнением, а не прямой."
PRINT #1, "        x = x0 + v * t * COS(A * dcoef)"
PRINT #1, "        y = y0 + v * t * SIN(A * dcoef)"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "'// Переопределение старья"
PRINT #1, "oldx = x: oldy = y"
PRINT #1, " "
PRINT #1, "'// Координаты патрона/снаряда - в массив"
PRINT #1, "Holder(numofw, 7) = x"
PRINT #1, "Holder(numofw, 8) = y"
PRINT #1, " "
PRINT #1, "'// Берём образ, что впереди"
PRINT #1, "GET (x - 12, y + 12)-(x + 12, y - 12), Weapon(1)"
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Это Ваш Рисунок. Вам повезло, если Вы догадались, что"
PRINT #1, "'// нужно было рисовать не само Оружие, а его снаряд/патрон :)"
OPEN DB$(4) FOR INPUT AS #2
        INPUT #2, n$
        FOR acc = 1 TO VAL(n$)
        INPUT #2, A$, B$, c$
        st$ = A$ + "," + B$ + "," + c$
        PRINT #1, st$
        st$ = ""
        NEXT acc
CLOSE #2
PRINT #1, " "
PRINT #1, "'// Обработка дырени"
PRINT #1, "NEXT t"
PRINT #1, "<метка_1>"
PRINT #1, " "
PRINT #1, "'// Стираем картинку, - не стало её больше!.."
PRINT #1, "        PUT (oldx - 12, oldy - 12), Weapon(1), PSET"
PRINT #1, ""
PRINT #1, "'// Обнуление тайма"
PRINT #1, "        t = 0"
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Здесь можете поместить СВОЙ звуковой ЭФФЕКТ"
PRINT #1, "        SOUND 440, 1"
PRINT #1, " "
PRINT #1, "'// Дырка. Но Вы можете здесь выводить (после касания почвы) всё,"
PRINT #1, "'// что угодно."
PRINT #1, "        CIRCLE (x, y), R, 0: PAINT (x, y), 0"
PRINT #1, " "
PRINT #1, "'// Цикл закраски крайних областей окружности (улучшение закраски)"
PRINT #1, "        CIRCLE (x + 1, y), R - 1, 0: PAINT (x + 1, y), 0"
PRINT #1, "        CIRCLE (x - 1, y), R - 1, 0: PAINT (x - 1, y), 0"
PRINT #1, "        CIRCLE (x, y + 1), R - 1, 0: PAINT (x, y + 1), 0"
PRINT #1, "        CIRCLE (x, y - 1), R - 1, 0: PAINT (x, y - 1), 0"
PRINT #1, ""
PRINT #1, "'// Проверяем, не был ли убит какой-нибудь Цеврь"
PRINT #1, "        FOR n = 1 TO 2"
PRINT #1, "        i = CheckWorm(x, y, n, " + CHR$(34) + UCASE$(DB$(2)) + CHR$(34) + "," + CHR$(34) + "CHECK " + CHR$(34) + ")"
PRINT #1, "        IF i = TRUE THEN"
PRINT #1, "                IF num = 1 THEN"
PRINT #1, "                PUT (WormPos(num, 1), WormPos(num, 2)), W1Pic, PSET"
PRINT #1, "                ELSEIF num = 2 THEN"
PRINT #1, "                PUT (WormPos(num, 1), WormPos(num, 2)), W2Pic, PSET"
PRINT #1, "                END IF"
PRINT #1, "                xc = WormPos(num, 1)"
PRINT #1, "                yc = WormPos(num, 2)"
PRINT #1, "        IF num = 1 THEN GET (xc, yc + 20)-(xc + 17, yc), W1Pic"
PRINT #1, "        IF num = 2 THEN GET (xc, yc + 20)-(xc + 17, yc), W2Pic"
PRINT #1, "        END IF"
PRINT #1, "        i = CheckWorm(x, y, n, " + CHR$(34) + UCASE$(DB$(2)) + CHR$(34) + "," + CHR$(34) + "REAL " + CHR$(34) + ")"
PRINT #1, "        IF i = TRUE THEN"
PRINT #1, "               WormDead n"
PRINT #1, "               WormPos(n, 1) = -1"
PRINT #1, "        END IF"
PRINT #1, "NEXT n"
PRINT #1, " "
PRINT #1, "'// Поправляем графику"
PRINT #1, "        UpdateGraphics 0"
PRINT #1, " "
PRINT #1, "'// Задержка. Если у Вас Автомат, уберите задержку вообще."
PRINT #1, "SLEEP 1"
PRINT #1, "NEXT n"
PRINT #1, "'// Обновляем Цевря"
PRINT #1, "        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "'////////////////////////////////////////////////////////////////////////////"
PRINT #1, "END SUB"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Вставьте следующие 4 строки в функцию Worm1Active в самый"
PRINT #1, "'// последний переключатель SELECT CASE Holder(1,3) (почти в самом низу)."
PRINT #1, "'// " + STR$(DB(1) + 1) + " - это индекс Вашего Оружия, проверяемый CASE       "
PRINT #1, "        CASE " + STR$(DB(1) + 1)
PRINT #1, "                ret$ = " + CHR$(34) + "CALL " + UCASE$(DB$(2)) + CHR$(34)
PRINT #1, "                Worm1Active$ = ret$"
PRINT #1, "                EXIT SUB"
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Вставьте следующие 4 строки в функцию Worm2Active в самый"
PRINT #1, "'// последний переключатель SELECT CASE Holder(2,3) (почти в самом низу)."
PRINT #1, "        CASE " + STR$(DB(1) + 1)
PRINT #1, "                ret$ = " + CHR$(34) + "CALL " + UCASE$(DB$(2)) + CHR$(34)
PRINT #1, "                Worm2Active$ = ret$"
PRINT #1, "                EXIT SUB"
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. В основной пргм. после метки 998 находятся 2 переключателя,"
PRINT #1, "'// очень похожих, но обрабатывающих разных червей. Вставьте 2 строки,"
PRINT #1, "'// находящиеся ниже, в ОБА переключателя, заменяя слово <Номер Цевря>"
PRINT #1, "'// соответственно переключателям на цифры: 1 - для обработчика"
PRINT #1, "'// первого Цевря, 2 - для второго"
PRINT #1, "        CASE " + CHR$(34) + "CALL " + UCASE$(DB$(2)) + CHR$(34)
PRINT #1, "                " + DB$(2) + " <Номер Цевря>"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. В функции CheckWorm после комментария '// Чем стреляли?"
PRINT #1, "'// находится переключатель, обрабатывающий переменную wep. Вставьте"
PRINT #1, "'// следующие 27 строк в этот переключатель. Эти строки определяют,"
PRINT #1, "'// сколько единиц энергии нужно отнять, при попадании патона, у Цевря в"
PRINT #1, "'// зависимости от дальности нахождения Цевря от эпицентра. Рассматриваются"
PRINT #1, "'// промежутки до 1/3, 2/3, и 1 от общего радиуса поражения"
PRINT #1, " "
PRINT #1, "CASE " + CHR$(34) + UCASE$(DB$(2)) + CHR$(34)
num4$ = DB$(2) + "A(4)"
num1$ = DB$(2) + "A(1)"
PRINT #1, "        IF x < WormPos(numofw, 1) + " + num4$ + " / 3 AND x > WormPos(numofw, 1) - " + num4$ + " / 3 AND y > WormPos(numofw, 2) - " + num4$ + " / 3 AND y < WormPos(numofw, 2) + " + num4$ + " / 3 THEN"
PRINT #1, "                IF fl = " + CHR$(34) + "CHECK" + CHR$(34) + " THEN ret = TRUE"
PRINT #1, "                IF fl = " + CHR$(34) + "REAL" + CHR$(34) + " AND Holder(numofw, 10) > 0 THEN"
PRINT #1, "                Holder(numofw, 10) = Holder(numofw, 10) - " + name1$
PRINT #1, "                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, DAMAGE)"
PRINT #1, "                END IF"
PRINT #1, "        ELSEIF x < WormPos(numofw, 1) + 2 * " + num4$ + " / 3 AND x > WormPos(numofw, 1) - 2 * " + num4$ + " / 3 AND y > WormPos(numofw, 2) - 2 * " + num4$ + " / 3 AND y < WormPos(numofw, 2) + 2 * " + num4$ + " / 3 THEN"
PRINT #1, "                IF fl = " + CHR$(34) + "CHECK" + CHR$(34) + " THEN ret = TRUE"
PRINT #1, "                IF fl = " + CHR$(34) + "REAL" + CHR$(34) + " AND Holder(numofw, 10) > 0 THEN"
PRINT #1, "                Holder(numofw, 10) = Holder(numofw, 10) - 2 * " + num1$ + " / 3"
PRINT #1, "                IF Holder(numofw, 10) > 0 THEN"
PRINT #1, "                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "                END IF"
PRINT #1, "                Holder(numofw, 9) = TRUE"
PRINT #1, "        ELSEIF x < WormPos(numofw, 1) + k * " + num4$ + " / 3 AND x > WormPos(numofw, 1) - k * " + num4$ + " / 3 AND y > WormPos(numofw, 2) - k * " + num4$ + " / 3 AND y < WormPos(numofw, 2) + k * " + num4$ + " / 3 THEN"
PRINT #1, "                IF fl = " + CHR$(34) + "CHECK" + CHR$(34) + " THEN ret = TRUE"
PRINT #1, "                IF fl = " + CHR$(34) + "REAL" + CHR$(34) + " AND Holder(numofw, 10) > 0 THEN"
PRINT #1, "                Holder(numofw, 10) = Holder(numofw, 10) - " + num1$ + " / 3"
PRINT #1, "                IF Holder(numofw, 10) > 0 THEN"
PRINT #1, "                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "                END IF"
PRINT #1, "        END IF"
PRINT #1, " "
PRINT #1, "'// Подсчёт убытков"
PRINT #1, "Holder(numofw, 10) = INT(Holder(numofw, 10))"
PRINT #1, "IF Holder(numofw, 10) <= 0 THEN Holder(numofw, 10) = 0: ret = TRUE"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. В подпрограмме SetWeapon увеличте переменную NumOfWep"
PRINT #1, "'// на 1. Затем, в раздел Рисунки, вставьте следующие операторы:  "
PRINT #1, " "
PRINT #1, "'// " + DB$(2)
PRINT #1, "x = 5 + (NumOfWep - 1) * 30 + 3 * (NumOfWep - 1) + 15: y = 460"
OPEN DB$(4) FOR INPUT AS #2
        INPUT #2, n$
        FOR acc = 1 TO VAL(n$)
        INPUT #2, A$, B$, c$
        st$ = A$ + "," + B$ + "," + c$
        PRINT #1, st$
        st$ = ""
        NEXT acc
CLOSE #2
PRINT #1, "IF Holder(numofw, " + STR$(DB(1)) + ") = 0 THEN"
PRINT #1, "        LINE (x - 15, 445)-(x + 30, 475), 4"
PRINT #1, "        LINE (x - 15, 475)-(x + 30, 445), 4"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "w = Holder(numofw, 3)"
PRINT #1, "LINE (x - 16, 444)-(x + 16, 476), 15, B"
PRINT #1, " "
PRINT #1, "'// СОВЕТ. Если хотите, чтоб у Цевря после выбора Оружия появлялось"
PRINT #1, "'// нечто похожее, нарисуйте  это нечто в виде операторов и вставьте в"
PRINT #1, "'// переключатель, обрабатывающий элемент массива: Holder(numofw, 3)"
PRINT #1, "'// При этом CASE должен проверять идентификатор Вашего Оружия."
PRINT #1, "'// Если Вы не напортачили, то он равен " + STR$(DB(1))
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Вставьте инициализацию массива Вашего Оружия в основную пргм."
PRINT #1, "'// в раздел Инициализация. Здесь элементы: 1). МАХ повреждение, 2). Радиус поражения,"
PRINT #1, "'// 3). МАХ скорость и 4). Радиус воронки."
PRINT #1, " "
PRINT #1, DB$(2) + "A(1) = " + STR$(DB(4))
PRINT #1, DB$(2) + "A(2) = " + STR$(DB(5))
PRINT #1, DB$(2) + "A(3) = " + STR$(DB(7))
PRINT #1, DB$(2) + "A(4) = " + STR$(DB(6))
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Инициализируйте также элемент массива Holder() с индексом"
PRINT #1, "'// во втором измерении, обозначающим Ваше Оружие. Он должен быть ра-"
PRINT #1, "'// вен по идее " + STR$(DB(1)) + ". Вы должны задать начальное количество"
PRINT #1, "'// боеприпасов. Если Вы приравняете элемент к отрицательному числу, это"
PRINT #1, "'// будет означать, что припасов бесконечно много."
PRINT #1, " "
PRINT #1, "Holder(1, " + STR$(DB(1)) + ") = ..."
PRINT #1, "Holder(2, " + STR$(DB(1)) + ") = ..."
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// КОНЕЦ ШАБЛОНА. С вопросами и предложениями обращайтесь по адресу:"
PRINT #1, "'// 309512, г. Старый Оскол Белгородской обл., м-н Жукова, 4-28,"
PRINT #1, "'// Довженко Егор. Или по телефону: (0725) 42-59-59"
PRINT #1, "'//========================================================================"
'///////////////////////////
CLOSE #1
'////////////////////////////////////////////////////////////////////////////
END SUB

SUB WriteThrower
'// Пишем Кидалку
'////////////////////////////////////////////////////////////////////////////
OPEN DB$(5) FOR OUTPUT AS #1
'///////////////////////////
PRINT #1, "'// НАЧАЛО ШАБЛОНА ТИПА КИДАЛКА"
PRINT #1, "'//========================================================================"
PRINT #1, "'// Поместите эти две строки (ниже) в основную пргм. в раздел МАССИВЫ ОРУЖИЯ"
PRINT #1, "DIM SHARED " + DB$(2) + "A(n)"
PRINT #1, "REDIM " + DB$(2) + "A(4)"
PRINT #1, "'// УКАЗАНИЕ. Увеличте второе измерение массива Holder() на 1"
PRINT #1, "'// Оно должно стать равным " + STR$(DB(1) + 1)
PRINT #1, "'// Вставьте строки с SUB " + DB$(2) + " по END SUB в основную пргм. (ниже)"

PRINT #1, "SUB " + DB$(2) + "(numofw)"
PRINT #1, "'////////////////////////////////////////////////////////////////////////////"
PRINT #1, "'// Проверяем наличие кидалок"
PRINT #1, "IF Holder(numofw, " + STR$(DB(1) + 1) + ") = 0 THEN"
PRINT #1, "        '// Обновляем Цевря"
PRINT #1, "        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "        '// Ваше Сообщение об отсутствии оружия"
PRINT #1, "        'LOCATE 2, 27: PRINT <Сообщение...>"
PRINT #1, "EXIT SUB"
PRINT #1, "ELSEIF Holder(numofw, " + STR$(DB(1) + 1) + ") > 0 THEN"
PRINT #1, "        Holder(numofw, " + STR$(DB(1) + 1) + ") = Holder(numofw, " + STR$(DB(1) + 1) + ") - 1"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "'// Приподнимаем чуть, чтобы не замочить своего Цевря сразу"
PRINT #1, "x0 = WormPos(numofw, 1) + 5"
PRINT #1, "y0 = WormPos(numofw, 2) + 35"
PRINT #1, " "
PRINT #1, "'// Нужно для вывода спрайта при следующем вызове"
PRINT #1, "oldx = x0: oldy = y0"
PRINT #1, " "
PRINT #1, "'// Коэффициент " + CHR$(34) + "дальновидности" + CHR$(34) + " кидалки (поиск твердой зоны)"
PRINT #1, "d = 8 * 1.3"
PRINT #1, " "
PRINT #1, "'// Получаем скорость благодаря сабу, который кладёт её в базу данных Цевря"
PRINT #1, "GetVelocity (numofw)"
PRINT #1, "v = Holder(numofw, 9)"
PRINT #1, " "
PRINT #1, "'// Обновляем Цевря"
PRINT #1, "i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, " "
PRINT #1, "'// Получаем угол броска (от -90 до 270 градусов)"
PRINT #1, "a = Holder(numofw, 4)"
PRINT #1, " "
PRINT #1, "'// Радиус дырки из массива Вашего Оружия (см. указания дальше)"
PRINT #1, "R = " + DB$(2) + "A(4)"
PRINT #1, " "
PRINT #1, "'// Убираем крестик-мушку, а то её неправильно поймут, как твердую зону"
PRINT #1, "i = SetTarget(numofw, " + CHR$(34) + " - " + CHR$(34) + ", FALSE)"
PRINT #1, " "
PRINT #1, "'// Полет. Если возникнет БАГ (кидалка не долетает до объекта), то вместо числа 100 поставьте что-нибудь побольше"
PRINT #1, "FOR t = 0 TO 100 STEP .3"
PRINT #1, " "
PRINT #1, "'// Задержка (микропауза)"
PRINT #1, "SOUND 32000, 1"
PRINT #1, " "
PRINT #1, "'// В момент времени t=0 проверка не производится"
PRINT #1, "IF t > 0 THEN"
PRINT #1, "'// Кидалка просиатривает перед собой угол (по направлению полёта) в 40 градусов, с частотой 10 градусов"
PRINT #1, "FOR B = Holder(numofw, 4) - 20 TO Holder(numofw, 4) + 20 STEP 10"
PRINT #1, "УКАЗАНИЕ. Замените везде слова <метка_1>, <метка_2> и т.п. своими уникальными метками соответственно"
PRINT #1, "'// с помощью опции Поиск -> Замена"
PRINT #1, "IF POINT(x + d * COS(B * dcoef), y + d * SIN(B * dcoef)) <> 0 THEN <метка_1>"
PRINT #1, "NEXT B"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "'// Если полёт только начался, спрайт не выводится"
PRINT #1, "IF t > 0 THEN PUT (oldx - 12, oldy - 12), Weapon(1), PSET"
PRINT #1, "'// Закон полёта кидалки (парабола)"
PRINT #1, "IF t = 0 THEN"
PRINT #1, "        x = x0"
PRINT #1, "        y = y0"
PRINT #1, "ELSE"
PRINT #1, "        x = x0 + v * t * COS(A * dcoef)"
PRINT #1, "        y = y0 + v * t * SIN(A * dcoef) - g * t ^ 2 / 2"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "'// Переопределение для вывода спрайта при след. итерации"
PRINT #1, "oldx = x: oldy = y"
PRINT #1, " "
PRINT #1, "'// Координаты кидалки - в массив"
PRINT #1, "'// С помощью них Вы в любой момент узнаете, где на экране находится кидалка"
PRINT #1, "Holder(numofw, 7) = x"
PRINT #1, "Holder(numofw, 8) = y"
PRINT #1, " "
PRINT #1, "'// Берём образ, что впереди кидалки по направлению полёта"
PRINT #1, "GET (x - 12, y + 12)-(x + 12, y - 12), Weapon(1)"
PRINT #1, " "
PRINT #1, "'// Когда кидалка достигает предельной нижней отметки - происходит выход из цикла полёта"
PRINT #1, "IF y < 0 THEN EXIT FOR"
PRINT #1, " "
PRINT #1, "'// Рисуем изображение Оружия (оно находится в виде операторов QBASIC в файле .pic"
PRINT #1, "'// СОВЕТ. Если Вы хотите создать эффект вращения при полёте или что-нибудь в"
PRINT #1, "этом роде, нарисуйте несколько изображений, создав пустышки Оружий"
PRINT #1, "и вытащив из них .pic-файлы. А затем, с помощью изменения переменной и"
PRINT #1, "оператора SELECT CASE определяйте, какое изо и когда должно появляться"
PRINT #1, " "
OPEN DB$(4) FOR INPUT AS #2
        INPUT #2, n$
        FOR acc = 1 TO VAL(n$)
        INPUT #2, A$, B$, c$
        st$ = A$ + "," + B$ + "," + c$
        PRINT #1, st$
        st$ = ""
        NEXT acc
CLOSE #2
PRINT #1, " "
PRINT #1, "NEXT t"
PRINT #1, ""
PRINT #1, "'// Обработка взрыва."
PRINT #1, "<метка_1>"
PRINT #1, "'// Стираем картинку"
PRINT #1, "        PUT (oldx - 12, oldy - 12), Weapon(1), PSET"
PRINT #1, ""
PRINT #1, "'// Обнуление времени (если Вы захотите сделать отскоки кидалки от стенок,"
PRINT #1, "'// то Вам это понадобится - можно каждый раз при ударе уменьшать скорость)"
PRINT #1, "и считать, что кидалка выброшена с позиции удара"
PRINT #1, "        t = 0"
PRINT #1, ""
PRINT #1, "'// Звук. Можете вставить ЗДЕСЬ СВОЙ звуковой эффект"
PRINT #1, "        SOUND 40, 5"
PRINT #1, ""
PRINT #1, "'// Отверстие цвета фона (" + CHR$(34) + "прозрачное" + CHR$(34) + ")"
PRINT #1, "'// Радиус отверстия хранится в массиве Вашего Оружия. Вам нужно будет его      "
PRINT #1, "инициализировать значениями (см. указания дальше)"
PRINT #1, "        CIRCLE (x, y), R, 0: PAINT (x, y), 0"
PRINT #1, ""
PRINT #1, "'// Цикл закраски крайних областей круга (улучшение закраски)"
PRINT #1, "        FOR b = 1 TO 360"
PRINT #1, "        PAINT (x + (R - 2) * COS(b * dcoef), y + (R - 2) * SIN(b * dcoef)), 0"
PRINT #1, "        NEXT b"
PRINT #1, "      "
PRINT #1, "'// Проверяем, не был ли убит какой-нибудь Цеврь"
PRINT #1, "        FOR n = 1 TO 2"
PRINT #1, "        i = CheckWorm(x, y, n, " + CHR$(34) + UCASE$(DB$(2)) + CHR$(34) + "," + CHR$(34) + "CHECK " + CHR$(34) + ")"
PRINT #1, "        IF i = TRUE THEN"
PRINT #1, "                IF num = 1 THEN"
PRINT #1, "                PUT (WormPos(num, 1), WormPos(num, 2)), W1Pic, PSET"
PRINT #1, "                ELSEIF num = 2 THEN"
PRINT #1, "                PUT (WormPos(num, 1), WormPos(num, 2)), W2Pic, PSET"
PRINT #1, "                END IF"
PRINT #1, "                xc = WormPos(num, 1)"
PRINT #1, "                yc = WormPos(num, 2)"
PRINT #1, "        IF num = 1 THEN GET (xc, yc + 20)-(xc + 17, yc), W1Pic"
PRINT #1, "        IF num = 2 THEN GET (xc, yc + 20)-(xc + 17, yc), W2Pic"
PRINT #1, "        END IF"
PRINT #1, "        i = CheckWorm(x, y, n, " + CHR$(34) + UCASE$(DB$(2)) + CHR$(34) + "," + CHR$(34) + "REAL " + CHR$(34) + ")"
PRINT #1, "        IF i = TRUE THEN"
PRINT #1, "               WormDead n"
PRINT #1, "               WormPos(n, 1) = -1"
PRINT #1, "        END IF"
PRINT #1, "NEXT n"
PRINT #1, " "
PRINT #1, "'// Поправляем графику"
PRINT #1, "        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "        UpdateGraphics 0"
PRINT #1, "'////////////////////////////////////////////////////////////////////////////"
PRINT #1, "END SUB"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Вставьте следующие 4 строки в функцию Worm1Active в самый"
PRINT #1, "'// последний переключатель SELECT CASE Holder(1,3) (почти в самом низу)."
PRINT #1, "'// " + STR$(DB(1) + 1) + " - это индекс Вашего Оружия, проверяемый CASE       "
PRINT #1, "        CASE " + STR$(DB(1) + 1)
PRINT #1, "                ret$ = " + CHR$(34) + "CALL " + UCASE$(DB$(2)) + CHR$(34)
PRINT #1, "                Worm1Active$ = ret$"
PRINT #1, "                EXIT SUB"
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Вставьте следующие 4 строки в функцию Worm2Active в самый"
PRINT #1, "'// последний переключатель SELECT CASE Holder(2,3) (почти в самом низу)."
PRINT #1, "        CASE " + STR$(DB(1) + 1)
PRINT #1, "                ret$ = " + CHR$(34) + "CALL " + UCASE$(DB$(2)) + CHR$(34)
PRINT #1, "                Worm2Active$ = ret$"
PRINT #1, "                EXIT SUB"
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. В основной пргм. после метки 998 находятся 2 переключателя,"
PRINT #1, "'// очень похожих, но обрабатывающих разных червей. Вставьте 2 строки,"
PRINT #1, "'// находящиеся ниже, в ОБА переключателя, заменяя слово <Номер Цевря>"
PRINT #1, "'// соответственно переключателям на цифры: 1 - для обработчика"
PRINT #1, "'// первого Цевря, 2 - для второго"
PRINT #1, "        CASE " + CHR$(34) + "CALL " + UCASE$(DB$(2)) + CHR$(34)
PRINT #1, "                " + DB$(2) + " <Номер Цевря>"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. В функции CheckWorm после комментария '// Чем стреляли?"
PRINT #1, "'// находится переключатель, обрабатывающий переменную wep. Вставьте"
PRINT #1, "'// следующие 27 строк в этот переключатель. Эти строки определяют,"
PRINT #1, "'// сколько единиц энергии нужно отнять, при попадании кидалки, у Цевря в"
PRINT #1, "'// зависимости от дальности нахождения Цевря от эпицентра. Рассматриваются"
PRINT #1, "'// промежутки до 1/3, 2/3, и 1 от общего радиуса поражения"
PRINT #1, " "
PRINT #1, "CASE " + CHR$(34) + UCASE$(DB$(2)) + CHR$(34)
num4$ = DB$(2) + "A(4)"
num1$ = DB$(2) + "A(1)"
PRINT #1, "        IF x < WormPos(numofw, 1) + " + num4$ + " / 3 AND x > WormPos(numofw, 1) - " + num4$ + " / 3 AND y > WormPos(numofw, 2) - " + num4$ + " / 3 AND y < WormPos(numofw, 2) + " + num4$ + " / 3 THEN"
PRINT #1, "                IF fl = " + CHR$(34) + "CHECK" + CHR$(34) + " THEN ret = TRUE"
PRINT #1, "                IF fl = " + CHR$(34) + "REAL" + CHR$(34) + " AND Holder(numofw, 10) > 0 THEN"
PRINT #1, "                Holder(numofw, 10) = Holder(numofw, 10) - " + name1$
PRINT #1, "                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, DAMAGE)"
PRINT #1, "                END IF"
PRINT #1, "        ELSEIF x < WormPos(numofw, 1) + 2 * " + num4$ + " / 3 AND x > WormPos(numofw, 1) - 2 * " + num4$ + " / 3 AND y > WormPos(numofw, 2) - 2 * " + num4$ + " / 3 AND y < WormPos(numofw, 2) + 2 * " + num4$ + " / 3 THEN"
PRINT #1, "                IF fl = " + CHR$(34) + "CHECK" + CHR$(34) + " THEN ret = TRUE"
PRINT #1, "                IF fl = " + CHR$(34) + "REAL" + CHR$(34) + " AND Holder(numofw, 10) > 0 THEN"
PRINT #1, "                Holder(numofw, 10) = Holder(numofw, 10) - 2 * " + num1$ + " / 3"
PRINT #1, "                IF Holder(numofw, 10) > 0 THEN"
PRINT #1, "                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "                END IF"
PRINT #1, "                Holder(numofw, 9) = TRUE"
PRINT #1, "        ELSEIF x < WormPos(numofw, 1) + k * " + num4$ + " / 3 AND x > WormPos(numofw, 1) - k * " + num4$ + " / 3 AND y > WormPos(numofw, 2) - k * " + num4$ + " / 3 AND y < WormPos(numofw, 2) + k * " + num4$ + " / 3 THEN"
PRINT #1, "                IF fl = " + CHR$(34) + "CHECK" + CHR$(34) + " THEN ret = TRUE"
PRINT #1, "                IF fl = " + CHR$(34) + "REAL" + CHR$(34) + " AND Holder(numofw, 10) > 0 THEN"
PRINT #1, "                Holder(numofw, 10) = Holder(numofw, 10) - " + num1$ + " / 3"
PRINT #1, "                IF Holder(numofw, 10) > 0 THEN"
PRINT #1, "                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)"
PRINT #1, "                END IF"
PRINT #1, "        END IF"
PRINT #1, " "
PRINT #1, "'// Подсчёт убытков"
PRINT #1, "Holder(numofw, 10) = INT(Holder(numofw, 10))"
PRINT #1, "IF Holder(numofw, 10) <= 0 THEN Holder(numofw, 10) = 0: ret = TRUE"
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. В подпрограмме SetWeapon увеличте переменную NumOfWep"
PRINT #1, "'// на 1. Затем, в раздел Рисунки, вставьте следующие операторы:  "
PRINT #1, " "
PRINT #1, "'// " + DB$(2)
PRINT #1, "x = 5 + (NumOfWep - 1) * 30 + 3 * (NumOfWep - 1) + 15: y = 460"
OPEN DB$(4) FOR INPUT AS #2
        INPUT #2, n$
        FOR acc = 1 TO VAL(n$)
        INPUT #2, A$, B$, c$
        st$ = A$ + "," + B$ + "," + c$
        PRINT #1, st$
        st$ = ""
        NEXT acc
CLOSE #2
PRINT #1, "IF Holder(numofw, " + STR$(DB(1)) + ") = 0 THEN"
PRINT #1, "        LINE (x - 15, 445)-(x + 30, 475), 4"
PRINT #1, "        LINE (x - 15, 475)-(x + 30, 445), 4"
PRINT #1, "END IF"
PRINT #1, " "
PRINT #1, "w = Holder(numofw, 3)"
PRINT #1, "LINE (x - 16, 444)-(x + 16, 476), 15, B"
PRINT #1, " "
PRINT #1, "'// СОВЕТ. Если хотите, чтоб у Цевря после выбора Оружия появлялось"
PRINT #1, "'// нечто похожее, нарисуйте  это нечто в виде операторов и вставьте в"
PRINT #1, "'// переключатель, обрабатывающий элемент массива: Holder(numofw, 3)"
PRINT #1, "'// При этом CASE должен проверять идентификатор Вашего Оружия."
PRINT #1, "'// Если Вы не напортачили, то он равен " + STR$(DB(1))
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Вставьте инициализацию массива Вашего Оружия в основную пргм."
PRINT #1, "'// в раздел Инициализация. Здесь элементы: 1). МАХ повреждение, 2). Радиус поражения,"
PRINT #1, "'// 3). МАХ скорость и 4). Радиус воронки."
PRINT #1, " "
PRINT #1, DB$(2) + "A(1) = " + STR$(DB(4))
PRINT #1, DB$(2) + "A(2) = " + STR$(DB(5))
PRINT #1, DB$(2) + "A(3) = " + STR$(DB(7))
PRINT #1, DB$(2) + "A(4) = " + STR$(DB(6))
PRINT #1, " "
PRINT #1, "'// УКАЗАНИЕ. Инициализируйте также элемент массива Holder() с индексом"
PRINT #1, "'// во втором измерении, обозначающим Ваше Оружие. Он должен быть ра-"
PRINT #1, "'// вен по идее " + STR$(DB(1)) + ". Вы должны задать начальное количество"
PRINT #1, "'// боеприпасов. Если Вы приравняете элемент к отрицательному числу, это"
PRINT #1, "'// будет означать, что припасов бесконечно много."
PRINT #1, " "
PRINT #1, "Holder(1, " + STR$(DB(1)) + ") = ..."
PRINT #1, "Holder(2, " + STR$(DB(1)) + ") = ..."
PRINT #1, " "
PRINT #1, " "
PRINT #1, "'// КОНЕЦ ШАБЛОНА. С вопросами и предложениями обращайтесь по адресу:"
PRINT #1, "'// 309512, г. Старый Оскол Белгородской обл., м-н Жукова, 4-28,"
PRINT #1, "'// Довженко Егор. Или по телефону: (0725) 42-59-59"
PRINT #1, "'//========================================================================"
'///////////////////////////
CLOSE #1
'////////////////////////////////////////////////////////////////////////////
END SUB
