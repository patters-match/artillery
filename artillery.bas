# Artillery: Projectile motion simulation for ZX Spectrum 
# https://patters.itch.io/artillery
#
        goto @variablessetup

                                                           rem Artillery, based on the 1987 Macintosh game by Kirk Crawford
                                                           rem Started in about 1994 and mostly developed in Feb 2019 by patters
                                                           rem 
                                                           rem sub - trajectories loop
                                                           rem 
@trajectoriesloop:
        for t=0 to 30 step 0.5
#                                                          player 1
#                                                          restore COORDS sysvars, store off-screen and in-flight flags from previous loop
            poke 23677,r: \
            poke 23678,s: \
            let p1=j: \
            let p3=f
#                                                          add wind to x velocity component
            let v1=v1+z/8
#                                                          calculate x position using origin, x velocity component, and time
            let x=o1+v1*t
#                                                          calculate y position using origin, y velocity component, time, and gravity
            let y=o3+v3*t-4.905*t*t
#                                                          is the projectile on screen? still in flight?
            let j=x>=0
            if y<0 then let f=0
            if x>255 then \
                let j=0: \
                if y<c2 then \
                    let f=0
#                                                          remove any previously printed offscreen arrow by reprinting (they use over 1)
            if h=1 then \
                let h=0: \
                print c$
            if h=2 then \
                let h=0: \
                print e$
#                                                          if the projectile is not in flight don't draw
            if not f then \
                goto @pl1nodraw
#                                                          gone off the top of the screen, draw an offscreen arrow
            if y>175 then \
                let j=0: \
                if x>=0 and x<=255 then \
                    let c$(3)=chr$ (int (x/8)): \
                    print c$: \
                    let h=1
#                                                          gone off the far side of the screen, draw an offscreen arrow
            if x>255 then \
                if y>=c2 and y<=175 then \
                    let e$(2)=chr$ (21-int (y/8)): \
                    print e$: \
                    let h=2
#                                                          if off-screen, don't draw
            if not j then goto @pl1nodraw
#                                                          draw trajectory increment line if it was onscreen last loop too 
            if p1 then draw ink 3;x-r,y-s
#                                                          returning from out of screen bounds, plot a pixel only
            if not p1 then plot ink 3;x,y
#                                                          did we hit the ground?
            if attr (21-int (y/8),int (x/8))=gd then let f=0
@pl1nodraw:
#                                                          if we didn't already hit player 2 castle then check all its character attributes for changes
            if not h2 then \
                if peek a+peek b+peek c+peek d<>cs then \
                    let h2=1: \
                    print h$: \
                    beep .4,-20: \
                    let s$=s$+"2": \
                    if x>127 then \
                        let f=0: \
                        let p3=0
#                                                          if the projectile is not in flight, but was flying last loop then play the thud sound
            if not f then \
                if p3 then \
                    beep .01,-20
#                                                          preserve COORDS sysvars so plot and draw commands continue from last used positions for this player
            let r=peek 23677: \
            let s=peek 23678
#                                                          player 2 - same as above, uses equivalent vars
            poke 23677,p: \
            poke 23678,q: \
            let p2=i: \
            let p4=e
            let v2=v2+z/8
            let v=o2+v2*t
            let w=o4+v4*t-4.905*t*t
            let i=v<=255
            if w<0 then let e=0
            if v<0 then \
                let i=0: \
                if w<c1 then \
                    let e=0
            if g=1 then \
                let g=0: \
                print d$
            if g=2 then \
                let g=0: \
                print f$
            if not e then goto @pl2nodraw
            if w>175 then \
                let i=0: \
                if v>=0 and v<=255 then \
                    let d$(3)=chr$ (int (v/8)): \
                    print d$: \
                    let g=1
            if v<0 then \
                if w>=c1 and w<=175 then \
                    let f$(2)=chr$ (21-int (w/8)): \
                    print f$: \
                    let g=2
            if not i then goto @pl2nodraw
            if p2 then draw ink 3;v-p,w-q
            if not p2 then plot ink 3;v,w
            if attr (21-int (w/8),int (v/8))=gd then let e=0
@pl2nodraw:
            if not h1 then \
                if peek l+peek m+peek n+peek o<>cs then \
                    let h1=1: \
                    print g$: \
                    beep .4,-20: \
                    let s$=s$+"1": \
                    if v<128 then \
                        let e=0: \
                        let p4=0
            if not e then \
                if p4 then \
                    beep .01,-20
            let p=peek 23677: \
            let q=peek 23678
        if f or e then next t
        return 
                                                           rem 
                                                           rem sub - redraw terrain
                                                           rem 
@redrawterrain:
        let t=0: \
        if te<>tp or bt<>bp then \
            let t=1
        if bt=bs then \
            if sk=sp then \
                if te=tp then \
                    let t=2
        for y=s to e step dd
            if dd=-1 then \
                if y=18 then \
                    if rv then \
                        gosub @drawwater
            if t=2 then \
                print at y,0; paper 8; ink 8; bright bs; over 1;tab 31;" ": \
                goto @drawcastles
            if c(y+1,1) then \
                print at y,0; paper sk; bright bs; over ov; ink 8;tab c(y+1,1)-1;" "
            if t then \
                print at y,c(y+1,1); paper te; bright bt; over 1; ink 8;tab c(y+1,2);" "
            if c(y+1,2)<31 then \
                print at y,c(y+1,2)+1; paper sk; bright bs; over ov; ink 8;tab 31;" "
@drawcastles:
#                                                          castle sprites are redrawn in horizontal slices with the terrain
            if y=k then print a$(30 to )
            if y=k-1 then print a$(17 to 29)
            if y=k-2 then print a$( to 16)
            if y=u then print b$(30 to )
            if y=u-1 then print b$(17 to 29)
            if y=u-2 then print b$( to 16)
        next y
        if dd=1 and rv then gosub @drawwater:              rem draw water
        return 
                                                           rem 
                                                           rem sub - generate and draw terrain
                                                           rem 
@terraingendraw:
#                                                          terrain sine function produces a height y for each x value (vertical stripes)
#                                                          rendering vertically is very slow, and far too slow for redrawing the screen to implement time of day changes
#                                                          by converting this shape into an array of 20 rows of start-stop extents we can draw the landscape in horizontal slices very fast using tab
#
        dim c(22,2):                                       rem terrain array, last 2 rows for water extents
                                                           rem generate terrain left to right with sine function
        let f=k+2:                                         rem previous y value
        let t=0:                                           rem x is river
        let p=0:                                           rem prev x is river
        let ym=19:                                         rem peak     
#                                                          castle 1 footing
        for n=0 to x1+2: \
            print at k+1,n;"~": \
        next n      
#                                                          landscape between the castles
        for x=x1+3 to x2-2
            let n=abs (31*q-x):                            rem x-flip
            let y=21-int (v*sin (pi/w*n-s)+r+0.5)
                                                           rem river extents
            if y>19 then \
                let y=19: \
                if rv then \
                    let t=1
            if t then \
                if not p then \
                    let c(21+(c(21,1)<>0),1)=x:            rem start
            if not t then \
                if p then \
                    let c(21+(c(21,2)<>0),2)=x-1:          rem end
            if t then \
                if x=x2-2 then \
                    let c(21+(c(21,2)<>0),2)=x:            rem catch last extent
            let p=t: \
            let t=0
            if y<0 then let y=0
            print at y,x;"~"
                                                           rem find horizontal extents
            if y<>f then let c(y+1,2-(y<f))=x
            if y>f then let c(f+1,2)=x-1:                  rem fix descending extents after gaps
            let f=y
            if y<ym then \
                let ym=y: \
                let xy=x:                                  rem peak
        next x
        if u+1>y then let c(y+1,2)=x-1:                    rem fix last descending extent
#                                                          castle 2 footing
        for n=x2-1 to 31: \
            print at u+1,n;"~": \
        next n
#                                                          ensure solid flat ground under both castles in the landscape horizontal slices
        for y=k+1 to 19: \
            let c(y+1,1)=0: \
        next y:                                            rem castle 1 footing
        for y=u+1 to 19: \
            let c(y+1,2)=31: \
        next y:                                            rem castle 2 footing
                                                           rem edge detection pass
        let v=0: \
        let w=0
        for y=ym to 19
            if not c(y+1,1) and y<=k then let c(y+1,1)=v
            if not c(y+1,2) then let c(y+1,2)=w
            let v=c(y+1,1): \
            let w=c(y+1,2)
        next y
                                                           rem 
                                                           rem draw terrain
                                                           rem 
        let ov=0
        for y=19 to ym step -1
            if y=18 then \
                if rv then gosub @drawwater:               rem draw water
            if y=k then print a$
            if y=u then print b$
            print at y,c(y+1,1); paper te; ink 3; bright bt;tab c(y+1,2);" "
        next y
        if k<=ym then print a$
        if u<=ym then print b$
        return 
                                                           rem 
                                                           rem sub - redraw sky
                                                           rem 
@redrawsky:
        for y=s to e step dd
            print at y,0; over ov; ink 8;tab 31;" "
#                                                          castle sprites are redrawn in horizontal slices with the sky
            if y=k then print a$(30 to )
            if y=k-1 then print a$(17 to 29)
            if y=k-2 then print a$( to 16)
            if y=u then print b$(30 to )
            if y=u-1 then print b$(17 to 29)
            if y=u-2 then print b$( to 16)
        next y
        return 

                                                           rem 
                                                           rem sub - redraw terrain and sky
                                                           rem 
@redrawterrainsky:
        let ov=1: \
        let dd=-1: \
        if td=1 or td=4 then let dd=1:                     rem draw dir, sunrise or sunset
        if td=3 and tn>4 then \
            let ov=0: \
            let tn=0:                                      rem nightfall scrubs trails in sky after 4 turns
        if dd=-1 then \
            let s=19: \
            let e=ym: \
            gosub @redrawterrain: \
            let s=ym-1: \
            let e=0: \
            gosub @redrawsky
        if dd=1 then \
            let s=0: \
            let e=ym-1: \
            gosub @redrawsky: \
            let s=ym: \
            let e=19: \
            gosub @redrawterrain
        print a$+b$:                                       rem redraw castles to catch edge cases
        return 
                                                           rem 
                                                           rem sub - draw water
                                                           rem 
@drawwater:
        print at 19,c(21,1); paper 1; bright (bs=0); ink 3; over ov;tab c(21,2)+(c(21,1)>0);at 19,c(22,1);tab c(22,2)+(c(22,1)>0)
        return 
                                                           rem 
                                                           rem sub - check input
                                                           rem 
@entryerror:
        print #0;at 1,ix;"Entry error": \
        pause 50
@checkinput:
        input at 1,ix;(v$;" [";d;"]: "); line i$
        if i$="" then \
            let i=d: \
            return 
        for n=1 to len i$: \
            if code i$(n)<45 or code i$(n)>57 then goto @entryerror: \
        next n
        let i=int val i$
        if i<mn then \
            let i=mn: \
            print #0;"Constrained to min": \
            pause 50
        if i>mx then \
            let i=mx: \
            print #0;"Constrained to max": \
            pause 50
        return 

@newgame:
        paper 7: \
        ink 0: \
        bright 0: \
        flash 0: \
        border 7: \
        cls 
        let s1=0: \
        let s2=0:                                          rem score
        let sk=0: \
        let te=0: \
        let bt=0:                                          rem sky colour, terrain colour, terrain bright
        let td=1:                                          rem time of day
        let ix=0:                                          rem input x pos
        let wn=5: \
        let v$="Score to win match (1-9)": \
        let d=wn: \
        let mn=1: \
        let mx=9: \
        gosub @checkinput: \
        let wn=i
        randomize 
                                                           rem 
                                                           rem start round
                                                           rem 
@startround:
        let z=(int (rnd*11))-5:                            rem wind
        if td=5 then let td=1:                             rem loop time of day counter
                                                           rem default params
        let a1=60: \
        let a2=60:                                         rem angle (deg)
        let q1=45: \
        let q2=45:                                         rem initial velocity
        let h1=0: \
        let h2=0:                                          rem reset castle hit states
        let s$="":                                         rem records order castles are hit in
        let tn=0:                                          rem turns
                                                           rem 
                                                           rem terrain and castle setup
                                                           rem 
@castleselevation:
#                                                          define all our random variables for the terrain now, and check they produce valid castle elevations, re-roll if not
#                                                          full terrain will be calculated later using these same random vars
#
        let v=(rnd*8)+3:                                   rem amplitude
        let w=(rnd*4)+13:                                  rem frequency
        let r=(rnd*(17-((v<6)*v)+((v>9)*(12-v))))-2:       rem y-offset
        let s=((rnd*25)+2)/10:                             rem x-offset
        let q=int (rnd*2):                                 rem terrain function may x-flip, to remove bias
                                                           rem castle 1 location
        let x1=2+(int (rnd*4))
        let n=abs (31*q-(x1+2)):                           rem x-flip
        let k=21-int (v*sin (pi/w*n-s)+r+0.5)-1:           rem castle is 1 row higher than terrain at x
        if k<4 then goto @castleselevation:                rem problem, reset terrain params
        if k>18 then let k=18
                                                           rem castle 2 location
        let x2=28-(int (rnd*4))
        let n=abs (31*q-(x2-1)):                           rem x-flip
        let u=21-int (v*sin (pi/w*n-s)+r+0.5)-1:           rem castle is 1 row higher than terrain at x
        if u<4 then goto @castleselevation:                rem problem, reset terrain params
        if u>18 then let u=18
                                                           rem castle coords valid, continue setup
        let lv=int (rnd*8)+2:                              rem level type, grass desert soil snow
        if lv>7 then let lv=3:                             rem grass is more likely
        let rv=int (rnd*3): \
        if rv=2 then let rv=0:                             rem water
        if lv=7 then let rv=1
                                                           rem trajectory origin coords
        let o1=(x1+2)*8: \
        let o3=(21-k+2)*8
        let o2=(x2*8)-1: \
        let o4=(21-u+2)*8
        gosub @settimeofday:                               rem set up time of day
        ink 0: \
        cls 
        gosub @windarrow:                                  rem wind arrow
        for n=20 to 21: \
            print at n,0; bright 0; paper 7; over 1;tab 31;" ": \
        next n
                                                           rem 
                                                           rem update castle sprites
                                                           rem 
        let a$(2 to 3)=chr$ (k-2)+chr$ (x1+po): \
        let a$(10 to 13)=w$(po+1)+chr$ 22+chr$ (k-2)+chr$ (x1+fl): \
        let a$(16 to 19)=w$(fl+1)+chr$ 22+chr$ (k-1)+chr$ x1: \
        let a$(31 to 32)=chr$ k+chr$ x1
        let b$(2 to 3)=chr$ (u-2)+chr$ (x2+po): \
        let b$(10 to 19)=w$(po+1)+chr$ 22+chr$ (u-2)+chr$ (x2+fl)+chr$ 16+chr$ 2+w$(fl+1)+chr$ 22+chr$ (u-1)+chr$ x2: \
        let b$(31 to 32)=chr$ u+chr$ x2
        let g$( to 32)=a$( to 32): \
        let g$(9)=chr$ 6: \
        let g$(28)=chr$ 2
        let h$( to 32)=b$( to 32): \
        let h$(9)=chr$ 6: \
        let h$(28)=chr$ 2
        gosub @updspritecolours:                           rem update sprite colours
        gosub @terraingendraw:                             rem generate and draw terrain
                                                           rem 
                                                           rem start turn
                                                           rem 
@startturn:
        let tn=tn+1
        print at 21,1; bright 0; inverse 1; paper 7;"SCORE  ";at 21,8-(s1>9);s1;at 21,23;"SCORE  ";at 21,30-(s2>9);s2
        gosub @pl1userinput:                               rem player 1 input
        print a$(11 to 16)
        gosub @pl2userinput:                               rem player 2 input
        print b$(11 to 16)
        let j=1: \
        let i=1:                                           rem on-screen trajectory flag
        let f=1: \
        let e=1:                                           rem projectile in flight flag
        let r=o1: \
        let s=o3: \
        let p=o2: \
        let q=o4:                                          rem draw coords set to origins
#                                                          x = (velocity * COS(angle)) + (wind * time * time)
#                                                          y = (velocity * SIN(angle)) - (0.5 * gravity * time * time)
                                                           rem velocity components
        let n=a1*pi/180:                                   rem deg to rad
        let v1=q1*cos n
        let v3=q1*sin n
        let n=(180-a2+180)*pi/180:                         rem deg to rad, x flip
        let v2=-q2*cos n
        let v4=-q2*sin n
        let h=0: let g=0:                                  rem off screen arrows
        let c1=(21-k)*8: let c2=(21-u)*8:                  rem castle footings y
                                                           rem castle attr mem addr
        let l=22528+k*32+x1: \
        let m=l+1: \
        let n=l-32: \
        let o=n+1
        let a=22528+u*32+x2: \
        let b=a+1: \
        let c=a-32: \
        let d=c+1
        beep .1,-35
        gosub @trajectoriesloop:                           rem trajectories loop
                                                           rem 
                                                           rem end of turn, check outcomes
                                                           rem 
        print a$(11 to 16)+b$(11 to 16):                   rem fix flags colour clash
        for n=0 to 1: \
            print at 20+n,0; bright 0; paper 7; over 1;tab 31;" ": \
        next n:                                            rem fix hud colour clash
        if s$="1" then \
            let pl=1: \
            let x=x1: \
            let y=k: \
            gosub @castlecollapse:                         rem castle 1 collapse
        if s$="2" then \
            let pl=2: \
            let x=x2: \
            let y=u: \
            gosub @castlecollapse:                         rem castle 2 collapse
        if s$="21" then \
            let pl=2: \
            let x=x2: \
            let y=u: \
            gosub @castlecollapse: \
            let pl=1: \
            let y=k: \
            let x=x1: \
            gosub @castlecollapse:                         rem castle 2 then 1 collapse
        if s$="12" then \
            let pl=1: \
            let x=x1: \
            let y=k: \
            gosub @castlecollapse: \
            let pl=2: \
            let y=u: \
            let x=x2: \
            gosub @castlecollapse:                         rem castle 1 then 2 collapse
        if s$<>"" then \
            let td=int td+1: \
            goto @checkscores:                             rem round over, increment time of day
        if td=2 or td=4 then let td=td+0.5:                rem dawn and dusk last one turn only
        let td=td+0.5: \
        if td=5 then let td=1:                             rem night and day last two turns
        if td-(int td)=0 then \
            gosub @settimeofday: \
            gosub @updspritecolours: \
            gosub @redrawterrainsky:                       rem change time of day, update sprites, redraw screen
        goto @startturn:                                   rem no score, round continues
                                                           rem 
                                                           rem user defined graphics
                                                           rem 
@udg:
        restore @udgdata
        for x=0 to 71: \
            read y: \
            poke usr "a"+x,y: \
        next x
@udgdata:
        data 1,1,1,1,1,1,1,1,\
             153,153,255,96,40,37,34,34,\
             153,153,255,38,132,68,164,164,\
             34,34,35,32,44,38,32,32,\
             164,36,236,28,20,4,100,4,\
             128,128,128,128,128,128,128,128,\
             0,16,40,16,0,0,0,0,\
             0,0,16,32,126,32,16,0,\
             0,0,8,4,126,4,8,0
                                                           rem 
                                                           rem variables setup, perf critical first
                                                           rem 
@variablessetup:
#                                                          variables are assigned in performance priority order
#                                                          those assigned first are retrieved faster by Sinclair BASIC
        let x=0: \
        let y=0: \
        let v=0: \
        let w=0: \
        let r=0: \
        let s=0: \
        let p=0: \
        let q=0: \
        let t=0: \
        let v1=0: \
        let v3=0: \
        let v2=0: \
        let v4=0: \
        let o1=0: \
        let o3=0: \
        let o2=0: \
        let o4=0: \
        let f=0: \
        let e=0: \
        let j=0: \
        let i=0: \
        let h=0: \
        let g=0: \
        let p1=0: \
        let p2=0: \
        let p3=0: \
        let p4=0: \
        let h1=0: \
        let h2=0: \
        let gd=0: \
        let cs=0
        dim c$(12): \
        restore @arrowsprite: \
        for n=1 to 12: \
            read a: \
            let c$(n)=chr$ a: \
        next n
        let d$=c$: \
        let e$=c$: \
        let f$=c$: \
        let e$(12)="\i": \
        let e$(3)=chr$ 31: \
        let f$(12)="\h":                                   rem offscreen arrows
        dim a$(42): \
        dim b$(42):                                        rem castle sprites
        dim g$(46): \
        dim h$(46):                                        rem hit castle sprites
#                                                          define sprites as chr$ control codes with position and colours encoded - will render much faster than print at
@arrowsprite:
        data 22,0,0,21,1,19,8,17,8,16,3,94:                rem top arrow
@castlesprite:
        data 22,17,0,17,8,19,8,16,7,144,22,17,1,16,1,130:  rem castle flag
        data 22,18,0,19,1,16,0,145,19,0,16,1,146:          rem castle top
        data 22,19,0,19,1,16,0,147,19,0,16,1,148:          rem castle base
        data 6,17,2,18,1,21,1,137,19,0,137:                rem castle fire
        restore @castlesprite
        for n=1 to 42: \
            read a: \
            let a$(n)=chr$ a: \
        next n
        let b$()=a$
        let g$=a$
        for n=36 to 46: \
            read a: \
            let g$(n)=chr$ a: \
        next n
        let h$()=g$
        dim c(22,2)
                                                           rem time of day colour lookup table
                                                           rem day,dusk,night,dawn - 1st row sky types, +10 for bright
        restore @colourlut
@colourlut:
        data 15,5,1,6
        data 2,2,0,2
        data 4,4,0,4
        data 14,4,0,5
        data 6,6,0,6
        data 16,6,0,16
        data 17,17,5,17
        dim e(7,4)
        for n=1 to 7: \
            for t=1 to 4: \
                read a: \
                let e(n,t)=a: \
            next t: \
        next n
        goto @newgame
                                                           rem 
                                                           rem sub - user input player 1
                                                           rem 
@pl1userinput:
        print at k-2,x1+fl; ink 1-(sk=1); flash 1; bright bs;"\..": rem highlight flag
        let ix=0: \
        let v$="Angle": \
        let d=a1: \
        let mn=-45: \
        let mx=135: \
        gosub @checkinput: \
        let a1=i
        print at 20,1; paper 7; ink 0; bright 0;"    ";at 20,1;a1;"\g"
        let ix=0: \
        let v$="Velocity": \
        let d=q1: \
        let mn=20: \
        let mx=99: \
        gosub @checkinput: \
        let q1=i
        print at 20,6; paper 7; ink 0; bright 0;"    ";at 20,6;"V";q1
        return 
                                                           rem 
                                                           rem sub - user input player 2
                                                           rem 
@pl2userinput:
        print at u-2,x2+fl; ink 2; flash 1; bright bs;"\..": rem highlight flag
        let ix=15: \
        let v$="Angle": \
        let d=a2: \
        let mn=-45: \
        let mx=135: \
        gosub @checkinput: \
        let a2=i
        print at 20,23; paper 7; ink 0; bright 0;"    ";at 20,23;a2;"\g"
        let ix=12: \
        let v$="Velocity": \
        let d=q2: \
        let mn=20: \
        let mx=99: \
        gosub @checkinput: \
        let q2=i
        print at 20,28; paper 7; ink 0; bright 0;"    ";at 20,28;"V";q2
        input #1:                                          rem clear bottom of screen
        return 
                                                           rem 
                                                           rem sub - wind arrow & flag
                                                           rem 
@windarrow:
        let r$="no wind": \
        if z>0 then \
            let m$="-----": \
            let r$=m$(1 to z-1)+">"
        if z then print at 21,14;"wind"
        if z<0 then \
            let m$="<-----": \
            let r$=m$(1 to int (abs (z)+0.5))
        let n=int ((32-(len r$))/2)
        print at 20,n; r$
        if z<0 then \
            plot (8*n)+3,11: \
            draw (((len r$)-1)*8)+3,0
        if z>0 then \
            plot (8*n)+2,11: \
            draw (((len r$)-1)*8)+3,0
        let w$="\a\' \. ": \
        let po=0: \
        let fl=1
        if z<0 then \
            let w$="\ '\f\ .": \
            let po=1: \
            let fl=0
        return 
                                                           rem 
                                                           rem sub - castle collapse
                                                           rem 
@castlecollapse:
        print at y-2,x+fl; ink pl-(pl=1 and sk=1);w$(3): \
        pause 10: \
        print at y-2,x+fl;" ": \
        pause 10: \
        print at y-2,x+fl; ink 7; bright bs;w$(3): \
        pause 10: \
        print at y-2,x+fl; ink 7; bright bs;w$(fl+1)
        pause 60: \
        print at y-2,x;"  ";at y-1,x; ink 0; bright 1; over 1;"#"; bright 0; ink 1-(sk=1);"#";at y,x; bright 1; ink 0;"\b"; bright 0; ink 1-(sk=1);"\c"
        for n=20 to -10 step -5: \
            beep 0.005,n: \
        next n
        print at y-1,x; ink 0; bright bs;"  ";at y,x; bright bs; inverse 1; over 1;"00"
        print at y,x-1; ink 0; bright bs;".";at y,x+2; ink 1-(sk=1);"'"
        pause 20: \
        print at y-2,x; ink 0; bright bs;"  ";at y-1,x;"  ";at y,x; bright 1;"\b"; bright 0; ink 1-(sk=1);"\c"; bright bs;",";at y,x; over 1; bright 1; ink 0;"_"; ink 1-(sk=1); bright 0;"_"
        pause 20: \
        return 
                                                           rem 
                                                           rem sub - set time of day
                                                           rem 
@settimeofday:
        let sp=sk: \
        let tp=te: \
        let bp=bt:                                         rem store previous values
        let sk=e(1,td)
        let bs=0:                                          rem sky bright
        if sk>10 then \
            let bs=1: \
            let sk=sk-10
        let te=e(lv,td)
        let bt=0:                                          rem terrain bright
        if te>10 then \
            let bt=1: \
            let te=te-10
                                                           rem colour constraints
        if te=6 and sk=6 then let sk=5
        if te=5 and sk=5 then \
            let sk=6: \
            let bs=0
        paper sk: \
        bright bs
        let gd=64*bt+8*te+3:                               rem ground attr
        let cs=32*sk+130-(sk=1)*2:                         rem castle aggregate attr
        return 
                                                           rem 
                                                           rem sub - update sprite colours
                                                           rem 
@updspritecolours:
        if sk=1 or sp=1 then \
            let a$(9)=chr$ (7-(sk=1)*2): \
            let b$(9)=a$(9): \
            let a$(15)=chr$ (1-(sk=1)): \
            let a$(28)=a$(15): \
            let b$(28)=a$(15): \
            let a$(41)=a$(15): \
            let b$(41)=a$(15): \
            let g$(15)=a$(15): \
            let g$(21 to 23)=a$(15)+chr$ 16+chr$ (0+(sk=1)*6): \
            let h$(21 to 23)=g$(21 to 23)
        if sk=6 or sp=6 then \
            let g$(9)=chr$ (6+(sk=6)): \
            let h$(9)=g$(9)
        return 
                                                           rem 
                                                           rem check scores
                                                           rem 
@checkscores:
        paper 7: \
        bright 0: \
        ink 0: \
        pause 60
        print at 21,1; bright 0; inverse 1; paper 7;"SCORE  ";at 21,8-(s1>9);s1;at 21,14; inverse 0;"    ";at 21,23; inverse 1;"SCORE  ";at 21,30-(s2>9);s2;at 20,0; inverse 0;tab 31;" "
        for n=0 to 10: \
            print at n,0; over 1; bright 0;tab 31;" ";at 20-n,0;tab 31;" ": \
        next n: \
        pause 20
        if h2=1 then \
            let s1=s1+1: \
            beep 0.01,20: \
            print at 21,8-(s1>9); inverse 1; paper 7; bright 1;s1: \
            beep 0.01,30: \
            pause 30
        if h1=1 then \
            let s2=s2+1: \
            beep 0.01,20: \
            print at 21,30-(s2>9); inverse 1; bright 1; paper 7;s2: \
            beep 0.01,30: \
            pause 30
        pause 60: \
        for n=0 to 10: \
            print at n,0;tab 31;" ";at 20-n,0;tab 31;" ": \
        next n
        if s1<wn and s2<wn then goto @startround
        if s1=s2 then let wn=wn+1: goto @startround:       rem tied, play another round
                                                           rem 
                                                           rem game over yeah
                                                           rem 
        if s1=wn then let pl=1
        if s2=wn then let pl=2
        cls : \
        bright bs: \
        paper sk
        for n=6 to 12
            if n>10 then \
                paper te: \
                bright bt
            print at n,12;tab 19;" "
        next n
        let n=10: \
        let y=10: \
        let x=15: \
        paper sk: \
        bright bs: \
        print at y-2,x; ink 7-(sk=1)*2;"\a"; ink pl-(pl=1 and sk=1);"\' ";at y-1,x;a$(20 to 29);at y,x;a$(33 to ): \
        pause 5: \
        print at y-2,x+1; ink pl-(pl=1 and sk=1);"\''": \
        pause n
        ink pl: \
        print at 15,12; bright 0; inverse 1; paper 7;"VICTORY!"
        let x=x+2: \
        let y=y-2: \
        pause n: \
        ink pl-(pl=1 and sk=1): \
        bright bs: \
        print at y,x;"\' ": \
        pause n: \
        print at y,x;"\. ": \
        pause n: \
        flash 1: \
        print at y,x;"\'.": \
        pause n*2: \
        print at y,x;"\''": \
        print at y,x+1; flash 0;"\' ": \
        pause n: \
        print at y,x+1; flash 0;"\. ": \
        pause n: \
        print at y,x+1;"\.."
        beep 0.5,0: \
        beep 0.25,0: \
        beep 0.5,7
        flash 0: \
        paper 7: \
        ink 0: \
        bright 0: \
        pause 0: \
        let sp=1: \
        let sk=6: \
        gosub @updspritecolours: \
        goto @newgame

# Sinclair BASIC is much faster with smaller variables names, lookup table below:

# +--------------+-----------------------------------------+-----------------------------------+---------------------+-------------------+-----------------+
# | Var/Context  | Global                                  | Trajectory loop                   | Terrain generation  | Edge detect       | Terrain draw    |
# +--------------+-----------------------------------------+-----------------------------------+---------------------+-------------------+-----------------+
# | a            | pl2 castle ATTR mem addr 1              |                                   |                     |                   |                 |
# | b            | pl2 castle ATTR mem addr 2              |                                   |                     |                   |                 |
# | c            | pl2 castle ATTR mem addr 3              |                                   |                     |                   |                 |
# | d            | pl2 castle ATTR mem addr 4              |                                   |                     |                   |                 |
# | e            |                                         | pl2 projectile in flight flag     |                     |                   | y end           |
# | f            |                                         | pl1 projectile in flight flag     | previous y value    |                   |                 |
# | g            |                                         | pl2 offscreen arrow flag          |                     |                   |                 |
# | h            |                                         | pl1 offscreen arrow flag          |                     |                   |                 |
# | i            |                                         | pl2 trajectory onscreen flag      |                     |                   |                 |
# | j            |                                         | pl1 trajectory onscreen flag      |                     |                   |                 |
# | k            | pl1 castle PRINT y                      |                                   |                     |                   |                 |
# | l            | pl1 castle ATTR mem addr 1              |                                   |                     |                   |                 |
# | m            | pl1 castle ATTR mem addr 2              |                                   |                     |                   |                 |
# | n            | pl1 castle ATTR mem addr 3              |                                   |                     |                   |                 |
# | o            | pl1 castle ATTR mem addr 4              |                                   |                     |                   |                 |
# | p            |                                         | pl2 projectile last x coord       | prev x is river     |                   |                 |
# | q            |                                         | pl2 projectile last y coord       | direction           |                   |                 |
# | r            |                                         | pl1 projectile last x coord       | y-offset            |                   |                 |
# | s            |                                         | pl1 projectile last y coord       | x-offset            |                   | y start         |
# | t            |                                         | time                              | x is river          |                   |                 |
# | u            | pl2 castle PRINT y                      |                                   |                     |                   |                 |
# | v            |                                         | pl2 projectile x coord            | amplitude           | prev left extent  |                 |
# | w            |                                         | pl2 projectile y coord            | frequency           | prev right extent |                 |
# | x            |                                         | pl1 projectile x coord            | x                   | x                 |                 |
# | y            |                                         | pl1 projectile y coord            | y                   | y                 |                 |
# | z            | wind                                    |                                   |                     |                   |                 |
# |              |                                         |                                   |                     |                   |                 |
# | bp           | previous terrain brightness             |                                   |                     |                   |                 |
# | bs           | sky brightness                          |                                   |                     |                   |                 |
# | bt           | terrain brightness                      |                                   |                     |                   |                 |
# | c1           | pl1 castle footing PLOT height          |                                   |                     |                   |                 |
# | c2           | pl2 castle footing PLOT height          |                                   |                     |                   |                 |
# | cs           | castle aggregate ATTR                   |                                   |                     |                   |                 |
# | dd           |                                         |                                   |                     |                   | draw direction  |
# | fl           | flag offset                             |                                   |                     |                   |                 |
# | gd           | terrain ATTR                            |                                   |                     |                   |                 |
# | h1           | pl1 castle hit                          |                                   |                     |                   |                 |
# | h2           | pl2 castle hit                          |                                   |                     |                   |                 |
# | lv           | level type (for LUT)                    |                                   |                     |                   |                 |
# | mn           | INPUT min value                         |                                   |                     |                   |                 |
# | mx           | INPUT max value                         |                                   |                     |                   |                 |
# | o1           | pl1 x origin                            |                                   |                     |                   |                 |
# | o2           | pl2 x origin                            |                                   |                     |                   |                 |
# | o3           | pl1 y origin                            |                                   |                     |                   |                 |
# | o4           | pl2 y origin                            |                                   |                     |                   |                 |
# | ov           | sky OVER                                |                                   |                     |                   |                 |
# | p1           |                                         | pl1 previous loop offscreen flag  |                     |                   |                 |
# | p2           |                                         | pl2 previous loop offscreen flag  |                     |                   |                 |
# | p3           |                                         | pl1 previous loop in flight flag  |                     |                   |                 |
# | p4           |                                         | pl1 previous loop in flight flag  |                     |                   |                 |
# | po           | flag pole offset                        |                                   |                     |                   |                 |
# | q1           | pl1 intial velocity                     |                                   |                     |                   |                 |
# | q2           | pl2 initial velocity                    |                                   |                     |                   |                 |
# | rv           | rivers flag                             |                                   |                     |                   |                 |
# | s1           | pl1 score                               |                                   |                     |                   |                 |
# | s2           | pl2 score                               |                                   |                     |                   |                 |
# | sk           | sky colour                              |                                   |                     |                   |                 |
# | sp           | previous sky colour                     |                                   |                     |                   |                 |
# | td           | time of day                             |                                   |                     |                   |                 |
# | te           | terrain colour                          |                                   |                     |                   |                 |
# | tn           | play turns counter                      |                                   |                     |                   |                 |
# | tp           | previous terrain colour                 |                                   |                     |                   |                 |
# | v1           | pl1 x velocity component                |                                   |                     |                   |                 |
# | v2           | pl2 x velocity component                |                                   |                     |                   |                 |
# | v3           | pl1 y velocity component                |                                   |                     |                   |                 |
# | v4           | pl2 y velocity component                |                                   |                     |                   |                 |
# | wn           | win score                               |                                   |                     |                   |                 |
# | x1           | pl1 castle PRINT x                      |                                   |                     |                   |                 |
# | x2           | pl2 castle PRINT x                      |                                   |                     |                   |                 |
# | ym           | terrain peak                            |                                   |                     |                   |                 |
# |              |                                         |                                   |                     |                   |                 |
# | a$           | pl1 castle sprite                       |                                   |                     |                   |                 |
# | b$           | pl2 castle sprite                       |                                   |                     |                   |                 |
# | c$           | pl1 offscreen top arrow                 |                                   |                     |                   |                 |
# | d$           | pl2 offscreen top arrow                 |                                   |                     |                   |                 |
# | e$           | pl1 offscreen right arrow               |                                   |                     |                   |                 |
# | f$           | pl2 offscreen left arrow                |                                   |                     |                   |                 |
# | g$           | pl1 castle hit sprite                   |                                   |                     |                   |                 |
# | h$           | pl2 castle hit sprite                   |                                   |                     |                   |                 |
# | i$           | INPUT entered string                    |                                   |                     |                   |                 |
# | m$           | wind arrow assembly                     |                                   |                     |                   |                 |
# | r$           | wind readout                            |                                   |                     |                   |                 |
# | s$           | round results (castle hit order)        |                                   |                     |                   |                 |
# | v$           | INPUT value prompt                      |                                   |                     |                   |                 |
# | w$           | flag and pole (orients w. wind)         |                                   |                     |                   |                 |
# |              |                                         |                                   |                     |                   |                 |
# | c(22,2)      | terrain array  (last 2 rows for water)  |                                   |                     |                   |                 |
# | e(7,4)       | sky and terrain colour LUT              |                                   |                     |                   |                 |
# +--------------+-----------------------------------------+-----------------------------------+---------------------+-------------------+-----------------+


