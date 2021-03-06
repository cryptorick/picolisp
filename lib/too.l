# 15dec18abu
# (c) Software Lab. Alexander Burger

(de admin "Prg"
   (out 2
      (prinl *Pid " + Admin " (stamp))
      (loop
         (tell 'bye 2)
         (NIL (lock))
         (wait 200) )
      (for (F . @) (or *Dbs (2))
         (when (dbck F)
            (quit "DB Check" (cons F @)) ) )
      (run "Prg")
      (when (dbgc)
         (println 'dbgc @) )
      (prinl *Pid " - Admin " (stamp)) ) )

### Local Backup ###
(de snapshot (Dst . @)
   (when (info (pack Dst "/1"))
      (for (L (flip (sort (extract format (dir Dst))))  L)
         (let N (++ L)
            (call "mv" (pack Dst '/ N) (pack Dst '/ (inc N)))
            (when (> (car L) (*/ N 59 60))
               (call "rm" "-rf" (pack Dst '/ (++ L))) ) ) ) )
   (when (call "mkdir" (pack Dst "/1"))
      (let Ign NIL
         (while (args)
            (if (pre? "-" (next))
               (push 'Ign (pack (cdr (chop (arg)))))
               (let
                  (Lst (filter bool (split (chop (arg)) '/))
                     Src (car Lst)
                     Old (pack Dst "/2/" Src)
                     New (pack Dst "/1/" Src) )
                  (recur (Lst Src Old New)
                     (ifn (cdr Lst)
                        (recur (Src Old New)
                           (unless (member Src Ign)
                              (cond
                                 ((=T (car (info Src T)))  # Directory
                                    (call "mkdir" "-p" New)
                                    (for F (dir Src T)
                                       (unless (member F '("." ".."))
                                          (recurse
                                             (pack Src '/ F)
                                             (pack Old '/ F)
                                             (pack New '/ F) ) ) )
                                    (call "touch" "-r" Src New) )
                                 ((= (info Src T) (info Old T))  # Same
                                    `(if (== 64 64)
                                       '(native "@" "link" 'I Old New)
                                       '(call "ln" Old New) ) )
                                 (T (call "cp" "-a" Src New)) ) ) )  # Changed or new
                        (call "mkdir" "-p" New)
                        (recurse
                           (cdr Lst)
                           (pack Src '/ (cadr Lst))
                           (pack Old '/ (cadr Lst))
                           (pack New '/ (cadr Lst)) )
                        (call "touch" "-r" Src New) ) ) ) ) ) ) ) )

(de purge (Dst N)
   (for D (dir Dst)
      (when (>= (format D) N)
         (call "rm" "-rf" (pack Dst '/ D)) ) ) )

### DB Garbage Collection ###
(de dbgc ()
   (markExt *DB)
   (for L *ExtDBs  # ("path/" <cnt> <ofs>)
      (let ((P N E) L  Lck)
         (for I N
            (let (Fd (open (pack P (hax (dec I))))  (Cnt . Siz) (blk Fd 0))
               (and (=1 I) (setq Lck Fd))
               (for Blk (dec Cnt)
                  (mapc markExt
                     (fish ext? (ext E (blk Fd Blk Siz Lck))) ) )
               (close Fd) ) ) ) )
   (let Cnt 0
      (finally (mark 0)
         (for (F . @) (or *Dbs (2))
            (for (S (seq F)  S  (seq S))
               (unless (mark S)
                  (inc 'Cnt)
                  (and (isa '+Entity S) (zap> S))
                  (zap S) ) ) ) )
      (commit)
      (when *Blob
         (use (@S @R F S)
            (let Pat (conc (chop *Blob) '(@S "." @R))
               (in (list 'find *Blob "-type" "f")
                  (while (setq F (line))
                     (when (match Pat F)
                        (unless
                           (and
                              (setq S (extern (pack (replace @S '/))))
                              (get S (intern (pack @R))) )
                           (inc 'Cnt)
                           (call "rm" (pack F)) )
                        (wipe S) ) ) ) ) ) )
      (gt0 Cnt) ) )

(de markExt (S)
   (unless (mark S T)
      (markData (val S))
      (maps markData S)
      (wipe S) ) )

(de markData (X)
   (while (pair X)
      (markData (++ X)) )
   (and (ext? X) (markExt X)) )

### DB Mapping ###
(de dbMap ("ObjFun" "TreeFun")
   (default "ObjFun" quote "TreeFun" quote)
   (finally (mark 0)
      (_dbMap *DB)
      (dbMapT *DB) ) )

(de _dbMap ("Hook")
   (unless (mark "Hook" T)
      ("ObjFun" "Hook")
      (for "X" (getl "Hook")
         (when (pair "X")
            (if
               (and
                  (ext? (car "X"))
                  (not (isa '+Entity (car "X")))
                  (sym? (cdr "X"))
                  (find
                     '(("X") (isa '+relation (car "X")))
                     (getl (cdr "X")) ) )
               (let ("Base" (car "X")  "Cls" (cdr "X"))
                  (dbMapT "Base")
                  (for "X" (getl "Base")
                     (when
                        (and
                           (pair "X")
                           (sym? (cdr "X"))
                           (pair (car "X"))
                           (num? (caar "X"))
                           (ext? (cdar "X")) )
                        ("TreeFun" "Base" (car "X") (cdr "X") "Cls" "Hook")
                        (iter (tree (cdr "X") "Cls" "Hook") _dbMap) ) )
                  (wipe "Base") )
               (dbMapV (car "X")) ) ) )
      (wipe "Hook") ) )

(de dbMapT ("Base")
   (let "X" (val "Base")
      (when
         (and
            (pair "X")
            (num? (car "X"))
            (ext? (cdr "X")) )
         ("TreeFun" "Base" "X")
         (iter "Base" dbMapV) ) ) )

(de dbMapV ("X")
   (while (pair "X")
      (dbMapV (++ "X")) )
   (and (ext? "X") (_dbMap "X")) )

### DB Check ###
(de dbCheck ()
   (loop
      (tell 'bye 2)
      (NIL (lock))
      (wait 200) )
   (for (F . N) (or *Dbs (2))  # Low-level integrity check
      (unless (pair (println F N (dbck F T)))
         (quit 'dbck @) ) )
   (dbMap  # Check tree structures
      NIL
      '((Base Root Var Cls Hook)
         (println Base Root Var Cls Hook)
         (unless (= (car Root) (chkTree (cdr Root)))
            (quit "Tree size mismatch") )
         (when Var
            (scan (tree Var Cls Hook)
               '((K V)
                  (or
                     (isa Cls V)
                     (isa '+Alt (meta V Var))
                     (quit "Bad Type" V) )
                  (unless (has> V Var (if (pair K) (car K) K))
                     (quit "Bad Value" K) ) )
               NIL T T ) ) ) )
   (and *Dbs (dbfCheck))  # Check DB file assignments
   (and (dangling) (println 'dangling @))  # Show dangling index references
   (and (badECnt) (println 'badECnt @))  # Show entity count mismatches
   T )

# Check Index References
(de dangling ()
   (make
      (dbMap
         '((This)
            (and
               (isa '+Entity This)
               (not (: T))
               (dangle This)
               (link @) ) ) ) ) )

(de dangle (Obj)
   (and
      (make
         (for X (getl Obj)
            (let V (or (atom X) (++ X))
               (unless (rel?> Obj X V)
                  (link X) ) ) ) )
      (cons Obj @) ) )

# Entity Counts
(de badECnt ()
   (let Cnt NIL
      (for (F . @) (or *Dbs (2))
         (for (This (seq F) This (seq This))
            (and
               (isa '+Entity This)
               (not (: T))
               (for Cls (type This)
                  (recur (Cls)
                     (or
                        (== '+Entity Cls)
                        (when (isa '+Entity Cls)
                           (for C (type Cls)
                              (recurse C) )
                           (accu 'Cnt Cls 1) ) ) ) ) ) ) )
      (filter
         '((X)
            (<> (cdr X) (get *DB (car X) 0)) )
         Cnt ) ) )

(de fixECnt ()
   (for X (getl *DB)
      (and (pair X) (set (car X) 0)) )
   (for (F . @) (or *Dbs (2))
      (for (This (seq F) This (seq This))
         (and
            (isa '+Entity This)
            (not (: T))
            (incECnt This) )
         (at (0 . 10000) (commit)) ) )
   (commit) )

### Rebuild tree ###
(de rebuild (X Var Cls Hook)
   (let Lst NIL
      (let? Base (get (or Hook *DB) Cls)
         (unless X
            (setq Lst
               (if (; (treeRel Var Cls) hook)
                  (collect Var Cls Hook)
                  (collect Var Cls) ) ) )
         (zapTree (get Base Var -1))
         (put Base Var NIL)
         (commit) )
      (nond
         (X
            (let Len (length Lst)
               (recur (Lst Len)
                  (unless (=0 Len)
                     (let (N (>> 1 (inc Len))  L (nth Lst N))
                        (re-index (car L) Var Hook)
                        (recurse Lst (dec N))
                        (recurse (cdr L) (- Len N)) ) ) ) ) )
         ((atom X)
            (for Obj X
               (re-index Obj Var Hook) ) )
         (NIL
            (for (Obj (seq X) Obj (seq Obj))
               (and (isa Cls Obj) (re-index Obj Var Hook)) ) ) )
      (commit) ) )

(de re-index (Obj Var Hook)
   (unless (get Obj T)
      (when (get Obj Var)
         (rel> (meta Obj Var) Obj NIL
            (put> (meta Obj Var) Obj NIL @)
            Hook )
         (at (0 . 10000) (commit)) ) ) )

### Database file management ###
(de dbfCheck ()
   (for "Cls" (all)
      (when (and (= `(char "+") (char "Cls")) (isa '+Entity "Cls"))
         (or
            (get "Cls" 'Dbf)
            (meta "Cls" 'Dbf)
            (println 'dbfCheck "Cls") )
         (for Rel (getl "Cls")
            (and
               (pair Rel)
               (isa '+relation (car Rel))
               (or
                  (isa '+index (car Rel))
                  (isa '+Swap (car Rel))
                  (find
                     '((B)
                        (or
                           (isa '+index B)
                           (isa '+Swap B) ) )
                     (; Rel 1 bag) ) )
               (not (; @ dbf))
               (println 'dbfCheck (cdr Rel) "Cls") ) ) ) ) )

### Dump Objects ###
(zero *DumpBlob)

(dm (dumpKey> . +Entity) ()
   (unless (: T)
      (pick
         '((X)
            (when (isa '+Key (meta This (fin X)))
               (if (meta This (fin X) 'hook)
                  (cons (fin X) (get This @) X)
                  (cons (fin X) X) ) ) )
         (getl This) ) ) )

(dm (dumpType> . +Entity) ()
   (type This) )

(dm (dumpValue> . +Entity) (X)
   X )

(de dump "CL"
   (let "C" (cons 0 10000)
      (for ("Q" (goal "CL") (asoq '@@ (prove "Q")))
         (let (Obj (cdr @)  K (fin (dumpExt Obj)))
            (for X (getl Obj)
               (unless (or (= K (fin X)) (= `(char "+") (char (fin X))))
                  (let? Y (dumpValue> Obj X)
                     (cond
                        ((pair Y)
                           (prinl)
                           (space 3)
                           (if (atom (cdr Y))
                              (printsp (cdr Y))
                              (printsp (cadr Y))
                              (prin "`") )
                           (dumpVal (car Y)) )
                        ((isa '+Blob (meta Obj X))
                           (let F (blob Obj X)
                              (ifn (info F)
                                 (msg F " no blob")
                                 (prinl)
                                 (space 3)
                                 (prin Y " `(tmp " (inc '*DumpBlob) ")")
                                 (call "cp" "-a" F (tmp *DumpBlob)) ) ) )
                        (T
                           (prinl)
                           (space 3)
                           (print Y T) ) ) ) ) )
            (prinl " )") )
         (at "C" (println '(commit))) )
      (println '(commit)) ) )

(de dumpExt (Obj)
   (prin "(obj ")
   (let K (dumpKey> Obj)
      (ifn (last K)
         (print (dumpType> Obj) (id Obj T))
         (prin "(")
         (printsp (dumpType> Obj) (car K))
         (dumpVal (cadr K))
         (when (pair (cddr K))
            (space)
            (dumpVal (car @)) )
         (prin ")") )
      K ) )

(de dumpVal (X)
   (nond
      ((atom X)
         (prin "(")
         (dumpVal (++ X))
         (while (pair X)
            (space)
            (dumpVal (++ X)) )
         (when X (prin " . ") (dumpVal X))
         (prin ")") )
      ((ext? X) (print X))
      ((type X) (print (val X)))
      (NIL (prin "`") (dumpExt X) (prin ")")) ) )

# Dump/load data and blobs
(de dumpDB ("Name" . "Prg")
   (out (pack "Name" ".l") (run "Prg"))
   (when (dir (tmp))
      (out (pack "Name" ".tgz")
         (chdir (tmp)
            (in (append '("tar" "cfz" "-") (filter format @))
               (echo) ) ) ) ) )

(de loadDB ("Name")
   (let Tgz (pack "Name" ".tgz")
      (when (and (info Tgz) (n0 (car @)))
         (in Tgz
            (chdir (tmp)
               (out '("tar" "xfz" "-") (echo)) ) ) ) )
   (load (pack "Name" ".l") ) )

# vi:et:ts=3:sw=3
