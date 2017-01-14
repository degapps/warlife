Warlife
----
[![powered by QB64](https://img.shields.io/badge/powered%20by-QB64-blue.svg)](http://www.qb64.net/)

A [relatively] simple parody on "Worms" game made as an open source school project in 2001. Those were first (well, actually, second) and exciting steps on the way to the Big Coding ت . Good old QBASIC, yeah.

- [Overview](#overview)
- [Reminiscences](#reminiscences)
- [Original readme](#original-readme)
- [Launching](#launching)
- [Issues](#issues)
- [Features](#features)
- [Thanks](#thanks)

<br>
### Overview
**Warlife** was created on pure enthusiasm at school in far 2001. The idea was to make a [relatively] simple yet demonstrative program for the graduation examination. Although initially it was intended to be a regular app just to pass the exam in informatics, it turned into a couple of weeks of real fun almost immediately after the project had started.

<br>
### Reminiscences
The game uses the idea of the awesome "Worms 2" game made by Team17 Software®, but in a, khm..., *quite* docked representation ت .

Also, during the cool intro in the beginning, a tune from "Jesus Christ Superstar" rock opera by Andrew Lloyd Webber and Tim Rice is used ("Damned For All Time" coda to be specific). Well, I had to use something dramatic enough.

<br>
### Original readme
The original instructions file, made for Windows 98 and QBASIC 1.0 in mind, contained the following (translated from Russian):
> Game "installation". Copy *Warlife* game folder to your hard drive (don't launch  it from A:\ !!!). Bind all `.bas` files with `qbasic.exe` app that resides in the same folder. Launch `setlnk.bas` (it will copy shortcuts to the Main menu and Desktop). Launch `warlife.bas`.

<br>
### Launching
The best way to launch the game is to install Windows 98, open main file named `warlife.bas` and run the project code under QBASIC 1.0 ت . However, it's not too convenient nowadays, so I propose to use QBASIC 4.5, e.g. [QB64](http://www.qb64.net/).

So, the plan as follows:

- install QB64 according to instructions;
- copy `Warlife` project files (including `User` folder) to QB64 root directory;
- run QB64;
- open `warlife.bas` file;
- run the program.

Note: in case you are facing problems with launching QB64 and see errors that say something like `syntax error near unexpected token ...`, then open Terminal, go to QB64 directory and try executing the following:

```find . -name '*.command' -exec perl -pi -e 's/\r\n|\n|\r/\n/g' {} \;```

<br>
### Issues
Unfortunately, at the moment (Jan 13, 2017) the code does not perform correctly in its original shape and needs upgrade and fixes to functionate properly under QB64 (but, to repeat, *it should run just fine under QBASIC 1.0 and Win98*). In fact the `Real initial commit` (which is the second commit in this repo) will only let you see crumpled intro, main menu and the game level which acts extremely buggy, while other sections in the Main menu will lead to termination. 

Besides, the code contains quite a bit of bugs (even if they're not visible to end user) and dirty places as this project was one of the first pretty large experiences and was created in a short period of time.  

Well, maybe I'll have time to fix all those, maybe not, but **enthusiasts are highly welcome** ت ! Diving into retro is full of nostalgy, floppy phantoms and dangling pupils.

<br>
### Features
The following is the translation of the original Reference Manual extracts. The word 'Wurm' references the player's character (the worm).

#### Main menu
> Start Game

The game randomly generates new level and starts.

> Help

Switches to OS and opens `.txt` help document.

> Grab Some Soil

Allows user to load his own custom level by entering the name of the text file where the level description is stored (see [*WarM Instructions*](#warm-instructions) section).

> Arms Plant

Runs gun workshop module. Follow the instructions - it is more for programmers rather than end users, because it launches `weapcrt.bas` which allowes to create your own weapon basing on pre-defined gun type templates.

Workshop keys:

- `UP` / `DOWN ARROW` - pagination
- `ENTER` - accept / confirm
- `ESC` - clear the input.

While drawing the weapon's shell:

- `SPACE` - switch paint
- `ENTER` - fill the pixel with paint
- `BACKSPACE` - erase the image or continue (option selection, use `LEFT` / `RIGHT` / `ENTER` to select appropriate)
- `END` - save-and-exit or continue (option selection)

#### In-game controls

Once the level has started, use the following keys:

- `LEFT` / `RIGHT ARROW` - move the Wurm
- `UP` / `DOWN ARROW` - switches to aiming mode and moves the sight up and down for setting and appropriate angle
- `W` - weapon menu (use `LEFT`, `RIGHT` and `ENTER` to select)

In case you have already selected the weapon, `LEFT` and `RIGHT` are used to change the power of hurl or weapon energy.

- `SPACE` - fire! (once the weapon is selected)
- `ESC` - unconditional exit to the Main Menu.

#### Comments

During the game user sees random entertaining (hopefully) comments. You may extend the set of those comments by altering `comcreat.bas`. The comment phrase should not exceed 28 characters (otherwise the string will be truncated).

Call `GetComment()` in `warlife.bas` where you need some idiotic comments ت Use range to pick comments from specific subset.

#### Creating new weapons

End user is able to create his own weapons with the `weapcrt.bas` Weapon Creation wizard, basing on pre-defined types:

- 'throw-the-shell' type (e.g. grenade)
- 'shoot' type (e.g. pistol)
- 'set-and-retreat' (e.g. dynamite)

You can set new weapon's power, effective action radius etc. as well as draw the shell of the weapon in a primitive pixel-by-pixel editor. After that the Wizard will generate 3 files in a `User\Weap_<ordinal_number>` folder. You shouldn't change the number or the name of the folder, because it is linked to the game settings (otherwise, if you delete or move weapon folders, you'll have to edit `status.dat` with the `datcorct.bas` utility).

Three aforementioned files are:

- `<weapon_name>.dat` - stores weapon data, used by the app for further template processing;
- `<weapon_name>.pic` - stores auto-generated QBASIC listing that draws your weapon programmatically;
- `<weapon_name>.txt` - that's the template; it keeps BASIC program fragments that describe weapon's behavior and the way the game process your weapon (shell). Necessary directives are written in comments - follow them to make complete creation of your weapon.

#### WarM Instructions
**WarM** stands for '**War M**essage' - a simple set of commands for level description. There are not so many of them, but you can define and create new in `LoadLevel` sub. Each instruction consists of 2 latin letters and accepts 1 or more comma-separated parameters. One line may contain only 1 command and each command should be enclosed in quotes, e.g.:

```"rg 30, 30, 30, 25"```

In case you omit one or more default parameters, you are still obliged to write comma-separator excluding the case of omitted trailing parameters, e.g.:

```
"rg 30, 30,, 25"
"rg 30, 30, 30"
```

Syntactically incorrect lines are ignored by interpreter.

To make a new level named, say, `mylevel`, create a text file in `User\Levels` folder and fill it with WarM instructions as you need (please note that brackets do *not* mean optional parameters but rather a list of parameters itself):

- **cl** [color]

Sets the active color for primitives' drawing. Possible parameter values:

`black` - background (black)<br>
`blue`	 -	blue<br>
`dgreen` - dark green<br>
`dturq` - dark turquoise<br>
`dred` - dark red<br>
`dviolet` - dark violet<br>
`brown` - brown<br>
`grey` - grey<br>
`dgrey` - dark grey<br>
`neon` - blue neon<br>
`green` - green<br>
`turq` - turquoise<br>
`red` - red<br>
`violet` - violet<br>
`yellow` - yellow<br>
`white` - white<br>

- **cr** [х, у, R]

Draws circle of radius `R` with the center at `{x, y}`. In case `R` < 2 then it is automatically being set to 2. `{x, y}` should be in range `{0, 0} – {640, 440}` for all primitives.

- **rg** [x, y, R, r]

Draws a ring with internal radius equal to `r`, external to `R` and with the center at `{x, y}`. In case `R` < 3 then it is forced-adjusted to 3. If `R` < `r` then `r` is set to `R`/2.

- **pt** [x, y]

Draws a pixel at `{x, y}`

- **gd** [x, y, l, w, a]

Draws girder – a slanting parallelogram. The origin of girder is at `{x, y}`, length is `l`, thickness (width) is `w`. In case `l` < `w` then `l` and `w` are swapped. `a` sets inclination angle in degrees (counterclockwise from horizontal vector pointing to the right). You may use one of the following symbols instead of most popular angles:

`-` = 0°<br>
`|` = 90°<br>
`\` = 135°<br>
`/` = 45°

- **wv** [x, y, l, w, A, k]

Draws the wave - a sine curve with the origin at `{x, y}`, run length `l`, width equal to `w` (defaults to 5 and cannot be less than 5), amplitude `A` (defaults to 5) and sin() coefficient *k* (defaults to 5), i.e.:

```y0 = y + A * sin((x0 + x) * k)```

- **fm** [x, y, l, h, w, f]

Draws either frame - in case `f` is defined - with the bottom left corner at `{x, y}`, width `l`, height `h` and of `w` thickness (defaults to 1), or filled rectangle otherwise.

- **pn** [x, y, c1, c2]

Fills closed region with bounding color `c1`, containing `{x, y}` point, with `c2` color.

- **vw** [x, y, l, w, A, k]

Vertical wave (sine curve).

<br>
### Thanks
Special thanks to Vera Mikhailovna Miloserdova, my informatics' tutor, who actually arouse the zest for programming which then led me through many interesting (well, sometimes not, but still quite educational ت) experiences and techs. Special thanks to Anton Kryukov, being the major and indefatigable beta-tester. Special thanks to all those tool and app makers that inspired me. And absolutely special thanks to my parents who made it all happen ت !