unit msShapeClassList;

interface

uses
 msInterfaces,
 msShape,
 Generics.Collections,
 msObject
 ;

type
 MCmsShape = msShape.MCmsShape;
 TmsShapeClassListItems = TList<MCmsShape>;

 TmsShapeClassLambda = reference to procedure (const aShapeClass : MCmsShape);

 TmsShapeClassList = class(TmsObject)
 strict protected
  f_Registered : TmsShapeClassListItems;
  constructor Create;
 protected
  function IndexOf(const aValue: String): Integer;
  procedure Cleanup; override;
 public
  procedure RegisterMC(const aValue: MCmsShape); overload; virtual;
  procedure RegisterMC(const aShapes: array of MCmsShape); overload;
  procedure Register(const aValue: RmsShape); overload;
  procedure Register(const aShapes: array of RmsShape); overload;
  function ByName(const aValue: String): MCmsShape;
  procedure IterateShapes(aLambda: TmsShapeClassLambda); virtual;
  // [�������� (������ ��������������)|https://ru.wikipedia.org/wiki/%D0%98%D1%82%D0%B5%D1%80%D0%B0%D1%82%D0%BE%D1%80_(%D1%88%D0%B0%D0%B1%D0%BB%D0%BE%D0%BD_%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F)]
 end;//TmsShapeClassList

implementation

uses
 SysUtils,
 msShapeClass
 ;

// TmsShapeClassList

constructor TmsShapeClassList.Create;
begin
 inherited;
 f_Registered := TmsShapeClassListItems.Create;
end;

procedure TmsShapeClassList.Cleanup;
begin
 FreeAndNil(f_Registered);
 inherited;
end;

procedure TmsShapeClassList.RegisterMC(const aValue: MCmsShape);
begin
 Assert(IndexOf(aValue.Name) < 0);
 f_Registered.Add(aValue);
end;

procedure TmsShapeClassList.RegisterMC(const aShapes: array of MCmsShape);
var
 l_Shape : MCmsShape;
begin
 for l_Shape in aShapes do
  Self.RegisterMC(l_Shape);
end;

procedure TmsShapeClassList.Register(const aValue: RmsShape);
begin
 RegisterMC(TmsShapeClass.Create(aValue));
end;

procedure TmsShapeClassList.Register(const aShapes: array of RmsShape);
var
 l_Shape : RmsShape;
begin
 for l_Shape in aShapes do
  Self.Register(l_Shape);
end;

function TmsShapeClassList.IndexOf(const aValue: String): Integer;
var
 l_Shape : MCmsShape;
 I : Integer;
begin
 Result := -1;
 for I := 0 to Pred(f_Registered.Count) do
 begin
  l_Shape := f_Registered.Items[I];
  if (l_Shape.Name = aValue) then
  begin
   Result := I;
   Exit;
  end;//l_Shape.Name = aValue.ClassName
 end;//for I
end;

function TmsShapeClassList.ByName(const aValue: String): MCmsShape;
var
 l_Shape : MCmsShape;
 I : Integer;
begin
 Result := nil;
 for I := 0 to Pred(f_Registered.Count) do
 begin
  l_Shape := f_Registered.Items[I];
  if (l_Shape.Name = aValue) then
  begin
   Result := l_Shape;
   Exit;
  end;//l_Shape.Name = aValue.ClassName
 end;//for I
end;

procedure TmsShapeClassList.IterateShapes(aLambda: TmsShapeClassLambda);
var
 l_ShapeClass : MCmsShape;
begin
 for l_ShapeClass in f_Registered do
  if not l_ShapeClass.IsTool then
   aLambda(l_ShapeClass);
 for l_ShapeClass in f_Registered do
  if l_ShapeClass.IsTool then
   aLambda(l_ShapeClass);
end;

end.
