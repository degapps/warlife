DECLARE SUB ErrCatch ()

CLS
ON ERROR GOTO 100

'// Открытие файла status.dat
all = 0: creat = 0
OPEN "status.dat" FOR INPUT AS #1
INPUT #1, all, creat, intr
CLOSE #1

'// Корректировка
LOCATE 2, 24: PRINT "Корректор реестра WARLIFE(tm)"
LOCATE 4, 1
INPUT "Количество созданных Вами Оружий: ", nofcrwep
IF nofcrwep < 0 THEN
        LOCATE 5, 1
        PRINT "Данные оставлены по умолчанию."
        nofcrwep = creat
        LOCATE 4, 35: PRINT nofcrwep
END IF

LOCATE 6, 1
INPUT "Общее количество Оружий: ", nofalwep
IF nofalwep < 0 THEN
        LOCATE 6, 26: PRINT all
        LOCATE 7, 1
        PRINT "Данные оставлены по умолчанию."
        nofalwep = all
END IF

'// Пересохранение
OPEN "status.dat" FOR OUTPUT AS #1
PRINT #1, nofalwep, nofcrwep, intr
CLOSE #1

100 ErrCatch
    RESUME NEXT
LOCATE 22, 25: PRINT "Редактирование завершено"

END

SUB ErrCatch
'// Обработчик ошибок
'////////////////////////////////////////////////////////////////////////////
mess$ = ""
SELECT CASE ERR
CASE 53: mess$ = "Файл не найден"
CASE 61: mess$ = "На диске нет места"
CASE 70: mess$ = "Файл защищён от изменений либо используется другой программой"
CASE 75: mess$ = "Путь/файл недоступен"
CASE 76: mess$ = "Путь к файлу не найден"
CASE 20: mess$ = ""
END SELECT
LOCATE 20, 10: PRINT mess$
'////////////////////////////////////////////////////////////////////////////
END SUB
