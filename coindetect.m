function  f=coindetect(rad);

if (93<rad) & (rad<94)
    f=1;
elseif (116<rad) & (rad<117)
    f=2;
elseif (128<rad) & (rad<129)
    f=5;
elseif (141<rad) & (rad<142)
    f=10;
else
    f=0;
end   

   