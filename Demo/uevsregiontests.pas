unit uevsRegionTests;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLIntf, LCLType, uEvsNumericEdit, StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    btnClearRegion : TButton;
    btnClearRegion1 : TButton;
    btnCreateRegion : TButton;
    edtLeft : TEvsNumericEdit;
    edtTop : TEvsNumericEdit;
    edtBottom : TEvsNumericEdit;
    edtRight : TEvsNumericEdit;
    EvsNumericEdit1 : TEvsNumericEdit;
    Panel1 : TPanel;
    procedure btnClearRegionClick(Sender : TObject);
    procedure btnCreateRegionClick(Sender : TObject);
    procedure FormMouseDown(Sender : TObject; Button : TMouseButton;
      Shift : TShiftState; X, Y : Integer);
    procedure FormMouseMove(Sender : TObject; Shift : TShiftState; X,
      Y : Integer);
    procedure FormPaint(Sender : TObject);
  private
    { private declarations }
    FRGN : HRGN;
    FPoints : array of TPoint;
    function RotatePoint(const aPoint :TPoint) :TPoint;
  public
    { public declarations }
    constructor Create(TheOwner : TComponent); override;
  end;

var
  Form3 : TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.btnCreateRegionClick(Sender : TObject);
begin
  if FRGN <> 0 then DeleteObject(FRGN); //CreateRegionCopy();
  FRGN := CreateRectRgn(edtLeft.IntegerValue,edtTop.IntegerValue, edtRight.IntegerValue, edtBottom.IntegerValue);
  Invalidate;
end;

procedure TForm3.FormMouseDown(Sender : TObject; Button : TMouseButton;
  Shift : TShiftState; X, Y : Integer);
begin
  if ssLeft in Shift then FPoints[1] :=classes.Point(X,Y);
  if ssRight in Shift then FPoints[0]:=Classes.Point(x,y);
  Invalidate;
end;

procedure TForm3.btnClearRegionClick(Sender : TObject);
begin
  if FRGN = 0 then Exit;
  DeleteObject(FRGN);
  FRGN := 0;
end;

procedure TForm3.FormMouseMove(Sender : TObject; Shift : TShiftState; X,
  Y : Integer);
begin
  Caption := Format('M.X:%D,M.Y:%D, PtinRegion:%S',[X,Y,BoolToStr(PtInRegion(FRGN,X,Y), True)]);
end;


procedure TForm3.FormPaint(Sender : TObject);
function canrotate:boolean;
begin
  Result := ((FPoints[0].x > 0) and (FPoints[0].y > 0)) and ((FPoints[1].x > 0) or (FPoints[1].y > 0));
end;

var
  vTmp : HRGN;
  vpt  : TPoint;
begin

  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Style := psClear;
  if (FPoints[0].x > 0) and (FPoints[0].y > 0) then begin
    Canvas.Brush.Color := clBlue;
    Canvas.Ellipse(FPoints[0].x-2,FPoints[0].y-2,FPoints[0].x+2,FPoints[0].y+2);
  end;
  if (FPoints[1].x > 0) and (FPoints[1].y > 0) then begin
    Canvas.Brush.Color := clRed;
    Canvas.Ellipse(FPoints[1].x-2,FPoints[1].y-2,FPoints[1].x+2,FPoints[1].y+2);
    Canvas.Line(FPoints[0],FPoints[1]);
  end;
  if canrotate then begin
    vPt := RotatePoint(classes.Point(FPoints[1].X - FPoints[0].X,FPoints[1].Y - FPoints[0].Y));
    Canvas.Brush.Color := clBlack;
    Canvas.Ellipse(vPt.x+FPoints[0].X-2,vPt.y++FPoints[0].Y-2,vPt.x++FPoints[0].X+2,vPt.y++FPoints[0].Y+2);
  end;
  if FRGN = 0 then Exit;
  vTmp := SelectClipRGN(Canvas.Handle, FRGN);
  Canvas.Brush.Color := clMoneyGreen;
  canvas.Brush.Style := bsSolid;
  Canvas.Pen.Style   := psClear;
  Canvas.Rectangle(0,0,ClientWidth,ClientHeight);
  SelectClipRGN(Canvas.Handle, vTmp);
end;

function TForm3.RotatePoint(const aPoint : TPoint) : TPoint;
var
  vTmp :Double;
begin
  vTmp := EvsNumericEdit1.Value;
  vTmp := 3.141592654 * 2 / 360 * vTmp;
  Result.x := round((aPoint.x*cos(vTmp)) - (aPoint.y * sin(vTmp)));
  Result.y := round((aPoint.x*sin(vTmp)) + (aPoint.y* cos(vTmp)));
end;

constructor TForm3.Create(TheOwner : TComponent);
begin
  inherited Create(TheOwner);
  FRGN := 0;
  SetLength(FPoints,2);
  FPoints[0] := Classes.Point(0,0);
  FPoints[1] := Classes.Point(0,0);
end;

end.

