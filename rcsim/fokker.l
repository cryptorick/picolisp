# 17sep04abu
# (c) Software Lab. Alexander Burger

(=: mass 910.0)               # kg
(=: power 3924.0)             # N
(=: rc -1.4)                  # kg/m
(=: lc -250.0)                # kg/m
(=: trim 25)                  # Trimmung
(=: lim1 0.8)                 # tan(a)
(=: lim2 0.24)
(=: tx 1.2)                   # Touchdown
(=: tz -1.9)
(=: pitch 0.26)
(=: torq -10000.0)            # Drehmoment
(=: stab (0.01 0.01 0.02))    # Stabilitaet

(model This
   '(body  0.0  0.0  1.50
      # Flaeche oben
      (`Blue `Blue
         -0.15  +0.30  +1.05
         +1.20   0.00  +1.05
         +1.20  +3.90  +1.05
         +0.90  +4.20  +1.05
         -0.20  +3.90  +1.05
         -0.60  +2.20  +1.05
         -0.60  +0.60  +1.05 )
      (`Blue `Blue
         -0.60  -0.60  +1.05
         -0.60  -2.20  +1.05
         -0.20  -3.90  +1.05
         +0.90  -4.20  +1.05
         +1.20  -3.90  +1.05
         +1.20   0.00  +1.05
         -0.15  -0.30  +1.05 )
      (`Blue `Blue
         +1.20   0.00  +1.05
         -0.15  -0.30  +1.05
         -0.15  +0.30  +1.05 )

      # Querruder
      (rightAileron  -0.60  +2.20  +1.05
         (`Red `Red
            +0.40  +1.70   0.00
            +0.72  +1.78   0.00
            +0.72  +1.90   0.00
            +0.40  +2.10   0.00
             0.00  +1.80   0.00
             0.00  +1.70   0.00 )
         (`Red `Red
            +0.40  +1.70   0.00
             0.00  +1.70   0.00
             0.00   0.00   0.00 ) )
      (leftAileron  -0.60  -2.20  +1.05
         (`Red `Red
            +0.40  -1.70   0.00
            +0.72  -1.78   0.00
            +0.72  -1.90   0.00
            +0.40  -2.10   0.00
             0.00  -1.80   0.00
             0.00  -1.70   0.00 )
         (`Red `Red
            +0.40  -1.70   0.00
             0.00  -1.70   0.00
             0.00   0.00   0.00 ) )

      # Flaeche rechts unten
      (`Blue `Blue
         +0.90  +0.20  -0.60
         +0.90  +3.90  -0.30
         +0.60  +4.20  -0.30
         -0.90  +3.90  -0.30
         -0.90  +0.20  -0.60 )

      # Flaeche links unten
      (`Blue `Blue
         -0.90  -0.20  -0.60
         -0.90  -3.90  -0.30
         +0.60  -4.20  -0.30
         +0.90  -3.90  -0.30
         +0.90  -0.20  -0.60 )

      # Streben links
      (`Brown `Brown
         -0.20  -2.55  +1.05
         -0.50  -2.55  -0.37
         -0.60  -2.55  -0.37
         -0.30  -2.55  +1.05 )

      (`Brown `Brown
         -0.50  -2.55  -0.37
         -0.50  -2.55  -0.37
         +0.80  -2.55  +0.90
         +0.80  -2.55  +1.05 )

      (`Brown `Brown
         +0.90  -2.55  +1.05
         +0.60  -2.55  -0.37
         +0.50  -2.55  -0.37
         +0.80  -2.55  +1.05 )

      # Streben rechts
      (`Brown `Brown
         -0.20  +2.55  +1.05
         -0.50  +2.55  -0.37
         -0.60  +2.55  -0.37
         -0.30  +2.55  +1.05 )

      (`Brown `Brown
         -0.50  +2.55  -0.37
         -0.50  +2.55  -0.37
         +0.80  +2.55  +0.90
         +0.80  +2.55  +1.05 )

      (`Brown `Brown
         +0.90  +2.55  +1.05
         +0.60  +2.55  -0.37
         +0.50  +2.55  -0.37
         +0.80  +2.55  +1.05 )

      # Motorlager
      (`Grey NIL
         +1.80  +0.30  +0.30
         +1.80  -0.30  +0.30
         +1.80  -0.30  -0.30
         +1.80  +0.30  -0.30 )

      # Rumpfnase
      (`Blue NIL
         +1.20   0.00  +0.60
         +1.80  -0.30  +0.30
         +1.80  +0.30  +0.30 )
      (`Blue NIL
         +1.20   0.00  +0.60
         +1.20  -0.45  +0.30
         +1.80  -0.30  +0.30 )
      (`Blue NIL
         +1.80  +0.30  +0.30
         +1.20  +0.45  +0.30
         +1.20   0.00  +0.60 )
      (`Blue NIL
         +1.20  -0.45  +0.30
         +1.20  -0.45  -0.30
         +1.80  -0.30  -0.30
         +1.80  -0.30  +0.30 )
      (`Blue NIL
         +1.80  +0.30  +0.30
         +1.80  +0.30  -0.30
         +1.20  +0.45  -0.30
         +1.20  +0.45  +0.30 )
      (`Blue NIL
         +1.20  -0.45  -0.30
         +1.20  -0.30  -0.60
         +1.80  -0.30  -0.30 )
      (`Blue NIL
         +1.80  +0.30  -0.30
         +1.20  +0.30  -0.60
         +1.20  +0.45  -0.30 )
      (`Blue NIL
         +1.20  -0.30  -0.60
         +1.20  +0.30  -0.60
         +1.80  +0.30  -0.30
         +1.80  -0.30  -0.30 )

      # Rumpfseite rechts
      (`Red NIL
         +1.20  +0.45  +0.30
         +1.20  +0.45  -0.30
         -1.50  +0.45  -0.30
         -1.50  +0.45  +0.30
         -1.20  +0.45  +0.45
         -0.90  +0.45  +0.45 )
      (`Red NIL
         -1.50  +0.45  +0.30
         -1.50  +0.45  -0.30
         -4.80   0.00  -0.30
         -4.80   0.00   0.00 )

      # Rumpfseite links
      (`Red NIL
         -0.90  -0.45  +0.45
         -1.20  -0.45  +0.45
         -1.50  -0.45  +0.30
         -1.50  -0.45  -0.30
         +1.20  -0.45  -0.30
         +1.20  -0.45  +0.30 )
      (`Red NIL
         -4.80   0.00   0.00
         -4.80   0.00  -0.30
         -1.50  -0.45  -0.30
         -1.50  -0.45  +0.30 )

      # Rumpfoberteil vorne
      (`Red NIL
         +1.20   0.00  +0.60
         +1.20  +0.45  +0.30
         -0.90  +0.45  +0.45
         -0.60   0.00  +0.60 )
      (`Red NIL
         -0.60   0.00  +0.60
         -0.90  -0.45  +0.45
         +1.20  -0.45  +0.30
         +1.20   0.00  +0.60 )

      # Cockpit
      (`Brown NIL
         -0.60   0.00  +0.60
         -0.90  +0.45  +0.45
         -0.90  -0.45  +0.45 )
      (`Black NIL
         -0.90  +0.45  +0.45
         -1.20  +0.45  +0.45
         -1.20  -0.45  +0.45
         -0.90  -0.45  +0.45 )
      (`Black NIL
         -1.20  +0.45  +0.45
         -1.35   0.00  +0.54
         -1.20  -0.45  +0.45 )

      # Rumpfoberteil hinten
      (`Red NIL
         -1.35   0.00  +0.54
         -1.20  +0.45  +0.45
         -4.80   0.00   0.00 )
      (`Red NIL
         -1.20  +0.45  +0.45
         -1.50  +0.45  +0.30
         -4.80   0.00   0.00 )
      (`Red NIL
         -4.80   0.00   0.00
         -1.20  -0.45  +0.45
         -1.35   0.00  +0.54 )
      (`Red NIL
         -4.80   0.00   0.00
         -1.50  -0.45  +0.30
         -1.20  -0.45  +0.45 )

      # Rumpfboden
      (`Red NIL
         +1.20  +0.45  -0.30
         +1.20  +0.30  -0.60
         -1.50  +0.30  -0.60
         -1.50  +0.45  -0.30 )
      (`Red NIL
         +1.20  +0.30  -0.60
         +1.20  -0.30  -0.60
         -1.50  -0.30  -0.60
         -1.50  +0.30  -0.60 )
      (`Red NIL
         -1.50  -0.45  -0.30
         -1.50  -0.30  -0.60
         +1.20  -0.30  -0.60
         +1.20  -0.45  -0.30 )
      (`Red NIL
         -4.80   0.00  -0.30
         -1.50  -0.30  -0.60
         -1.50  -0.45  -0.30 )
      (`Red NIL
         -4.80   0.00  -0.30
         -1.50  +0.30  -0.60
         -1.50  -0.30  -0.60 )
      (`Red NIL
         -1.50  +0.45  -0.30
         -1.50  +0.30  -0.60
         -4.80   0.00  -0.30 )

      # Hoehenleitwerk
      (`Red `Red
         -3.60  +0.15   0.00
         -4.20  +1.80   0.00
         -4.50  +1.80   0.00
         -4.50  +0.06   0.00 )
      (`Red `Red
         -4.50  -0.06   0.00
         -4.50  -1.80   0.00
         -4.20  -1.80   0.00
         -3.60  -0.15   0.00 )

      # Hoehenruder
      (elevator  -4.50  0.00  0.00
         (`Blue `Blue
             0.00  +1.80   0.00
            -0.60  +1.50   0.00
            -0.60  +0.60   0.00
             0.00  +0.06   0.00 )
         (`Blue `Blue
             0.00  -0.06   0.00
            -0.60  -0.60   0.00
            -0.60  -1.50   0.00
             0.00  -1.80   0.00 ) )

      # Seitenleitwerk
      (`Red `Red
         -4.80   0.00   0.00
         -3.60   0.00  +0.15
         -4.20   0.00  +0.90
         -4.80   0.00  +1.05 )

      # Seitenruder
      (rudder  -4.80  0.00  0.00
         (`Blue `Blue
             0.00   0.00  +1.05
             0.00   0.00  -0.30
            -0.45   0.00  +0.30
            -0.45   0.00  +0.90 ) )

      # Schatten Nase
      (NIL T
         +0.90  -0.30  -0.20
         +1.70   0.00  -0.20
         +0.90  +0.30  -0.20 )

      # Schatten Flaechen
      (NIL T
         +0.90  -3.00  -0.20
         +0.90  +3.00  -0.20
         -0.90  +3.00  -0.20
         -0.90  -3.00  -0.20 )

      # Schatten Rumpf
      (NIL T
         -0.90  -0.40  -0.20
         -0.90  +0.40  -0.20
         -4.70   0.00  -0.20 )

      # Schatten Leitwerk
      (NIL T
         -3.60   0.00  -0.20
         -4.20  +1.80  -0.20
         -4.50  +1.80  -0.20
         -4.50  -1.80  -0.20
         -4.20  -1.80  -0.20 )

      # Spinner
      (`Blue NIL
         +1.80  +0.15  -0.15
         +1.80  +0.15  +0.15
         +2.10   0.00   0.00 )
      (`Blue NIL
         +1.80  -0.15  -0.15
         +1.80  +0.15  -0.15
         +2.10   0.00   0.00 )
      (`Blue NIL
         +1.80  -0.15  +0.15
         +1.80  -0.15  -0.15
         +2.10   0.00   0.00 )
      (`Blue NIL
         +1.80  +0.15  +0.15
         +1.80  -0.15  +0.15
         +2.10   0.00   0.00 )

      # Fahrwerk
      (`Grey `Grey
         +1.20  +0.30  -0.60
         +1.20  +0.90  -1.47
         +1.20  +1.00  -1.47
         +1.20  +0.40  -0.60 )
      (`Grey `Grey
         +1.20  -0.30  -0.60
         +1.20  -0.90  -1.47
         +1.20  -1.00  -1.47
         +1.20  -0.40  -0.60 )
      (`Grey `Grey
         +1.20  -1.20  -1.47
         +1.20  -1.20  -1.53
         +1.20  +1.20  -1.53
         +1.20  +1.20  -1.47 )
      (`Grey `Grey
         +1.20  +0.90  -1.53
         +1.20  +0.90  -1.47
         +0.30  +0.30  -0.60
         +0.18  +0.30  -0.60 )
      (`Grey `Grey
         +1.20  -0.90  -1.53
         +1.20  -0.90  -1.47
         +0.30  -0.30  -0.60
         +0.18  -0.30  -0.60 )

      # Rad rechts
      (`Yellow `Yellow
         +1.20  +1.20  -1.20
         +1.38  +1.20  -1.25
         +1.50  +1.20  -1.37
         +1.55  +1.20  -1.55
         +1.50  +1.20  -1.73
         +1.38  +1.20  -1.85
         +1.20  +1.20  -1.90
         +1.02  +1.20  -1.85
         +0.90  +1.20  -1.72
         +0.85  +1.20  -1.55
         +0.90  +1.20  -1.37
         +1.02  +1.20  -1.25 )

      # Schatten Rad rechts
      (NIL T
         +1.60  +1.00  -1.55
         +1.60  +1.40  -1.55
         +0.80  +1.40  -1.55
         +0.80  +1.00  -1.55 )

      # Rad links
      (`Yellow `Yellow
         +1.20  -1.20  -1.20
         +1.38  -1.20  -1.25
         +1.50  -1.20  -1.37
         +1.55  -1.20  -1.55
         +1.50  -1.20  -1.73
         +1.38  -1.20  -1.85
         +1.20  -1.20  -1.90
         +1.02  -1.20  -1.85
         +0.90  -1.20  -1.72
         +0.85  -1.20  -1.55
         +0.90  -1.20  -1.37
         +1.02  -1.20  -1.25 )

      # Schatten Rad links
      (NIL T
         +1.60  -1.00  -1.55
         +1.60  -1.40  -1.55
         +0.80  -1.40  -1.55
         +0.80  -1.00  -1.55 )

      # Latte
      (propeller  +1.95  0.00  0.00) ) )

(model This
   '(blade  +1.95  0.00  0.00
      (`Black `Black
         -0.05   0.00   0.00
         +0.05   0.00   0.00
         +0.02  +0.40  -0.50
         +0.00  +0.90  -0.90
         -0.02  +0.50  -0.40
         -0.05   0.00   0.00
         -0.02  -0.50  +0.40
         +0.00  -0.90  +0.90
         +0.02  -0.40  +0.50
         +0.05   0.00   0.00 ) ) )

(model This
   '(disk  +1.95  0.00  0.00
      (NIL NIL
         +0.00  -0.30  +1.20
         +0.00  -0.90  +0.90
         +0.00  -1.20  +0.30
         +0.00  -1.20  -0.30
         +0.00  -0.90  -0.90
         +0.00  -0.30  -1.20
         +0.00  +0.30  -1.20
         +0.00  +0.90  -0.90
         +0.00  +1.20  -0.30
         +0.00  +1.20  +0.30
         +0.00  +0.90  +0.90
         +0.00  +0.30  +1.20 ) ) )

(z3d:Yrot 0.26 (: body))