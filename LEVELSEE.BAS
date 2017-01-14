DECLARE FUNCTION GetColor! (n AS STRING)
DECLARE FUNCTION GetParameter$ (s AS STRING)
DECLARE SUB LoadLevel (n AS STRING)
ON ERROR GOTO 2

CLS
SCREEN 12
WINDOW (0, 0)-(640, 480)
'/////////////////////////////////
'// Имя файла БЕЗ расширения и пути с инструкциями WarM
CONST NameOfFile$ = "Test"

'// Рисуем уровень
LoadLevel (NameOfFile$)

'// Открываем текст инструкций (если это Вас не устраивает, закомару сделайте
SHELL "C:\Windows\notepad.exe" + " User\Levels\" + NameOfFile$

2 RESUME NEXT

END

FUNCTION GetColor (n AS STRING)
        SELECT CASE n
        CASE "black": col = 0
        CASE "blue": col = 1
        CASE "dgreen": col = 2
        CASE "dturq": col = 3
        CASE "dred": col = 4
        CASE "dviolet": col = 5
        CASE "brown": col = 6
        CASE "grey": col = 7
        CASE "dgrey": col = 8
        CASE "neon": col = 9
        CASE "green": col = 10
        CASE "turq": col = 11
        CASE "red": col = 12
        CASE "violet": col = 13
        CASE "yellow": col = 14
        CASE "white": col = 15
        CASE ELSE: col = 0
        END SELECT
GetColor = col
END FUNCTION

FUNCTION GetParameter$ (s AS STRING)
'// Выбираем параметр
'// Параметр - символы, находящиеся между запятыми
'////////////////////////////////////////////////////////////////////////////
res$ = ""

'// Функция возвращает найденный параметр и отрезает его от переданной строки
FOR n = 1 TO LEN(s)
IF MID$(s, n, 1) = "," THEN
        s = MID$(s, n + 1, LEN(s) - n)
        GetParameter$ = RTRIM$(LTRIM$(res$))
        EXIT FUNCTION
ELSE
        res$ = res$ + MID$(s, n, 1)
        IF LEN(s) = n THEN s = ""
END IF
NEXT n
'////////////////////////////////////////////////////////////////////////////
GetParameter$ = RTRIM$(LTRIM$(res$))

END FUNCTION

SUB LoadLevel (nm AS STRING)
dcoef = 3.14159 / 180
440
CLS

name$ = "User\Levels\" + NameOfFile$ + ".txt"
xlim = 641: ylim = 441: col = 14

'// Открываем файл с графическими инструкциями (если он есть)
OPEN name$ FOR INPUT AS #1

'// Пока не закончится...
WHILE NOT EOF(1)
IF ERR THEN EXIT SUB
'// Обрабатываем
INPUT #1, ins$
ins$ = LTRIM$(RTRIM$(ins$))
com$ = LEFT$(ins$, 2): ins$ = LTRIM$(RTRIM$(MID$(ins$, 3, LEN(ins$) - 2)))

'// Чистка от пробелов строки ins$
ni$ = ""
FOR n = 1 TO LEN(ins$)
IF MID$(ins$, n, 1) <> " " THEN ni$ = ni$ + MID$(ins$, n, 1)
NEXT n
ins$ = ni$

SELECT CASE com$
CASE "fm"
        w$ = "": f$ = ""
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        l = VAL(GetParameter$(ins$))
        h = VAL(GetParameter$(ins$))
        w$ = GetParameter$(ins$)
        IF VAL(w$) < 5 THEN w = 5 ELSE w = VAL(w$)
        IF w$ = "" THEN w = 1
        f$ = GetParameter$(ins$)
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                FOR tt = 0 TO w
                IF f$ <> "" THEN
                        LINE (x + tt, y + tt)-(x + l - tt, y + h - tt), col, BF
                        EXIT FOR
                ELSE
                        LINE (x + tt, y + tt)-(x + l - tt, y + h - tt), col, B
                END IF
                NEXT tt
        END IF

CASE "pn"
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        cl1$ = GetParameter$(ins$)
        cl2$ = GetParameter$(ins$)
        cmain = GetColor(cl1$)
        cbord = GetColor(cl2$)
        PAINT (x, y), cmain, cbord

CASE "vw"
        k$ = "": A$ = "": w$ = ""
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        l = VAL(GetParameter$(ins$))
        w$ = GetParameter$(ins$)
        IF w$ = "" OR VAL(w$) < 5 THEN w = 5 ELSE w = VAL(w$)
        A$ = GetParameter$(ins$)
        IF A$ = "" OR VAL(A$) = 0 THEN A = 5 ELSE A = VAL(A$)
        k$ = GetParameter$(ins$)
        IF k$ = "" OR VAL(k$) = 0 THEN k = 5 ELSE k = VAL(k$)
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                FOR tt = 0 TO w
                oldx = 0: oldy = 0
                FOR ys = 0 TO l
                        xs = A * SIN(ys * k * dcoef)
                        LINE (oldx + x + tt, oldy + y)-(xs + x + tt, ys + y), col
                        oldx = xs: oldy = ys
                NEXT ys
                NEXT tt
        END IF

CASE "wv"
        k$ = "": A$ = "": w$ = ""
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        l = VAL(GetParameter$(ins$))
        w$ = GetParameter$(ins$)
        IF w$ = "" OR VAL(w$) < 5 THEN w = 5 ELSE w = VAL(w$)
        A$ = GetParameter$(ins$)
        IF A$ = "" OR VAL(A$) = 0 THEN A = 5 ELSE A = VAL(A$)
        k$ = GetParameter$(ins$)
        IF k$ = "" OR VAL(k$) = 0 THEN k = 5 ELSE k = VAL(k$)
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                FOR tt = 0 TO w
                oldx = 0: oldy = 0
                FOR xs = 0 TO l
                        ys = A * SIN(xs * k * dcoef)
                        LINE (oldx + x, oldy + tt + y)-(xs + x, tt + ys + y), col
                        oldx = xs: oldy = ys
                NEXT xs
                NEXT tt
        END IF

CASE "cr"
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        R = VAL(GetParameter$(ins$))
        IF R < 2 THEN R = 2
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                CIRCLE (x, y), R, col: PAINT (x, y), col
        END IF
        FOR B = 0 TO 360
        PAINT (x + (R - 1) * COS(A * dcoef), y + (R - 1) * SIN(A * dcoef)), col
        NEXT B
      
CASE "rg"
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        R = VAL(GetParameter$(ins$))
        Sr = VAL(GetParameter$(ins$))
        IF R < 3 THEN R = 3
        IF R <= Sr THEN Sr = R / 2
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                CIRCLE (x, y), R, col: PAINT (x, y), col
                CIRCLE (x, y), Sr, 0: PAINT (x, y), 0
        END IF
        FOR B = 0 TO 360
        PAINT (x + (Sr + 1) * COS(A * dcoef), y + (Sr + 1) * SIN(A * dcoef)), col
        PAINT (x + (Sr - 1) * COS(A * dcoef), y + (Sr - 1) * SIN(A * dcoef)), 0
        NEXT B

CASE "cl"
        SELECT CASE GetParameter$(ins$)
        CASE "black": col = 0
        CASE "blue": col = 1
        CASE "dgreen": col = 2
        CASE "dturq": col = 3
        CASE "dred": col = 4
        CASE "dviolet": col = 5
        CASE "brown": col = 6
        CASE "grey": col = 7
        CASE "dgrey": col = 8
        CASE "neon": col = 9
        CASE "green": col = 10
        CASE "turq": col = 11
        CASE "red": col = 12
        CASE "violet": col = 13
        CASE "yellow": col = 14
        CASE "white": col = 15
        END SELECT

CASE "gd"
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        l = VAL(GetParameter$(ins$))
        w = VAL(GetParameter$(ins$))
        A$ = GetParameter$(ins$)
        SELECT CASE A$
        CASE "-": A = 0
        CASE "|": A = 90
        CASE "/": A = 45
        CASE "\": A = 135
        CASE ELSE: A = VAL(A$)
        END SELECT
        IF l < w THEN SWAP w, l
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                FOR tt = 0 TO w STEP .03
                x2 = x + l * COS(A * dcoef)
                y2 = y + l * SIN(A * dcoef)
                xa = -tt * SIN(A * dcoef)
                ya = tt * COS(A * dcoef)
                LINE (x + xa, y + ya)-(x2 + xa, y2 + ya), col
                NEXT tt
        END IF
CASE "pt"
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                PSET (x, y), col
        END IF

END SELECT
WEND
CLOSE #1

2202
LINE (0, 441)-(640, 480), 0, BF
'// Неразрушимая граница
IF UNBORDER = TRUE THEN
        LINE (0, 0)-(640, 440), 15, B
        LINE (10, 10)-(630, 430), 15, B
        PAINT (2, 2), 15
END IF
COLOR 15
'////////////////////////////////////////////////////////////////////////////

END SUB
