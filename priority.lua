C SuS SuS 3.5 Operators Priority Table
--------------------------------------
14    = += -= ..= >>= <<= &= |= *= /= //= %=
13    or
12    and
11    <     >     <=    >=    ~=    ==
10    |
9     ~
8     &
7     <<    >>
6     ..     is
5     +     -
4     *     /     //    %
3     unary operators (not   #     -     ~)
2     ^
1     .     :     ?.     ?:     ?(     ?{     ?"     ?[     function_call


C SuS SuS 3.5 Operators Priority Table + simplifications *operator*(*simplification*)
--------------------------------------
14    = += -= ..= >>= <<= &= |= *= /= //= %=
13    or(||)
12    and(&&)
11    <     >     <=    >=    ~=    ==
10    |
9     ~
8     &
7     <<    >>
6     ..     is
5     +     -
4     *     /     //    %
3     unary operators (not(!)   #     -     ~)
2     ^
1     .     :     ?.     ?:     ?(     ?{     ?"     ?[     function_call

Keywords:
     @ -> local
     $ -> return
     ; -> end

     ? -> then (UNRECOMENDED)
     /| -> if (UNRECOMENDED)
     :| -> elseif (UNRECOMENDED)
     \| -> else (UNRECOMENDED)

Lua 5.1 Operators Priority Table
-------------------------------
10    =
9     or
8     and
7     <     >     <=    >=    ~=    ==
6     ..
5     +     -
4     *     /     //    %
3     unary operators (not   #     -)
2     ^
1     .     :     function_call