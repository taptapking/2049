uses crt;
type mang=array[0..10,0..10] of longint;
var a,c:mang;
        i,j,diff,diff1,difftotal,code,count:word;
        ch,ch1,ch2,ch3,ch4,ch5,up,down,left,right,re:char;
        fmove,fnum:longint;
        moved,loaded,wide:boolean;
        hidden,hardrock,spunout,nofail,easy,flashlight:shortint;
        cs,s:byte;
        username:string;
procedure calibrate(st:string;s:byte);
var k:byte;
begin
     for k:=1 to (s-length(st)) div 2 do
         write(' ');
     writeln(st);
end;
function lnth(a:longint):byte;
var l:byte;
begin
     l:=0;
     repeat
           l:=l+1;
           a:=a div 10;
     until a=a div 10;
     lnth:=l;
end;
function multiplier(ez,hd,hr,so,nf,fl:byte):real;
var m:real;
begin
     m:=1;
     if ez=1 then m:=m*0.5;
     if hd=1 then m:=m*1.12;
     if fl=1 then m:=m*1.12;
     if hr=1 then m:=m*1.06;
     if so=1 then m:=m*0.9;
     if nf=1 then m:=m*0.5;
     multiplier:=m;
end;
procedure modsintro(ez1,hd1,hr1,so1,nf1,fl1:byte);
var i:byte;
begin
        for i:=1 to s-1 do write('-');writeln;
        calibrate('Mods',s);
        for i:=1 to s-1 do write('-');writeln;
        for i:=1 to 2 do
                writeln;
        for i:=2 to (s-21) div 2 do
                write(' ');
        writeln('Score multiplier:',multiplier(easy,hidden,hardrock,spunout,nofail,flashlight):0:2);
        writeln;
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        write('Difficulty reduction:    ');
        if ez1=1 then write('EZ   ') else write('ez   ');
        if nf1=1 then write('NF   ') else write('nf   ');
        writeln;
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        write('Difficulty increase:     ');
        if hr1=1 then write('HR   ') else write('hr   ');
        if hd1=1 then write('HD   ') else write('hd   ');
        if fl1=1 then write('FL   ') else write('fl   ');
        writeln;
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        write('Special:                 ');
        if so1=1 then write('SO') else write('so');
        writeln;
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        writeln('Hit 1 to reset all mods');
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        write('Hit esc to close');
end;
function point(a:mang;cs,hd,hr,so,nf,fl:byte;diff:word):longint;
var i,j,pt:longint;
begin
     pt:=0;
     for i:=0 to cs do
         for j:=0 to cs do
             pt:=pt+a[i,j];
     if cs>=4 then pt:=round(pt*0.5);
     if hd=1 then pt:=round(pt*1.12);
     if hr=1 then pt:=round(pt*1.06);
     if so=1 then pt:=round(pt*0.9);
     if nf=1 then pt:=round(pt*0.5);
     pt:=pt*(diff+1);
     point:=pt;
end;
procedure continue;
var b:array[1..121] of longint;
    tmp:longint;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             b[i*(cs+1)+(j+1)]:=a[i,j];
     for i:=1 to sqr(cs+1)-1 do
         for j:=i+1 to sqr(cs+1) do
             if  b[i]>b[j] then
             begin
                  tmp:=b[i];
                  b[i]:=b[j];
                  b[j]:=tmp;
             end;
     for i:=0 to cs do
         for j:=0 to cs do
             if (a[i,j]=b[1]) or (a[i,j]=b[2]) then a[i,j]:=0;
end;
function checkfile(fl:string):boolean;
var f:text;
    chk:boolean;
begin
     assign(f,fl);
{$I-}
     reset(f);
{$I+}
     if IOResult=0 then chk:=true
     else chk:=false;
     if chk=true then close(f);
     checkfile:=chk;
end;
procedure rewind;
var i,j:byte;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             a[i,j]:=c[i,j];
end;
procedure backup;
var i,j:byte;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             c[i,j]:=a[i,j];
end;
function difference(a,b:mang;cs:byte):boolean;
var i,j:byte;
    chk:boolean;
begin
     chk:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]<>b[i,j] then chk:=true;
     difference:=chk;
end;
function win(a:mang;n:word;cs:byte):boolean;
var i,j:byte;
begin
     win:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=n then win:=true;
end;
function lose(a:mang;cs:byte):boolean;
var i,j:byte;
begin
     lose:=true;
     for i:=0 to cs do
         for j:=0 to cs-1 do
             if a[i,j]=a[i,j+1] then lose:=false;
     for i:=0 to cs-1 do
         for j:=0 to cs do
             if a[i,j]=a[i+1,j] then lose:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=0 then lose:=false;
end;
procedure start;
var i,j,k:byte;
    check:boolean;
begin
     randomize;
     for k:=1 to cs do
     begin
          check:=false;
          for i:=0 to cs do
              for j:=0 to cs do
                  if a[i,j]=0 then check:=true;
          if check=true then
          repeat
                i:=random(cs+1);
                j:=random(cs+1);
          until a[i,j]=0;
          repeat
                a[i,j]:=random(5);
          until (a[i,j]=2) or (a[i,j]=4);
     end;
end;
procedure spawn;
var i,j:byte;
    check:boolean;
begin
     randomize;
     check:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=0 then check:=true;
     if check=true then
     begin
          repeat
                i:=random(cs+1);
                j:=random(cs+1);
          until a[i,j]=0;
          repeat
                a[i,j]:=random(5);
          until a[i,j] mod 2=0;
     end;
end;
procedure spawnhardrock;
var i,j:byte;
    check:boolean;
begin
     randomize;
     check:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=0 then check:=true;
     if check=true then
     begin
          repeat
                i:=random(cs+1);
                j:=random(cs+1);
          until a[i,j]=0;
          repeat
                a[i,j]:=random(9);
          until (a[i,j] mod 2=0) and (a[i,j]<>6);
     end;
end;
function health(a:mang;cs:byte):byte;
var i,j,count:byte;
begin
     count:=1;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=0 then count:=count+1;
     health:=count;
end;
procedure printf;
var i,j,k:byte;
begin
     for i:=1 to s-1 do
         write('-');
     writeln;
     if diff1=0 then
     begin
          for i:=1 to (s-9) div 2  do
              write(' ');
          writeln('EASY ',diff);
     end;
     if diff1=1 then
     begin
          for i:=1 to (s-11) div 2  do
              write(' ');
          writeln('NORMAL ',diff);
     end;
     if diff1=2 then
     begin
          for i:=1 to (s-9) div 2  do
              write(' ');
          writeln('HARD ',diff);
     end;
     if diff1=3 then
     begin
          for i:=1 to (s-14) div 2  do
              write(' ');
          writeln('VERY HARD ',diff);
     end;
     if diff1=4 then
     begin
          for i:=1 to (s-11) div 2  do
              write(' ');
          writeln('MASTER ',diff);
     end;
     for i:=1 to s-1 do
         write('-');
     writeln;
     for i:=1 to difftotal do
         write('* ');
     writeln;
     if nofail<>1 then
     begin
        for i:=1 to sqr(cs+1) do
            write('--');
        write('|');
        writeln;
        if lose(a,cs)=false then
           for i:=1 to health(a,cs) do
               write('##');
           for i:=1 to sqr(cs+1)-health(a,cs) do
               write('  ');
        if lose(a,cs)=false then
           write('|')
           else write('  |');
        for i:=2 to (s-sqr(cs+1)*2-1-lnth(point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1))) do
            write(' ');
        writeln(point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1));
        for i:=1 to sqr(cs+1) do
            write('--');
        write('|');
        writeln;
     end
     else
     begin
          for k:=1 to s-1-lnth(point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1)) do
              write(' ');
          writeln(point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1));
     end;
     for k:=2 to (s-6*(cs+1)) div 2 do
         write(' ');
     write('|');
     for k:=1 to cs+1 do
         write('-----|');
     for k:=1 to (s-6*(cs+1)) div 2-round((nofail+hidden+hardrock+spunout+flashlight+cs+2)*1.5)-2 do
         write(' ');
     if cs>=4 then write('EZ ');
     if nofail=1 then write('NF ');
     if spunout=1 then write('SO ');
     if hidden=1 then write('HD ');
     if hardrock=1 then write('HR ');
     if flashlight=1 then write('FL');
     writeln;
     for i:=0 to cs do
     begin
          for k:=2 to (s-6*(cs+1)) div 2 do
              write(' ');
          write('|');
          for j:=0 to cs do
          begin
                   if (a[i,j]<>0) and (flashlight<>1) then
                   begin
                        if (a[i,j]<=10) and (hidden=1) then write('  ',a[i,j],'  |');
                        if (a[i,j]=16) and (hidden=1) then write('  ',a[i,j],' |');
                        if (a[i,j]>16) and (hidden=1) then write('  ','?','  |');
                        if (a[i,j]<10) and (hidden=-1) then
                           write('  ',a[i,j],'  |');
                        if (a[i,j]>9) and (a[i,j]<100) and (hidden=-1) then
                           write('  ',a[i,j],' |');
                        if (a[i,j]>99) and (a[i,j]<1000) and (hidden=-1) then
                           write(' ',a[i,j],' |');
                        if (a[i,j]>999) and (a[i,j]<10000) and (hidden=-1) then
                           write(' ',a[i,j],'|');
                        if (a[i,j]>9999) and (a[i,j]<100000) and (hidden=-1) then
                           write(a[i,j],'|');
                   end;
                   if (a[i,j]=0) and (flashlight<>1) then write('     |');
                    if flashlight=1 then
                    begin
                    if ((health(a,cs)>2) and (i>=1) and (j<=cs-1)) or ((health(a,cs)<=2) and (i>=2) and (j<=cs-2)) then
                        begin
                             if a[i,j]=0 then write('     |');
                             if a[i,j]<>0 then
                             begin
                                  if (a[i,j]<=10) and (hidden=1) then write('  ',a[i,j],'  |');
                                  if (a[i,j]=16) and (hidden=1) then write('  ',a[i,j],' |');
                                  if (a[i,j]>16) and (hidden=1) then write('  ','?','  |');
                                  if (a[i,j]<10) and (hidden=-1) then
                                     write('  ',a[i,j],'  |');
                                  if (a[i,j]>9) and (a[i,j]<100) and (hidden=-1) then
                                     write('  ',a[i,j],' |');
                                  if (a[i,j]>99) and (a[i,j]<1000) and (hidden=-1) then
                                     write(' ',a[i,j],' |');
                                  if (a[i,j]>999) and (a[i,j]<10000) and (hidden=-1) then
                                     write(' ',a[i,j],'|');
                                  if (a[i,j]>9999) and (a[i,j]<100000) and (hidden=-1) then
                                     write(a[i,j],'|');
                             end;
                        end
                        else write('#####|');
                    end;

          end;
          writeln;
          if i<=cs then
          begin
               for  k:=2 to (s-6*(cs+1)) div 2 do
                   write(' ');
               write('|');
               for k:=1 to cs do
                   write('-----|');
               writeln('-----|');
          end;
     end;
     writeln('Moves:',count);
end;
procedure move(c:char);
var i,j,n:byte;
    b:array[0..10,0..10] of longint;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             b[i,j]:=0;
     if c=up then
        for j:=0 to cs do
        begin
             n:=0;
             for i:=0 to cs do
                 if a[i,j]<>0 then
                 begin
                      b[n,j]:=a[i,j];
                      n:=n+1;
                 end;
        end;
     if c=down then
        for j:=0 to cs do
        begin
             n:=0;
             for i:=cs downto 0 do
                 if a[i,j]<>0 then
                 begin
                      b[cs-n,j]:=a[i,j];
                      n:=n+1;
                 end;
        end;
     if c=left then
        for i:=0 to cs do
        begin
             n:=0;
             for j:=0 to cs do
                 if a[i,j]<>0 then
                 begin
                      b[i,n]:=a[i,j];
                      n:=n+1;
                 end;
        end;
     if c=right then
        for i:=0 to cs do
        begin
             n:=0;
             for j:=cs downto 0 do
                 if a[i,j]<>0 then
                 begin
                      b[i,cs-n]:=a[i,j];
                      n:=n+1;
                 end;
        end;
        for i:=0 to cs do
            for j:=0 to cs do
                a[i,j]:=b[i,j];
end;
procedure clear(c:char);
var i,j,k:byte;
begin
     if c=up then
        for i:=0 to cs-1 do
            for j:=0 to cs do
                if a[i,j]=a[i+1,j] then
                begin
                     a[i,j]:=a[i,j]+a[i+1,j];
                     a[i+1,j]:=0;
                end;
     if c=down then
        for i:=cs-1 downto 0 do
            for j:=0 to cs do
                if a[i,j]=a[i+1,j] then
                begin
                     a[i+1,j]:=a[i,j]+a[i+1,j];
                     a[i,j]:=0;
                end;
     if c=left then
        for i:=0 to cs do
            for j:=0 to cs-1 do
                if a[i,j]=a[i,j+1] then
                begin
                     a[i,j]:=a[i,j]+a[i,j+1];
                     a[i,j+1]:=0;
                end;
     if c=right then
        for i:=0 to cs do
            for j:=cs-1 downto 0 do
                if a[i,j]=a[i,j+1] then
                begin
                     a[i,j+1]:=a[i,j]+a[i,j+1];
                     a[i,j]:=0;
                end;
     move(c);
end;
procedure readf;
var f:text;
begin
     assign(f,'record.txt');
     reset(f);
     readln(f,fnum,fmove);
     readln(f,username);
     close(f);
end;
procedure writef1;
var f:text;
begin
     assign(f,'record.txt');
     rewrite(f);
     writeln(f,fnum,' ',fmove);
     writeln(f,username);
     close(f);
end;
function maxnum(a:mang;cs:byte):longint;
var i,j,m:longint;
begin
     m:=a[0,0];
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]>m then m:=a[i,j];
     maxnum:=m;
end;
procedure writef;
var f:text;
begin
     assign(f,'record.txt');
     rewrite(f);
     writeln(f,point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1),' ',maxnum(a,cs));
     writeln(f,username);
     close(f);
end;
procedure save;
var i,j:byte;
    f:text;
    c:char;
begin
     if checkfile('save.txt')=true then
     begin
          writeln('We have detected that there is a save file on your computer');
          writeln('If you attempt to save,the save file will be overwritten');
          writeln('Do you want to proceed');
          writeln('Press y to proceed');
          writeln('Press n to cancel');
          repeat
                c:=readkey;
          until (c='y') or (c='n');
     end
     else c:='y';
     if c='y' then
     begin
          assign(f,'save.txt');
          rewrite(f);
          for i:=0 to cs do
          begin
               for j:=0 to cs do
               begin
                    if j<cs then
                       write(f,a[i,j],' ')
                    else
                        write(f,a[i,j]);
               end;
               writeln(f);
          end;
          write(f,ch2,' ',diff1,' ',count,' ',hidden,' ',hardrock,' ',spunout,' ',nofail,' ',flashlight);
          close(f);
     end;
end;
procedure load;
var f:text;
    i,j:byte;
begin
        assign(f,'save.txt');
        reset(f);
        cs:=0;
        while eoln(f)=false do
        begin
             read(f,a[0,cs]);
             inc(cs);
        end;
        cs:=cs-1;
        for i:=1 to cs do
        begin
             for j:=0 to cs do
                 read(f,a[i,j]);
             readln(f);
        end;
        readln(f,ch2,diff1,count,hidden,hardrock,spunout,nofail,flashlight);
        if hidden=0 then hidden:=-1;
        if hardrock=0 then hardrock:=-1;
        if spunout=0 then spunout:=-1;
        if nofail=0 then nofail:=-1;
        if flashlight=0 then flashlight:=-1;
        close(f);
end;
procedure cleargame;
var f:text;
begin
     assign(f,'save.txt');
     erase(f);
end;
procedure menu1;
var k:byte;
begin
     clrscr;
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('2048 Advanced',s);
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Hit 1 to start a game',s-2);
     calibrate('Hit 2 to access user preferences',s+8);
     if checkfile('save.txt')=true then
     begin
          calibrate('Hit 3 to load your game',s-1);
          calibrate('Hit d to clear your game',s);
     end;
     calibrate('Hit 4 to use mods',s-6);
     for i:=1 to (s-24) div 2 do
     write(' ');
     write('Hit 5 to change target number ');writeln('(',diff,')');
     for i:=1 to (s-24) div 2 do
     write(' ');
     write('Hit 6 to change difficulty ');writeln('(',chr(ord(ch3)+1),'x)');
     calibrate('Hit esc to Exit',s-8);
     calibrate('Update 4.0',s-13);
     writeln;
     for i:=1 to (s-24) div 2 do
     write(' ');
     writeln(username);
     for i:=1 to (s-24) div 2 do
     write(' ');
     write('Score:',fnum);
     writeln;
     for i:=1 to (s-24) div 2 do
     write(' ');
     write('Max number:',fmove);

end;
procedure menu2;
var k:byte;
begin
     clrscr;
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Select Target Number',s);
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Hit 0 for endless',s);
     calibrate('Hit 1 for 512',s-4);
     calibrate('Hit 2 for 1024',s-3);
     calibrate('Hit 3 for 2048',s-3);
     calibrate('Hit 4 for 4096',s-3);
     calibrate('Hit 5 for 8192',s-3);
     calibrate('Hit 6 for 16384',s-2);
end;
procedure menu3;
var k:byte;
begin
     clrscr;
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Select Difficulty',s);
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Hit 0 for easy',s-3);
     calibrate('Hit 1 for normal',s-1);
     calibrate('Hit 2 for hard',s-3);
     calibrate('Hit 3 for very hard',s+2);
     calibrate('Hit 4 for master',s-1);
end;
procedure menu4;
begin
        clrscr;
        for i:=1 to s-1 do write('-');
        writeln;
        calibrate('User preferences',s);
        for i:=1 to s-1 do write('-');
        writeln;
        calibrate('Hit 1 to use night mode',s);
        calibrate('Hit 2 to use classic mode',s);
        {calibrate('Hit 3 to trigger widescreen mode',s);}
        calibrate('Hit 4 to change username',s);
        calibrate('Hit 5 to change keyboard bindings',s);
        calibrate('Hit esc to exit',s);
end;
procedure menu5;
var k:byte;
begin
        clrscr;
        for i:=1 to s-1 do write('-');
        writeln;
        calibrate('Keyboard bindings',s);
        for i:=1 to s-1 do write('-');
        writeln;
        calibrate('Hit 1 to reassign up key',s-4);
        calibrate('Hit 2 to reassign down key',s-2);
        calibrate('Hit 3 to reassign left key',s-2);
        calibrate('HIt 4 to reassign right key',s-1);
        calibrate('Hit 5 to reassign rewind key',s);
        writeln;
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('up: ',up);
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('down: ',down);
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('left: ', left);
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('right: ',right);
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('rewind: ',re);
        writeln;
        calibrate('Hit esc to exit',s-13);
end;
begin
     hidden:=-1;hardrock:=-1;spunout:=-1;nofail:=-1;flashlight:=-1;cs:=3;easy:=-1;s:=80;wide:=false;
     ch3:='1';diff:=512;up:=#72;down:=#80;left:=#75;right:=#77;re:='r';
     textcolor(black);
     textbackground(white);
     repeat
           count:=0;if checkfile('record.txt')=true then readf;moved:=false;loaded:=false;
           repeat
                if username='' then username:='Player';
                {case wide of
                        true:s:=120;
                        false:s:=80;
                end;}
                menu1;
                repeat
                        ch:=readkey;
                until (ch='1') or (ch='2') or (ch='3') or (ch='4') or (ch='d') or (ch=chr(27)) or (ch='5') or (ch='6');
                if ch='2' then
                repeat
                        {case wide of
                                true:s:=120;
                                false:s:=80;
                        end;}
                        menu4;
                        repeat
                                ch4:=readkey;
                        until (ch4='1') or (ch4='2') {or (ch4='3')} or (ch4=chr(27)) or (ch4='4') or (ch4='5');
                        if ch4='1' then
                        begin
                                textcolor(white);
                                textbackground(black);
                                lowvideo;
                        end;
                        if ch4='2' then
                        begin
                                textcolor(black);
                                textbackground(white);
                        end;
                        {if ch4='3' then
                        case s of
                                80:wide:=true;
                                120:wide:=false;
                        end;}
                        if ch4='4' then
                        begin
                                writeln('Type your new username');
                                readln(username);
                                writef1;
                        end;
                        if ch4='5' then
                        repeat
                                menu5;
                                repeat
                                        ch5:=readkey;
                                until (ch5='1') or (ch5='2') or (ch5='3') or (ch5='4') or (ch5='5') or (ch5=chr(27));
                                if ch5='1' then
                                begin
                                        writeln('input new key for up');
                                        repeat
                                                up:=readkey;
                                                if up=#0 then up:=readkey;
                                        until (up<>chr(27)) and (up<>down) and (up<>left) and (up<>right) and (up<>re);
                                end;
                                if ch5='2' then
                                begin
                                        writeln('input new key for down');
                                        repeat
                                                down:=readkey;
                                                if down=#0 then down:=readkey;
                                        until (down<>up) and (down<>chr(27)) and (down<>left) and (down<>right) and (down<>re);
                                end;
                                if ch5='3' then
                                begin
                                        writeln('input new key for left');
                                        repeat
                                                left:=readkey;
                                                if left=#0 then left:=readkey;
                                        until (left<>down) and (left<>up) and (left<>chr(27)) and (left<>right) and (left<>re);
                                end;
                                if ch5='4' then
                                begin
                                        writeln('input new key for right');
                                        repeat
                                                right:=readkey;
                                                if right=#0 then right:=readkey;
                                        until (right<>left) and (right<>down) and (right<>up) and (right<>chr(27))
                                        and (right<>re);
                                end;
                                if ch5='5' then
                                begin
                                        writeln('input new key for rewind');
                                        repeat
                                                re:=readkey;
                                                if re=#0 then re:=readkey;
                                        until (re<>right) and (re<>left) and (re<>down) and (re<>up) and (re<>chr(27));
                                end;
                        until ch5=chr(27);
                until ch4=chr(27);
                if ch='4' then
                begin
                        repeat
                                clrscr;
                                modsintro(easy,hidden,hardrock,spunout,nofail,flashlight);
                                repeat
                                        ch4:=readkey;
                                until (ch4='h') or (ch4='e') or (ch4='r') or (ch4='s') or (ch4='n') or (ch4='f')
                                or (ch4=chr(27)) or (ch4='1');
                                if ch4='h' then hidden:=hidden*(-1);
                                if ch4='e' then easy:=easy*(-1);
                                if ch4='r' then hardrock:=hardrock*(-1);
                                if ch4='s' then spunout:=spunout*(-1);
                                if ch4='n' then nofail:=nofail*(-1);
                                if ch4='f' then flashlight:=flashlight*(-1);
                                if ch4='1' then
                                begin
                                        hidden:=-1;
                                        easy:=-1;
                                        hardrock:=-1;
                                        spunout:=-1;
                                        nofail:=-1;
                                        flashlight:=-1;
                                end;

                        until ch4=chr(27);
                end;

                if (ch='d') and (checkfile('save.txt')=true) then
                   cleargame;
                if (ch='3') and (checkfile('save.txt')=true) then break;
                if ch='5' then
                begin
                        menu2;
                        repeat
                                ch2:=readkey;
                        until (ch2='0') or (ch2='1') or (ch2='2') or (ch2='3') or (ch2='4') or (ch2='5') or (ch2='6');
                        if ch2='1' then
                                diff:=512;
                        if ch2='2' then
                                diff:=1024;
                        if ch2='3' then
                                diff:=2048;
                        if ch2='4' then
                                diff:=4096;
                        if ch2='5' then
                                diff:=8192;
                        if ch2='6' then
                                diff:=16384;
                        if ch2='0' then
                                diff:=1;
                end;
                if ch='6' then
                begin
                        menu3;
                        repeat
                                ch3:=readkey;
                        until (ch3='0') or (ch3='1') or (ch3='2') or (ch3='3') or (ch3='4');
                end;
           until (ch='1') or (ch=chr(27));
           if ch='3' then
           begin
                load;
                loaded:=true;
                if ch2='1' then
                        diff:=512;
                if ch2='2' then
                        diff:=1024;
                if ch2='3' then
                        diff:=2048;
                if ch2='4' then
                        diff:=4096;
                if ch2='5' then
                        diff:=8192;
                if ch2='6' then
                        diff:=16384;
                if ch2='0' then
                        diff:=1;
           end;
           if loaded=false then
              if easy=1 then cs:=4 else cs:=3;
           if ch=chr(27) then exit;
           if loaded=false then
              val(ch3,diff1,code);
           val(ch2,difftotal,code);
           difftotal:=difftotal+diff1;
           if cs=4 then difftotal:=round(difftotal*0.75);
           if hardrock=1 then difftotal:=round(difftotal*1.5);
           if spunout=1 then difftotal:=round(difftotal*0.85);
           if loaded=false then
           begin
                for i:=0 to cs do
                    for j:=0 to cs do
                        a[i,j]:=0;
                        start;
           end;
           repeat
                 clrscr;
                 printf;
                 repeat
                        ch:=readkey;
                 until (ch=up) or (ch=down) or (ch=left) or (ch=right) or (ch=re) or (ch=chr(27));
                 if (count>0) and (ch=re) and (moved=true) then rewind;
                 if (ch=up) or (ch=down) or (ch=left) or (ch=right) then
                 begin
                      moved:=true;
                      backup;
                      move(ch);
                      if spunout<>1 then
                         clear(ch)
                         else
                         for i:=1 to 11 do
                         clear(ch);
                      if difference(a,c,cs)=true then
                      begin
                           for i:=1 to diff1+1 do
                               if hardrock=-1 then
                                  spawn
                                  else
                                  spawnhardrock;
                           count:=count+1;
                      end;
                 end;
                 if ch=chr(27) then
                 begin
                      ch:=#0;
                      writeln('ARE YOU SURE YOU WANT TO QUIT?');
                      writeln('Press y to return to menu');
                      writeln('Press n to continue');
                      writeln('Press s to save your game and return to menu');
                      repeat
                            ch:=readkey;
                      until (ch='y') or (ch='n') or (ch='s');
                if (ch='y') or (ch='s') then break;
                end;
                if (lose(a,cs)=true) and (nofail=1) then continue;
           until (win(a,diff,cs)=true) or (lose(a,cs)=true);
           if (point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1)>fnum) then
              writef;
           repeat
                 if win(a,diff,cs)=true then
                 begin
                      flashlight:=-1;
                      hidden:=-1;
                      clrscr;
                      printf;
                      writeln('YOU WON');
                      {if loaded=true then
                         cleargame;}
                 end;
                 if lose(a,cs)=true then
                 begin
                      flashlight:=-1;
                      hidden:=-1;
                      clrscr;
                      printf;
                      writeln('YOU LOST');
                      {if loaded=true then
                         cleargame;}
                 end;
                 if ch='s' then save;
                 if (ch='y') or (ch='s') then ch1:='y';
                 if (ch<>'y') and (ch<>'s') then
                 begin
                      writeln('Wanna try again?');
                      writeln('Hit y for yes');
                      writeln('Hit n for no');
                      ch1:=readkey;
                 end;
           until (ch1='y') or (ch1='n');
     until ch1='n';
end.