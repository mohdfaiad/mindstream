﻿unit msMoverIcon;

interface

uses
 msInterfaces,
 System.Types,
 System.Math.Vectors,
 msPolygonShape
 ;
type
 TmsDirection = (dTop, dBottom, dRight, dLeft);
 TTmsDirection = set of TmsDirection;

type
 TmsMoverIcon = class(TmsPolygonShape)
  // - класс для реализации полигональных объектов
 private
  function BuildArrow(const aStartPoint: TPointF; const aDirection: TTmsDirection): TPolygon;
 protected
  class function CreateIcon(const aStartPoint: TPointF): ImsShape;
  function Polygon: TPolygon; virtual;
  procedure DoDrawTo(const aCtx: TmsDrawContext); override;
  function GetDrawBounds: TRectF; override;
 end;//TmsPolygonShape

implementation

const
 c_ArrowLength = 30;
 c_ArrowWidth = 15;
 c_TriangleWidth = 10;
 c_TriangleHeight = 20;

{ TmsMoverIcon }
function TmsMoverIcon.GetDrawBounds: TRectF;
var
 l_Pl : TPolygon;
 l_P : TPointF;
begin
 l_Pl := Polygon;
 Result.Left := High(Integer);
 Result.Top := High(Integer);
 Result.Right := Low(Integer);
 Result.Bottom := Low(Integer);
 for l_P in l_PL do
 begin
  if (l_P.X < Result.Left) then
   Result.Left := l_P.X;
  if (l_P.X > Result.Right) then
   Result.Right := l_P.X;

  if (l_P.Y < Result.Top) then
   Result.Top := l_P.Y;
  if (l_P.Y > Result.Bottom) then
   Result.Bottom := l_P.Y;
 end;//l_P in l_PL
 //Result := PolygonBounds(Polygon);
end;


function TmsMoverIcon.Polygon: TPolygon;
var
 l_Polygon : TPolygon;
 l_StartPoint, l_Point: TPointF;
 l_RectF: TRectF;
begin
 l_StartPoint := StartPoint;

 l_Point := TPointF.Create(l_StartPoint.X, l_StartPoint.Y);

 l_Polygon := l_Polygon + BuildArrow(l_Point, [TmsDirection.dTop]);
 // Нарисовали стрелку вверх

 l_Point := (l_Polygon[High(l_Polygon)]);
 l_Polygon := l_Polygon + BuildArrow(l_Point, [TmsDirection.dRight]);
 // Нарисовали стрелку вправо

 l_Point := (l_Polygon[High(l_Polygon)]);
 l_Polygon := l_Polygon + BuildArrow(l_Point, [TmsDirection.dBottom]);
 // Нарисовали стрелку вниз

 l_Point := (l_Polygon[High(l_Polygon)]);
 l_Polygon := l_Polygon + BuildArrow(l_Point, [TmsDirection.dLeft]);
 // Нарисовали стрелку влево

end;

function TmsMoverIcon.BuildArrow(const aStartPoint: TPointF;
  const aDirection: TTmsDirection): TPolygon;
var
 l_Polygon : TPolygon;
 l_Point: TPointF;
 l_X, l_Y : Single;
 l_Invert : SmallInt;

begin
 l_Invert := 1;
 SetLength(l_Polygon, 7);

 l_Point := aStartPoint;
 l_Polygon[0] := l_Point;

 if (dLeft in aDirection) or (dBottom in aDirection) then
  l_Invert := -1;

 if (dTop in aDirection) or
    (dBottom in aDirection) then
 begin
  l_Y := l_Point.Y - (c_ArrowLength * l_Invert);
  l_Point := TPointF.Create(l_Point.X, l_Y);
  l_Polygon[1] := l_Point;

  l_X := l_Point.X - (c_TriangleWidth * l_Invert);
  l_Point := TPointF.Create(l_X, l_Point.Y);
  l_Polygon[2] := l_Point;

  l_X := l_Point.X + (c_TriangleWidth + c_ArrowWidth / 2) * l_Invert;
  l_Y := l_Point.Y - (c_TriangleHeight * l_Invert);
  l_Point := TPointF.Create(l_X, l_Y);
  l_Polygon[3] := l_Point;

  l_X := l_Point.X + (c_TriangleWidth + c_ArrowWidth / 2) * l_Invert;
  l_Y := l_Point.Y + (c_TriangleHeight * l_Invert);
  l_Point := TPointF.Create(l_X, l_Y);
  l_Polygon[4] := l_Point;

  l_X := l_Point.X - (c_TriangleWidth * l_Invert);
  l_Y := l_Point.Y;
  l_Point := TPointF.Create(l_X, l_Y);
  l_Polygon[5] := l_Point;

  l_Y := l_Point.Y + (c_ArrowLength * l_invert);
  l_Point := TPointF.Create(l_Point.X, l_Y);
  l_Polygon[6] := l_Point;
  Result := l_Polygon;
 end;

 if (dRight in aDirection) or
    (dLeft in aDirection) then
 begin
  l_X := l_Point.X + (c_ArrowLength * l_Invert);
  l_Point := TPointF.Create(l_X, l_Point.Y);
  l_Polygon[1] := l_Point;

  l_Y :=  l_Point.Y - (c_TriangleWidth * l_Invert);
  l_Point := TPointF.Create(l_Point.X, l_Y);
  l_Polygon[2] := l_Point;

  l_X := l_Point.X + (c_TriangleHeight * l_Invert);
  l_Y := l_Point.Y + (c_TriangleWidth + c_ArrowWidth / 2) * l_Invert;
  l_Point := TPointF.Create(l_X, l_Y);
  l_Polygon[3] := l_Point;

  l_X := l_Point.X - (c_TriangleHeight * l_Invert);
  l_Y := l_Point.Y + (c_TriangleWidth + c_ArrowWidth / 2) * l_Invert;
  l_Point := TPointF.Create(l_X, l_Y);
  l_Polygon[4] := l_Point;

  l_Y := l_Point.Y - (c_TriangleWidth * l_Invert);
  l_Point := TPointF.Create(l_Point.X, l_Y);;
  l_Polygon[5] := l_Point;

  l_X := l_Point.X - (c_ArrowLength * l_Invert);
  l_Point := TPointF.Create(l_X, l_Point.Y);
  l_Polygon[6] := l_Point;
  Result := l_Polygon;
 end;

end;

class function TmsMoverIcon.CreateIcon(const aStartPoint: TPointF): ImsShape;
begin
 Result := Self.Create(TmsMakeShapeContext.Create(aStartPoint, nil, nil));
end;

procedure TmsMoverIcon.DoDrawTo(const aCtx: TmsDrawContext);
var
 l_P : TPolygon;
begin
 l_P := Polygon;
 aCtx.rCanvas.DrawPolygon(l_P, 1);
 aCtx.rCanvas.FillPolygon(l_P, 0.5);
end;

end.
