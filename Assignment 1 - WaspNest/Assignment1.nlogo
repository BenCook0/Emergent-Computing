;;turtles know their surrounding coordinates, and the colors around them
turtles-own [surroundingCoords surroundingColors]
;;sets up turtles
to setup-turtles
  ;;based on slider
  create-turtles Number-Wasps
  ask turtles [ setxy random-xcor random-ycor
    set shape "bug"
    set color green
    set surroundingColors (list -1 -1 -1 -1 -1 -1 -1 -1)
    set label-color black
    ;;used for debugging, shows wasps surrounding colors
   ifelse show-surroundingcolors
    [set label surroundingColors]
    [set label ""]
  ]

end

;;sets up patches
;;sets blue and red frequency number of patches (must be white to set so red and blue don't overlap)
to setup-patches
  ask patches [set pcolor white]
  ask n-of Blue-Frequency patches with [pcolor = white] [ set pcolor blue ]
  ask n-of Red-Frequency patches with [pcolor = white] [ set pcolor red ]
  ask n-of Yellow-Frequency patches with [pcolor = white] [ set pcolor yellow ]
end

to setup
  clear-all
  setup-turtles
  setup-patches
  ;;resets ticks counter (used for more accurate "effiency tracking"
   reset-ticks
end

;;random movement each turn
to move-turtles
  ask turtles [
    right random 360
    forward 1
  ]
end

;;executes when go button is toggled
to go
  move-turtles
  set-surroundings
  set-surroundingColors
  ask turtles[
   ifelse show-surroundingcolors
    [set label surroundingColors]
    [set label ""]
  ]
  match-ruleset
  tick-advance 1
end


;;ASK ABOUT THE STOP THING! ITS WEIRD LMAO
to match-ruleset
  foreach which-ruleset [
    x ->
    ask turtles [
      if first x = surroundingColors [place-material last x] ;; add a stop here?
    ]
  ]
end

;;given a number of 1 or 2, blace a red or blue block
to place-material [material]
  if pcolor = white [
    if material = 2 [set pcolor red]
    if material = 1 [set pcolor blue]
    if material = 3 [set pcolor yellow]
  ]
end
;;sets surroundingColors
to set-surroundingColors
  ask turtles[
    let z 0
    while [z < 8] [
      set surroundingColors replace-item z surroundingColors (patchcolor first item z surroundingCoords last item z surroundingCoords)
      set z z + 1
    ]
  ]
end

;;converts a color into a 0,1 or 2 value
;;white is 0, blue is 1, red is 2
to-report patchcolor [x y]
  let z -1
  ask patch x y [
    if pcolor = white [
      set z 0
    ]
    if pcolor = blue [
      set z 1
    ]
    if pcolor = red [
      set z 2
    ]
    if pcolor = yellow [
      set z 3
    ]
  ]
  report z
end

;;takes turtles and creates a list of it's surrounding terrain
;;(first index is North West, and moves clockwise)
to set-surroundings
  ask turtles [set label-color black]
  ask turtles[
    set surroundingCoords (list
      (list (round xcor) (round (ycor + 1)))         ;;north
      (list (round (xcor + 1)) (round (ycor + 1)))   ;;northeast
      (list (round (xcor + 1)) (round (ycor)))       ;;east
      (list (round (xcor + 1)) (round (ycor - 1)))   ;;southeast
      (list (round (xcor)) (round (ycor - 1)))       ;;south
      (list (round (xcor - 1)) (round (ycor - 1)))   ;;southwest
      (list (round (xcor - 1)) (round (ycor)))       ;;west
      (list (round (xcor - 1)) (round (ycor + 1)))   ;;northwest
  )
  ]
end

;;reports which ruleset to use based on the chooser
to-report which-ruleset
  if Rule-set = "vespa-ruleset" [report convert-ruleset-to-symmetric vespa]
  if Rule-set = "vespula-ruleset" [report convert-ruleset-to-symmetric vespula]
  if Rule-set = "parachartergus-ruleset" [report convert-ruleset-to-symmetric parachartergus]
  if Rule-set = "custom1-ruleset" [report convert-ruleset-to-symmetric custom1]
  if Rule-set = "custom2-ruleset" [report convert-ruleset-to-symmetric custom2]
end

;; this reporter converts an asymmetric rule set into a symmetric ruleset
;;code taken from d2l
to-report convert-ruleset-to-symmetric [asymruleset]
  let symruleset (list)
  foreach asymruleset [ [rule] ->
    let asymrule first rule
    let result last rule

    ; Add asymmetric rule
    set symruleset lput rule symruleset

    ; Add the 3 other symmetric rules
    foreach [2 4 6] [ [sym] ->
      set symruleset lput (list (sentence (sublist asymrule sym 8) (sublist asymrule 0 sym)) result) symruleset
    ]
  ]
  report symruleset
end

;;rulesets here

;;seed: 1, vespa ruleset
to-report vespa
let vespa-ruleset
  (list
    (list (list 1 0 0 0 0 0 0 0) 2)
    (list (list 1 2 0 0 0 0 0 0) 2)
    (list (list 1 0 0 0 0 0 0 2) 2)
    (list (list 2 0 0 0 0 0 2 1) 2)
    (list (list 0 0 0 0 2 1 2 0) 2)
    (list (list 2 0 0 0 0 0 1 2) 2)
    (list (list 0 0 0 0 2 2 1 0) 2)
    (list (list 2 0 0 0 0 0 2 1) 2)
    (list (list 1 2 0 0 0 0 0 2) 2)
    (list (list 2 2 0 0 0 0 0 2) 2)
    (list (list 2 2 0 0 0 2 2 2) 2)
    (list (list 2 0 0 0 0 0 2 2) 2)
    (list (list 2 2 2 0 0 0 2 2) 2)
    (list (list 1 2 2 0 0 0 2 2) 2)
    (list (list 2 2 2 2 0 2 2 2) 2)
    (list (list 2 0 0 0 0 2 2 1) 2)
    (list (list 2 2 0 0 0 0 2 1) 2)
    (list (list 2 2 0 0 0 2 2 1) 2))
  report vespa-ruleset
end

; seed: 2
to-report vespula
  let vespula-ruleset
  (list
    (list (list 2 0 0 0 0 0 0 0) 2)
    (list (list 2 2 0 0 0 0 0 0) 2)
    (list (list 2 0 0 0 0 0 0 2) 2)
    (list (list 2 0 0 0 0 0 2 2) 2)
    (list (list 2 2 2 0 0 0 0 0) 2)
    (list (list 2 2 0 0 0 0 0 2) 2)
    (list (list 2 2 0 0 0 0 2 2) 2)
    (list (list 2 2 2 0 0 0 2 2) 2))
  report vespula-ruleset
end

; seed: 3
to-report parachartergus
let parachartergus-ruleset
(list
(list (list 0 0 0 0 0 0 1 0) 2)
(list (list 2 0 0 0 0 0 0 1) 2)
(list (list 0 0 0 0 2 1 0 0) 2)
(list (list 0 0 0 0 0 2 2 2) 2)
(list (list 0 0 0 0 2 2 2 0) 2)
(list (list 2 0 0 0 0 0 2 2) 2)
(list (list 2 2 0 0 0 0 0 2) 2)
(list (list 0 0 0 2 2 2 0 0) 2)
(list (list 2 0 0 0 0 0 0 1) 2)
(list (list 2 0 0 0 0 2 2 2) 2)
(list (list 2 2 2 2 0 0 0 0) 2)
(list (list 2 2 2 0 0 0 2 2) 2)
(list (list 2 0 0 0 2 2 2 2) 2)
(list (list 0 0 2 2 2 2 2 0) 2)
(list (list 2 2 2 0 0 0 0 0) 2)
(list (list 0 0 2 2 2 0 0 0) 2)
(list (list 0 0 0 2 2 2 2 2) 2))
  report parachartergus-ruleset
end

;;seed 4 (custom seed 1)
to-report custom1
  let custom1-ruleset
  (list
  (list (list 3 0 0 0 0 0 0 0) 1)
  (list (list 3 1 0 0 0 0 0 1) 3)
  (list (list 3 3 1 0 0 0 0 1) 2)
  (list (list 1 0 0 0 0 0 0 0) 3)
  (list (list 2 0 0 0 0 0 0 0) 2)
  (list (list 2 0 0 0 2 0 0 0) 2)
  )
  report custom1-ruleset
end

to-report custom2
  let custom2-ruleset
  (list
  (list (list 0 3 0 0 0 0 0 0) 1)
  (list (list 3 0 1 0 0 0 1 0) 2)
  (list (list 3 2 1 0 0 0 1 2) 1)
  (list (list 1 1 0 0 0 0 0 1) 3)
  (list (list 2 1 0 0 0 0 0 1) 3)
  )
  report custom2-ruleset
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
868
669
-1
-1
10.0
1
10
1
1
1
0
1
1
1
-32
32
-32
32
0
0
1
ticks
30.0

BUTTON
6
10
72
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
92
10
155
43
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
53
179
86
Blue-Frequency
Blue-Frequency
0
100
8.0
1
1
NIL
HORIZONTAL

SLIDER
8
91
180
124
Red-Frequency
Red-Frequency
0
100
5.0
1
1
NIL
HORIZONTAL

SWITCH
0
615
213
648
show-surroundingcolors
show-surroundingcolors
1
1
-1000

CHOOSER
6
207
200
252
Rule-set
Rule-set
"vespa-ruleset" "vespula-ruleset" "parachartergus-ruleset" "custom1-ruleset" "custom2-ruleset"
4

SLIDER
6
270
178
303
Number-Wasps
Number-Wasps
0
200
100.0
1
1
NIL
HORIZONTAL

MONITOR
9
317
66
362
NIL
ticks
17
1
11

MONITOR
11
437
98
482
Red Patches
count patches with [pcolor = red]
17
1
11

MONITOR
9
378
98
423
Blue Patches
count patches with [pcolor = blue]
17
1
11

MONITOR
11
554
125
599
patches-per tick
(count patches with [pcolor = red] + count patches with [pcolor = blue]) / ticks
5
1
11

SLIDER
10
133
182
166
Yellow-Frequency
Yellow-Frequency
0
100
5.0
1
1
NIL
HORIZONTAL

MONITOR
12
496
115
541
Yellow Patches
count patches with [pcolor = yellow]
17
1
11

@#$#@#$#@
## WHAT IS IT?

Simulation of various "species" of wasps and how they build their nests using a collection of simple rules.

## HOW IT WORKS

Each wasp is aware of it's surrounding 8 neighbors. If a Wasp's current color surroundings match one of the rules defined in the currently chosen ruleset, then the wasp will place a color (material) down which corresponds to said rule. Variations made can include number of wasps, number of initial material spawned, and the initial ruleset. Rulesets can be changed mid-simulation to produce some interesting "hybrid" behavior.

## HOW TO USE IT

The 3 sliders Red-Frequency, Blue-Frequency and Yellow-Frequency all determine how much of each color (material) is initially placed on the grid. Note that these colors will never overlap/overwrite one another (will only place on a white space).

The Rule-set picker allows the user to change which ruleset the wasps are following. As stated above, this ruleset can be changed mid-simulation. The first 3 rulesets are taken from the assignment page POST THE LINK, whereas custom1 and custom2 were created by me.

There is a monitor for both ticks (which represent simulation time), as well as the "patches per tick" monitor. This monitor can be used to roughly compare how quickly/efficiently the wasps built their nest by measuring how many patches were placed over a given time. This was added because it is difficult to discern how changing the number of wasps effects build time (since fewer wasps means the simulation runs faster, but in reality it takes more ticks to build similar structures).

There are 3 colored patch monitors which keep track of how much of each color is on the board.

Finally, there is a show-surroundings switch. This was mostly used for debugging/testing purposes. It is suggested to remain off at all times when using the simulation. When toggled on, each wasp will be labeled with a length 8 array of their surroundings (first index is north, and moves clockwise). This was used to test that wasps are correctly aware of their surrounding colors.

## THINGS TO NOTICE

Note: the first 3 simulations do not interact at all with the yellow material as this was added for my custom1 and custom2 simulations. It is recommended when running the first 3 simulations to generate 0 yellow materials (although it still does work if this is not the case).

## THINGS TO TRY

Try changing the number of wasps and seeing how the "patches-per-tick" (rough efficiency estimate) changes. Furthermore, it is interesting to change rulesets mid-simulation to see "hybrid" nests form.

## EXTENDING THE MODEL

The first and most simple model addition I would add would be the abillity to easily target portions of the nest to "destroy" (change back to white) and observe how the wasps are able to rebuild. It would be interesting to see how similar their repair is to the original structure, or if there is a notable difference.

## NETLOGO FEATURES

Overall the Netlogo used was fairly standard. The only note is that the symmetric ruleset function was provided in the assignment page, and was not written by me and was instead provided by the assignment.

## Analysis

After many runthroughs of the simulation, it is clear that the most inefficient wasp "species" is the first ruleset (Vespa), followed by the parachartergus. Finally, the vespula wasps are the quickest building of the first 3 provided.

The first custom ruleset uses 3 materials and is primarily composed on interconnected yellow-blue chains. Thesea are broken up by long straight walls of the red material. Generally I've found that the most interesting shapes that form from this rule is when the board is initialized to contain a large amount of red (~50) and a lower amount of yellow/blue (~3-5 each).

Finally, the last ruleset creates interesting "traintrack" or "road" patterns of repeating red and yellow, with blue borders. Interestingly, if the last rule is removed (commented out), then the wasps behave extremely differently, creating extremely small but limited shapes (I think they look almost "tie-fighter"...ish). This final rule is how the patter is able to continue repeating to create these straight "road" patterns.

The final interesting pattern I noticed is when I added the "yellow" material to the first 3 rulesets. Since these rulesets completely ignore this material, it is interesting to see how these wasps build "around" these materials to avoid them.

## CREDITS AND REFERENCES
Assignment description, first 3 simulations as well as the symmetric function code provided by CPSC 565, Emergent Computing by U of C.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
