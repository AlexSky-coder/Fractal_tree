unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls,Clipbrd;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox5: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    procedure Draw(b:tbitmap;i:integer;x,y,d,ppp,g:extended);
    procedure fetch_from_array(b:tbitmap;i:integer;x,y:integer;v:extended);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
  private

  public

  end;
type
  Tcoordinates=record
   g,d:extended;
  end;


var
  Form1: TForm1;
  map:tbitmap;
  j:integer;
  Wind:extended;
  m:array [1..65535] of Tcoordinates;

implementation

{$R *.lfm}

procedure TForm1.Draw(b:tbitmap;i:integer;x,y,d,ppp,g:extended);
var xx,yy:integer;
    p:extended;
    r:extended;
begin
 //случайный угол
 if form1.CheckBox1.Checked then
 r:=(random(form1.TrackBar3.Position*2)-form1.TrackBar3.Position)
 else r:=0;
 p:=((pi*2)/360)*(ppp+r);
 //случайная длина
 if CheckBox2.Checked then r:=random(150)/100 else r:=1;

 inc(j);
 m[j].g:=g;
 m[j].d:=d*r;
 xx:=round(x+cos(m[j].g)*m[j].d);
 yy:=round(y+sin(m[j].g)*m[j].d);

 if CheckBox3.Checked then
 b.Canvas.Pen.Width:=i;

 b.Canvas.MoveTo(round(x),round(y));
 b.Canvas.Lineto(xx,yy);
 if i>0 then
 begin
   draw(b,i-1,xx,yy,d*0.8,ppp,g+p);
   draw(b,i-1,xx,yy,d*0.8,ppp,g-p);
 end;

end;


procedure TForm1.fetch_from_array(b:tbitmap;i:integer;x,y:integer;v:extended);
var xx,yy:integer;
begin
inc(j);
 xx:=round(x+cos(m[j].g+v)*m[j].d);
 yy:=round(y+sin(m[j].g+v)*m[j].d);

 if CheckBox3.Checked then
 b.Canvas.Pen.Width:=i;

 b.Canvas.MoveTo(x,y);
 b.Canvas.Lineto(xx,yy);

 if i>0 then
 begin
   fetch_from_array(b,i-1,xx,yy,v+v/3);
   fetch_from_array(b,i-1,xx,yy,v+v/3);
 end;

end;


{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 map:=tbitmap.Create;
 map.SetSize(paintbox1.width,paintbox1.Height);
 button1.Click;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  map.SetSize(paintbox1.width,paintbox1.Height);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var gg:extended;
begin
  if RadioButton1.Checked then
  begin
   map.Canvas.Brush.Color:=clwhite;
   map.Canvas.pen.Color:=clwhite;
   map.Canvas.Rectangle(map.Canvas.ClipRect);
   map.Canvas.pen.Color:=0;
   map.Canvas.Pen.Width:=1;
   j:=0;
   Wind:=Wind+0.1;
   gg:=(sin(Wind)*pi)*0.01;
   fetch_from_array(map,trackbar1.Position,map.width div 2,map.height,gg);
   paintbox1.Canvas.Draw(0,0,map);
  end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  label1.Caption:='Граница рекурсии: '+inttostr(trackbar1.Position);
  button1.Click;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
  label2.Caption:='Угол: '+inttostr(trackbar2.Position);
  button1.Click;
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
begin
  form1.CheckBox1.Caption:='Рандомный угол: '+
  inttostr(trackbar3.Position);
  button1.Click;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  map.Canvas.Brush.Color:=clwhite;
  map.Canvas.pen.Color:=clwhite;
  map.Canvas.Rectangle(map.Canvas.ClipRect);
  map.Canvas.pen.Color:=0;
  map.Canvas.Pen.Width:=1;

  j:=0;
  draw(map,trackbar1.Position,map.width div 2,map.height,
  map.height div 5-10,trackbar2.Position,pi+pi/2);

  paintbox1.Canvas.Draw(0,0,map);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Clipboard.Assign(map)
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
begin
  timer1.Enabled:=CheckBox5.Checked;
end;

end.

