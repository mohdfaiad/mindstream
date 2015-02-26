unit msCircleWithRadius;

interface

uses
 System.Types,
 msInterfaces,
 msCircle
 ;

type
 TmsCircleWithRadius = class(TmsCircle)
 private
  f_Rad : Single;
 protected
  function InitialRadiusX: Integer; override;
  constructor CreateInner(const aShapeClass : ImsShapeClass; const aStartPoint: TPointF; aRad: Single); reintroduce;
 public
  class function Create(const aStartPoint: TPointF; aRad: Single): ImsShape;
 end;//TmsCircleWithRadius

implementation

uses
 msShape,
 msShapeClass
 ;

// TmsCircleWithRadius

constructor TmsCircleWithRadius.CreateInner(const aShapeClass : ImsShapeClass; const aStartPoint: TPointF; aRad: Single);
begin
 inherited CreateInner(aShapeClass, TmsMakeShapeContext.Create(aStartPoint, nil, nil));
 f_Rad := aRad;
end;

class function TmsCircleWithRadius.Create(const aStartPoint: TPointF; aRad: Single): ImsShape;
begin
 Result := CreateInner(TmsShapeClass.Create(Self), aStartPoint, aRad);
end;

function TmsCircleWithRadius.InitialRadiusX: Integer;
begin
 Result := Round(f_Rad);
end;

end.
