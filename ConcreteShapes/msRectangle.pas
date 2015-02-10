﻿unit msRectangle;

interface

uses
 msShape,
 System.Types,
 FMX.Graphics,
 FMX.Types,
 System.UITypes,
 msInterfaces,
 msRectangularShape
 ;

type
 TmsRectangle = class(TmsRectangularShape)
 protected
  class function CornerRadius: Single; override;
  class function InitialWidth: Single; override;
  class function InitialHeight: Single; override;
  procedure DoDrawTo(const aCtx: TmsDrawContext); override;
  procedure TransformDrawOptionsContext(var theCtx: TmsDrawOptionsContext); override;
 end;//TmsRectangle

implementation

// TmsRectangle

class function TmsRectangle.InitialHeight: Single;
begin
 Result := 90;
end;

class function TmsRectangle.InitialWidth: Single;
begin
 Result := 100;
end;

class function TmsRectangle.CornerRadius: Single;
begin
 Result := 0;
end;


procedure TmsRectangle.DoDrawTo(const aCtx: TmsDrawContext);
var
 l_msPointContext: TRectF;
begin
 l_msPointContext := DrawBounds;
 aCtx.rCanvas.DrawRect(l_msPointContext,
                  CornerRadius,
                  CornerRadius,
                  AllCorners,
                  1,
                  TCornerType.Round);
 aCtx.rCanvas.FillRect(l_msPointContext,
                  CornerRadius,
                  CornerRadius,
                  AllCorners,
                  0.5,
                  TCornerType.Round);
end;

procedure TmsRectangle.TransformDrawOptionsContext(var theCtx: TmsDrawOptionsContext);
begin
 inherited;
 theCtx.rFillColor := TAlphaColorRec.White;
end;

end.


