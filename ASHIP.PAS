
uses help2, supergfx, games;

{$I consts.pas}

const
     ileastr = 55;

type
    astrxy = record
                   x, y : integer;
                   nr, w : byte;
                   jest : boolean;
             end;

var
   astr : array[0..ileastr] of astrxy;
   a, b, c, d, a2, b2, c2, d2, a3, b3, c3, d3 : integer;
   z, z2, p, p2, s, s2 : real;
   px, py, kx, ky : integer;
   xr, yr, predkosc : real;
   kkx, kky : real;
   strzal : boolean;
   licznik_strzalu : word;
   level : byte;
   naboje : byte;
   energia : integer;
   punkty : longint;
   n, e : integer;
   nlos, elos : integer;
   xn, yn, xe, ye : integer;
   ammo_where : boolean;
   energy_where : boolean;
   cc : byte;
   j : integer;
   exit : boolean;
   speed : word;

const
     ilestar = 90;

type
    starxy = record
                   x, y : integer;
             end;

var
   star : array[1..ilestar] of starxy;
   star2 : array[1..ilestar] of starxy;

procedure ustaw_stars;
var
   i : integer;
begin
     randomize;
     for i:= 1 to ilestar do
     begin
          star[i].x:=random(320);
          star[i].y:=random(200);
          star2[i].x:=random(320);
          star2[i].y:=random(200);
     end;
end;

procedure stary(y, nr : integer);
begin
     star[nr].x:=0;
     star[nr].y:=y;
     star2[nr].x:=0;
     star2[nr].y:=y;
end;

procedure starx(x, nr : integer);
begin
     star[nr].x:=x;
     star[nr].y:=0;
     star2[nr].x:=x;
     star2[nr].y:=0;
end;

procedure ppixel(x, y : real; z, z2 : real; w, show, col : byte);
begin
     if show=1 then
     begin
          putpixel(round(x),round(y),col);
     end;
end;

procedure pokaz_stars;

var
   i : integer;

begin
     for i:= 1 to ilestar do
     begin
          ppixel(star[i].x,star[i].y,z,z2,1,1,25);
          ppixel(star2[i].x,star2[i].y,z,z2,1,1,20);
     end;
end;

procedure ruszaj_stars;
var
   i : integer;
   lx, ly : real;
   k1, k2, xr, yr : real;
   nr : byte;

function itin(x, y, x1, y1, x2, y2 : integer) : boolean;
begin
     itin:=false;
     if (x>x1-1) and (x<x2+1) and (y>y1-1) and (y<y2+1) then
     itin:=true;
end;

begin
     randomize;
     for i:= 1 to ilestar do
     begin
          lx:=round(xr)+2;
          star[i].x:=star[i].x+round(lx);
          if star[i].x>320 then star[i].x:=0;
          if star[i].x<0 then star[i].x:=320;
          lx:=round(xr)+1;
          star2[i].x:=star2[i].x+round(lx);
          if star2[i].x>320 then star2[i].x:=0;
          if star2[i].x<0 then star2[i].x:=320;
     end;
end;

procedure ustaw_asteroidy;
var
   i : integer;
begin
     randomize;
     for i:= 1 to ileastr do
     begin
          astr[i].x:=random(320);
          astr[i].y:=random(200);
          astr[i].w:=random(2)+1;
          astr[i].nr:=i;
          astr[i].jest:=true;
     end;
end;

procedure astry(y, nr : integer);
begin
     astr[nr].x:=0;
     astr[nr].y:=y;
end;

procedure astrx(x, nr : integer);
begin
     astr[nr].x:=x;
     astr[nr].y:=0;
end;

procedure ustaw_wielkosci_asteroidow;
begin
     a:=-8; a2:=-18; a3:=-24;
     b:=8; b2:=18; b3:=24;
     c:=-8; c2:=-18; c3:=-24;
     d:=8; d2:=18; d3:=24;
end;

function ox(x : real; typ : byte) : integer;
begin
     if typ=1 then ox:=round(320/(a-b)*(x-b));
     if typ=2 then ox:=round(320/(a2-b2)*(x-b2));
     if typ=3 then ox:=round(320/(a3-b3)*(x-b3));
end;

function oy(y : real; typ : byte) : integer;
begin
     if typ=1 then oy:=round(200/(c-d)*(y-d));
     if typ=2 then oy:=round(200/(c2-d2)*(y-d2));
     if typ=3 then oy:=round(200/(c3-d3)*(y-d3));
end;

procedure asteroid(x, y : real; z, z2 : real; w, show, col : byte);
begin
     if show=1 then
     begin
          x:=x-160;
          y:=y-100;
          line(round(x+ox(sin(z),w)),round(y+oy(cos(z),w)),round(x+ox(cos(z2),w)),round(y+oy(sin(z2),w)),col);
          line(round(x+ox(cos(z2),w)),round(y+oy(sin(z2),w)),round(x+ox(sin(z+pi),w)),round(y+oy(cos(z+pi),w)),col);
          line(round(x+ox(sin(z+pi),w)),round(y+oy(cos(z+pi),w)),round(x+ox(cos(z2+pi),w)),round(y+oy(sin(z2+pi),w)),col);
          line(round(x+ox(cos(z2+pi),w)),round(y+oy(sin(z2+pi),w)),round(x+ox(sin(z),w)),round(y+oy(cos(z),w)),col);
     end;
end;

procedure rotate_asteroid(o : byte);
begin
     z:=z+pi/o;
     z2:=z2-pi/o;
end;

procedure pokaz_asteroidy;

var
   i : integer;

begin
     for i:= 0 to ileastr do
     begin
          if astr[i].jest then asteroid(astr[i].x,astr[i].y,z,z2,astr[i].w,1,25);
     end;
end;

procedure ruszaj_asteroid;
var
   i : integer;
   lx, ly : real;
   k1, k2, xr, yr : real;
   nr : byte;

function itin(x, y, x1, y1, x2, y2 : integer) : boolean;
begin
     itin:=false;
     if (x>x1-1) and (x<x2+1) and (y>y1-1) and (y<y2+1) then
     itin:=true;
end;

procedure kolizja_big(nr, n1, n2 : byte);
begin
     if itin(round(kx),round(ky),astr[nr].x-15,astr[nr].y-13,astr[nr].x+15,astr[nr].y+13) and (astr[nr].w=1)
     and (astr[nr].nr=nr) and (astr[nr].jest) and (strzal) then
     begin
          dzwiek(500,2);
          dzwiek(300,2);
          punkty:=punkty+random(517)-200;
          astr[nr].jest:=false;
          strzal:=false;
          licznik_strzalu:=0;
          astr[n1].jest:=true;
          astr[n1].x:=astr[nr].x;
          astr[n1].y:=astr[nr].y;
          astr[n1].w:=2;
          astr[n2].jest:=true;
          astr[n2].y:=astr[nr].y;
          astr[n2].x:=astr[nr].x;
          astr[n2].w:=2;
     end;
end;

procedure kolizja_small(nr : byte);
begin
     if itin(round(kx),round(ky),astr[nr].x-12,astr[nr].y-11,astr[nr].x+12,astr[nr].y+11) and (astr[nr].w=2)
     and(astr[nr].nr=nr)and(astr[nr].jest)and(strzal) then
     begin
          dzwiek(100,10);
          dzwiek(100,7);
          astr[nr].jest:=false; strzal:=false; licznik_strzalu:=0;
          punkty:=punkty+random(250)+100;
     end;
end;

procedure statek_big(nr : byte);
begin
     if itin(round(px)+160,round(py)+100,astr[nr].x-15,astr[nr].y-13,astr[nr].x+15,astr[nr].y+13) and (astr[nr].w=1)
     and (astr[nr].nr=nr) and (astr[nr].jest) then
     begin
          energia:=energia-random(2)-2;
     end;
end;

procedure statek_small(nr : byte);
begin
     if itin(round(px)+160,round(py)+100,astr[nr].x-12,astr[nr].y-11,astr[nr].x+12,astr[nr].y+11) and (astr[nr].w=2)
     and(astr[nr].nr=nr) and (astr[nr].jest) then
     begin
          energia:=energia-random(2)-2;
     end;
end;

begin
     randomize;
     for i:= 1 to ileastr do
     begin
          k1:=k1+0.05;
          k2:=k2+0.1;
          xr:=xr+sin(k1/8)-0.05;
          yr:=yr+cos(k2/8)+0.2;
          lx:=round(xr/2);
          ly:=round(yr/2);

          astr[i].x:=astr[i].x+round(lx);
          if astr[i].x>335 then astr[i].x:=-10;
          if astr[i].x<-10 then astr[i].x:=335;
          astr[i].y:=astr[i].y+round(ly);
          if astr[i].y>215 then astr[i].y:=-10;
          if astr[i].y<-10 then astr[i].y:=215;

          if level=1 then
          begin
          kolizja_big(1,3,4);
          kolizja_big(2,5,6);
          kolizja_big(7,8,9);
          kolizja_big(10,11,12);
          kolizja_big(13,14,15);
          kolizja_big(16,17,18);
          kolizja_big(19,20,21);
          for j:= 1 to 21 do kolizja_small(j);
          statek_big(1);
          statek_big(2);
          statek_big(7);
          statek_big(10);
          statek_big(13);
          statek_big(16);
          statek_big(19);
          for j:= 1 to 21 do statek_small(j);
          end;
          if level=2 then
          begin
          kolizja_big(1,3,4);
          kolizja_big(2,5,6);
          kolizja_big(7,8,9);
          kolizja_big(10,11,12);
          kolizja_big(13,14,15);
          kolizja_big(16,17,18);
          kolizja_big(19,20,21);
          kolizja_big(22,23,24);
          kolizja_big(25,26,27);
          for j:= 1 to 27 do kolizja_small(j);
          statek_big(1);
          statek_big(2);
          statek_big(7);
          statek_big(10);
          statek_big(13);
          statek_big(16);
          statek_big(19);
          statek_big(22);
          statek_big(25);
          for j:= 1 to 27 do statek_small(j);
          end;
          if level=3 then
          begin
          kolizja_big(1,3,4);
          kolizja_big(2,5,6);
          kolizja_big(7,8,9);
          kolizja_big(10,11,12);
          kolizja_big(13,14,15);
          kolizja_big(16,17,18);
          kolizja_big(19,20,21);
          kolizja_big(22,23,24);
          kolizja_big(25,26,27);
          kolizja_big(28,29,30);
          kolizja_big(31,32,33);
          kolizja_big(34,35,36);
          for j:= 1 to 37 do kolizja_small(j);
          statek_big(1);
          statek_big(2);
          statek_big(7);
          statek_big(10);
          statek_big(13);
          statek_big(16);
          statek_big(19);
          statek_big(22);
          statek_big(25);
          statek_big(28);
          statek_big(31);
          statek_big(34);
          for j:= 1 to 37 do statek_small(j);
          end;
          if level=4 then
          begin
          kolizja_big(1,3,4);
          kolizja_big(2,5,6);
          kolizja_big(7,8,9);
          kolizja_big(10,11,12);
          kolizja_big(13,14,15);
          kolizja_big(16,17,18);
          kolizja_big(19,20,21);
          kolizja_big(22,23,24);
          kolizja_big(25,26,27);
          kolizja_big(28,29,30);
          kolizja_big(31,32,33);
          kolizja_big(34,35,36);
          kolizja_big(37,38,39);
          kolizja_big(40,41,42);
          kolizja_big(43,44,45);
          for j:= 1 to 46 do kolizja_small(j);
          statek_big(1);
          statek_big(2);
          statek_big(7);
          statek_big(10);
          statek_big(13);
          statek_big(16);
          statek_big(19);
          statek_big(22);
          statek_big(25);
          statek_big(28);
          statek_big(31);
          statek_big(34);
          statek_big(37);
          statek_big(40);
          statek_big(43);
          for j:= 1 to 46 do statek_small(j);
          end;
          if level=5 then
          begin
          kolizja_big(1,3,4);
          kolizja_big(2,5,6);
          kolizja_big(7,8,9);
          kolizja_big(10,11,12);
          kolizja_big(13,14,15);
          kolizja_big(16,17,18);
          kolizja_big(19,20,21);
          kolizja_big(22,23,24);
          kolizja_big(25,26,27);
          kolizja_big(28,29,30);
          kolizja_big(31,32,33);
          kolizja_big(34,35,36);
          kolizja_big(37,38,39);
          kolizja_big(40,41,42);
          kolizja_big(43,44,45);
          kolizja_big(46,47,48);
          kolizja_big(49,50,51);
          kolizja_big(52,53,54);
          for j:= 1 to 55 do kolizja_small(j);
          statek_big(1);
          statek_big(2);
          statek_big(7);
          statek_big(10);
          statek_big(13);
          statek_big(16);
          statek_big(19);
          statek_big(22);
          statek_big(25);
          statek_big(28);
          statek_big(31);
          statek_big(34);
          statek_big(37);
          statek_big(40);
          statek_big(43);
          statek_big(46);
          statek_big(49);
          statek_big(52);
          for j:= 1 to 55 do statek_small(j);
          end;
     end;
end;

procedure zerownik_asteroidow_na_kazdy_level(level : byte);
var
   i : integer;
begin
     astr[0].jest:=true;
     if level=1 then
     begin
          astr[1].jest:=true; astr[2].jest:=true; astr[3].jest:=false;
          astr[4].jest:=false; astr[5].jest:=false; astr[6].jest:=false;
          astr[7].jest:=true; astr[8].jest:=false; astr[9].jest:=false;
          astr[10].jest:=true; astr[11].jest:=false; astr[12].jest:=false;
          astr[13].jest:=true; astr[14].jest:=false; astr[15].jest:=false;
          astr[16].jest:=true; astr[17].jest:=false; astr[18].jest:=false;
          astr[19].jest:=true;
          for i:= 20 to 55 do astr[i].jest:=false;
     end;
     if level=2 then
     begin
          astr[1].jest:=true; astr[2].jest:=true; astr[3].jest:=false;
          astr[4].jest:=false; astr[5].jest:=false; astr[6].jest:=false;
          astr[7].jest:=true; astr[8].jest:=false; astr[9].jest:=false;
          astr[10].jest:=true; astr[11].jest:=false; astr[12].jest:=false;
          astr[13].jest:=true; astr[14].jest:=false; astr[15].jest:=false;
          astr[16].jest:=true; astr[17].jest:=false; astr[18].jest:=false;
          astr[19].jest:=true; astr[20].jest:=false; astr[21].jest:=false;
          astr[22].jest:=true; astr[23].jest:=false; astr[24].jest:=false;
          astr[25].jest:=true; astr[26].jest:=false; astr[27].jest:=false;
          for i:= 28 to 55 do astr[i].jest:=false;
     end;
     if level=3 then
     begin
          astr[1].jest:=true; astr[2].jest:=true; astr[3].jest:=false;
          astr[4].jest:=false; astr[5].jest:=false; astr[6].jest:=false;
          astr[7].jest:=true; astr[8].jest:=false; astr[9].jest:=false;
          astr[10].jest:=true; astr[11].jest:=false; astr[12].jest:=false;
          astr[13].jest:=true; astr[14].jest:=false; astr[15].jest:=false;
          astr[16].jest:=true; astr[17].jest:=false; astr[18].jest:=false;
          astr[19].jest:=true; astr[20].jest:=false; astr[21].jest:=false;
          astr[22].jest:=true; astr[23].jest:=false; astr[24].jest:=false;
          astr[25].jest:=true; astr[26].jest:=false; astr[27].jest:=false;
          astr[28].jest:=true; astr[29].jest:=false; astr[30].jest:=false;
          astr[31].jest:=true; astr[32].jest:=false; astr[33].jest:=false;
          astr[34].jest:=true; astr[35].jest:=false; astr[36].jest:=false;
          for i:= 37 to 55 do astr[i].jest:=false;
     end;
     if level=4 then
     begin
          astr[1].jest:=true; astr[2].jest:=true; astr[3].jest:=false;
          astr[4].jest:=false; astr[5].jest:=false; astr[6].jest:=false;
          astr[7].jest:=true; astr[8].jest:=false; astr[9].jest:=false;
          astr[10].jest:=true; astr[11].jest:=false; astr[12].jest:=false;
          astr[13].jest:=true; astr[14].jest:=false; astr[15].jest:=false;
          astr[16].jest:=true; astr[17].jest:=false; astr[18].jest:=false;
          astr[19].jest:=true; astr[20].jest:=false; astr[21].jest:=false;
          astr[22].jest:=true; astr[23].jest:=false; astr[24].jest:=false;
          astr[25].jest:=true; astr[26].jest:=false; astr[27].jest:=false;
          astr[28].jest:=true; astr[29].jest:=false; astr[30].jest:=false;
          astr[31].jest:=true; astr[32].jest:=false; astr[33].jest:=false;
          astr[34].jest:=true; astr[35].jest:=false; astr[36].jest:=false;
          astr[37].jest:=true; astr[38].jest:=false; astr[39].jest:=false;
          astr[40].jest:=true; astr[41].jest:=false; astr[42].jest:=false;
          astr[43].jest:=true; astr[44].jest:=false; astr[45].jest:=false;
          for i:= 46 to 55 do astr[i].jest:=false;
     end;
     if level=5 then
     begin
          astr[1].jest:=true; astr[2].jest:=true; astr[3].jest:=false;
          astr[4].jest:=false; astr[5].jest:=false; astr[6].jest:=false;
          astr[7].jest:=true; astr[8].jest:=false; astr[9].jest:=false;
          astr[10].jest:=true; astr[11].jest:=false; astr[12].jest:=false;
          astr[13].jest:=true; astr[14].jest:=false; astr[15].jest:=false;
          astr[16].jest:=true; astr[17].jest:=false; astr[18].jest:=false;
          astr[19].jest:=true; astr[20].jest:=false; astr[21].jest:=false;
          astr[22].jest:=true; astr[23].jest:=false; astr[24].jest:=false;
          astr[25].jest:=true; astr[26].jest:=false; astr[27].jest:=false;
          astr[28].jest:=true; astr[29].jest:=false; astr[30].jest:=false;
          astr[31].jest:=true; astr[32].jest:=false; astr[33].jest:=false;
          astr[34].jest:=true; astr[35].jest:=false; astr[36].jest:=false;
          astr[37].jest:=true; astr[38].jest:=false; astr[39].jest:=false;
          astr[40].jest:=true; astr[41].jest:=false; astr[42].jest:=false;
          astr[43].jest:=true; astr[44].jest:=false; astr[45].jest:=false;
          astr[46].jest:=true; astr[47].jest:=false; astr[48].jest:=false;
          astr[49].jest:=true; astr[50].jest:=false; astr[51].jest:=false;
          astr[52].jest:=true; astr[53].jest:=false; astr[54].jest:=false;
          for i:= 55 to 55 do astr[i].jest:=false;
     end;
     if level=6 then exit:=true;
end;

procedure ammo(x, y : integer);
begin
     bar(x,y,x+7,y+8,4);
     rectangle(x,y,x+7,y+8,12);
     printfontxy(x-4,y+1,40,'N');
end;

procedure energy(x, y : integer);
begin
     bar(x,y,x+7,y+8,2);
     rectangle(x,y,x+7,y+8,10);
     printfontxy(x-4,y+1,48,'E');
end;

function granice(x, y, x1, y1, x2, y2 : integer) : boolean;
begin
     granice:=false;
     if (x>x1-1) and (x<x2+1) and (y>y1-1) and (y<y2+1) then
     granice:=true;
end;

procedure energia_i_amunicja_randomize_xy;
begin
     n:=n+1;
     e:=e+1;
     if (n=nlos) then
     begin
          ammo_where:=true;
          n:=0;
          xn:=random(300)+10;
          yn:=random(180)+10;
          nlos:=random(10)+100;
     end;
     if granice(px+160,py+100,xn-5,yn-5,xn+12,yn+13) and (ammo_where) then
     begin
          naboje:=naboje+3;
          ammo_where:=false;
          nlos:=random(100)+100;
          n:=0;
     end;
     if (e=elos) then
     begin
          energy_where:=true;
          e:=0;
          xe:=random(300)+10;
          ye:=random(180)+10;
          elos:=random(500)+100;
     end;
     if granice(px+160,py+100,xe-5,ye-5,xe+12,ye+13) and (energy_where) then
     begin
          if energia<10001 then energia:=energia+250;
          energy_where:=false;
          elos:=random(500)+100;
          e:=0;
     end;
end;

procedure badaj_czy_koniec_levelu;
begin
     if (level=1) and (not astr[1].jest) and (not astr[2].jest) and (not astr[3].jest) and
     (not astr[4].jest) and (not astr[5].jest) and (not astr[6].jest) and (not astr[7].jest) and
     (not astr[8].jest) and (not astr[9].jest) and (not astr[10].jest) and (not astr[11].jest) and
     (not astr[12].jest) and (not astr[13].jest) and (not astr[14].jest) and (not astr[15].jest) and
     (not astr[16].jest) and (not astr[17].jest) and (not astr[18].jest) and (not astr[19].jest) and
     (not astr[20].jest) then begin level:=2; zerownik_asteroidow_na_kazdy_level(level); naboje:=naboje+10; end;
     if (level=2) and (not astr[1].jest) and (not astr[2].jest) and (not astr[3].jest) and
     (not astr[4].jest) and (not astr[5].jest) and (not astr[6].jest) and (not astr[7].jest) and
     (not astr[8].jest) and (not astr[9].jest) and (not astr[10].jest) and (not astr[11].jest) and
     (not astr[12].jest) and (not astr[13].jest) and (not astr[14].jest) and (not astr[15].jest) and
     (not astr[16].jest) and (not astr[17].jest) and (not astr[18].jest) and (not astr[19].jest) and
     (not astr[20].jest) and (not astr[21].jest) and (not astr[22].jest) and (not astr[23].jest) and
     (not astr[24].jest) and (not astr[25].jest) and (not astr[26].jest) and (not astr[27].jest) then
     begin level:=3; zerownik_asteroidow_na_kazdy_level(level); naboje:=naboje+10; end;
     if (level=3) and (not astr[1].jest) and (not astr[2].jest) and (not astr[3].jest) and
     (not astr[4].jest) and (not astr[5].jest) and (not astr[6].jest) and (not astr[7].jest) and
     (not astr[8].jest) and (not astr[9].jest) and (not astr[10].jest) and (not astr[11].jest) and
     (not astr[12].jest) and (not astr[13].jest) and (not astr[14].jest) and (not astr[15].jest) and
     (not astr[16].jest) and (not astr[17].jest) and (not astr[18].jest) and (not astr[19].jest) and
     (not astr[20].jest) and (not astr[21].jest) and (not astr[22].jest) and (not astr[23].jest) and
     (not astr[24].jest) and (not astr[25].jest) and (not astr[26].jest) and (not astr[27].jest) and
     (not astr[28].jest) and (not astr[29].jest) and (not astr[30].jest) and (not astr[31].jest) and
     (not astr[32].jest) and (not astr[33].jest) and (not astr[34].jest) and (not astr[35].jest) and
     (not astr[36].jest) then begin level:=4; zerownik_asteroidow_na_kazdy_level(level); naboje:=naboje+10; end;
     if (level=4) and (not astr[1].jest) and (not astr[2].jest) and (not astr[3].jest) and
     (not astr[4].jest) and (not astr[5].jest) and (not astr[6].jest) and (not astr[7].jest) and
     (not astr[8].jest) and (not astr[9].jest) and (not astr[10].jest) and (not astr[11].jest) and
     (not astr[12].jest) and (not astr[13].jest) and (not astr[14].jest) and (not astr[15].jest) and
     (not astr[16].jest) and (not astr[17].jest) and (not astr[18].jest) and (not astr[19].jest) and
     (not astr[20].jest) and (not astr[21].jest) and (not astr[22].jest) and (not astr[23].jest) and
     (not astr[24].jest) and (not astr[25].jest) and (not astr[26].jest) and (not astr[27].jest) and
     (not astr[28].jest) and (not astr[29].jest) and (not astr[30].jest) and (not astr[31].jest) and
     (not astr[32].jest) and (not astr[33].jest) and (not astr[34].jest) and (not astr[35].jest) and
     (not astr[36].jest) and (not astr[37].jest) and (not astr[38].jest) and (not astr[39].jest) and
     (not astr[40].jest) and (not astr[41].jest) and (not astr[42].jest) and (not astr[32].jest) and
     (not astr[44].jest) and (not astr[45].jest) then begin level:=5; zerownik_asteroidow_na_kazdy_level(level);
     naboje:=naboje+10; end;
     if (level=5) and (not astr[1].jest) and (not astr[2].jest) and (not astr[3].jest) and
     (not astr[4].jest) and (not astr[5].jest) and (not astr[6].jest) and (not astr[7].jest) and
     (not astr[8].jest) and (not astr[9].jest) and (not astr[10].jest) and (not astr[11].jest) and
     (not astr[12].jest) and (not astr[13].jest) and (not astr[14].jest) and (not astr[15].jest) and
     (not astr[16].jest) and (not astr[17].jest) and (not astr[18].jest) and (not astr[19].jest) and
     (not astr[20].jest) and (not astr[21].jest) and (not astr[22].jest) and (not astr[23].jest) and
     (not astr[24].jest) and (not astr[25].jest) and (not astr[26].jest) and (not astr[27].jest) and
     (not astr[28].jest) and (not astr[29].jest) and (not astr[30].jest) and (not astr[31].jest) and
     (not astr[32].jest) and (not astr[33].jest) and (not astr[34].jest) and (not astr[35].jest) and
     (not astr[36].jest) and (not astr[37].jest) and (not astr[38].jest) and (not astr[39].jest) and
     (not astr[40].jest) and (not astr[41].jest) and (not astr[42].jest) and (not astr[32].jest) and
     (not astr[44].jest) and (not astr[45].jest) and (not astr[46].jest) and (not astr[47].jest) and
     (not astr[48].jest) and (not astr[49].jest) and (not astr[50].jest) and (not astr[51].jest) and
     (not astr[52].jest) and (not astr[53].jest) and (not astr[54].jest) then
     begin level:=6; zerownik_asteroidow_na_kazdy_level(level); naboje:=naboje+10; end
end;

procedure intro;
const
     xy : array[1..10, 1..58] of byte =
     ((1,1,2,1,1,1,1,1,1,2,2,2,1,1,1,2,2,1,1,1,1,1,2,2,2,1,1,1,1,2,2,2,2,1,1,1,1,2,2,2,2,1,1,2,1,1,1,1,2,1,2,1,2,2,2,2,2,1),
      (1,2,1,2,1,1,1,1,2,1,1,1,2,1,1,1,1,2,2,2,1,1,2,1,1,2,2,1,1,2,1,1,1,2,1,1,2,1,1,1,1,2,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,2),
      (1,2,1,1,2,1,1,1,2,1,1,1,1,1,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,2,1,1,1,1,2,1,2,1,1,1,1,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,2),
      (2,1,1,1,2,1,1,1,2,1,2,2,1,1,1,1,1,1,2,1,1,1,2,1,1,1,1,1,2,2,2,1,1,1,2,1,2,1,2,2,1,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,2),
      (2,2,2,1,2,1,1,1,1,2,1,1,2,1,1,1,1,1,2,1,1,1,2,2,2,2,1,1,2,1,2,2,2,2,1,1,1,2,1,1,2,1,1,2,2,1,1,1,2,1,2,1,2,2,2,2,2,1),
      (2,1,1,2,2,1,1,1,1,1,1,1,1,2,1,1,1,2,1,1,1,1,2,1,1,1,2,1,2,1,1,2,1,1,1,1,1,1,1,1,1,2,1,2,1,2,2,2,2,1,2,1,2,1,1,1,1,1),
      (2,1,1,1,2,1,1,1,2,1,1,1,1,2,1,1,1,2,1,1,1,1,2,1,1,1,1,1,2,1,1,1,2,1,1,1,1,1,1,1,1,2,1,2,1,1,1,1,2,1,2,1,1,2,1,1,1,1),
      (2,1,1,1,1,2,1,1,2,1,1,1,1,2,1,1,1,2,1,1,1,2,1,1,1,1,1,1,2,1,1,1,1,2,1,1,2,1,1,1,1,2,1,2,1,1,1,1,2,1,1,2,1,2,1,1,1,1),
      (2,1,1,1,1,2,1,1,1,2,1,1,2,1,1,1,1,2,1,1,1,2,2,1,1,1,2,1,2,1,1,1,1,2,1,1,1,2,1,1,2,1,1,2,1,1,1,1,2,1,1,2,1,2,1,1,1,1),
      (1,1,1,1,1,2,1,1,1,1,2,2,1,1,1,1,1,2,1,1,1,1,1,2,2,2,1,1,2,1,1,1,1,1,2,1,1,1,2,2,1,1,1,2,1,1,1,1,2,1,1,2,1,2,1,1,1,1));

procedure rysuj_intro(px, py : integer);
var
   x, y : integer;
procedure box(x, y, c : integer);
begin
     bar(x,y,x+5,y+5,c);
end;
begin
     for x:= 1 to 58 do
     for y:= 1 to 10 do
     begin
          if xy[y,x]<>1 then box(px+x*5,py+y*5,xy[y,x]+20);
          if xy[y,x]<>1 then box(px-1+x*5,py-1+y*5,xy[y,x]+21);
          if xy[y,x]<>1 then box(px-2+x*5,py-2+y*5,xy[y,x]+22);
     end;
end;

var
   x, y : integer;
   l : byte;

begin
initgfx13h;
repeat
      inc(l);
      putpixel(random(320),random(200),random(10)+16);
      putpixel(random(320),random(200),random(10)+18);
      putpixel(random(320),random(200),random(10)+19);
until l=255;
rysuj_intro(10,10);
printfontxy(150,90,15,'BY');
printfontxy(115,111,15,'MICHA[ RYGIELSKI');
printfontxy(115,180,15,'WWW\RPAGE\PRV\PL');
printfontxy(103,190,15,'REGI007]POCZTA\ONET\PL');
pokazgrafike2;
czekaj(400);
end;

procedure levelgry(nr : byte);
begin
      if ammo_where then ammo(xn,yn);
      if energy_where then energy(xe,ye);

      printfontxy(0,5,15,'LEVEL: '+numstr(nr)+' PUNKTY: '+numstr(punkty));
      printfontxy(0,190,15,'NABOJE: '+numstr(naboje)+' ENERGIA: ');

      line(105,192,105+10000 div 50,192,22);
      line(105,193,105+10000 div 50,193,25);
      line(105,194,105+10000 div 50,194,22);

      if (energia<=0) then exit:=true;

      badaj_czy_koniec_levelu;

      if (energia>=0) or (energia>10001) then
      begin
      line(105,192,105+energia div 50,192,4);
      line(105,193,105+energia div 50,193,40);
      line(105,194,105+energia div 50,194,4);
      end;


      energia_i_amunicja_randomize_xy;

      xr:=xr+sin(p-8)*predkosc;
      yr:=yr+cos(p-8)*predkosc;

      px:=round(xr);
      py:=round(yr);

      kkx:=kkx+sin(s-8)*8;
      kky:=kky+cos(s-8)*8;

      if strzal then
      begin
           inc(licznik_strzalu);
           kx:=round(kkx);
           ky:=round(kky);
      end;

      if licznik_strzalu=20 then
      begin
           licznik_strzalu:=0;
           strzal:=false;
      end;

      if not strzal then
      begin
           kkx:=xr+160;
           kky:=yr+100;
           kx:=round(kkx);
           ky:=round(kky);
      end;

      rotate_asteroid(15);
      pokaz_asteroidy;
      ruszaj_asteroid;

      putpixel(round(kx),round(ky),12);
      line(round(px+ox(sin(p),3)),round(py+oy(cos(p),3)),round(px+ox(cos(p2),3)),round(py+oy(sin(p2),3)),15);
      line(round(px+ox(cos(p2),3)),round(py+oy(sin(p2),3)),round(px+ox(sin(p+pi),3)),round(py+oy(cos(p+pi),3)),15);
      line(round(px+ox(sin(p),3)),round(py+oy(cos(p),3)),round(px+ox(sin(p+pi),3)),round(py+oy(cos(p+pi),3)),15);

      if keydown[75] then begin p:=p+pi/16; p2:=p2-pi/16; end;
      if keydown[77] then begin p:=p-pi/16; p2:=p2+pi/16; end;
      if keydown[72] and (predkosc<5) then begin predkosc:=predkosc+0.3; end;
      if keydown[80] and (predkosc>1.0) then begin predkosc:=predkosc-0.2; end;
      if (licznik_strzalu=0) and keydown[scanof(' ')] and (naboje>0) then
      begin
           dzwiek(300,5);
           naboje:=naboje-1;
           strzal:=true;
           kkx:=xr+160;
           kky:=yr+100;
           s:=p;
      end;

      if px<-170 then xr:=160;
      if px>160 then xr:=-170;
      if py<-110 then yr:=100;
      if py>100 then yr:=-110;

      if kx<-5 then kkx:=325;
      if kx>325 then kkx:=-5;
      if ky<-5 then kky:=205;
      if ky>205 then kky:=-5;

      if not keydown[72] then
      begin
      if predkosc>0.10 then
      begin
           if predkosc=0 then predkosc:=1 else predkosc:=predkosc-0.05;
      end;
      end;

      pokazgrafike2;
      czekaj(speed);
      cls(0);
end;

var
   stars_who : boolean;

begin
initgfx13h;
randomize;
intro;
cls(0);
ustaw_asteroidy;
ustaw_wielkosci_asteroidow;
initnewkeyint;
px:=60;
py:=10;
predkosc:=0;
strzal:=false;
kkx:=kkx+sin(s-8)*4;
kky:=kky+cos(s-8)*4;
kx:=round(kkx);
ky:=round(kky);
s:=p;
licznik_strzalu:=0;
level:=1;
zerownik_asteroidow_na_kazdy_level(level);
energia:=10000;
naboje:=25;
punkty:=0;
xn:=-30;
yn:=-30;
xe:=-30;
ye:=-60;
n:=0;
e:=0;
j:=0;
ammo_where:=true;
nlos:=random(200)+100;
energy_where:=true;
elos:=random(500)+100;
exit:=false;
ustaw_stars;
stars_who:=true;
speed:=20;
repeat
      if stars_who then
      begin
           pokaz_stars;
           ruszaj_stars;
      end;
      if stars_who then printfontxy(0,15,15,'F4 ^ STARS ON'+' SPEED: '+numstr(speed)) else
      printfontxy(0,15,15,'F4 ^ STARS OFF'+' SPEED: '+numstr(speed));
      levelgry(level);
      if keydown[f4scan] and (stars_who) then begin stars_who:=false; czekaj(100); end;
      if keydown[f4scan] and (not stars_who) then begin stars_who:=true; czekaj(100); end;
      if keydown[scanof('-')] and (speed>0) then begin speed:=speed-1; end;
      if keydown[scanof('+')] and (speed<100) then begin speed:=speed+1; end;
until keydown[1] or exit;
setoldkeyint;
closegfx13h;
end.