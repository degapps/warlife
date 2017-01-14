CLS
CONST NumOfComs = 20

ON ERROR GOTO 100
TYPE Cmt
        Comm AS STRING * 28
END TYPE
DIM SHARED CmtArr AS Cmt

'// Ваш комментарий - наш элемент массива.
DIM C$(NumOfComs)
C$(1) = "Пожалуста, бейтесь."
C$(2) = "Оно пришло..."
C$(3) = "Забабахай-ка чем-нибудь!"
C$(4) = "Удави его, Билли!"
C$(5) = "Время пошло."
C$(6) = "Граната - это хорошо!"
C$(7) = "Зелёная... нет, не лягушка!"
C$(8) = "Врежь ему разрывной!"
C$(9) = "А тебя не самого не замочит?"
C$(10) = "Поосторожней с этим"
C$(11) = "Маузер Дзержинского"
C$(12) = "Влепи ему пять пулек"
C$(13) = "Плюмбум готов"
C$(14) = "Что это за пукалка?"
C$(15) = "Ого, что у тебя есть!"
C$(16) = "Во чё бойся!"
C$(17) = "Гексоген? Тротилл? Пластид?"
C$(18) = "Классно придумал!"
C$(19) = "Динамомит"
C$(20) = "Хрясь таким - и всё..."
'////////////////////////////////////////////////////////////
'// Коррекция длин строк
FOR n = 1 TO NumOfComs
IF LEN(C$(n)) > 28 THEN
        LOCATE 3, 10: PRINT "Строка " + C$(n) + " неверной длины (>28)"
10      LOCATE 4, 10: INPUT "Исправьте её: ", new$
        IF LEN(new$) > 28 THEN
                LOCATE 4, 10: PRINT "                                        "
                GOTO 10
        END IF
        C$(n) = new$
END IF
NEXT n


KILL "sentence.cmt"
OPEN "sentence.cmt" FOR RANDOM AS #1 LEN = LEN(CmtArr)
FOR b = 1 TO NumOfComs
CmtArr.Comm = C$(b)
PUT #1, b, CmtArr.Comm
NEXT b
CLOSE #1

GOTO 101
100 PRINT "Ошибка " + STR$(ERR): RESUME NEXT
101 PRINT "Заполнение файла завершено."
END