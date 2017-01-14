CLS

PRINT "Копирование ярлыков..."
ON ERROR GOTO 2

'====
MKDIR "C:\Windows\Главно~1\Програ~1\Warlife"

NAME "warlife.lnk" AS "C:\Windows\Главно~1\Програ~1\Warlife\Warlife.lnk"
NAME "warDT.lnk" AS "C:\Windows\Рабочи~1\Warlife.lnk"
NAME "weapcrt.lnk" AS "C:\Windows\Главно~1\Програ~1\Warlife\Weapcrt.lnk"
NAME "Hint.lnk" AS "C:\Windows\Главно~1\Програ~1\Warlife\Hint.lnk"
'====

PRINT "Копирование завершено."
GOTO 3
2 PRINT "Ошибка #" + STR$(ERR): RESUME NEXT

3 END
