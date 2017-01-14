'/////////////////////////////////////////////////////////////////////////
'// WarLife v1.0                                                        //
'// Copyright (ã) 2001-2017 Egor Dovzhenko (©¬Öá §Öëé¨ÔÆÖ).             //
'// ÝÖ ÒÖå·ë Ò ó û0åÔÖ½ ·¬áñ Worms Öå Team17                            //
'// ÝáÖ¨Æå Ô û å 19.04.2001, ÖÆÖÔû¨Ô 12.05.2001                         //
'// Project started on April 19, finished on May 12, 2001               //
'// æ¨ãå·áç¨Ò Þ ë¨áã·Þ. äëÖ¢Ö¦ÔÖ á ãØáÖãåá ÔÞ¨Ò Þ.                      //
'// Beta-version. Freeware.                                             //
'// ¸Ò¨œåãÞ ëÖØáÖãñ? Ý·õ·å¨:                                            //
'// E-mail: deg.apps@gmail.com                                          //
'// £ç¦ç ë¨ãíÒ  Øá·óÔ å¨Ð¨Ô, ¨ãÐ· ÆåÖ-åÖ ¦Öá ¢Öå ¨å, ÒÖ¦·ª·¤·áç¨å ·Ð·   //
'// ÖØå·Ò·ó·áç¨å ÒÖœ ØáÖ¬á ÒÒç · Øá·õÐ„å ÒÔ¨ ÷Æó¨ÒØÐÞá.                 //
'// Optimization, upgrades and enhancement of the app is highly         //
'// appreciated! :)                                                     //
'// Use QB64 to run: http://www.qb64.net                                //
'//                                                               Deg   //
'/////////////////////////////////////////////////////////////////////////
1
DECLARE FUNCTION GetColor! (n AS STRING)
DECLARE FUNCTION CheckWorm! (x!, y!, numofw!, wep AS STRING, fl AS STRING)
DECLARE FUNCTION GetParameter$ (s AS STRING)
DECLARE SUB LoadLevel ()
DECLARE SUB Introduction ()
DECLARE SUB UpdateGraphics (index!)
DECLARE FUNCTION GetComment$ (lfrom!, lto!)
DECLARE FUNCTION GetYesNo! (mess AS STRING)
DECLARE FUNCTION MainMenu! ()
DECLARE SUB WormDead (numofw!)
DECLARE SUB Dynamite (numofw!)
DECLARE FUNCTION Worm2Active$ (param AS STRING)
DECLARE FUNCTION Worm1Active$ (param AS STRING)
DECLARE SUB SetWeapon (numofw!)
DECLARE SUB Shotgun (numofw!)
DECLARE SUB Grenade (numofw!)
DECLARE SUB EndGame ()
DECLARE SUB GetVelocity (numofw!)
DECLARE FUNCTION SetTarget! (numofw!, multip AS STRING, fl!)
DECLARE FUNCTION SetWorm! (x!, y!, posit!, num!, ind!)
DECLARE SUB GenerateLevel (tpe!, mode!)
'// ô ãå ëÖûÆ 
CALL Introduction

SLEEP 1000

'// ×û·ù ¨Ò Ø ÒÞåí ¦ÐÞ ¥¨ëáÞûÆÖë
CLEAR

'// äÐ¨éÆ  ó  ÆÖë áÔñÒ· ¨ááÖá Ò·
ON ERROR GOTO 999
CLS
SCREEN 12
WINDOW (0, 0)-(640, 480)
'=======================Ç×Õäæ¡Õæò=============================
CONST FALSE = 0, TRUE = NOT FALSE, DAMAGE = 3, REDRAW = 4, INTRO = 5
CONST pi = 3.141592654#
CONST dcoef = pi / 180
CONST LEFT = 1, RIGHT = 2
CONST SIMPLE = 1, HARD = 3, NORMAL = 2
CONST NumOfComs = 20
CONST GrassColor = 2
CONST GroundColor = 6
CONST NumOfHoles = 0
CONST StopHeight = 15
CONST GREY = 7
CONST DGREY = 8
CONST GREEN = 6
CONST RED = 6
CONST WHITE = 15
CONST BLACK = 0
CONST UNBORDER = TRUE
CONST TurnTime = 30
CONST TargetLineLen = 30
CONST TargetColor = 10
CONST g = 9.78
CONST MaxGrenadeSpeed = 70
CONST MaxWormEnergy = 200
ExternLevel = FALSE
'=============================æ¸Ýò============================
TYPE Cmt
        Comment AS STRING * 28
END TYPE
DIM SHARED CmtArr AS Cmt
'=======================Ó¡ää¸ìò=×âèê¸à========================
DIM SHARED GrenadeA(n)
REDIM GrenadeA(4)
GrenadeA(1) = 50
GrenadeA(2) = 35
GrenadeA(3) = 70
GrenadeA(4) = 25
DIM SHARED ShotgunA(n)
REDIM ShotgunA(4)
ShotgunA(1) = 5
ShotgunA(2) = 3
ShotgunA(3) = 5
ShotgunA(4) = 3
DIM SHARED DynamiteA(n)
REDIM DynamiteA(4)
DynamiteA(1) = 50
DynamiteA(2) = 60
DynamiteA(3) = FALSE
DynamiteA(4) = 50
'==========================Ó¡ää¸ìò============================
DIM SHARED Scr(n)
REDIM Scr(1000)
DIM SHARED WormPos(n, c)
REDIM WormPos(2, 4)
DIM SHARED Holder(n, c)
REDIM Holder(2, 20)
'// §ÐÞ ãØá ½åÖë
DIM SHARED W1Pic(n)
REDIM W1Pic(150)
DIM SHARED W2Pic(n)
REDIM W2Pic(150)
DIM SHARED Cursor(n)
REDIM Cursor(23)
DIM SHARED Weapon(n)
REDIM Weapon(110)
DIM SHARED LastComment$(n)
REDIM LastComment$(1)
'==========================¸Õ¸¥¸¡Ñ¸ô¡¥¸à=========================
index = 0: '// Õ¨ åáÖ¬ åí!
Holder(1, 2) = TRUE: '// ¶Ö¦·å Ø¨áëñ½
Holder(2, 2) = FALSE: '// ìåÖáÖ½ Öå¦ñµ ¨å
Holder(1, 13) = -1: '//­á Ô å ÒÔÖ¬Ö
Holder(2, 13) = -1: '//­á Ô å ÒÔÖ¬Ö
Holder(1, 11) = -1 * 5: '//Ý åáÖÔÖë ÒÔÖ¬Ö
Holder(2, 11) = -1 * 5: '//Ý åáÖÔÖë ÒÔÖ¬Ö
Holder(1, 12) = -1: '//ìóáñëû åÆ· ÒÔÖ¬Ö
Holder(2, 12) = -1: '//ìóáñëû åÆ· ÒÔÖ¬Ö
Holder(1, 3) = 3
Holder(2, 3) = 3
Holder(1, 9) = FALSE
Holder(2, 9) = FALSE
Holder(1, 10) = MaxWormEnergy
Holder(2, 10) = MaxWormEnergy
'=============================================================
11011
index = MainMenu
SELECT CASE index
CASE 1
        GOTO 555
CASE 2
        SHELL "C:\Windows\notepad.exe Hint.txt"
        RUN "warlife.bas"
CASE 3
        GOTO 11011
CASE 4
        ExternLevel = TRUE
CASE 5
        RUN "weapcrt.bas"
CASE 6
        i = SetWorm(270, 312, RIGHT, 1, INTRO)
        i = GetYesNo("èµÖ¦·å¨ çé¨?")
        IF i = 1 THEN
                CLS
                acc = 1
                FOR x = 10 TO 630 STEP 80
                PLAY "MB o3 l32 CEG"
                FOR y = 450 TO 30 STEP -60
                IF acc = 1 THEN
                        i = SetWorm(x, y, RIGHT, 1, INTRO)
                        acc = 2
                ELSE
                        i = SetWorm(x, y, LEFT, 1, INTRO)
                        acc = 1
                END IF
                NEXT y
                NEXT x
        OPEN "status.dat" FOR INPUT AS #1
        INPUT #1, a, B, c
        CLOSE #1
        c = TRUE
        OPEN "status.dat" FOR OUTPUT AS #1
        PRINT #1, a, B, c
        CLOSE #1
        PLAY "MB o3 l8 C l8 D l8 E l4 F o4 l64 E l8 F"
        END
        END IF
        GOTO 11011
END SELECT
555
'// ­¨Ô¨á ¤·Þ çáÖëÔÞ, çãå ÔÖëÆ  ¥¨ëá¨½, Ø¨á¨¦ û  µÖ¦Öë
IF ExternLevel = FALSE THEN
        GenerateLevel SIMPLE, SIMPLE
ELSE LoadLevel
END IF

UpdateGraphics 0
i = SetWorm(50, 400, RIGHT, 1, FALSE)
i = SetWorm(450, 400, LEFT, 2, FALSE)

'// ÇÖÒÒ¨Ôå  á·¦? Ççã·Òçã¨¦?
LastComment$(1) = GetComment(1, 5)

998
IF Holder(1, 2) = TRUE THEN
IF WormPos(1, 1) < 0 THEN 1
        Holder(1, 2) = FALSE
        Holder(2, 2) = TRUE
        i$ = Worm1Active$("")
        SELECT CASE i$
        CASE "EXIT"
                GOTO 11011
        CASE "CALL GRENADE"
                Grenade 1
        CASE "CALL SHOTGUN"
                Shotgun 1
        CASE "CALL DYNAMITE"
                Dynamite 1
        END SELECT
LOCATE 2, 27: PRINT "                            "
END IF
IF Holder(1, 2) = FALSE THEN
IF WormPos(1, 1) < 0 THEN 1
        Holder(1, 2) = TRUE
        Holder(2, 2) = FALSE
        i$ = Worm2Active$("")
        SELECT CASE i$
        CASE "EXIT"
                GOTO 11011
        CASE "CALL GRENADE"
                Grenade 2
        CASE "CALL SHOTGUN"
                Shotgun 2
        CASE "CALL DYNAMITE"
                Dynamite 2
        END SELECT
LOCATE 2, 27: PRINT "                            "
END IF
GOTO 998

999     IF ERR = 53 THEN
                CLS : COLOR 4: LOCATE 10, 33: PRINT "FILE NOT FOUND": SLEEP
                RUN "warlife.bas"
        END IF
        RESUME NEXT
1000 END
'////////////////////////////SUBROUTINES/////////////////////////

FUNCTION CheckWorm (x, y, numofw, wep AS STRING, fl AS STRING)
'// ÝáÖë¨áÆ  Ô  åáçØÔÖãåí
'////////////////////////////////////////////////////////////////////////////

flag = FALSE
'// ÝÖ çÒÖÐû Ô·œ ¥¨ëáí é·ë
ret = FALSE

'// Ýá· çë¨Ð·û¨Ô·· û·ãÐ  ¥¨ëá¨½ åçå Ô ¦Ö ¢ç¦¨å ûçåÖûÆç ØÖ¦õ Ò Ô·åí

k = 2.4
'// ü¨Ò ãåá¨ÐÞÐ·?
oldHolder = Holder(numofw, 10)
SELECT CASE wep
CASE "GRENADE"
        IF x < WormPos(numofw, 1) + GrenadeA(4) / 3 AND x > WormPos(numofw, 1) - GrenadeA(4) / 3 AND y > WormPos(numofw, 2) - GrenadeA(4) / 3 AND y < WormPos(numofw, 2) + GrenadeA(4) / 3 THEN
                flag = TRUE
                IF fl = "CHECK" THEN ret = TRUE
                IF fl = "REAL" AND Holder(numofw, 10) > 0 THEN
                Holder(numofw, 10) = Holder(numofw, 10) - GrenadeA(1)
                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, DAMAGE)
                END IF
        ELSEIF x < WormPos(numofw, 1) + 2 * GrenadeA(4) / 3 AND x > WormPos(numofw, 1) - 2 * GrenadeA(4) / 3 AND y > WormPos(numofw, 2) - 2 * GrenadeA(4) / 3 AND y < WormPos(numofw, 2) + 2 * GrenadeA(4) / 3 THEN
                flag = TRUE
                IF fl = "CHECK" THEN ret = TRUE
                IF fl = "REAL" AND Holder(numofw, 10) > 0 THEN
                Holder(numofw, 10) = Holder(numofw, 10) - 2 * GrenadeA(1) / 3
                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, DAMAGE)
                END IF
                Holder(numofw, 9) = TRUE
        ELSEIF x < WormPos(numofw, 1) + k * GrenadeA(4) / 3 AND x > WormPos(numofw, 1) - k * GrenadeA(4) / 3 AND y > WormPos(numofw, 2) - k * GrenadeA(4) / 3 AND y < WormPos(numofw, 2) + k * GrenadeA(4) / 3 THEN
                flag = TRUE
                IF fl = "CHECK" THEN ret = TRUE
                IF fl = "REAL" AND Holder(numofw, 10) > 0 THEN
                Holder(numofw, 10) = Holder(numofw, 10) - GrenadeA(1) / 3
                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, DAMAGE)
                END IF
        END IF

'// ÝÖ¦ãû„å ç¢ñåÆÖë
IF fl = "REAL" THEN
Holder(numofw, 10) = INT(Holder(numofw, 10))
IF Holder(numofw, 10) <= 0 THEN Holder(numofw, 10) = 0: ret = TRUE
END IF

CASE "SHOTGUN"
        IF x > WormPos(numofw, 1) - ShotgunA(2) AND x < WormPos(numofw, 1) + 16 + ShotgunA(2) AND y > WormPos(numofw, 2) - ShotgunA(2) AND y < WormPos(numofw, 2) + 20 + ShotgunA(2) THEN
                IF fl = "CHECK" THEN ret = TRUE
                IF fl = "REAL" AND Holder(numofw, 10) > 0 THEN
                Holder(numofw, 10) = Holder(numofw, 10) - ShotgunA(1)
                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)
                END IF
        END IF

'// ÝÖ¦ãû„å ç¢ñåÆÖë
IF fl = "REAL" THEN
Holder(numofw, 10) = INT(Holder(numofw, 10))
IF Holder(numofw, 10) <= 0 THEN Holder(numofw, 10) = 0: ret = TRUE
END IF

CASE "DYNAMITE"
        IF x < WormPos(numofw, 1) + DynamiteA(4) / 3 AND x > WormPos(numofw, 1) - DynamiteA(4) / 3 AND y > WormPos(numofw, 2) - DynamiteA(4) / 3 AND y < WormPos(numofw, 2) + DynamiteA(4) / 3 THEN
                IF fl = "CHECK" THEN ret = TRUE
                IF fl = "REAL" AND Holder(numofw, 10) > 0 THEN
                Holder(numofw, 10) = Holder(numofw, 10) - DynamiteA(1)
                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, DAMAGE)
                END IF
        ELSEIF x < WormPos(numofw, 1) + 2 * DynamiteA(4) / 3 AND x > WormPos(numofw, 1) - 2 * DynamiteA(4) / 3 AND y > WormPos(numofw, 2) - 2 * DynamiteA(4) / 3 AND y < WormPos(numofw, 2) + 2 * DynamiteA(4) / 3 THEN
                flag = TRUE
                IF fl = "CHECK" THEN ret = TRUE
                IF fl = "REAL" AND Holder(numofw, 10) > 0 THEN
                Holder(numofw, 10) = Holder(numofw, 10) - 2 * DynamiteA(1) / 3
                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, DAMAGE)
                END IF
        ELSEIF x < WormPos(numofw, 1) + k * DynamiteA(4) / 3 AND x > WormPos(numofw, 1) - k * DynamiteA(4) / 3 AND y > WormPos(numofw, 2) - k * DynamiteA(4) / 3 AND y < WormPos(numofw, 2) + k * DynamiteA(4) / 3 THEN
                flag = TRUE
                IF fl = "CHECK" THEN ret = TRUE
                IF fl = "REAL" AND Holder(numofw, 10) > 0 THEN
                Holder(numofw, 10) = Holder(numofw, 10) - DynamiteA(1) / 3
                i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, DAMAGE)
                END IF
        END IF


'// ÝÖ¦ãû„å ç¢ñåÆÖë
IF fl = "REAL" THEN
Holder(numofw, 10) = INT(Holder(numofw, 10))
IF Holder(numofw, 10) <= 0 THEN Holder(numofw, 10) = 0: ret = TRUE
END IF

'CASE <ü¨Ò-åÖ ¨ù„>
'<Ç Æ ¨¬Ö ó ÒÖû·ÐÖ>
END SELECT

'i = SetWorm(WormPos(1, 1), WormPos(1, 2), Holder(1, 1), 1, REDRAW)
'i = SetWorm(WormPos(2, 1), WormPos(2, 2), Holder(2, 1), 2, REDRAW)

'// ìÖóëá ù ¨Ò Ð·¢Ö ØÖµÖáÖÔÆç, Ð·¢Ö Øá·ë¨å
'////////////////////////////////////////////////////////////////////////////
CheckWorm = ret
END FUNCTION

SUB Dynamite (numofw)
'// §·Ô Ò·å
'////////////////////////////////////////////////////////////////////////////
'// ×¢ÔÖëÐÞ¨Ò ¥¨ëáÞ
i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)

'// ÝáÖë¨áÞ¨Ò Ô Ð·û·¨ ëóáñëû åÆ·
IF Holder(numofw, 12) = 0 THEN
        '// ×¢ÔÖëÐÞ¨Ò ¥¨ëáÞ
        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)

        '// äÖÖ¢ù¨Ô·¨ Ö¢ Öåãçåãë·· ¢Ö¨Øá·Ø ãÖë
EXIT SUB
ELSEIF Holder(numofw, 12) > 0 THEN
        Holder(numofw, 12) = Holder(numofw, 12) - 1
END IF

'// ÝÖ¦Ö¦ë·¬ ¨Ò ûçåí, ûåÖ¢ñ Ô¨ ó ÒÖû·åí ãëÖ¨¬Ö ¥¨ëáÞ ãá óç
IF Holder(numofw, 1) = RIGHT THEN
        x0 = WormPos(numofw, 1) + 23
ELSEIF Holder(numofw, 1) = LEFT THEN
        x0 = WormPos(numofw, 1) - 7
END IF
y0 = WormPos(numofw, 2)

'// ÕçéÔÖ ¦ÐÞ ëñëÖ¦  ãØá ½å  Øá· ãÐ¨¦çœù¨Ò ëñóÖë¨
oldx = x0: oldy = y0

'// ÇÖ÷ªª·¤·¨Ôå "¦ ÐíÔÖë·¦ÔÖãå·" ¦·Ô Ò·å  (ØÖ·ãÆ åë¨á¦Ö½ óÖÔñ)
d = 2

'// â ¦·çã ¦ñáÆ· Öå ØçÐ· ·ó Ò ãã·ë  DynamiteA()
R = DynamiteA(4)

'// è¢·á ¨Ò Æá¨ãå·Æ-ÒçõÆç,   åÖ ¨„ Ô¨Øá ë·ÐíÔÖ ØÖ½Òçå, Æ Æ åë¨á¦çœ óÖÔç
i = SetTarget(numofw, "-", FALSE)

flag = FALSE

'// äåá¨ÐÞ¨Ò
x = x0: y = y0
IF POINT(x, y - 2) = 0 AND POINT(x + 1, y - 2) = 0 AND POINT(x + 2, y - 2) = 0 THEN
        FOR t = 0 TO 1000 STEP .1
       
        flag = TRUE

        IF t > 0 THEN
        IF POINT(x, y - 2) <> 0 THEN GOTO 910
        END IF

'// ©ãÐ· ØÖÐ„å åÖÐíÆÖ Ô û ÐãÞ, ãØá ½å Ô¨ ëñëÖ¦·åãÞ
        IF t > 0 THEN PUT (oldx - 12, oldy - 12), Weapon(1), PSET

        IF t > 0 THEN
                y = y - 1
        END IF

'// Ý¨á¨ÖØá¨¦¨Ð¨Ô·¨ "ãå áíÞ"
        oldx = x: oldy = y

'// ÇÖÖá¦·Ô åñ ¢ ¢ µ ÐÆ· - ë Ò ãã·ë
        Holder(numofw, 7) = x
        Holder(numofw, 8) = y

'// £¨á„Ò Ö¢á ó, ûåÖ ëØ¨á¨¦·
        GET (x - 12, y + 12)-(x + 12, y - 12), Weapon(1)

'// â·ãç¨Ò
        LINE (x - 1, y)-(x + 2, y + 6), 4, BF
        LINE (x, y + 1)-(x, y + 5), 12
        CIRCLE (x + 2, y + 8), 2, 14, pi / 2, pi

'// Ñ„å ¨Ò ë Worm#Active
        IF numofw = 1 THEN i$ = Worm1Active$("THRU") ELSE i$ = Worm2Active("THRU")
       
        NEXT t
END IF
910

'// â·ãç¨Ò
        LINE (x - 1, y)-(x + 2, y + 6), 4, BF
        LINE (x, y + 1)-(x, y + 5), 12
        CIRCLE (x + 2, y + 8), 2, 14, pi / 2, pi

FOR t = 1 TO 2000
'// Ñ„å ¨Ò ë Worm#Active
        IF numofw = 1 THEN i$ = Worm1Active$("THRU") ELSE i$ = Worm2Active("THRU")
'// Ý¨á¨á·ãÖëñë ¨Ò
        LINE (x - 1, y)-(x + 2, y + 6), 4, BF
        LINE (x, y + 1)-(x, y + 5), 12
        CIRCLE (x + 2, y + 8), 2, 14, pi / 2, pi
NEXT t

'// ×¢á ¢ÖåÆ  ¦ñá¨Ô·
'// äå·á ¨Ò Æ áå·ÔÆç, - Ô¨ ãå ÐÖ ¨„ ¢ÖÐíõ¨!..
        LINE (x - 3, y - 3)-(x + 3, y + 11), 0, BF

'// ×¢ÔçÐ¨Ô·¨ å ½Ò 
        t = 0

'// ìáÖ¦¨ Æ Æ óëçÆ, ûåÖ Ð·...
        SOUND 40, 2

'// §ñáÆ 
        CIRCLE (x, y), R, 0: PAINT (x, y), 0

'// ¥·ÆÐ ó Æá ãÆ· Æá ½Ô·µ Ö¢Ð ãå¨½ ÖÆáçéÔÖãå· (çÐçûõ¨Ô·¨ ó Æá ãÆ·)
        FOR a = 0 TO 360 STEP 5
        PAINT (x + (R - 4) * COS(a * dcoef), y + (R - 4) * SIN(a * dcoef)), 0
        NEXT a

'// ÝáÖë¨áÞ¨Ò, Ô¨ Øá·¢·ÐÖ Ð· ¥¨ëáÞ
        FOR n = 1 TO 2
        i = CheckWorm(x, y, n, "DYNAMITE", "CHECK")
        IF i = TRUE THEN
                IF num = 1 THEN
                PUT (WormPos(num, 1), WormPos(num, 2)), W1Pic, PSET
                ELSEIF num = 2 THEN
                PUT (WormPos(num, 1), WormPos(num, 2)), W2Pic, PSET
                END IF
                xc = WormPos(num, 1)
                yc = WormPos(num, 2)
        IF num = 1 THEN GET (xc, yc + 20)-(xc + 17, yc), W1Pic
        IF num = 2 THEN GET (xc, yc + 20)-(xc + 17, yc), W2Pic
        END IF
        i = CheckWorm(x, y, n, "DYNAMITE", "REAL")
       
        IF i = TRUE THEN
                WormDead n
                WormPos(n, 1) = -1
        END IF
        NEXT n

'// ÝÖØá ëÐÞ¨Ò ¬á ª·Æç
        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)
        UpdateGraphics 0
'////////////////////////////////////////////////////////////////////////////
END SUB

SUB EndGame
'// ô ë¨áõ¨Ô·¨ ·¬á ûÆ·
'/////////////////////////////////////////////////////////////////////////////
OPEN "status.dat" FOR INPUT AS #1
INPUT #1, a, B, c
CLOSE #1
c = TRUE
OPEN "status.dat" FOR OUTPUT AS #1
PRINT #1, a, B, c
CLOSE #1
END
END SUB

SUB GenerateLevel (tpe, mode)
'// äÖó¦ Ô·¨ Ð Ô¦õ ªå 
'////////////////////////////////////////////////////////////////////////////
'// ÕçéÔñ ¢ç¦çå ãÐçû ½Ôñ¨ û·ãÐ 
RANDOMIZE TIMER

CLS

'// ôÔ û¨Ô·Þ å·Ø  default
Hillnum = 10
Critical = 30

'// ìÔçåá¨ÔÔ¨ Ô¨Ö¢µÖ¦·ÒÖ¨ û·ãÐÖ
num = 40

'// æ·Ø óÖÔñ (û·ãÐÖ µÖÐÒÖë) (çãÐÖëÔÖ!)
IF tpe = HARD THEN Hillnum = 15: num = 40
IF tpe = SIMPLE THEN Hillnum = 3: num = 10

9
'// â·ãÖë Ô·¨ · ÒÔÖé¨ãåëÖ ØáÖë¨áÖÆ
FOR n = 1 TO num
10
x = INT(RND * 640)
y = INT(RND * 100)
R = INT(RND * 50 + 20)
IF n > 1 THEN
'// äÒÖåá·Ò, Ô¨ ó ãåáÞÐ  Ð· ÆÖÖá¦·Ô å  µ ë Æ ÆÖÒ-åÖ Ö¦ÔÖÒ · åÖÒ é¨ çû ãåÆ¨
        IF x < oldcx + Critical AND x > oldcx - Critical THEN
                RANDOMIZE TIMER
                num = num - n
                GOTO 9
        END IF
'// ä y åÖ é¨
        IF y < oldcy + Critical AND x > oldcy - Critical THEN
                RANDOMIZE TIMER
                num = num - n
                GOTO 9
        END IF
'// Õ¨ ëãå ëÐÞ¨åãÞ Ð· Ö¦Ô  ÖÆáçéÔÖãåí ë ¦áç¬çœ?
        IF x < oldx + 3 / 4 * oldR THEN GOTO 10
        IF oldx = x - R OR oldx = x + R THEN
                FOR rs = R TO 0 STEP -1
                CIRCLE (x, y), rs, 14
                NEXT rs
        ELSE
                GOTO 10
        END IF
ELSE
        FOR rs = R TO 0 STEP -1
        CIRCLE (x, y), rs, 14
        NEXT rs
        oldcx = x: oldcy = y
END IF
oldx = x: oldy = y: oldR = R
NEXT n

'// ©ù„ û ãåí ¬¨Ô¨á ¤·· (ëëñãí)

'// Ýá¨¦¨Ðñ ëñãÖå · õ·á·Ôñ
FHillX1 = INT(RND * 200 + 50)
FHillX2 = INT(RND * 340 + 150)
SHillX1 = INT(RND * 450 + 350)
SHillX2 = INT(RND * 580 + 500)
FHillY1 = INT(RND * 300 + 170)
SHillY1 = INT(RND * 250 + 190)

FOR n = 1 TO Hillnum
x = INT(RND * FHillX2 + FHillX1)
y = INT(RND * FHillY1)
R = INT(RND * 50 + 30)
FOR rs = R TO 0 STEP -1
CIRCLE (x, y), rs, 14
NEXT rs
NEXT n
FOR n = 1 TO Hillnum
x = INT(RND * SHillX2 + SHillX1)
y = INT(RND * SHillY1)
R = INT(RND * 50 + 30)
FOR rs = R TO 0 STEP -1
CIRCLE (x, y), rs, 14
NEXT rs
NEXT n

'// ¶·åáñ½ Ò Ô„ëá ¦ÐÞ Æ û¨ãåë¨ÔÔÖ½ ó Æá ãÆ· (know-how, ¨ãÐ· µÖå·å¨)
PAINT (1, 480), 11, 14
FOR x = 1 TO 640 STEP 20
FOR y = 1 TO 480 STEP 20
IF POINT(x, y) = 14 THEN PAINT (x, y), 2, 11
NEXT y
NEXT x
PAINT (1, 480), 0, 2
FOR x = 1 TO 640 STEP 20
FOR y = 1 TO 480 STEP 20
IF POINT(x, y) = 2 THEN PAINT (x, y), 14, 0
NEXT y
NEXT x

'// §ñáÖû¨Æ Ô¨ÒÔÖ¬Ö
FOR n = 1 TO NumOfHoles
        x = INT(RND * 640)
        y = INT(RND * 480)
        R = INT(RND * 50 + 20)
        CIRCLE (x, y), R, 0: PAINT (x, y), 0
        FOR xs = x - R TO x + R STEP 5
        IF POINT(xs, y) = 14 THEN
                PAINT (xs, y), 0
                EXIT FOR
        END IF
        NEXT xs
        FOR ys = y - R TO y + R STEP 5
        IF POINT(x, ys) = 14 THEN
                PAINT (s, ys), 0
                EXIT FOR
        END IF
        NEXT ys
NEXT n

'// ©ãÐ· ìñ ã¦¨Ð ¨å¨ ëÖ¦ç, åÖ ç¦ Ð·å¨ ãåáÖÆç, Ô µÖ¦ÞùçœãÞ Ô·é¨
LINE (10, 10)-(630, 30), 14, BF

'// Õ¨á óáçõ·Ò Þ ¬á Ô·¤ 
IF UNBORDER = TRUE THEN
        LINE (0, 0)-(640, 440), 15, B
        LINE (10, 10)-(630, 430), 15, B
        PAINT (2, 2), 15
END IF
'////////////////////////////////////////////////////////////////////////////
END SUB

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

FUNCTION GetComment$ (lfrom, lto)
'// ìñ¢·á ¨Ò ÆÖÒÒ¨Ôå á·½
'////////////////////////////////////////////////////////////////////////////
IF lfrom < 1 THEN EXIT FUNCTION
IF lto > NumOfComs THEN EXIT FUNCTION
IF lfrom > lto THEN EXIT FUNCTION

B = INT(RND * (lto - lfrom) + lfrom)

OPEN "sentence.cmt" FOR RANDOM AS #1 LEN = LEN(CmtArr)
GET #1, B, CmtArr.Comment
CLOSE #1

LOCATE 2, 27: PRINT "                            "
LOCATE 2, 27: PRINT RTRIM$(LTRIM$(CmtArr.Comment))
'////////////////////////////////////////////////////////////////////////////
GetComment$ = CmtArr.Comment
END FUNCTION

FUNCTION GetParameter$ (s AS STRING)
'// ìñ¢·á ¨Ò Ø á Ò¨åá
'// Ý á Ò¨åá - ã·ÒëÖÐñ, Ô µÖ¦Þù·¨ãÞ Ò¨é¦ç ó ØÞåñÒ·
'////////////////////////////////////////////////////////////////////////////
res$ = ""

'// «çÔÆ¤·Þ ëÖóëá ù ¨å Ô ½¦¨ÔÔñ½ Ø á Ò¨åá · Öåá¨ó ¨å ¨¬Ö Öå Ø¨á¨¦ ÔÔÖ½ ãåáÖÆ·
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

SUB GetVelocity (numofw)
IF numofw = 1 THEN
        x = 12
        c = 3
        cl = 14
ELSEIF numofw = 2 THEN
        x = 486
        c = 62
        cl = 11
END IF
'// len=142, h=17
LINE (x, 488)-(x + 142, 465), 0, BF
LINE (x, 448)-(x + 142, 465), cl, B
UpdateGraphics 0
LOCATE 2, c: PRINT "                 "
LOCATE 2, c + 5: PRINT "Power?.."
DO
a$ = INKEY$
SELECT CASE a$
CASE CHR$(0) + CHR$(75)
        LINE (x, 448)-(x + 142, 465), 0, BF
        LINE (x, 448)-(x + 142, 465), cl, B
        IF Holder(numofw, 9) > 0 THEN Holder(numofw, 9) = Holder(numofw, 9) - 1
        LINE (x + 2, 450)-(x + 2 + 138 / MaxGrenadeSpeed * Holder(numofw, 9), 463), 4, BF
CASE CHR$(0) + CHR$(77)
        LINE (x, 448)-(x + 142, 465), 0, BF
        LINE (x, 448)-(x + 142, 465), cl, B
        IF Holder(numofw, 9) < MaxGrenadeSpeed THEN Holder(numofw, 9) = Holder(numofw, 9) + 1
        LINE (x + 2, 450)-(x + 2 + 138 / MaxGrenadeSpeed * Holder(numofw, 9), 463), 4, BF
END SELECT
LOOP WHILE a$ <> " "

'// ÇÖ÷ªª·¤·¨Ôå·Æ Ô ¦¢ ëÆ· ãÆÖáÖãå·,   åÖ Æ Æ-åÖ Ò ÐÖë åÖ...
IF Holder(numofw, 9) > 0 THEN v = v + 10

END SUB

FUNCTION GetYesNo (mess AS STRING)
IF LEN(mess) > 20 THEN EXIT FUNCTION
        LINE (228, 220)-(412, 310), 9, B
        LINE (238, 270)-(402, 270), 9
        COLOR 11
        c = INT(40 - LEN(mess) / 2)
        LOCATE 13, c: PRINT mess
        LOCATE 15, 33: PRINT "YES"
        LOCATE 15, 46: PRINT "NO"
        rese = 1: '// Yes
        LINE (240, 240)-(290, 260), 14, B
        DO
        B$ = INKEY$
        IF B$ = CHR$(0) + CHR$(75) THEN
                IF rese = 1 THEN
                        rese = 2
                        LINE (240, 240)-(290, 260), 0, B
                        LINE (350, 240)-(400, 260), 14, B
                ELSE
                        rese = 1
                        LINE (240, 240)-(290, 260), 14, B
                        LINE (350, 240)-(400, 260), 0, B
                END IF
        ELSEIF B$ = CHR$(0) + CHR$(77) THEN
                IF rese = 2 THEN
                        rese = 1
                        LINE (240, 240)-(290, 260), 14, B
                        LINE (350, 240)-(400, 260), 0, B
                ELSE
                        rese = 2
                        LINE (240, 240)-(290, 260), 0, B
                        LINE (350, 240)-(400, 260), 14, B
                END IF
        END IF
        LOOP WHILE B$ <> CHR$(13)
LINE (400, 220)-(584, 310), 0, BF

GetYesNo = rese

END FUNCTION

SUB Grenade (numofw)
'// ­á Ô å  â­§-5
'////////////////////////////////////////////////////////////////////////////
'// ÝáÖë¨áÞ¨Ò Ô Ð·û·¨ ¬á Ô å
IF Holder(numofw, 13) = 0 THEN
        '// ×¢ÔÖëÐÞ¨Ò ¥¨ëáÞ
        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)

        '// äÖÖ¢ù¨Ô·¨ Ö¢ Öåãçåãåë·· Öáçé·Þ
EXIT SUB
ELSEIF Holder(numofw, 13) > 0 THEN
        Holder(numofw, 13) = Holder(numofw, 13) - 1
END IF

'// Ýá·ØÖ¦Ô·Ò ¨Ò ûçåí, ûåÖ¢ñ Ô¨ ó ÒÖû·åí ãëÖ¨¬Ö ¥¨ëáÞ ãá óç
x0 = WormPos(numofw, 1) + 5
y0 = WormPos(numofw, 2) + 35

'// ÕçéÔÖ ¦ÐÞ ëñëÖ¦  ãØá ½å  Øá· ãÐ¨¦çœù¨Ò ëñóÖë¨
oldx = x0: oldy = y0

'// ÇÖ÷ªª·¤·¨Ôå "¦ ÐíÔÖë·¦ÔÖãå·" ¬á Ô åñ (ØÖ·ãÆ åë¨á¦Ö½ óÖÔñ)
d = 8 * 1.3

'// ÝÖÐçû ¨Ò ãÆÖáÖãåí ¢Ð ¬Ö¦ áÞ ã ¢ç, ÆÖåÖáñ½ ÆÐ ¦„å ¨„ ë ¢ óç ¦ ÔÔñµ ¥¨ëáÞ
GetVelocity (numofw)
v = Holder(numofw, 9)

'// ×¢ÔÖëÐÞ¨Ò ¥¨ëáÞ
i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)

'// ÝÖÐçû ¨Ò ç¬ÖÐ ¢áÖãÆ  (Öå -90 ¦Ö 270 ¬á ¦çãÖë)
a = Holder(numofw, 4)

'// â ¦·çã ¦ñáÆ· ·ó Ò ãã·ë  ­á Ô å 
R = GrenadeA(4)

'// è¢·á ¨Ò Æá¨ãå·Æ-ÒçõÆç,   åÖ ¨„ Ô¨Øá ë·ÐíÔÖ ØÖ½Òçå, Æ Æ åë¨á¦çœ óÖÔç
i = SetTarget(numofw, "-", FALSE)

'// ÝÖÐ¨å¨-¨-¨Ð·... (ü·ãÐÖ 100 ëóÞåÖ "Ô  ¬Ð ó", ûåÖ¢ µë å·ÐÖ,   åÖ Ô¨ ¦ÖÐ¨å·å)
FOR t = 0 TO 100 STEP .3

'// ô ¦¨áéÆ  (Ò·ÆáÖØ çó )
SOUND 32000, 1

'// ì ÒÖÒ¨Ôå ëá¨Ò¨Ô· t=0 ØáÖë¨áÆ  Ô¨ ØáÖ·óëÖ¦·åãÞ
IF t > 0 THEN
'// è¬ÖÐ "ë·¦·ÒÖãå·" á ë¨Ô 20+20=40 ¬á ¦çãÖë. ü ãåÖå  ØáÖë¨áÆ· - û¨á¨ó 10.
FOR B = Holder(numofw, 4) - 20 TO Holder(numofw, 4) + 20 STEP 10
IF POINT(x + d * COS(B * dcoef), y + d * SIN(B * dcoef)) <> 0 THEN 610
NEXT B
END IF

'// ©ãÐ· ØÖÐ„å åÖÐíÆÖ Ô û ÐãÞ, ãØá ½å Ô¨ ëñëÖ¦·åãÞ
IF t > 0 THEN PUT (oldx - 12, oldy - 12), Weapon(1), PSET
IF t = 0 THEN
        x = x0
        y = y0
ELSE
        x = x0 + v * t * COS(a * dcoef)
        y = y0 + v * t * SIN(a * dcoef) - g * t ^ 2 / 2
END IF

'// Ý¨á¨ÖØá¨¦¨Ð¨Ô·¨ "ãå áíÞ"
oldx = x: oldy = y

'// ÇÖÖá¦·Ô åñ ¬á Ô åñ - ë Ò ãã·ë
Holder(numofw, 7) = x
Holder(numofw, 8) = y

'// £¨á„Ò Ö¢á ó, ûåÖ ëØ¨á¨¦·
GET (x - 12, y + 12)-(x + 12, y - 12), Weapon(1)

'// Õ·é¨ ØÖÐ  Ô¨ çØ ãåí
IF y < 0 THEN EXIT FOR

'// ×Øá¨¦¨ÐÞ¨Ò, Æ Æçœ Æ áå·ÔÆç á·ãÖë åí, ë Æ ÆÖÒ á Æçáã¨, å Æ ãÆ ó åí...
IF k = 4 THEN k = 1 ELSE k = k + .5

'// â·ãç¨Ò-ã!
SELECT CASE INT(k)
CASE 1
'// 1st
        CIRCLE (x, y), 3, 2: PAINT (x, y), 2
        CIRCLE (x - 1, y + 1), 1, 10: PAINT (x - 1, y + 1), 10
        CIRCLE (x + 4 * COS(0), y + 4 * SIN(0)), 2, 8
CASE 2
'// 2nd
        CIRCLE (x, y), 3, 2: PAINT (x, y), 2
        CIRCLE (x - 1, y + 1), 1, 10: PAINT (x - 1, y + 1), 10
        CIRCLE (x + 4 * COS(3.14 / 2), y + 4 * SIN(3.14 / 2)), 2, 8
CASE 3
'// 3d
        CIRCLE (x, y), 3, 2: PAINT (x, y), 2
        CIRCLE (x - 1, y + 1), 1, 10: PAINT (x - 1, y + 1), 10
        CIRCLE (x + 4 * COS(3.14), y + 4 * SIN(3.14)), 2, 8
CASE 4
'// 4th
        CIRCLE (x, y), 3, 2: PAINT (x, y), 2
        CIRCLE (x - 1, y + 1), 1, 10: PAINT (x - 1, y + 1), 10
        CIRCLE (x + 4 * COS(3 * 3.14 / 2), y + 4 * SIN(3 * 3.14 / 2)), 2, 8
END SELECT
NEXT t

'// ×¢á ¢ÖåÆ  Æá¨ØÆÖ¬Ö £¡£¡¶¡
610
'// äå·á ¨Ò Æ áå·ÔÆç, - Ô¨ ãå ÐÖ ¨„ ¢ÖÐíõ¨!..
        PUT (oldx - 12, oldy - 12), Weapon(1), PSET

'// ×¢ÔçÐ¨Ô·¨ ëá¨Ò¨Ô· (¨ãÐ· ìñ ó µÖå·å¨ ã¦¨Ð åí ÖåãÆÖÆ· ¬á Ô åñ Öå ãå¨ÔÖÆ,
'// åÖ ì Ò ÷åÖ ØÖÔ ¦Ö¢·åãÞ
        t = 0

'// ìáÖ¦¨ Æ Æ óëçÆ, ûåÖ Ð·...
        SOUND 40, 5

'// §ñáÆ 
        CIRCLE (x, y), R, 0: PAINT (x, y), 0
'// ¥·ÆÐ ó Æá ãÆ· Æá ½Ô·µ Ö¢Ð ãå¨½ ÖÆáçéÔÖãå· (çÐçûõ¨Ô·¨ ó Æá ãÆ·)
        FOR B = 1 TO 360
        PAINT (x + (R - 2) * COS(B * dcoef), y + (R - 2) * SIN(B * dcoef)), 0
        NEXT B

'// ÝáÖë¨áÞ¨Ò, Ô¨ Øá·¢·ÐÖ Ð· ¥¨ëáÞ

        FOR n = 1 TO 2
        i = CheckWorm(x, y, n, "GRENADE", "CHECK")
        IF i = TRUE THEN
                IF num = 1 THEN
                PUT (WormPos(num, 1), WormPos(num, 2)), W1Pic, PSET
                ELSEIF num = 2 THEN
                PUT (WormPos(num, 1), WormPos(num, 2)), W2Pic, PSET
                END IF
                xc = WormPos(num, 1)
                yc = WormPos(num, 2)
        IF num = 1 THEN GET (xc, yc + 20)-(xc + 17, yc), W1Pic
        IF num = 2 THEN GET (xc, yc + 20)-(xc + 17, yc), W2Pic
        END IF
       
        i = CheckWorm(x, y, n, "GRENADE", "REAL")
        IF i = TRUE THEN
               WormDead n
               WormPos(n, 1) = -1
        END IF
        NEXT n

'// ÝÖØá ëÐÞ¨Ò ¬á ª·Æç
        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)
        UpdateGraphics 0
'////////////////////////////////////////////////////////////////////////////
END SUB

SUB Introduction
'// ìãåçØÐ¨Ô·¨
'////////////////////////////////////////////////////////////////////////////
OPEN "status.dat" FOR INPUT AS #1
INPUT #1, a, B, c
IF c = FALSE THEN EXIT SUB
CLOSE #1
IF c = TRUE THEN
        c = FALSE
        OPEN "status.dat" FOR OUTPUT AS #1
        PRINT #1, a, B, c
        CLOSE #1
END IF

CLS
SCREEN 13
WINDOW (0, 0)-(640, 480)
'=======INTRODUCTION-===========
'// â·ãç¨Ò ãå¨ÆÐÖ
FOR c = 31 TO 16 STEP -.005
PAINT (1, 1), INT(c)
NEXT c

RANDOMIZE TIMER
FOR x = 0 TO 640 + 60
d = INT(RND * 75)
IF d = 1 THEN
c = 31
        FOR x = x TO x + 20
        c = c - .2
        LINE (x - 60, 0)-(x, 480), c
        NEXT x
        FOR x = x TO x + 20
        c = c + .2
        LINE (x - 60, 0)-(x, 480), c
        NEXT x
       
END IF
LINE (x - 60, 0)-(x, 480), 15
NEXT x

'// ÝáÖãåá¨Ð·ë ¨Ò
d = 3.14159 / 180
SOUND 40, 4
PLAY "MBo5 l64 CD+GD+F+CD+FC+C+GAAG+D-CBD-G+GFC+C+GAAG+D-CBD-G+G"
CIRCLE (xs, ys), 4, 0: PAINT (xs, ys), 0

'// æá¨ù·Ôñ · ëã„ å ÆÖ¨
DO
xs = 320: ys = 240
CIRCLE (xs, ys), 9, 0: PAINT (xs, ys), 0
IF acc = 1 THEN R = 20
IF acc = 2 THEN R = 25
IF acc = 3 THEN R = 32
IF acc = 4 THEN R = 48
IF acc = 5 THEN R = 59
IF acc = 6 THEN R = 86
IF acc = 7 THEN R = 105
IF acc = 8 THEN R = 140
IF acc = 9 THEN R = 180
IF acc = 10 THEN R = 230
IF acc = 11 THEN R = 270
IF acc = 12 THEN R = 340
IF acc = 13 THEN R = 420

FOR a = 0 TO 360
f = INT(RND * 18)
IF a = 360 THEN f = 1
IF f = 1 THEN
        IF nnn > 0 THEN
                x = xs + R * COS(a * d)
                y = ys + R * SIN(a * d)
                LINE (oldx, oldy)-(x, y), 0
                oldx = x: oldy = y
        ELSE
                oldx = xs + R: oldy = ys
                nnn = 1
        END IF
END IF
NEXT a
LINE (oldx, oldy)-(x, y), 0
acc = acc + 1: nnn = 0
LOOP WHILE acc < 14
'=========
LINE (xs, ys)-(xs - 60, ys + 15), 0
LINE -(xs - 120, ys + 45), 0
LINE -(xs - 180, ys + 85), 0
LINE -(xs - 240, ys + 135), 0
LINE -(xs - 300, ys + 190), 0
LINE -(xs - 360, ys + 205), 0

LINE (xs, ys)-(xs + 5, ys + 15), 0
LINE -(xs + 12, ys + 45), 0
LINE -(xs + 19, ys + 95), 0
LINE -(xs + 26, ys + 125), 0
LINE -(xs + 33, ys + 160), 0
LINE -(xs + 40, ys + 245), 0

LINE (xs, ys)-(xs + 60, ys + 15), 0
LINE -(xs + 120, ys + 5), 0
LINE -(xs + 180, ys + 25), 0
LINE -(xs + 240, ys + 35), 0
LINE -(xs + 300, ys + 10), 0
LINE -(xs + 360, ys + 15), 0

LINE (xs, ys)-(xs + 20, ys - 25), 0
LINE -(xs + 40, ys - 55), 0
LINE -(xs + 60, ys - 95), 0
LINE -(xs + 80, ys - 135), 0
LINE -(xs + 100, ys - 185), 0
LINE -(xs + 120, ys - 225), 0

LINE (xs, ys)-(xs - 20, ys - 25), 0
LINE -(xs - 70, ys - 55), 0
LINE -(xs - 120, ys - 95), 0
LINE -(xs - 180, ys - 135), 0
LINE -(xs - 240, ys - 185), 0
LINE -(xs - 300, ys - 225), 0

SLEEP 1

'// ÇáÖëÞÆ  å¨Æ„å
PLAY "MB ML o3 l2 D+DBB-D+ l4 FF+ l2 FG+ l1C+"
y1 = 480: y5 = 480: y9 = 480: y13 = 480: y17 = 480: y21 = 480
y2 = 480: y6 = 480: y10 = 480: y14 = 480: y18 = 480: y22 = 480
y3 = 480: y7 = 480: y11 = 480: y15 = 480: y19 = 480
y4 = 480: y8 = 480: y12 = 480: y16 = 480: y20 = 480

r1 = 20: r5 = 50: r9 = 4: r13 = 14: r17 = 24: r21 = 12
r2 = 30: r6 = 60: r10 = 30: r14 = 22: r18 = 34: r22 = 50
r3 = 10: r7 = 35: r11 = 26: r15 = 12: r19 = 10
r4 = 5: r8 = 10: r12 = 46: r16 = 2: r20 = 44

x1 = 20: x5 = 140: x9 = 272: x13 = 383: x17 = 438: x21 = 544
x2 = 70: x6 = 195: x10 = 289: x14 = 401: x18 = 467: x22 = 600
x3 = 105: x7 = 242.5: x11 = 317: x15 = 418: x19 = 489
x4 = 112.5: x8 = 265: x12 = 353: x16 = 425: x20 = 516

k = 12
FOR n = 1 TO 1050 STEP .5
y1 = y1 - 3.2 / k
y2 = y2 - 4 / k
y3 = y3 - 5 / k
y4 = y4 - 6 / k
y5 = y5 - 2.5 / k
y6 = y6 - 4 / k
y7 = y7 - 3 / k
y8 = y8 - 7 / k
y9 = y9 - 3 / k
y10 = y10 - 5 / k
y11 = y11 - 4 / k
y12 = y12 - 6 / k
y13 = y13 - .5 / k
y14 = y14 - 3 / k
y15 = y15 - 9 / k
y16 = y16 - 2.5 / k
y17 = y17 - 5 / k
y18 = y18 - 3.5 / k
y19 = y19 - 3.5 / k
y20 = y20 - 3.4 / k
y21 = y21 - 3.8 / k
y22 = y22 - 4 / k

CIRCLE (x1, y1), r1, 4
CIRCLE (x2, y2), r2, 4
CIRCLE (x3, y3), r3, 4
CIRCLE (x4, y4), r4, 4
CIRCLE (x5, y5), r5, 4
CIRCLE (x6, y6), r6, 4
CIRCLE (x7, y7), r7, 4
CIRCLE (x8, y8), r8, 4
CIRCLE (x9, y9), r9, 4
CIRCLE (x10, y10), r10, 4
CIRCLE (x11, y11), r11, 4
CIRCLE (x12, y12), r12, 4
CIRCLE (x13, y13), r13, 4
CIRCLE (x14, y14), r14, 4
CIRCLE (x15, y15), r15, 4
CIRCLE (x16, y16), r16, 4
CIRCLE (x17, y17), r17, 4
CIRCLE (x18, y18), r18, 4
CIRCLE (x19, y19), r19, 4
CIRCLE (x20, y20), r20, 4
CIRCLE (x21, y21), r21, 4
CIRCLE (x22, y22), r22, 4
NEXT n
SLEEP 1

'// äÐ¨¦
FOR x = 0 TO 640 STEP 1
IF l < 30 THEN l = l + 1 ELSE l = 0
LINE (x, 205 - l / 2)-(x, 265 + l / 2), 0
NEXT x

'// ì ç! øåÖ ì áÑ ½ª!
PLAY "MN o3 l16 F+l8Fl16D+l8C< l16B-l8G l16F+l8F D+<B->l2C"
LOCATE 13, 17
COLOR 31
PRINT "WARLIFE"
SLEEP 1
FOR n = 31 TO 16 STEP -.006
         LOCATE 13, 17
         COLOR n
         PRINT "WARLIFE"
NEXT n
CLS

'// ¸ ÖÔ Ô û·Ô ¨åãÞ!
FOR n = 25 TO 16 STEP -.006
         LOCATE 13, 16
         COLOR n
         PRINT "It Starts"
NEXT n
CLS
'////////////////////////////////////////////////////////////////////////////
END SUB

SUB LoadLevel
440
CLS
LINE (5, 55)-(635, 475), 9, B
LINE (4, 54)-(636, 476), 1, B
LOCATE 2, 28: COLOR 11: PRINT "Load Private Level"
LINE (10, 445)-(630, 445), 1

COLOR 11
LOCATE 4, 5: PRINT "Your level filename:"
LINE (20, 415)-(300, 415), 9

COLOR 15
LINE (220, 317)-(410, 340), 10, B
LINE (219, 316)-(411, 341), 2, B
LOCATE 10, 30: '// 21 symbol max
c = 29
name$ = ""
DO
a$ = INPUT$(1)
IF a$ = CHR$(13) THEN EXIT DO
IF a$ = CHR$(27) THEN
        LOCATE 10, 29: PRINT "                     "
        c = 29
        name$ = ""
        GOTO 200
END IF
'// æÖÐíÆÖ ¢çÆëñ. ¸ åÖÐíÆÖ L åiÔãÆi¨
IF ASC(a$) < 65 OR (ASC(a$) > 90 AND ASC(a$) < 97) OR ASC(a$) > 122 THEN 200
IF c < 50 THEN c = c + 1
IF LEN(name$) > 7 THEN
        name$ = MID$(name$, 1, 6) + "~1"
        LOCATE 10, 29: PRINT "         "
        LOCATE 10, 30: PRINT name$
ELSE
        LOCATE 10, c: PRINT a$: name$ = name$ + a$
END IF
200
LOOP
IF LTRIM$(RTRIM$(name$)) = "" THEN
        LOCATE 8, 30: COLOR 4: PRINT "Name is absent!":
        COLOR 15: SLEEP
        GOTO 440
END IF

CLS

name$ = "User\Levels\" + name$ + ".txt"
xlim = 641: ylim = 441: col = 14

'// ×åÆáñë ¨Ò ª ½Ð ã ¬á ª·û¨ãÆ·Ò· ·ÔãåáçÆ¤·ÞÒ· (¨ãÐ· ÖÔ ¨ãåí)
OPEN name$ FOR INPUT AS #1

'// ÝÖÆ  Ô¨ ó ÆÖÔû·åãÞ...
WHILE NOT EOF(1)
IF ERR THEN EXIT SUB
'// ×¢á ¢ åñë ¨Ò
INPUT #1, ins$
ins$ = LTRIM$(RTRIM$(ins$))
com$ = LEFT$(ins$, 2): ins$ = LTRIM$(RTRIM$(MID$(ins$, 3, LEN(ins$) - 2)))

'// ü·ãåÆ  Öå ØáÖ¢¨ÐÖë ãåáÖÆ· ins$
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
        k$ = "": a$ = "": w$ = ""
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        l = VAL(GetParameter$(ins$))
        w$ = GetParameter$(ins$)
        IF w$ = "" OR VAL(w$) < 5 THEN w = 5 ELSE w = VAL(w$)
        a$ = GetParameter$(ins$)
        IF a$ = "" OR VAL(a$) = 0 THEN a = 5 ELSE a = VAL(a$)
        k$ = GetParameter$(ins$)
        IF k$ = "" OR VAL(k$) = 0 THEN k = 5 ELSE k = VAL(k$)
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                FOR tt = 0 TO w
                oldx = 0: oldy = 0
                FOR ys = 0 TO l
                        xs = a * SIN(ys * k * dcoef)
                        LINE (oldx + x + tt, oldy + y)-(xs + x + tt, ys + y), col
                        oldx = xs: oldy = ys
                NEXT ys
                NEXT tt
        END IF

CASE "wv"
        k$ = "": a$ = "": w$ = ""
        x = VAL(GetParameter$(ins$))
        y = VAL(GetParameter$(ins$))
        l = VAL(GetParameter$(ins$))
        w$ = GetParameter$(ins$)
        IF w$ = "" OR VAL(w$) < 5 THEN w = 5 ELSE w = VAL(w$)
        a$ = GetParameter$(ins$)
        IF a$ = "" OR VAL(a$) = 0 THEN a = 5 ELSE a = VAL(a$)
        k$ = GetParameter$(ins$)
        IF k$ = "" OR VAL(k$) = 0 THEN k = 5 ELSE k = VAL(k$)
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                FOR tt = 0 TO w
                oldx = 0: oldy = 0
                FOR xs = 0 TO l
                        ys = a * SIN(xs * k * dcoef)
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
        PAINT (x + (R - 1) * COS(a * dcoef), y + (R - 1) * SIN(a * dcoef)), col
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
        PAINT (x + (Sr + 1) * COS(a * dcoef), y + (Sr + 1) * SIN(a * dcoef)), col
        PAINT (x + (Sr - 1) * COS(a * dcoef), y + (Sr - 1) * SIN(a * dcoef)), 0
        NEXT B

CASE "md"
        CLS
        p = LEFT
        FOR y = 90 TO 310 STEP 20
        i = SetWorm(140, y, 1, p, 50)
        i = SetWorm(300, y, 1, p, 50)
        i = SetWorm(340, y, 1, p, 50)
        NEXT y
        p = RIGHT
        y = 310
        FOR x = 140 TO 220 STEP 10
        i = SetWorm(x, y, 1, p, 50)
        i = SetWorm(300 - x + 120 + 20, y, 1, p, 50)
        y = y - 20
        NEXT x
        FOR B = -90 TO 90 STEP 10
        x = 350 + 110 * COS(B * dcoef)
        y = 200 + 110 * SIN(B * dcoef)
        i = SetWorm(x, y, 1, p, 50)
        NEXT B
        GOTO 2202
       
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
        a$ = GetParameter$(ins$)
        SELECT CASE a$
        CASE "-": a = 0
        CASE "|": a = 90
        CASE "/": a = 45
        CASE "\": a = 135
        CASE ELSE: a = VAL(a$)
        END SELECT
        IF l < w THEN SWAP w, l
        IF x >= 0 AND x < xlim AND y < ylim AND y >= 0 THEN
                FOR tt = 0 TO w STEP .03
                x2 = x + l * COS(a * dcoef)
                y2 = y + l * SIN(a * dcoef)
                xa = -tt * SIN(a * dcoef)
                ya = tt * COS(a * dcoef)
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
'// Õ¨á óáçõ·Ò Þ ¬á Ô·¤ 
IF UNBORDER = TRUE THEN
        LINE (0, 0)-(640, 440), 15, B
        LINE (10, 10)-(630, 430), 15, B
        PAINT (2, 2), 15
END IF
COLOR 15
'////////////////////////////////////////////////////////////////////////////
END SUB

FUNCTION MainMenu
'////////////////////////////////////////////////////////////////////////////
'// ×û·ãåÆ· ÖÆÔ  Ô¨ ØáÖ·óëÖ¦·åãÞ.

'// "â óëÖá û·ë ¨Ò" Ò¨Ôœ
PAINT (10, 10), 1, 3
FOR y = 1 TO 150
LINE (325 - y, 250 - y)-(325 + y, 250 + y), 10, B
LINE (325 - y - 1, 250 - y - 1)-(325 + y + 1, 250 + y + 1), 3, B
LINE (325 - y, 250 - y)-(325 + y, 250 + y), 0, B
LINE (325 - y - 1, 250 - y - 1)-(325 + y + 1, 250 + y + 1), 0, B
NEXT y
y = 150
LINE (325 - y, 250 - y)-(325 + y, 250 + y), 10, B
LINE (325 - y - 1, 250 - y - 1)-(325 + y + 1, 250 + y + 1), 3, B

'// ¥ë¨å Ô¨ Æå·ëÔÖ¬Ö å¨Æãå 
backcolor = 8

'// Ó¨Ôœ ë Ô û ÐíÔÖÒ ãÖãåÖÞÔ··
COLOR backcolor
LOCATE 10, 30: PRINT "Start Game"
LOCATE 12, 30: PRINT "Help"
LOCATE 14, 30: PRINT "Refresh menu"
LOCATE 16, 30: PRINT "Grab some sand"
LOCATE 18, 30: PRINT "Weapon factory"
LOCATE 20, 30: PRINT "Quit"

'// ìÔ û Ð¨ ëñ¢á Ô ØçÔÆå "äå áå Ôçåí ¥¨ëá¨½"
LOCATE 10, 30: COLOR 14: PRINT "Start Game"
LINE (199, 317)-(451, 341), 1, B
LINE (200, 318)-(450, 340), 9, B
index = 1

'// ¥·ÆÐ Ô  ØáÖë¨áÆç Ô é åÖ½ ÆÐ ë·õ· · ØÖãÐ¨¦çœùçœ ¬á ª·û¨ãÆçœ Ö¢á ¢ÖåÆç
DO
buttonpressed$ = INKEY$

'// ESCape Øá·á ëÔ·ë ¨åãÞ Æ ëñ¢Öáç ØçÔÆå  "Quit"
IF buttonpressed$ = CHR$(27) THEN COLOR 15: index = 6: GOTO 1010101

SELECT CASE buttonpressed$
'// ©ãÐ· Ô é å  ãåá¨ÐÆ  ìÕ¸ô
CASE CHR$(0) + CHR$(80)
        SELECT CASE index
        CASE 1
                index = 2
                LOCATE 10, 30: COLOR backcolor: PRINT "Start Game"
                LINE (199, 317)-(451, 341), 0, B
                LINE (200, 318)-(450, 340), 0, B
                LOCATE 12, 30: COLOR 14: PRINT "Help"
                LINE (199, 285)-(451, 309), 1, B
                LINE (200, 286)-(450, 308), 9, B
        CASE 2
                index = 3
                LOCATE 12, 30: COLOR backcolor: PRINT "Help"
                LINE (199, 285)-(451, 309), 0, B
                LINE (200, 286)-(450, 308), 0, B
                LOCATE 14, 30: COLOR 14: PRINT "Refresh menu"
                LINE (199, 253)-(451, 277), 1, B
                LINE (200, 254)-(450, 276), 9, B
        CASE 3
                index = 4
                LOCATE 14, 30: COLOR backcolor: PRINT "Refresh menu"
                LINE (199, 253)-(451, 277), 0, B
                LINE (200, 254)-(450, 276), 0, B
                LOCATE 16, 30: COLOR 14: PRINT "Grab some sand"
                LINE (199, 220)-(451, 245), 1, B
                LINE (200, 221)-(450, 244), 9, B
        CASE 4
                index = 5
                LOCATE 16, 30: COLOR backcolor: PRINT "Grab some sand"
                LINE (199, 220)-(451, 245), 0, B
                LINE (200, 221)-(450, 244), 0, B
                LOCATE 18, 30: COLOR 14: PRINT "Weapon factory"
                LINE (199, 188)-(451, 212), 1, B
                LINE (200, 189)-(450, 211), 9, B
        CASE 5
                index = 6
                LOCATE 18, 30: COLOR backcolor: PRINT "Weapon factory"
                LINE (199, 188)-(451, 212), 0, B
                LINE (200, 189)-(450, 211), 0, B
                LOCATE 20, 30: COLOR 14: PRINT "Quit"
                LINE (199, 156)-(451, 180), 1, B
                LINE (200, 157)-(450, 179), 9, B
        CASE 6
                index = 1
                LOCATE 20, 30: COLOR backcolor: PRINT "Quit"
                LINE (199, 156)-(451, 180), 0, B
                LINE (200, 157)-(450, 179), 0, B
                LOCATE 10, 30: COLOR 14: PRINT "Start Game"
                LINE (199, 317)-(451, 341), 1, B
                LINE (200, 318)-(450, 340), 9, B
        END SELECT
'// ©ãÐ· Ô é å  ãåá¨ÐÆ  ìì©â¶
CASE CHR$(0) + CHR$(72)
        SELECT CASE index
        CASE 1
                index = 6
                LOCATE 10, 30: COLOR backcolor: PRINT "Start Game"
                LINE (199, 317)-(451, 341), 0, B
                LINE (200, 318)-(450, 340), 0, B
                LOCATE 20, 30: COLOR 14: PRINT "Quit"
                LINE (199, 156)-(451, 180), 1, B
                LINE (200, 157)-(450, 179), 9, B
        CASE 6
                index = 5
                LOCATE 20, 30: COLOR backcolor: PRINT "Quit"
                LINE (199, 156)-(451, 180), 0, B
                LINE (200, 157)-(450, 179), 0, B
                LOCATE 18, 30: COLOR 14: PRINT "Weapon factory"
                LINE (199, 188)-(451, 212), 1, B
                LINE (200, 189)-(450, 211), 9, B
        CASE 5
                index = 4
                LOCATE 18, 30: COLOR backcolor: PRINT "Weapon factory"
                LINE (199, 188)-(451, 212), 0, B
                LINE (200, 189)-(450, 211), 0, B
                LOCATE 16, 30: COLOR 14: PRINT "Grab some sand"
                LINE (199, 220)-(451, 245), 1, B
                LINE (200, 221)-(450, 244), 9, B
        CASE 4
                index = 3
                LOCATE 16, 30: COLOR backcolor: PRINT "Grab some sand"
                LINE (199, 220)-(451, 245), 0, B
                LINE (200, 221)-(450, 244), 0, B
                LOCATE 14, 30: COLOR 14: PRINT "Refresh menu"
                LINE (199, 253)-(451, 277), 1, B
                LINE (200, 254)-(450, 276), 9, B
        CASE 3
                index = 2
                LOCATE 14, 30: COLOR backcolor: PRINT "Refresh menu"
                LINE (199, 253)-(451, 277), 0, B
                LINE (200, 254)-(450, 276), 0, B
                LOCATE 12, 30: COLOR 14: PRINT "Help"
                LINE (199, 285)-(451, 309), 1, B
                LINE (200, 286)-(450, 308), 9, B
        CASE 2
                index = 1
                LOCATE 12, 30: COLOR backcolor: PRINT "Help"
                LINE (199, 285)-(451, 309), 0, B
                LINE (200, 286)-(450, 308), 0, B
                LOCATE 10, 30: COLOR 14: PRINT "Start Game"
                LINE (199, 317)-(451, 341), 1, B
                LINE (200, 318)-(450, 340), 9, B
        END SELECT
END SELECT

'// ENTER - ëñ¢á åí ØçÔÆå (ëÖóëá å óÔ û¨Ô·Þ)
LOOP WHILE buttonpressed$ <> CHR$(13)
'//
1010101

'// äëÖá û·ë ¨Ò Ò¨Ôœ
FOR y = 150 TO 1 STEP -1
LINE (325 - y, 250 - y)-(325 + y, 250 + y), 10, B
LINE (325 - y - 1, 250 - y - 1)-(325 + y + 1, 250 + y + 1), 3, B
LINE (325 - y, 250 - y)-(325 + y, 250 + y), 1, B
LINE (325 - y - 1, 250 - y - 1)-(325 + y + 1, 250 + y + 1), 1, B
NEXT y
y = 150
CIRCLE (325, 250), 3, 15: PAINT (325, 250), 15
FOR x = 0 TO 325 STEP .5
LINE (325 - x, 250)-(325 + x, 250), 15
NEXT x
FOR y = 3 TO 1 STEP -.01
CIRCLE (325, 250), y, 1: PAINT (325, 250), 1
LINE (0, 250)-(325 + 325, 250), 15
NEXT y

'// ×û·ù ¨Ò ÷Æá Ô
CLS

'// Ý á Ò¨åáñ ØÖ çÒÖÐû Ô·œ. ìñ ÒÖé¨å¨ ¦Ö¢ ë·åí ãëÖ· ëÖããå ÔÖëÐ¨Ô·Þ ó¦¨ãí
COLOR 15

'// ìÖóëá å ·Ô¦¨Æã  Ò¨Ôœ
MainMenu = index
'////////////////////////////////////////////////////////////////////////////
END FUNCTION

FUNCTION SetTarget (numofw, multip AS STRING, fl) STATIC
'// èãå ÔÖëÆ  Øá·¤¨Ð 
'////////////////////////////////////////////////////////////////////////////
'// ÝÖãå ë·åí ·Ð· ç¢á åí?
SELECT CASE fl
'// ÝÖãå ë·åí
CASE TRUE
'// üçåí ãÒ¨ù ¨Ò
        x0 = WormPos(numofw, 1) + 8
        y0 = WormPos(numofw, 2) + 5
        IF Holder(numofw, 1) = RIGHT THEN sig$ = "RIGHT" ELSE sig$ = "LEFT"

IF sig$ = "LEFT" AND alpha < 90 THEN alpha = 180 - alpha
IF sig$ = "RIGHT" AND alpha > 90 THEN alpha = 180 - alpha

'// Ñ·¢Ö ØÖ¦Ô·Ò ¨Ò, Ð·¢Ö ÖØçãÆ ¨Ò
IF multip = "+" THEN k = 1 ELSE k = -1

'// ìÖããå Ô ëÐ·ë ¨Ò Æ áå·ÔÆç
PUT (xold, yold), Cursor(1), PSET

IF sig$ = "RIGHT" THEN
        IF k = 1 THEN
                IF alpha < 90 THEN alpha = alpha + 3
        ELSEIF k = -1 THEN
                IF alpha > -90 THEN alpha = alpha - 3
        END IF
ELSEIF sig$ = "LEFT" THEN
        IF k = 1 THEN
                IF alpha > 90 THEN alpha = alpha - 3
        ELSEIF k = -1 THEN
                IF alpha < 270 THEN alpha = alpha + 3
        END IF
END IF

'// £¨á„Ò Æ áå·ÔÆç · á·ãç¨Ò Øá·¤¨Ð
GET (x0 + (TargetLineLen) * COS(alpha * dcoef) - 5, y0 - 5 + (TargetLineLen) * SIN(alpha * dcoef))-(x0 + 5 + (TargetLineLen) * COS(alpha * dcoef), y0 + 5 + (TargetLineLen) * SIN(alpha * dcoef)), Cursor(1)
LINE (x0 + (TargetLineLen - 5) * COS(alpha * dcoef), y0 + (TargetLineLen - 5) * SIN(alpha * dcoef))-(x0 + (TargetLineLen + 5) * COS(alpha * dcoef), y0 + (TargetLineLen + 5) * SIN(alpha * dcoef)), TargetColor
LINE (x0 + (TargetLineLen) * COS(alpha * dcoef) - 5 * SIN(alpha * dcoef), y0 + (TargetLineLen) * SIN(alpha * dcoef) + 5 * COS(alpha * dcoef))-(x0 + (TargetLineLen) * COS(alpha * dcoef) + 5 * SIN(alpha * dcoef), y0 + (TargetLineLen) * SIN(alpha * dcoef) - 5 * COS(alpha * dcoef)), TargetColor
CIRCLE (x0 + TargetLineLen * COS(alpha * dcoef), y0 + TargetLineLen * SIN(alpha * dcoef)), 4, TargetColor

'// «Ð ¬ çãå ÔÖëÆ· Øá·¤¨Ð 
Holder(numofw, 5) = TRUE

'// äå·á ¨Ò
CASE FALSE
        Holder(numofw, 5) = FALSE
        PUT (xold, yold), Cursor(1), PSET
END SELECT

'// äå áñ¨ óÔ û¨Ô·Þ ¢¨á¨éÔÖ ãÖµá ÔÞœåãÞ ¦Ö ãÐ¨¦çœù¨¬Ö ëñóÖë 
xold = x0 + (TargetLineLen) * COS(alpha * dcoef) - 5
yold = y0 - 5 + (TargetLineLen) * SIN(alpha * dcoef)

'// ìÖóëá ù ¨Ò ç¬ÖÐ ë ¬á ¦çã µ
SetTarget = alpha
END FUNCTION

SUB SetWeapon (numofw)
'// ìñ¢Öá ×áçé·Þ
'////////////////////////////////////////////////////////////////////////////
NumOfWeap = 3: '// Õ¨ Ò¨Ôíõ¨ Ö¦ÔÖ¬Ö!
LINE (0, 440)-(640, 480), 0, BF
LINE (1, 441)-(639, 479), 11, B

FOR n = 0 TO NumOfWeap - 1
LINE (5 + n * 30 + k, 445)-(5 + n * 30 + 30 + k, 475), 11, B
PAINT (5 + 3 + n * 30 + k, 445 + 3), 1, 11
k = k + 3
NEXT n

'// â·ãçÔÆ· Öáçé·Þ
'// ­á Ô å 
CIRCLE (5 + 2 * 30 + 6 + 15, 445 + 15), 3, 2: PAINT (5 + 2 * 30 + 15 + 6, 445 + 15), 2
CIRCLE (4 + 2 * 30 + 6 + 15, 445 + 16), 1, 10: PAINT (4 + 2 * 30 + 6 + 15, 445 + 16), 10
CIRCLE (5 + 2 * 30 + 6 + 15 + 4 * COS(0), 445 + 15 + 4 * SIN(0)), 2, 8
IF Holder(numofw, 13) = 0 THEN
        LINE (5 + 2 * 30 + 6, 445)-(5 + 2 * 30 + 30 + 6, 475), 4
        LINE (5 + 2 * 30 + 6, 475)-(5 + 2 * 30 + 30 + 6, 445), 4
END IF
'// Ý·ãåÖÐ¨å
x = 5 + 15: y = 445 + 15
LINE (x - 7, y - 2)-(x + 9, y + 2), 0, BF
LINE (x - 6, y + 1)-(x + 8, y + 1), 15
LINE (x - 5, y - 6)-(x - 2, y - 2), 15
LINE (x - 4, y - 7)-(x - 2, y - 3), 0
LINE (x - 3, y - 7)-(x - 1, y - 3), 0
LINE (x - 3, y - 5)-(x + 4, y - 5), 0
LINE -(x + 5, y), 0
IF Holder(numofw, 11) = 0 THEN
        LINE (5 + 0 * 30 + 0, 445)-(5 + 0 * 30 + 30 + 0, 475), 4
        LINE (5 + 0 * 30 + 0, 475)-(5 + 0 * 30 + 30 + 0, 445), 4
END IF
'// §·Ô Ò·å
x = 5 + 1 * 30 + 3 + 15: y = 460
        LINE (x - 3, y - 6)-(x + 3, y + 6), 4, BF
        LINE (x - 2, y - 5)-(x - 2, y + 5), 12
        CIRCLE (x + 3, y + 9), 3, 14, pi / 2, pi
IF Holder(numofw, 11) = 0 THEN
        LINE (5 + 1 * 30 + 3, 445)-(5 + 1 * 30 + 30 + 3, 475), 4
        LINE (5 + 1 * 30 + 3, 475)-(5 + 1 * 30 + 30 + 3, 445), 4
END IF

w = Holder(numofw, 3)
LINE (5 + (w - 1) * 30 + 3 * (w - 1) - 1, 444)-(5 + (w - 1) * 30 + 3 * (w - 1) - 1 + 32, 476), 15, B

DO
a$ = INKEY$
SELECT CASE a$
CASE CHR$(0) + CHR$(75)
        LINE (5 + (w - 1) * 30 + 3 * (w - 1) - 1, 444)-(5 + (w - 1) * 30 + 3 * (w - 1) - 1 + 32, 476), 0, B
        IF w = 1 THEN w = NumOfWeap ELSE w = w - 1
        LINE (5 + (w - 1) * 30 + 3 * (w - 1) - 1, 444)-(5 + (w - 1) * 30 + 3 * (w - 1) - 1 + 32, 476), 15, B
        Holder(numofw, 3) = w
CASE CHR$(0) + CHR$(77)
        LINE (5 + (w - 1) * 30 + 3 * (w - 1) - 1, 444)-(5 + (w - 1) * 30 + 3 * (w - 1) - 1 + 32, 476), 0, B
        IF w = NumOfWeap THEN w = 1 ELSE w = w + 1
        LINE (5 + (w - 1) * 30 + 3 * (w - 1) - 1, 444)-(5 + (w - 1) * 30 + 3 * (w - 1) - 1 + 32, 476), 15, B
        Holder(numofw, 3) = w
END SELECT
LOOP WHILE a$ <> CHR$(13)

x = WormPos(numofw, 1) + 7
y = WormPos(numofw, 2) + 5
SELECT CASE Holder(numofw, 3)
CASE 1
        LINE (x - 3, y - 1)-(x + 6, y + 1), 0, BF
        LINE (x - 2, y)-(x + 5, y), 15
        LINE (x - 1, y - 3)-(x - 2, y - 2), 0, BF
'// ÇÖÒÒ¨Ôå  á·¦? Ççã·Òçã¨¦?
LastComment$(1) = GetComment(11, 15)
CASE 2
        LINE (x - 1, y - 1)-(x + 2, y + 5), 4, BF
        LINE (x + 1, y)-(x, y + 4), 12
        CIRCLE (x + 2, y + 7), 2, 14, pi / 2, pi
'// ÇÖÒÒ¨Ôå  á·¦? Ççã·Òçã¨¦?
LastComment$(1) = GetComment(16, 20)
CASE 3
        CIRCLE (x, y), 3, 2: PAINT (x, y), 2
        CIRCLE (x - 1, y + 1), 1, 10: PAINT (x - 1, y + 1), 10
        CIRCLE (x + 4 * COS(0), y + 4 * SIN(0)), 2, 8
'// ÇÖÒÒ¨Ôå  á·¦? Ççã·Òçã¨¦?
LastComment$(1) = GetComment(6, 10)
END SELECT

UpdateGraphics 0
'////////////////////////////////////////////////////////////////////////////
END SUB

FUNCTION SetWorm (x, y, posit, num, ind)
'// ÝÖã ¦Æ  ¥¨ëáÞ
'/////////////////////////////////////////////////////////////////////////////
'// TRUE, ¨ãÐ· ¥¨áëí ¢ñÐ ØÖã é¨Ô, Æç¦  ØáÖã·Ð· (å ÆÖ¨ á¨¦ÆÖ ¢ñë ¨å)
ret = TRUE
IF ind = INTRO THEN 111
IF ind = 50 THEN 113
IF ind = REDRAW THEN
        x = WormPos(num, 1)
        y = WormPos(num, 2)
        GOTO 111
END IF
100

'// ÝáÖë¨áÆ  Ö¢ãåÖÞå¨Ðíãåë, Øá· ÆÖåÖáñµ ¥¨ëáí ¢ñÐ ØÖã é¨Ô
IF ind = FALSE THEN
Holder(num, 15) = FALSE
flag = TRUE
IF POINT(x + 1, y - 1) <> 0 AND POINT(x + 9, y - 1) <> 0 AND POINT(x + 17, y - 1) <> 0 AND POINT(x + 1, y + 9) = 0 AND POINT(x + 9, y + 18) = 0 AND POINT(x + 17, y + 9) = 0 AND POINT(x + 9, y + 9) = 0 THEN
        FOR xc = x TO x + 16 STEP 3
        FOR yc = y + 21 TO y + 25 STEP 2
        IF POINT(xc, yc) <> 0 THEN y = y - 2: GOTO 100
        NEXT yc
        NEXT xc
        GOTO 115
ELSE
        ret = FALSE
        y = y - 2
        IF y < 10 THEN x = x + 20: y = 420
        GOTO 100
END IF

ELSEIF ind = DAMAGE THEN
'// ìñëÖ¦ ãØá ½å  ë ãÖÖåë¨åãåë··
IF num = 1 THEN
'PUT (WormPos(num, 1), WormPos(num, 2)), W1Pic, PSET
ELSEIF num = 2 THEN
'PUT (WormPos(num, 1), WormPos(num, 2)), W2Pic, PSET
END IF
LINE (WormPos(num, 1), WormPos(num, 2))-(WormPos(num, 1) + 20, WormPos(num, 2) + 4), 0, BF

Holder(num, 15) = FALSE
flag = TRUE
IF POINT(x + 1, y - 1) <> 0 AND POINT(x + 9, y - 1) <> 0 AND POINT(x + 17, y - 1) <> 0 AND POINT(x + 1, y + 9) = 0 AND POINT(x + 9, y + 18) = 0 AND POINT(x + 17, y + 9) = 0 AND POINT(x + 9, y + 9) = 0 THEN
        FOR xc = x TO x + 16 STEP 3
        FOR yc = y + 21 TO y + 25 STEP 2
        IF POINT(xc, yc) <> 0 THEN y = y - 2: GOTO 100
        NEXT yc
        NEXT xc
        IF num = 1 THEN GET (xc, yc + 20)-(xc + 17, yc), W1Pic
        IF num = 2 THEN GET (xc, yc + 20)-(xc + 17, yc), W2Pic
        GOTO 115
ELSE
        ret = FALSE
        y = y - 2
        IF y < 10 THEN
                IF x < 630 THEN x = x + 20 ELSE x = 320
                y = 420
        END IF
        GOTO 100
END IF

ELSEIF ind = TRUE THEN
'// øå·Ò ó Ô·Ò ¨åãÞ ¥ÖáÒøÆå·ë
END IF
'////////////////////////////////////////////////

115
'// ô ØÖÒ·Ô ÐÆ  Æ áå·ÔÆ·
IF ind <> TRUE THEN
IF num = 1 THEN
        'GET (x, y + 20)-(x + 17 + 10, y), W1Pic
        GET (x, y + 20)-(x + 17, y), W1Pic
ELSEIF num = 2 THEN
        'GET (x, y + 20)-(x + 17 + 10, y), W2Pic
        GET (x, y + 20)-(x + 17, y), W2Pic
END IF
END IF

'// Õ Ò Ôçé¨Ô Ò¨ÐÆ·½ û¨áëí!

GOTO 111
113
'// £ÖÐíõÖ½ ä÷Ò ãÒÖåá·å ëÐ¨ëÖ
IF posit = LEFT THEN
PSET (x + 4, y + 26), GREY
PSET (x + 5, y + 26), DGREY
PSET (x + 6, y + 26), GREEN
PSET (x + 7, y + 26), RED
PSET (x + 8, y + 26), RED
PSET (x + 9, y + 26), GREEN
PSET (x + 10, y + 26), DGREY
PSET (x + 11, y + 26), DGREY
PSET (x + 2, y + 25), GREY
PSET (x + 3, y + 25), GREEN
PSET (x + 4, y + 25), RED
PSET (x + 5, y + 25), RED
PSET (x + 6, y + 25), RED
PSET (x + 7, y + 25), GREEN
PSET (x + 8, y + 25), GREEN
PSET (x + 10, y + 25), RED
PSET (x + 11, y + 25), RED
PSET (x + 12, y + 25), RED
PSET (x + 13, y + 25), RED
PSET (x + 14, y + 25), DGREY
PSET (x + 1, y + 24), GREY
PSET (x + 2, y + 24), RED
PSET (x + 3, y + 24), RED
PSET (x + 4, y + 24), DGREY
PSET (x + 5, y + 24), DGREY
LINE (x + 6, y + 24)-(x + 9, y + 24), GREY
PSET (x + 10, y + 24), DGREY
PSET (x + 11, y + 24), DGREY
PSET (x + 12, y + 24), RED
PSET (x + 13, y + 24), RED
PSET (x + 14, y + 24), DGREY
PSET (x + 1, y + 23), RED
PSET (x + 2, y + 23), RED
PSET (x + 3, y + 23), DGREY
LINE (x + 4, y + 23)-(x + 11, y + 23), GREY
PSET (x + 12, y + 23), DGREY
PSET (x + 13, y + 23), RED
PSET (x + 14, y + 23), RED
PSET (x + 15, y + 23), GREY
PSET (x, y + 22), DGREY
PSET (x + 1, y + 22), RED
PSET (x + 2, y + 22), GREEN
PSET (x + 3, y + 22), GREEN
PSET (x + 4, y + 22), GREY
PSET (x + 5, y + 22), DGREY
PSET (x + 6, y + 22), BLACK
PSET (x + 7, y + 22), BLACK
PSET (x + 8, y + 22), BLACK
PSET (x + 9, y + 22), BLACK
PSET (x + 10, y + 22), DGREY
PSET (x + 11, y + 22), GREY
PSET (x + 12, y + 22), GREY
PSET (x + 13, y + 22), DGREY
PSET (x + 14, y + 22), RED
PSET (x + 15, y + 22), GREEN
PSET (x, y + 21), DGREY
PSET (x + 1, y + 21), GREEN
PSET (x + 2, y + 21), RED
PSET (x + 3, y + 21), RED
PSET (x + 4, y + 21), DGREY
PSET (x + 5, y + 21), DGREY
PSET (x + 6, y + 21), GREEN
PSET (x + 7, y + 21), GREEN
PSET (x + 8, y + 21), DGREY
LINE (x + 9, y + 21)-(x + 13, y + 21), GREY
PSET (x + 14, y + 21), GREEN
PSET (x + 15, y + 21), RED
PSET (x, y + 20), GREEN
PSET (x + 1, y + 20), GREEN
LINE (x + 2, y + 20)-(x + 6, y + 20), GREY
PSET (x + 7, y + 20), WHITE
LINE (x + 8, y + 20)-(x + 13, y + 20), GREY
PSET (x + 14, y + 20), GREEN
PSET (x + 15, y + 20), RED
PSET (x + 16, y + 20), GREY
PSET (x, y + 19), DGREY
PSET (x + 1, y + 19), GREEN
PSET (x + 2, y + 19), WHITE
PSET (x + 3, y + 19), WHITE
PSET (x + 4, y + 19), WHITE
PSET (x + 5, y + 19), GREY
PSET (x + 6, y + 19), WHITE
PSET (x + 7, y + 19), WHITE
PSET (x + 8, y + 19), WHITE
PSET (x + 9, y + 19), WHITE
LINE (x + 10, y + 19)-(x + 13, y + 19), GREY
PSET (x + 14, y + 19), GREEN
PSET (x + 15, y + 19), RED
PSET (x + 16, y + 19), GREY
PSET (x, y + 18), DGREY
PSET (x + 1, y + 18), RED
PSET (x + 2, y + 18), WHITE
PSET (x + 3, y + 18), DGREY
PSET (x + 4, y + 18), WHITE
PSET (x + 5, y + 18), WHITE
PSET (x + 6, y + 18), WHITE
PSET (x + 7, y + 18), GREEN
PSET (x + 8, y + 18), WHITE
PSET (x + 9, y + 18), WHITE
LINE (x + 10, y + 18)-(x + 13, y + 18), GREY
PSET (x + 14, y + 18), GREEN
PSET (x + 15, y + 18), RED
PSET (x + 1, y + 17), RED
PSET (x + 2, y + 17), DGREY
PSET (x + 4, y + 17), DGREY
PSET (x + 6, y + 17), DGREY
PSET (x + 8, y + 17), DGREY
PSET (x + 9, y + 17), WHITE
PSET (x + 13, y + 17), GREY
PSET (x + 14, y + 17), GREEN
PSET (x + 15, y + 17), GREEN
PSET (x + 1, y + 16), DGREY
PSET (x + 2, y + 16), DGREY
PSET (x + 4, y + 16), GREEN
PSET (x + 6, y + 16), DGREY
PSET (x + 8, y + 16), DGREY
PSET (x + 9, y + 16), WHITE
PSET (x + 13, y + 16), GREY
PSET (x + 14, y + 16), RED
PSET (x + 15, y + 16), DGREY
PSET (x + 1, y + 15), GREY
PSET (x + 2, y + 15), RED
PSET (x + 4, y + 15), GREEN
PSET (x + 6, y + 15), WHITE
PSET (x + 8, y + 15), GREY
PSET (x + 9, y + 15), WHITE
PSET (x + 13, y + 15), DGREY
PSET (x + 14, y + 15), RED
PSET (x + 15, y + 15), GREY
LINE (x + 3, y + 15)-(x + 3, y + 17), BLACK
LINE (x + 5, y + 15)-(x + 5, y + 17), WHITE
LINE (x + 7, y + 15)-(x + 7, y + 17), BLACK
PSET (x + 2, y + 14), DGREY
PSET (x + 3, y + 14), DGREY
LINE (x + 4, y + 14)-(x + 6, y + 14), WHITE
PSET (x + 7, y + 14), GREY
PSET (x + 8, y + 14), WHITE
PSET (x + 9, y + 14), GREY
PSET (x + 13, y + 14), DGREY
PSET (x + 14, y + 14), RED
PSET (x + 15, y + 14), GREY
PSET (x + 2, y + 13), GREY
PSET (x + 3, y + 13), RED
PSET (x + 4, y + 13), GREY
PSET (x + 5, y + 13), WHITE
PSET (x + 6, y + 13), GREY
PSET (x + 7, y + 13), WHITE
PSET (x + 8, y + 13), WHITE
PSET (x + 9, y + 13), GREY
PSET (x + 13, y + 13), GREEN
PSET (x + 14, y + 13), GREEN
PSET (x + 3, y + 12), DGREY
PSET (x + 4, y + 12), GREEN
PSET (x + 13, y + 12), RED
PSET (x + 14, y + 12), DGREY
PSET (x + 3, y + 11), DGREY
PSET (x + 4, y + 11), DGREY
PSET (x + 13, y + 11), RED
PSET (x + 14, y + 11), DGREY
PSET (x + 15, y + 11), DGREY
PSET (x + 16, y + 11), GREY
LINE (x + 10, y + 11)-(x + 12, y + 17), GREY, BF
LINE (x + 5, y + 11)-(x + 9, y + 12), GREY, BF
PSET (x + 3, y + 10), DGREY
PSET (x + 4, y + 10), RED
PSET (x + 5, y + 10), DGREY
PSET (x + 6, y + 10), GREY
PSET (x + 7, y + 10), GREY
PSET (x + 8, y + 10), DGREY
PSET (x + 9, y + 10), GREEN
PSET (x + 10, y + 10), GREY
PSET (x + 11, y + 10), GREY
PSET (x + 12, y + 10), DGREY
LINE (x + 13, y + 10)-(x + 17, y + 10), RED
PSET (x + 18, y + 10), GREY
PSET (x + 4, y + 9), DGREY
LINE (x + 5, y + 9)-(x + 8, y + 9), RED
PSET (x + 9, y + 9), GREEN
PSET (x + 10, y + 9), GREY
PSET (x + 11, y + 9), GREY
PSET (x + 12, y + 9), RED
PSET (x + 13, y + 9), GREEN
PSET (x + 14, y + 9), DGREY
PSET (x + 15, y + 9), GREY
PSET (x + 16, y + 9), DGREY
PSET (x + 17, y + 9), RED
PSET (x + 18, y + 9), DGREY
PSET (x + 7, y + 8), DGREY
PSET (x + 8, y + 8), DGREY
PSET (x + 9, y + 8), GREY
PSET (x + 10, y + 8), GREY
PSET (x + 11, y + 8), DGREY
PSET (x + 12, y + 8), GREEN
PSET (x + 13, y + 8), DGREY
LINE (x + 14, y + 8)-(x + 16, y + 8), GREY
PSET (x + 17, y + 8), DGREY
PSET (x + 18, y + 8), RED
PSET (x + 19, y + 8), GREY
PSET (x + 18, y + 7), RED
PSET (x + 19, y + 7), DGREY
PSET (x + 18, y + 6), GREEN
PSET (x + 19, y + 6), GREEN
PSET (x + 20, y + 6), GREY
PSET (x + 18, y + 5), DGREY
PSET (x + 19, y + 5), RED
PSET (x + 20, y + 5), RED
PSET (x + 21, y + 5), DGREY
LINE (x + 13, y + 5)-(x + 17, y + 7), GREY, BF
PSET (x + 13, y + 4), GREY
PSET (x + 14, y + 4), DGREY
PSET (x + 15, y + 4), RED
PSET (x + 16, y + 4), GREY
PSET (x + 17, y + 4), GREY
PSET (x + 18, y + 4), DGREY
PSET (x + 19, y + 4), DGREY
PSET (x + 20, y + 4), GREEN
PSET (x + 21, y + 4), RED
PSET (x + 22, y + 4), GREY
LINE (x + 5, y + 4)-(x + 5, y + 8), RED
LINE (x + 6, y + 4)-(x + 6, y + 8), DGREY
PSET (x + 5, y + 3), GREEN
PSET (x + 6, y + 3), GREEN
PSET (x + 13, y + 3), GREY
PSET (x + 14, y + 3), GREEN
PSET (x + 15, y + 3), RED
PSET (x + 16, y + 3), DGREY
LINE (x + 17, y + 3)-(x + 20, y + 3), GREY
PSET (x + 21, y + 3), RED
PSET (x + 22, y + 3), DGREY
LINE (x + 7, y + 3)-(x + 12, y + 7), GREY, BF
PSET (x + 5, y + 2), GREY
PSET (x + 6, y + 2), RED
PSET (x + 7, y + 2), GREEN
PSET (x + 8, y + 2), DGREY
LINE (x + 9, y + 2)-(x + 11, y + 2), GREY
PSET (x + 12, y + 2), DGREY
LINE (x + 13, y + 2)-(x + 16, y + 2), GREEN
LINE (x + 17, y + 2)-(x + 19, y + 2), GREY
PSET (x + 20, y + 2), DGREY
PSET (x + 21, y + 2), RED
PSET (x + 22, y + 2), DGREY
PSET (x + 6, y + 1), GREY
LINE (x + 6, y + 1)-(x + 12, y + 1), RED
PSET (x + 13, y + 1), DGREY
PSET (x + 14, y + 1), GREY
PSET (x + 15, y + 1), GREY
LINE (x + 16, y + 1)-(x + 21, y + 1), RED
PSET (x + 22, y + 1), GREY
PSET (x + 8, y), GREY
LINE (x + 9, y)-(x + 11, y), DGREY
PSET (x + 12, y), GREY
PSET (x + 16, y), GREY
PSET (x + 17, y), GREY
PSET (x + 18, y), DGREY
PSET (x + 19, y), DGREY
PSET (x + 20, y), GREY

'// £ÖÐíõá ä÷Ò ãÒÖåá·å Ô Øá ëÖ (· ÷åÖ ¨¬Ö Ð·ûÔÖ¨ Øá ëÖ :)
ELSEIF posit = RIGHT THEN
PSET (x + 0, y + 4), BLACK
PSET (x + 0, y + 3), DGREY
PSET (x + 0, y + 2), DGREY
PSET (x + 0, y + 1), BLACK
PSET (x + 1, y + 5), DGREY
PSET (x + 1, y + 4), RED
PSET (x + 1, y + 3), RED
PSET (x + 1, y + 2), RED
PSET (x + 1, y + 1), RED
PSET (x + 2, y + 6), BLACK
PSET (x + 2, y + 5), RED
PSET (x + 2, y + 4), RED
PSET (x + 2, y + 3), BLACK
PSET (x + 2, y + 2), DGREY
PSET (x + 2, y + 1), RED
PSET (x + 2, y + 0), BLACK
PSET (x + 3, y + 8), BLACK
PSET (x + 3, y + 7), DGREY
PSET (x + 3, y + 6), RED
PSET (x + 3, y + 5), RED
PSET (x + 3, y + 4), DGREY
PSET (x + 3, y + 3), BLACK
PSET (x + 3, y + 2), BLACK
PSET (x + 3, y + 1), RED
PSET (x + 3, y + 0), DGREY
PSET (x + 4, y + 10), BLACK
PSET (x + 4, y + 9), DGREY
PSET (x + 4, y + 8), RED
PSET (x + 4, y + 7), RED
PSET (x + 4, y + 6), RED
PSET (x + 4, y + 5), DGREY
PSET (x + 4, y + 4), DGREY
PSET (x + 4, y + 3), BLACK
PSET (x + 4, y + 2), BLACK
PSET (x + 4, y + 1), RED
PSET (x + 4, y + 0), DGREY
PSET (x + 5, y + 10), RED
PSET (x + 5, y + 9), RED
PSET (x + 5, y + 8), DGREY
PSET (x + 5, y + 7), BLACK
PSET (x + 5, y + 6), BLACK
PSET (x + 5, y + 5), BLACK
PSET (x + 5, y + 4), BLACK
PSET (x + 5, y + 3), BLACK
PSET (x + 5, y + 2), BLACK
PSET (x + 5, y + 1), RED
PSET (x + 5, y + 0), BLACK
PSET (x + 6, y + 20), BLACK
PSET (x + 6, y + 19), BLACK
PSET (x + 6, y + 11), BLACK
PSET (x + 6, y + 10), RED
PSET (x + 6, y + 9), DGREY
PSET (x + 6, y + 8), BLACK
PSET (x + 6, y + 7), BLACK
PSET (x + 6, y + 6), BLACK
PSET (x + 6, y + 5), BLACK
PSET (x + 6, y + 4), BLACK
PSET (x + 6, y + 3), DGREY
PSET (x + 6, y + 2), RED
PSET (x + 6, y + 1), RED
PSET (x + 6, y + 0), BLACK
PSET (x + 7, y + 23), BLACK
PSET (x + 7, y + 22), RED
PSET (x + 7, y + 21), RED
PSET (x + 7, y + 20), RED
PSET (x + 7, y + 19), RED
PSET (x + 7, y + 18), RED
PSET (x + 7, y + 17), RED
PSET (x + 7, y + 16), DGREY
PSET (x + 7, y + 15), BLACK
PSET (x + 7, y + 14), BLACK
PSET (x + 7, y + 11), DGREY
PSET (x + 7, y + 10), RED
PSET (x + 7, y + 9), BLACK
PSET (x + 7, y + 8), BLACK
PSET (x + 7, y + 7), BLACK
PSET (x + 7, y + 6), BLACK
PSET (x + 7, y + 5), BLACK
PSET (x + 7, y + 4), RED
PSET (x + 7, y + 3), RED
PSET (x + 7, y + 2), RED
PSET (x + 7, y + 1), BLACK
PSET (x + 8, y + 25), DGREY
PSET (x + 8, y + 24), DGREY
PSET (x + 8, y + 23), RED
PSET (x + 8, y + 22), RED
PSET (x + 8, y + 21), RED
PSET (x + 8, y + 20), RED
PSET (x + 8, y + 19), RED
PSET (x + 8, y + 18), RED
PSET (x + 8, y + 17), RED
PSET (x + 8, y + 16), RED
PSET (x + 8, y + 15), RED
PSET (x + 8, y + 14), RED
PSET (x + 8, y + 13), RED
PSET (x + 8, y + 12), DGREY
PSET (x + 8, y + 11), DGREY
PSET (x + 8, y + 10), RED
PSET (x + 8, y + 9), DGREY
PSET (x + 8, y + 8), BLACK
PSET (x + 8, y + 7), BLACK
PSET (x + 8, y + 6), BLACK
PSET (x + 8, y + 5), BLACK
PSET (x + 8, y + 4), DGREY
PSET (x + 8, y + 3), RED
PSET (x + 8, y + 2), RED
PSET (x + 8, y + 1), BLACK
PSET (x + 9, y + 25), RED
PSET (x + 9, y + 24), RED
PSET (x + 9, y + 23), RED
PSET (x + 9, y + 22), DGREY
PSET (x + 9, y + 21), BLACK
PSET (x + 9, y + 20), BLACK
PSET (x + 9, y + 19), BLACK
PSET (x + 9, y + 18), BLACK
PSET (x + 9, y + 17), BLACK
PSET (x + 9, y + 16), BLACK
PSET (x + 9, y + 15), DGREY
PSET (x + 9, y + 14), DGREY
PSET (x + 9, y + 13), RED
PSET (x + 9, y + 12), RED
PSET (x + 9, y + 11), RED
PSET (x + 9, y + 10), RED
PSET (x + 9, y + 9), RED
PSET (x + 9, y + 8), DGREY
PSET (x + 9, y + 7), BLACK
PSET (x + 9, y + 6), GREY
PSET (x + 9, y + 5), GREY
PSET (x + 9, y + 4), GREY
PSET (x + 9, y + 3), GREY
PSET (x + 9, y + 2), RED
PSET (x + 9, y + 1), DGREY
PSET (x + 10, y + 25), RED
PSET (x + 10, y + 24), RED
PSET (x + 10, y + 23), DGREY
PSET (x + 10, y + 22), GREY
PSET (x + 10, y + 21), GREY
PSET (x + 10, y + 20), GREY
PSET (x + 10, y + 19), GREY
PSET (x + 10, y + 18), GREY
PSET (x + 10, y + 17), GREY
PSET (x + 10, y + 16), GREY
PSET (x + 10, y + 15), GREY
PSET (x + 10, y + 14), GREY
PSET (x + 10, y + 13), GREY
PSET (x + 10, y + 12), GREY
PSET (x + 10, y + 11), GREY
PSET (x + 10, y + 10), DGREY
PSET (x + 10, y + 9), RED
PSET (x + 10, y + 8), RED
PSET (x + 10, y + 7), GREY
PSET (x + 10, y + 6), GREY
PSET (x + 10, y + 5), GREY
PSET (x + 10, y + 4), GREY
PSET (x + 10, y + 3), GREY
PSET (x + 10, y + 2), DGREY
PSET (x + 10, y + 1), RED
PSET (x + 10, y + 0), GREY
PSET (x + 11, y + 26), DGREY
PSET (x + 11, y + 25), RED
PSET (x + 11, y + 24), DGREY
PSET (x + 11, y + 23), GREY
PSET (x + 11, y + 22), GREY
PSET (x + 11, y + 21), GREY
PSET (x + 11, y + 20), GREY
PSET (x + 11, y + 19), GREY
PSET (x + 11, y + 18), GREY
PSET (x + 11, y + 17), GREY
PSET (x + 11, y + 16), GREY
PSET (x + 11, y + 15), GREY
PSET (x + 11, y + 14), GREY
PSET (x + 11, y + 13), GREY
PSET (x + 11, y + 12), GREY
PSET (x + 11, y + 11), GREY
PSET (x + 11, y + 10), GREY
PSET (x + 11, y + 9), GREY
PSET (x + 11, y + 8), DGREY
PSET (x + 11, y + 7), GREY
PSET (x + 11, y + 6), GREY
PSET (x + 11, y + 5), GREY
PSET (x + 11, y + 4), GREY
PSET (x + 11, y + 3), GREY
PSET (x + 11, y + 2), GREY
PSET (x + 11, y + 1), RED
PSET (x + 11, y + 0), DGREY
PSET (x + 12, y + 26), DGREY
PSET (x + 12, y + 25), RED
PSET (x + 12, y + 24), DGREY
PSET (x + 12, y + 23), GREY
PSET (x + 12, y + 22), DGREY
PSET (x + 12, y + 21), GREY
PSET (x + 12, y + 20), GREY
PSET (x + 12, y + 19), GREY
PSET (x + 12, y + 18), GREY
PSET (x + 12, y + 17), GREY
PSET (x + 12, y + 16), GREY
PSET (x + 12, y + 15), GREY
PSET (x + 12, y + 14), GREY
PSET (x + 12, y + 13), GREY
PSET (x + 12, y + 12), GREY
PSET (x + 12, y + 11), GREY
PSET (x + 12, y + 10), GREY
PSET (x + 12, y + 9), GREY
PSET (x + 12, y + 8), GREY
PSET (x + 12, y + 7), GREY
PSET (x + 12, y + 6), GREY
PSET (x + 12, y + 5), GREY
PSET (x + 12, y + 4), GREY
PSET (x + 12, y + 3), GREY
PSET (x + 12, y + 2), GREY
PSET (x + 12, y + 1), RED
PSET (x + 12, y + 0), DGREY
PSET (x + 13, y + 26), RED
PSET (x + 13, y + 24), GREY
PSET (x + 13, y + 23), GREY
PSET (x + 13, y + 22), BLACK
PSET (x + 13, y + 21), GREY
PSET (x + 13, y + 20), GREY
PSET (x + 13, y + 19), WHITE
PSET (x + 13, y + 18), WHITE
PSET (x + 13, y + 17), WHITE
PSET (x + 13, y + 16), WHITE
PSET (x + 13, y + 15), WHITE
PSET (x + 13, y + 14), GREY
PSET (x + 13, y + 13), GREY
PSET (x + 13, y + 12), GREY
PSET (x + 13, y + 11), GREY
PSET (x + 13, y + 10), RED
PSET (x + 13, y + 9), RED
PSET (x + 13, y + 8), GREY
PSET (x + 13, y + 7), GREY
PSET (x + 13, y + 6), GREY
PSET (x + 13, y + 5), GREY
PSET (x + 13, y + 4), GREY
PSET (x + 13, y + 3), GREY
PSET (x + 13, y + 2), GREY
PSET (x + 13, y + 1), RED
PSET (x + 13, y + 0), DGREY
PSET (x + 14, y + 26), RED
PSET (x + 14, y + 25), RED
PSET (x + 14, y + 24), GREY
PSET (x + 14, y + 23), GREY
PSET (x + 14, y + 22), BLACK
PSET (x + 14, y + 21), DGREY
PSET (x + 14, y + 20), GREY
PSET (x + 14, y + 19), WHITE
PSET (x + 14, y + 18), WHITE
PSET (x + 14, y + 17), DGREY
PSET (x + 14, y + 16), DGREY
PSET (x + 14, y + 15), GREY
PSET (x + 14, y + 14), WHITE
PSET (x + 14, y + 13), WHITE
PSET (x + 14, y + 12), GREY
PSET (x + 14, y + 11), GREY
PSET (x + 14, y + 10), DGREY
PSET (x + 14, y + 9), RED
PSET (x + 14, y + 8), DGREY
PSET (x + 14, y + 7), GREY
PSET (x + 14, y + 6), GREY
PSET (x + 14, y + 5), GREY
PSET (x + 14, y + 4), GREY
PSET (x + 14, y + 3), GREY
PSET (x + 14, y + 2), DGREY
PSET (x + 14, y + 1), RED
PSET (x + 14, y + 0), GREY
PSET (x + 15, y + 26), RED
PSET (x + 15, y + 25), RED
PSET (x + 15, y + 24), GREY
PSET (x + 15, y + 23), GREY
PSET (x + 15, y + 22), BLACK
PSET (x + 15, y + 21), RED
PSET (x + 15, y + 20), WHITE
PSET (x + 15, y + 19), WHITE
PSET (x + 15, y + 18), RED
PSET (x + 15, y + 17), BLACK
PSET (x + 15, y + 16), BLACK
PSET (x + 15, y + 15), BLACK
PSET (x + 15, y + 14), GREY
PSET (x + 15, y + 13), WHITE
PSET (x + 15, y + 12), GREY
PSET (x + 15, y + 11), GREY
PSET (x + 15, y + 10), GREY
PSET (x + 15, y + 9), RED
PSET (x + 15, y + 8), DGREY
PSET (x + 15, y + 7), GREY
PSET (x + 15, y + 6), GREY
PSET (x + 15, y + 5), GREY
PSET (x + 15, y + 4), GREY
PSET (x + 15, y + 3), GREY
PSET (x + 15, y + 2), RED
PSET (x + 15, y + 1), RED
PSET (x + 15, y + 0), BLACK
PSET (x + 16, y + 26), RED
PSET (x + 16, y + 25), RED
PSET (x + 16, y + 24), GREY
PSET (x + 16, y + 23), GREY
PSET (x + 16, y + 22), BLACK
PSET (x + 16, y + 21), RED
PSET (x + 16, y + 20), GREY
PSET (x + 16, y + 19), WHITE
PSET (x + 16, y + 18), WHITE
PSET (x + 16, y + 17), DGREY
PSET (x + 16, y + 16), DGREY
PSET (x + 16, y + 15), WHITE
PSET (x + 16, y + 14), WHITE
PSET (x + 16, y + 13), GREY
PSET (x + 16, y + 12), GREY
PSET (x + 16, y + 11), GREY
PSET (x + 16, y + 10), GREY
PSET (x + 16, y + 9), RED
PSET (x + 16, y + 8), DGREY
PSET (x + 16, y + 7), DGREY
PSET (x + 16, y + 6), DGREY
PSET (x + 16, y + 5), DGREY
PSET (x + 16, y + 4), DGREY
PSET (x + 16, y + 3), RED
PSET (x + 16, y + 2), RED
PSET (x + 16, y + 1), RED
PSET (x + 16, y + 0), BLACK
PSET (x + 17, y + 26), DGREY
PSET (x + 17, y + 25), RED
PSET (x + 17, y + 24), DGREY
PSET (x + 17, y + 23), GREY
PSET (x + 17, y + 22), DGREY
PSET (x + 17, y + 21), DGREY
PSET (x + 17, y + 20), GREY
PSET (x + 17, y + 19), GREY
PSET (x + 17, y + 18), WHITE
PSET (x + 17, y + 17), WHITE
PSET (x + 17, y + 16), WHITE
PSET (x + 17, y + 15), WHITE
PSET (x + 17, y + 14), WHITE
PSET (x + 17, y + 13), WHITE
PSET (x + 17, y + 12), GREY
PSET (x + 17, y + 11), GREY
PSET (x + 17, y + 10), DGREY
PSET (x + 17, y + 9), RED
PSET (x + 17, y + 8), RED
PSET (x + 17, y + 7), RED
PSET (x + 17, y + 6), RED
PSET (x + 17, y + 5), RED
PSET (x + 17, y + 4), RED
PSET (x + 17, y + 3), RED
PSET (x + 17, y + 2), GREY
PSET (x + 18, y + 26), GREY
PSET (x + 18, y + 25), RED
PSET (x + 18, y + 24), DGREY
PSET (x + 18, y + 23), GREY
PSET (x + 18, y + 22), GREY
PSET (x + 18, y + 21), DGREY
PSET (x + 18, y + 20), GREY
PSET (x + 18, y + 19), WHITE
PSET (x + 18, y + 18), WHITE
PSET (x + 18, y + 17), DGREY
PSET (x + 18, y + 16), RED
PSET (x + 18, y + 15), RED
PSET (x + 18, y + 14), WHITE
PSET (x + 18, y + 13), GREY
PSET (x + 18, y + 12), RED
PSET (x + 18, y + 11), DGREY
PSET (x + 18, y + 10), RED
PSET (x + 18, y + 9), DGREY
PSET (x + 19, y + 25), RED
PSET (x + 19, y + 24), RED
PSET (x + 19, y + 23), DGREY
PSET (x + 19, y + 22), RED
PSET (x + 19, y + 21), RED
PSET (x + 19, y + 20), GREY
PSET (x + 19, y + 19), WHITE
PSET (x + 19, y + 18), DGREY
PSET (x + 19, y + 17), BLACK
PSET (x + 19, y + 16), BLACK
PSET (x + 19, y + 15), BLACK
PSET (x + 19, y + 14), DGREY
PSET (x + 19, y + 13), RED
PSET (x + 19, y + 12), DGREY
PSET (x + 19, y + 11), DGREY
PSET (x + 19, y + 10), DGREY
PSET (x + 20, y + 25), GREY
PSET (x + 20, y + 24), RED
PSET (x + 20, y + 23), RED
PSET (x + 20, y + 22), RED
PSET (x + 20, y + 21), RED
PSET (x + 20, y + 20), GREY
PSET (x + 20, y + 19), WHITE
PSET (x + 20, y + 18), WHITE
PSET (x + 20, y + 17), DGREY
PSET (x + 20, y + 16), DGREY
PSET (x + 20, y + 15), RED
PSET (x + 20, y + 14), DGREY
PSET (x + 20, y + 13), GREY
PSET (x + 21, y + 24), GREY
PSET (x + 21, y + 23), RED
PSET (x + 21, y + 22), RED
PSET (x + 21, y + 21), RED
PSET (x + 21, y + 20), RED
PSET (x + 21, y + 19), RED
PSET (x + 21, y + 18), RED
PSET (x + 21, y + 17), RED
PSET (x + 21, y + 16), DGREY
PSET (x + 21, y + 15), GREY
PSET (x + 22, y + 22), DGREY
PSET (x + 22, y + 21), DGREY
PSET (x + 22, y + 20), RED
PSET (x + 22, y + 19), DGREY
PSET (x + 22, y + 18), DGREY
PAINT (x + 10, y + 3), GREY, RED
PSET (x + 9, y + 21), GREY
PSET (x + 9, y + 20), GREY
PSET (x + 9, y + 19), GREY
PSET (x + 9, y + 18), GREY
PSET (x + 9, y + 17), GREY
PSET (x + 9, y + 16), GREY
PSET (x + 9, y + 15), GREY
PSET (x + 10, y + 14), GREY
END IF
GOTO 114

111
'// Ó Ð¨ÔíÆ·½ §éÖ ãØÖåá·å Ô Ð¨ëÖ
IF posit = RIGHT THEN
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

'// Ó Ð¨ÔíÆ·½ §éÖ ãØÖåá·å Ô Øá ëÖ
ELSEIF posit = LEFT THEN
PSET (x + 0, y + 11), GREY
PSET (x + 0, y + 13), RED
PSET (x + 0, y + 14), DGREY
PSET (x + 0, y + 15), RED
PSET (x + 0, y + 16), DGREY
PSET (x + 0, y + 18), GREY
PSET (x + 1, y + 10), GREY
PSET (x + 1, y + 11), RED
PSET (x + 1, y + 12), DGREY
PSET (x + 1, y + 13), RED
PSET (x + 1, y + 14), WHITE
PSET (x + 1, y + 15), RED
PSET (x + 1, y + 16), RED
PSET (x + 1, y + 17), RED
PSET (x + 1, y + 18), RED
PSET (x + 1, y + 19), GREY
PSET (x + 2, y + 7), DGREY
PSET (x + 2, y + 8), DGREY
PSET (x + 2, y + 9), RED
PSET (x + 2, y + 10), DGREY
PSET (x + 2, y + 13), DGREY
PSET (x + 2, y + 14), WHITE
PSET (x + 2, y + 15), RED
PSET (x + 2, y + 16), RED
PSET (x + 2, y + 17), DGREY
PSET (x + 2, y + 18), RED
PSET (x + 3, y + 2), RED
PSET (x + 3, y + 4), RED
PSET (x + 3, y + 7), RED
PSET (x + 3, y + 8), DGREY
PSET (x + 3, y + 9), GREY
PSET (x + 3, y + 10), WHITE
PSET (x + 3, y + 11), WHITE
PSET (x + 3, y + 12), RED
PSET (x + 3, y + 13), WHITE
PSET (x + 3, y + 14), WHITE
PSET (x + 3, y + 15), GREY
PSET (x + 3, y + 16), GREY
PSET (x + 3, y + 17), GREY
PSET (x + 3, y + 18), DGREY
PSET (x + 3, y + 19), GREY
PSET (x + 4, y + 1), RED
PSET (x + 4, y + 2), RED
PSET (x + 4, y + 3), GREY
PSET (x + 4, y + 4), RED
PSET (x + 4, y + 5), GREY
PSET (x + 4, y + 6), RED
PSET (x + 4, y + 7), RED
PSET (x + 4, y + 8), GREY
PSET (x + 4, y + 9), GREY
PSET (x + 4, y + 10), GREY
PSET (x + 4, y + 11), WHITE
PSET (x + 4, y + 12), DGREY
PSET (x + 4, y + 13), WHITE
PSET (x + 4, y + 14), WHITE
PSET (x + 4, y + 15), GREY
PSET (x + 4, y + 16), RED
PSET (x + 4, y + 17), GREY
PSET (x + 4, y + 18), GREY
PSET (x + 4, y + 19), RED
PSET (x + 5, y + 0), RED
PSET (x + 5, y + 1), RED
PSET (x + 5, y + 2), GREY
PSET (x + 5, y + 3), GREY
PSET (x + 5, y + 4), GREY
PSET (x + 5, y + 5), GREY
PSET (x + 5, y + 6), RED
PSET (x + 5, y + 7), GREY
PSET (x + 5, y + 8), GREY
PSET (x + 5, y + 9), WHITE
PSET (x + 5, y + 10), GREY
PSET (x + 5, y + 13), RED
PSET (x + 5, y + 14), WHITE
PSET (x + 5, y + 15), RED
PSET (x + 5, y + 17), GREY
PSET (x + 5, y + 18), RED
PSET (x + 5, y + 19), RED
PSET (x + 6, y + 0), DGREY
PSET (x + 6, y + 1), GREY
PSET (x + 6, y + 2), GREY
PSET (x + 6, y + 3), GREY
PSET (x + 6, y + 4), GREY
PSET (x + 6, y + 5), GREY
PSET (x + 6, y + 6), GREY
PSET (x + 6, y + 7), DGREY
PSET (x + 6, y + 8), GREY
PSET (x + 6, y + 9), GREY
PSET (x + 6, y + 10), WHITE
PSET (x + 6, y + 11), WHITE
PSET (x + 6, y + 12), DGREY
PSET (x + 6, y + 13), WHITE
PSET (x + 6, y + 14), WHITE
PSET (x + 6, y + 15), GREY
PSET (x + 6, y + 17), GREY
PSET (x + 6, y + 18), GREY
PSET (x + 6, y + 19), RED
PSET (x + 7, y + 0), DGREY
PSET (x + 7, y + 1), RED
PSET (x + 7, y + 2), GREY
PSET (x + 7, y + 3), GREY
PSET (x + 7, y + 4), GREY
PSET (x + 7, y + 5), GREY
PSET (x + 7, y + 6), GREY
PSET (x + 7, y + 7), GREY
PSET (x + 7, y + 8), GREY
PSET (x + 7, y + 9), GREY
PSET (x + 7, y + 10), GREY
PSET (x + 7, y + 11), GREY
PSET (x + 7, y + 12), GREY
PSET (x + 7, y + 13), WHITE
PSET (x + 7, y + 14), GREY
PSET (x + 7, y + 15), GREY
PSET (x + 7, y + 16), GREY
PSET (x + 7, y + 17), GREY
PSET (x + 7, y + 18), DGREY
PSET (x + 7, y + 19), RED
PSET (x + 8, y + 0), RED
PSET (x + 8, y + 1), GREY
PSET (x + 8, y + 2), GREY
PSET (x + 8, y + 3), GREY
PSET (x + 8, y + 4), GREY
PSET (x + 8, y + 5), GREY
PSET (x + 8, y + 6), GREY
PSET (x + 8, y + 7), GREY
PSET (x + 8, y + 8), GREY
PSET (x + 8, y + 9), GREY
PSET (x + 8, y + 10), GREY
PSET (x + 8, y + 11), GREY
PSET (x + 8, y + 12), GREY
PSET (x + 8, y + 13), GREY
PSET (x + 8, y + 14), GREY
PSET (x + 8, y + 15), GREY
PSET (x + 8, y + 16), GREY
PSET (x + 8, y + 17), GREY
PSET (x + 8, y + 18), RED
PSET (x + 8, y + 19), DGREY
PSET (x + 9, y + 1), GREY
PSET (x + 9, y + 2), GREY
PSET (x + 9, y + 3), GREY
PSET (x + 9, y + 4), GREY
PSET (x + 9, y + 5), GREY
PSET (x + 9, y + 6), RED
PSET (x + 9, y + 7), DGREY
PSET (x + 9, y + 8), GREY
PSET (x + 9, y + 9), RED
PSET (x + 9, y + 10), GREY
PSET (x + 9, y + 11), GREY
PSET (x + 9, y + 12), GREY
PSET (x + 9, y + 13), GREY
PSET (x + 9, y + 14), GREY
PSET (x + 9, y + 15), GREY
PSET (x + 9, y + 16), GREY
PSET (x + 9, y + 17), DGREY
PSET (x + 9, y + 18), RED
PSET (x + 10, y + 2), RED
PSET (x + 10, y + 3), GREY
PSET (x + 10, y + 4), GREY
PSET (x + 10, y + 5), GREY
PSET (x + 10, y + 6), GREY
PSET (x + 10, y + 7), GREY
PSET (x + 10, y + 8), RED
PSET (x + 10, y + 9), DGREY
PSET (x + 10, y + 10), RED
PSET (x + 10, y + 11), RED
PSET (x + 10, y + 12), RED
PSET (x + 10, y + 13), GREY
PSET (x + 10, y + 14), RED
PSET (x + 10, y + 15), GREY
PSET (x + 10, y + 16), RED
PSET (x + 10, y + 17), RED
PSET (x + 10, y + 18), DGREY
PSET (x + 10, y + 19), DGREY
PSET (x + 11, y + 1), RED
PSET (x + 11, y + 2), RED
PSET (x + 11, y + 3), GREY
PSET (x + 11, y + 4), GREY
PSET (x + 11, y + 5), GREY
PSET (x + 11, y + 6), GREY
PSET (x + 11, y + 7), RED
PSET (x + 11, y + 8), DGREY
PSET (x + 11, y + 12), RED
PSET (x + 11, y + 13), RED
PSET (x + 11, y + 14), RED
PSET (x + 11, y + 15), RED
PSET (x + 11, y + 16), RED
PSET (x + 12, y + 1), RED
PSET (x + 12, y + 2), GREY
PSET (x + 12, y + 3), GREY
PSET (x + 12, y + 4), GREY
PSET (x + 12, y + 5), GREY
PSET (x + 12, y + 6), GREY
PSET (x + 12, y + 7), RED
PSET (x + 13, y + 0), DGREY
PSET (x + 13, y + 1), RED
PSET (x + 13, y + 2), GREY
PSET (x + 13, y + 3), GREY
PSET (x + 13, y + 4), GREY
PSET (x + 13, y + 5), RED
PSET (x + 13, y + 6), GREY
PSET (x + 13, y + 7), DGREY
PSET (x + 14, y + 0), RED
PSET (x + 14, y + 1), GREY
PSET (x + 14, y + 2), GREY
PSET (x + 14, y + 3), RED
PSET (x + 14, y + 4), RED
PSET (x + 14, y + 5), DGREY
PSET (x + 15, y + 1), GREY
PSET (x + 15, y + 2), RED
PSET (x + 15, y + 3), RED
PSET (x + 16, y + 2), DGREY
PSET (x + 16, y + 4), DGREY
END IF

'// ô Ø·ãñë ¨Ò ÆÖÖá¦·Ô åñ ¥¨ëáÞ · Öá·¨Ôå ¤·œ ÖåÔÖã·å¨ÐíÔÖ Ò ¬Ô·åÔÖ¬Ö ØÖÐœã 
IF ind = FALSE THEN
WormPos(num, 1) = x
WormPos(num, 2) = y
Holder(num, 1) = posit
END IF

114
'// ìÖóëá ù ¨Ò ã·åç ¤·œ (¢ñÐ ØÖã é¨Ô/ãÐ·ÔÞÐ ë ¦áç¬·¨ Æá Þ)
SetWorm = ret
END FUNCTION

SUB Shotgun (numofw)
'// Ý·ãåÖÐ¨å
'////////////////////////////////////////////////////////////////////////////
'// ÝáÖë¨áÞ¨Ò Ô Ð·û·¨ Ø åáÖÔÖë
IF Holder(numofw, 11) = 0 THEN
        '// ×¢ÔÖëÐÞ¨Ò ¥¨ëáÞ
        i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)

        '// äÖÖ¢ù¨Ô·¨ Ö¢ Öåãçåãë·· ¢Ö¨Øá·Ø ãÖë
EXIT SUB
ELSEIF Holder(numofw, 13) > 0 THEN
        Holder(numofw, 13) = Holder(numofw, 13) - 5
END IF

'// ÝÖ¦Ö¦ë·¬ ¨Ò ûçåí, ûåÖ¢ñ Ô¨ ó ÒÖû·åí ãëÖ¨¬Ö ¥¨ëáÞ ãá óç
IF Holder(numofw, 1) = RIGHT THEN
        x0 = WormPos(numofw, 1) + 20
ELSE
        x0 = WormPos(numofw, 1) - 3
END IF
y0 = WormPos(numofw, 2) + 10

'// ÕçéÔÖ ¦ÐÞ ëñëÖ¦  ãØá ½å  Øá· ãÐ¨¦çœù¨Ò ëñóÖë¨
oldx = x0: oldy = y0

'// ÇÖ÷ªª·¤·¨Ôå "¦ ÐíÔÖë·¦ÔÖãå·" Ø åáÖÔÖë (ØÖ·ãÆ åë¨á¦Ö½ óÖÔñ)
d = 2

v = ShotgunA(3)

'// ÝÖÐçû ¨Ò ç¬ÖÐ ¢áÖãÆ  (Öå -90 ¦Ö 270 ¬á ¦çãÖë)
a = Holder(numofw, 4)

'// â ¦·çã ¦ñáÆ· Öå ØçÐ· ·ó Ò ãã·ë  ShotgunA()
R = ShotgunA(4)

'// è¢·á ¨Ò Æá¨ãå·Æ-ÒçõÆç,   åÖ ¨„ Ô¨Øá ë·ÐíÔÖ ØÖ½Òçå, Æ Æ åë¨á¦çœ óÖÔç
i = SetTarget(numofw, "-", FALSE)

'// äåá¨ÐÞ¨Ò
FOR n = 1 TO 5
FOR t = 1 TO 1000

IF t > 3 THEN
IF POINT(x + 2 * COS(a * dcoef), y + 2 * SIN(a * dcoef)) <> 0 THEN 710
END IF

'// ©ãÐ· ØÖÐ„å åÖÐíÆÖ Ô û ÐãÞ, ãØá ½å Ô¨ ëñëÖ¦·åãÞ
IF t > 1 THEN PUT (oldx - 12, oldy - 12), Weapon(1), PSET

IF t = 0 THEN
        x = x0
        y = y0
ELSE
        x = x0 + v * t * COS(a * dcoef)
        y = y0 + v * t * SIN(a * dcoef)
END IF

'// Ý¨á¨ÖØá¨¦¨Ð¨Ô·¨ "ãå áíÞ"
oldx = x: oldy = y

'// ÇÖÖá¦·Ô åñ ¬á Ô åñ - ë Ò ãã·ë
Holder(numofw, 7) = x
Holder(numofw, 8) = y

'// £¨á„Ò Ö¢á ó, ûåÖ ëØ¨á¨¦·
GET (x - 12, y + 12)-(x + 12, y - 12), Weapon(1)

PSET (x, y), 12

'// ×¢á ¢ÖåÆ  ¦ñá¨Ô·
NEXT t
710

'// äå·á ¨Ò Æ áå·ÔÆç, - Ô¨ ãå ÐÖ ¨„ ¢ÖÐíõ¨!..
        PUT (oldx - 12, oldy - 12), Weapon(1), PSET

'// ×¢ÔçÐ¨Ô·¨ å ½Ò 
        t = 0

'// ìáÖ¦¨ Æ Æ óëçÆ, ûåÖ Ð·...
        SOUND 440, 1

'// §ñáÆ 
        CIRCLE (x, y), R, 0: PAINT (x, y), 0

'// ¥·ÆÐ ó Æá ãÆ· Æá ½Ô·µ Ö¢Ð ãå¨½ ÖÆáçéÔÖãå· (çÐçûõ¨Ô·¨ ó Æá ãÆ·)
        CIRCLE (x + 1, y), R - 1, 0: PAINT (x + 1, y), 0
        CIRCLE (x - 1, y), R - 1, 0: PAINT (x - 1, y), 0
        CIRCLE (x, y + 1), R - 1, 0: PAINT (x, y + 1), 0
        CIRCLE (x, y - 1), R - 1, 0: PAINT (x, y - 1), 0

'// ÝáÖë¨áÞ¨Ò, Ô¨ Øá·¢·ÐÖ Ð· ¥¨ëáÞ
        FOR e = 1 TO 2
        i = CheckWorm(x, y, e, "SHOTGUN", "CHECK")
        IF i = TRUE THEN
                IF num = 1 THEN
                PUT (WormPos(num, 1), WormPos(num, 2)), W1Pic, PSET
                ELSEIF num = 2 THEN
                PUT (WormPos(num, 1), WormPos(num, 2)), W2Pic, PSET
                END IF
                xc = WormPos(num, 1)
                yc = WormPos(num, 2)
        IF num = 1 THEN GET (xc, yc + 20)-(xc + 17, yc), W1Pic
        IF num = 2 THEN GET (xc, yc + 20)-(xc + 17, yc), W2Pic
        END IF

        i = CheckWorm(x, y, e, "SHOTGUN", "REAL")
        IF i = TRUE THEN
                WormDead e
                WormPos(e, 1) = -1
        END IF
        NEXT e

'// ÝÖØá ëÐÞ¨Ò ¬á ª·Æç
        UpdateGraphics 0

721

'// ô ¦¨áéÆ 
SLEEP 1
NEXT n
i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, REDRAW)
'////////////////////////////////////////////////////////////////////////////
END SUB

SUB UpdateGraphics (index)
LINE (0, 440)-(640, 480), 0, BF
LINE (1, 441)-(639, 479), 11, B

SELECT CASE index
CASE 0
'// ÇÖáÖ¢Æ  Ø¨áëÖ¬Ö ¥¨ëáÞ
LINE (12, 448)-(154, 465), 0, BF
LINE (12, 448)-(154, 465), 14, B
LOCATE 2, 3: PRINT Holder(1, 10)
'// ÇÖáÖ¢Æ  ëåÖáÖ¬Ö ¥¨ëáÞ
LINE (486, 448)-(628, 465), 0, BF
LINE (486, 448)-(628, 465), 11, B
LOCATE 2, 62: PRINT Holder(2, 10)
'// ÇÖáÖ¢Æ  ÆÖÒÒ¨Ôå á·¨ë. §Ð·Ô  = 28
LINE (200, 448)-(440, 465), 0, BF
LINE (200, 448)-(440, 465), 15, B
LOCATE 2, 27: PRINT LastComment$(1)
IF UNBORDER = TRUE THEN
        FOR l = 0 TO 10
        LINE (0 + l, 0 + l)-(640 - l, 440 - l), 15, B
        NEXT l
END IF

CASE 1
IF UNBORDER = TRUE THEN
        FOR l = 0 TO 10
        LINE (0 + l, 0 + l)-(640 - l, 440 - l), 15, B
        NEXT l
END IF

CASE 2
'// Ýçãå

CASE 3
'// ÇÖáÖ¢Æ  Ø¨áëÖ¬Ö ¥¨ëáÞ
LINE (12, 448)-(154, 465), 0, BF
LINE (12, 448)-(154, 465), 14, B
LOCATE 2, 3: PRINT Holder(1, 10)
'// ÇÖáÖ¢Æ  ëåÖáÖ¬Ö ¥¨ëáÞ
LINE (486, 448)-(628, 465), 0, BF
LINE (486, 448)-(628, 465), 11, B
LOCATE 2, 62: PRINT Holder(2, 10)

END SELECT
END SUB

FUNCTION Worm1Active$ (param AS STRING)
'// ¥¨ëáí ë ¦¨½ãåë··
'////////////////////////////////////////////////////////////////////////////
cn = 0
DO
cn = cn + 1
a$ = INKEY$
SELECT CASE a$
CASE CHR$(27)
        IF param <> "THRU" THEN
                Worm1Active$ = "EXIT"
                EXIT FUNCTION
        END IF
CASE CHR$(0) + CHR$(75)
IF WormPos(1, 1) < 15 THEN 1010
Holder(1, 4) = SetTarget(1, "+", FALSE)
XADDON = -10
       
        PUT (WormPos(1, 1), WormPos(1, 2)), W1Pic, PSET
        '// ¥¨ëáí á óëÖá û·ë ¨åãÞ
        IF Holder(1, 1) = RIGHT THEN
                Holder(1, 1) = LEFT
                WormPos(1, 1) = WormPos(1, 1) - 1
                Holder(1, 5) = FALSE
                a = SetTarget(1, "+", FALSE)
        ELSE
        '// ¥¨ëáí ¦ë·é¨åãÞ
                yc = 0
                IF POINT(WormPos(1, 1) - FOREX - XADDON, WormPos(1, 2)) <> 0 THEN
                FOR y = WormPos(1, 2) TO WormPos(1, 2) + StopHeight
                IF POINT(WormPos(1, 1) - FOREX - XADDON, y) = 0 THEN
                        yc = y
127                     flag = TRUE
                        FOR y = y + 2 TO y + 18
                        IF POINT(WormPos(1, 1) - FOREX - XADDON, y) <> 0 THEN
                                flag = FALSE
                                GOTO 128
                        END IF
                        NEXT y
                END IF
                NEXT y
128                     IF flag = TRUE THEN
                                FOR y = y + 2 TO y + 18 STEP 3
                                FOR x = WormPos(1, 1) - FOREX - XADDON TO WormPos(1, 1) + 9 STEP 3
                                IF POINT(x, y) <> 0 THEN
                                        flag = FALSE
                                        GOTO 129
                                END IF
                                NEXT x
                                NEXT y
129                             IF flag = TRUE THEN
                                        WormPos(1, 2) = yc - 1
                                        WormPos(1, 1) = WormPos(1, 1) - 1
                                        GOTO 130
                                END IF
                        END IF
                IF flag = TRUE THEN 130
        ELSEIF POINT(WormPos(1, 1) - FOREX - XADDON, WormPos(1, 2)) = 0 THEN
                FOR y = WormPos(1, 2) TO WormPos(1, 2) + 18
                IF POINT(WormPos(1, 1) - FOREX - XADDON, y) <> 0 THEN
                        yc = y
                        GOTO 127
                END IF
                NEXT y
                FOR y = WormPos(1, 2) - 1 TO 0 STEP -1
                IF POINT(WormPos(1, 1) - FOREX - XADDON, y) <> 0 THEN
                                IF y < WormPos(1, 2) - 3 THEN WormPos(1, 2) = y + 1
                                WormPos(1, 1) = WormPos(1, 1) - 1
                GOTO 130
                END IF
                NEXT y
        '/////////////////////////////////////////////////////////
        END IF
END IF
130
        'GET (WormPos(1, 1), WormPos(1, 2) + 20)-(WormPos(1, 1) + 17 + 10, WormPos(1, 2)), W1Pic
        GET (WormPos(1, 1), WormPos(1, 2) + 20)-(WormPos(1, 1) + 17, WormPos(1, 2)), W1Pic
        i = SetWorm(WormPos(1, 1), WormPos(1, 2), LEFT, 1, TRUE)
        GOTO 132
131
        'GET (WormPos(1, 1), WormPos(1, 2) + 20)-(WormPos(1, 1) + 17 + 10, WormPos(1, 2)), W1Pic
        GET (WormPos(1, 1), WormPos(1, 2) + 20)-(WormPos(1, 1) + 17, WormPos(1, 2)), W1Pic
132
Holder(1, 5) = FALSE
'////////////////To Right/////////////////
CASE CHR$(0) + CHR$(77)
IF WormPos(1, 1) > 625 THEN 1010
Holder(2, 4) = SetTarget(2, "+", FALSE)
XADDON = -10

        PUT (WormPos(1, 1), WormPos(1, 2)), W1Pic, PSET
        '// ¥¨ëáí á óëÖá û·ë ¨åãÞ
        IF Holder(1, 1) = LEFT THEN
                Holder(1, 1) = RIGHT
                 WormPos(1, 1) = WormPos(1, 1) + 1
                 Holder(1, 5) = FALSE
                 a = SetTarget(1, "+", FALSE)
        ELSE
        '// ¥¨ëáí ¦ë·é¨åãÞ
                yc = 0
                IF POINT(WormPos(1, 1) - FOREX - XADDON, WormPos(1, 2)) <> 0 THEN
                FOR y = WormPos(1, 2) TO WormPos(1, 2) + StopHeight
                IF POINT(WormPos(1, 1) - FOREX - XADDON, y) = 0 THEN
                        yc = y
227                     flag = TRUE
                        FOR y = y + 2 TO y + 18
                        IF POINT(WormPos(1, 1) - FOREX - XADDON, y) <> 0 THEN
                                flag = FALSE
                                GOTO 228
                        END IF
                        NEXT y
                END IF
                NEXT y
228                     IF flag = TRUE THEN
                                FOR y = y + 2 TO y + 18 STEP 3
                                FOR x = WormPos(1, 1) + 5 - FOREX - XADDON TO WormPos(1, 1) + 14 STEP 3
                                IF POINT(x, y) <> 0 THEN
                                        flag = FALSE
                                        GOTO 229
                                END IF
                                NEXT x
                                NEXT y
229                             IF flag = TRUE THEN
                                        WormPos(1, 2) = yc - 1
                                        WormPos(1, 1) = WormPos(1, 1) + 1
                                        GOTO 230
                                END IF
                        END IF
                IF flag = TRUE THEN 230
        ELSEIF POINT(WormPos(1, 1) - FOREX - XADDON, WormPos(1, 2)) = 0 THEN
                FOR y = WormPos(1, 2) TO WormPos(1, 2) + 18
                IF POINT(WormPos(1, 1) - FOREX - XADDON, y) <> 0 THEN
                        yc = y
                        GOTO 227
                END IF
                NEXT y
                FOR y = WormPos(1, 2) - 1 TO 0 STEP -1
                IF POINT(WormPos(1, 1) - FOREX - XADDON, y) <> 0 THEN
                                IF y < WormPos(1, 2) - 3 THEN WormPos(1, 2) = y + 1
                                WormPos(1, 1) = WormPos(1, 1) + 1
                GOTO 230
                END IF
                NEXT y
        '/////////////////////////////////////////////////////////
        END IF
END IF
230
        'GET (WormPos(1, 1), WormPos(1, 2) + 20)-(WormPos(1, 1) + 17 + 10, WormPos(1, 2)), W1Pic
        GET (WormPos(1, 1), WormPos(1, 2) + 20)-(WormPos(1, 1) + 17, WormPos(1, 2)), W1Pic
        i = SetWorm(WormPos(1, 1), WormPos(1, 2), RIGHT, 1, TRUE)
        GOTO 232
231
        'GET (WormPos(1, 1), WormPos(1, 2) + 20)-(WormPos(1, 1) + 17 + 10, WormPos(1, 2)), W1Pic
        GET (WormPos(1, 1), WormPos(1, 2) + 20)-(WormPos(1, 1) + 17, WormPos(1, 2)), W1Pic
232
Holder(1, 5) = FALSE
'///////////////////////////////////////
'// ¥¨ëáí çãå Ô ëÐ·ë ¨å Öáçé·¨!//////
CASE "w"
IF param <> "THRU" THEN SetWeapon 1
CASE "W"
IF param <> "THRU" THEN SetWeapon 1
CASE "¥"
IF param <> "THRU" THEN SetWeapon 1
CASE "¤"
IF param <> "THRU" THEN SetWeapon 1

'// §ë·¬ ¨Ò ¦ë·éÖÆ ¦ë·ÔçåñÒ ¦ë·é¨Ô·¨Ò ¦ë·¬ å¨ÐÞ
CASE CHR$(0) + CHR$(72)
IF param <> "THRU" THEN
        a = SetTarget(1, "+", TRUE)
        Holder(1, 4) = a
END IF
CASE CHR$(0) + CHR$(80)
IF param <> "THRU" THEN
        a = SetTarget(1, "-", TRUE)
        Holder(1, 4) = a
END IF
CASE " "
IF param <> "THRU" THEN
        SELECT CASE Holder(1, 3)
        CASE 1
                ret$ = "CALL SHOTGUN"
                Worm1Active$ = ret$
                EXIT FUNCTION
        CASE 2
                ret$ = "CALL DYNAMITE"
                Worm1Active$ = ret$
                EXIT FUNCTION
        CASE 3
                ret$ = "CALL GRENADE"
                Worm1Active$ = ret$
                EXIT FUNCTION
        END SELECT
END IF
END SELECT
1010
IF param = "THRU" THEN EXIT FUNCTION
LOOP WHILE a$ <> CHR$(27)
'////////////////////////////////////////////////////////////////////////////
END FUNCTION

FUNCTION Worm2Active$ (param AS STRING)
'// ¥¨ëáí ë ¦¨½ãåë··
'////////////////////////////////////////////////////////////////////////////
DO
a$ = INKEY$
SELECT CASE a$
CASE CHR$(27)
        IF param <> "THRU" THEN
                Worm2Active$ = "EXIT"
                EXIT FUNCTION
        END IF
CASE CHR$(0) + CHR$(75)
IF WormPos(2, 1) < 15 THEN 2020
Holder(2, 4) = SetTarget(2, "+", FALSE)
XADDON = -8
        
        PUT (WormPos(2, 1), WormPos(2, 2)), W2Pic, PSET
        '// ¥¨ëáí á óëÖá û·ë ¨åãÞ
        IF Holder(2, 1) = RIGHT THEN
                Holder(2, 1) = LEFT
                 WormPos(2, 1) = WormPos(2, 1) - 1
        '// ¥¨ëáí ¦ë·é¨åãÞ
        ELSE
                yc = 0
                IF POINT(WormPos(2, 1) - FOREX - XADDON, WormPos(2, 2)) <> 0 THEN
                
                FOR y = WormPos(2, 2) TO WormPos(2, 2) + StopHeight
                IF POINT(WormPos(2, 1) - FOREX - XADDON, y) = 0 THEN
                        yc = y
327                     flag = TRUE
                        FOR y = y + 2 TO y + 18
                        IF POINT(WormPos(2, 1) - FOREX - XADDON, y) <> 0 THEN
                                flag = FALSE
                                GOTO 328
                        END IF
                        NEXT y
                END IF
                NEXT y
328                     IF flag = TRUE THEN
                                FOR y = y + 2 TO y + 18 STEP 3
                                FOR x = WormPos(2, 1) - FOREX - XADDON TO WormPos(2, 1) + 9 STEP 3
                                IF POINT(x, y) <> 0 THEN
                                        flag = FALSE
                                        GOTO 329
                                END IF
                                NEXT x
                                NEXT y
329                             IF flag = TRUE THEN
                                        WormPos(2, 2) = yc - 1
                                        WormPos(2, 1) = WormPos(2, 1) - 1
                                        GOTO 330
                                END IF
                        END IF
                IF flag = TRUE THEN 330
       
        ELSEIF POINT(WormPos(2, 1) - FOREX - XADDON, WormPos(2, 2)) = 0 THEN
                FOR y = WormPos(2, 2) TO WormPos(2, 2) + 18
                IF POINT(WormPos(2, 1) - FOREX - XADDON, y) <> 0 THEN
                        yc = y
                        GOTO 327
                END IF
                NEXT y
                FOR y = WormPos(2, 2) - 1 TO 0 STEP -1
                IF POINT(WormPos(2, 1) - FOREX - XADDON, y) <> 0 THEN
                                IF y < WormPos(2, 2) - 3 THEN WormPos(2, 2) = y + 1
                                WormPos(2, 1) = WormPos(2, 1) - 1
                GOTO 330
                END IF
                NEXT y
        '/////////////////////////////////////////////////////////
        END IF
END IF
330
        'GET (WormPos(2, 1), WormPos(2, 2) + 20)-(WormPos(2, 1) + 17 + 10, WormPos(2, 2)), W2Pic
        GET (WormPos(2, 1), WormPos(2, 2) + 20)-(WormPos(2, 1) + 17, WormPos(2, 2)), W2Pic
        i = SetWorm(WormPos(2, 1), WormPos(2, 2), LEFT, 1, TRUE)
        GOTO 332
331
        'GET (WormPos(2, 1), WormPos(2, 2) + 20)-(WormPos(2, 1) + 17 + 10, WormPos(2, 2)), W2Pic
        GET (WormPos(2, 1), WormPos(2, 2) + 20)-(WormPos(2, 1) + 17, WormPos(2, 2)), W2Pic
332
'////////////////To Right/////////////////
CASE CHR$(0) + CHR$(77)
IF WormPos(2, 1) > 625 THEN 2020
Holder(2, 4) = SetTarget(2, "+", FALSE)
XADDON = -8

        PUT (WormPos(2, 1), WormPos(2, 2)), W2Pic, PSET
        '// ¥¨ëáí á óëÖá û·ë ¨åãÞ
        IF Holder(2, 1) = LEFT THEN
                Holder(2, 1) = RIGHT
                 WormPos(2, 1) = WormPos(2, 1) + 1
        ELSE
        '// ¥¨ëáí ¦ë·é¨åãÞ
                yc = 0
                IF POINT(WormPos(2, 1) - FOREX - XADDON, WormPos(2, 2)) <> 0 THEN
                FOR y = WormPos(2, 2) TO WormPos(2, 2) + StopHeight
                IF POINT(WormPos(2, 1) - FOREX - XADDON, y) = 0 THEN
                yc = y
427                     flag = TRUE
                        FOR y = y + 2 TO y + 18
                        IF POINT(WormPos(2, 1) - FOREX - XADDON, y) <> 0 THEN
                                flag = FALSE
                                GOTO 428
                        END IF
                        NEXT y
                END IF
                NEXT y
428                     IF flag = TRUE THEN
                                FOR y = y + 2 TO y + 18 STEP 3
                                FOR x = WormPos(2, 1) + 5 - FOREX - XADDON TO WormPos(2, 1) + 14 STEP 3
                                IF POINT(x, y) <> 0 THEN
                                        flag = FALSE
                                        GOTO 429
                                END IF
                                NEXT x
                                NEXT y
429                             IF flag = TRUE THEN
                                        WormPos(2, 2) = yc - 1
                                        WormPos(2, 1) = WormPos(2, 1) + 1
                                        GOTO 430
                                END IF
                        END IF
                IF flag = TRUE THEN 430
       
        ELSEIF POINT(WormPos(2, 1) - FOREX - XADDON, WormPos(2, 2)) = 0 THEN
                FOR y = WormPos(2, 2) TO WormPos(2, 2) + 18
                IF POINT(WormPos(2, 1) - FOREX - XADDON, y) <> 0 THEN
                        yc = y
                        GOTO 427
                END IF
                NEXT y
                FOR y = WormPos(2, 2) - 1 TO 0 STEP -1
                IF POINT(WormPos(2, 1) - FOREX - XADDON, y) <> 0 THEN
                                IF y < WormPos(2, 2) - 3 THEN WormPos(2, 2) = y + 1
                                WormPos(2, 1) = WormPos(2, 1) + 1
                GOTO 430
                END IF
                NEXT y
        '/////////////////////////////////////////////////////////
        END IF
END IF
430
        'GET (WormPos(2, 1), WormPos(2, 2) + 20)-(WormPos(2, 1) + 17 + 10, WormPos(2, 2)), W2Pic
        GET (WormPos(2, 1), WormPos(2, 2) + 20)-(WormPos(2, 1) + 17, WormPos(2, 2)), W2Pic
        i = SetWorm(WormPos(2, 1), WormPos(2, 2), RIGHT, 1, TRUE)
        GOTO 432
431
        'GET (WormPos(2, 1), WormPos(2, 2) + 20)-(WormPos(2, 1) + 17 + 10, WormPos(2, 2)), W2Pic
        GET (WormPos(2, 1), WormPos(2, 2) + 20)-(WormPos(2, 1) + 17, WormPos(2, 2)), W2Pic
432
'//////////////////////////////////////
'// ¥¨ëáí ¦¨Ð ¨å ØÖØñåÆç ëóÞåí Ô ¬ Ô //
CASE "w"
IF param <> "THRU" THEN SetWeapon 2
CASE "W"
IF param <> "THRU" THEN SetWeapon 2
CASE "¥"
IF param <> "THRU" THEN SetWeapon 2
CASE "¤"
IF param <> "THRU" THEN SetWeapon 2

CASE CHR$(0) + CHR$(72)
IF param <> "THRU" THEN Holder(2, 4) = SetTarget(2, "+", TRUE)

CASE CHR$(0) + CHR$(80)
IF param <> "THRU" THEN Holder(2, 4) = SetTarget(2, "-", TRUE)

CASE " "
IF param <> "THRU" THEN
        SELECT CASE Holder(2, 3)
        CASE 1
                ret$ = "CALL SHOTGUN"
                Worm2Active$ = ret$
                EXIT FUNCTION
        CASE 2
                ret$ = "CALL DYNAMITE"
                Worm2Active$ = ret$
                EXIT FUNCTION
        CASE 3
                ret$ = "CALL GRENADE"
                Worm2Active$ = ret$
                EXIT FUNCTION
        END SELECT
END IF
END SELECT
2020
IF param = "THRU" THEN EXIT FUNCTION
LOOP WHILE a$ <> " "
'////////////////////////////////////////////////////////////////////////////
END FUNCTION

SUB WormDead (numofw)
'// ¥¨ëáÞÆ ã¦Öµ. Ó¦ - - ...
'////////////////////////////////////////////////////////////////////////////
x = WormPos(numofw, 1)
y = WormPos(numofw, 2)

CIRCLE (x, y), 40, 0: PAINT (x, y), 0
FOR a = 0 TO 360 STEP 10
PAINT (x + 13 * COS(a * dcoef), y + 13 * SIN(a * dcoef)), 0
PAINT (x + 23 * COS(a * dcoef), y + 23 * SIN(a * dcoef)), 0
PAINT (x + 33 * COS(a * dcoef), y + 33 * SIN(a * dcoef)), 0
NEXT a

'// ÝÖØá ëÐÞ¨Ò ¬á ª·Æç
        UpdateGraphics 1

IF y <= 50 THEN y = 10 ELSE y = y - 40

IF numofw = 1 THEN numofw = 2 ELSE numofw = 1
i = SetWorm(WormPos(numofw, 1), WormPos(numofw, 2), Holder(numofw, 1), numofw, INTRO)

LINE (x - 1, y - 2)-(x + 1, y + 16), 8, BF
LINE (x - 6, y + 6)-(x + 6, y + 8), 8, BF
LINE (x - 1, y - 2)-(x - 1, y + 5), 7
LINE (x - 1, y + 9)-(x - 1, y + 15), 7
LINE (x - 5, y + 8)-(x - 2, y + 8), 7
LINE (x + 2, y + 8)-(x + 5, y + 8), 7

'// Ý·õ¨Ò ÆÖÒÒ¨Ôå á·½
LOCATE 2, 28: PRINT "Worm is dead..."

p = INT(RND * 4)
IF p = 1 THEN PLAY "o3 ML l8 DFAF l4G l8 FE l4 AGD"
IF p = 2 THEN PLAY "o3  l2 A>F< l2 A+ l8 >CEG l4A+ G l8 <A+l2A+A"
IF p = 3 THEN PLAY "o1 l16 A+ A+ A+ l2 F+ P4 L16 G+G+G+ l2 F"
IF p = 4 THEN PLAY "o4 l8 G+F+ED+F+C+CD+<AG+F+AED+F+C+CD+<AG+F+AED+F+C+CD+< l4AG+ l16 C+l4C+"

SLEEP
RUN "warlife.bas"
'////////////////////////////////////////////////////////////////////////////
END SUB
