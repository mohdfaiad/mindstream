unit msProxyShapeClass;

interface

uses
 System.UITypes,
 msInterfaces,
 msShape,
 msInterfacedRefcounted
 ;

type
 TmsProxyShapeClass = class(TmsInterfacedRefcounted, ImsShapeClass, ImsTunableShapeClass)
 private
  f_ShapeClass : MCmsShape;
  f_Name : String;
  f_FillColor : TmsColorRec;
 private
  constructor CreateInner(const aName : String; const aShapeClass: MCmsShape);
 protected
  function IsForToolbar: Boolean;
  function IsTool: Boolean;
  function IsLineLike: Boolean;
  function Creator: ImsShapeCreator;
  function Name: String;
  function Stereotype: String;
  procedure TransformDrawOptionsContext(var theCtx: TmsDrawOptionsContext);
  procedure RegisterInMarshal(aMarshal: TmsJSONMarshal);
  procedure RegisterInUnMarshal(aMarshal: TmsJSONUnMarshal);
  function IsNullClick: Boolean;
  function ButtonShape: ImsShape;
  function IsOurInstance(const aShape: ImsShape): Boolean;
  function NullClick(const aHolder: ImsDiagrammsHolder): Boolean;
  function SetFillColor(aColor: TAlphaColor): ImsTunableShapeClass;
 public
  class function Create(const aName : String; const aShapeClass: MCmsShape): ImsTunableShapeClass; overload;
  class function Create(const aName : String; const aShapeClass: RmsShape): ImsTunableShapeClass; overload;
 end;//TmsProxyShapeClass

implementation

uses
 msShapeCreator,
 msRegisteredShapes
 ;

// TmsProxyShapeClass

constructor TmsProxyShapeClass.CreateInner(const aName : String; const aShapeClass: MCmsShape);
begin
 inherited Create;
 f_ShapeClass := aShapeClass;
 f_Name := aName;
end;

class function TmsProxyShapeClass.Create(const aName : String; const aShapeClass: MCmsShape): ImsTunableShapeClass;
begin
 Result := CreateInner(aName, aShapeClass);
end;

class function TmsProxyShapeClass.Create(const aName : String; const aShapeClass: RmsShape): ImsTunableShapeClass;
begin
 Result := Create(aName, TmsRegisteredShapes.Instance.ByName(aShapeClass.ClassName));
end;

function TmsProxyShapeClass.IsForToolbar: Boolean;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_ShapeClass.IsForToolbar;
end;

function TmsProxyShapeClass.IsTool: Boolean;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_ShapeClass.IsTool;
end;

function TmsProxyShapeClass.IsLineLike: Boolean;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_ShapeClass.IsLineLike;
end;

function TmsProxyShapeClass.Creator: ImsShapeCreator;
var
 l_SC : TClass;
begin
 Assert(f_ShapeClass <> nil);
 l_SC := (f_ShapeClass.Creator As ImsShapeCreatorFriend).ShapeClassForCreate;
 Assert(l_SC.InheritsFrom(TmsShape));
 Result := TmsShapeCreator.Create(Self, RmsShape(l_SC));
 //Result := f_ShapeClass.Creator;
end;

function TmsProxyShapeClass.Name: String;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_Name;
(* Assert(false, '�� �����������');
 Result := f_ShapeClass.Name;*)
end;

function TmsProxyShapeClass.Stereotype: String;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_Name;
(* Assert(false, '�� �����������');
 Result := f_ShapeClass.Stereotype;*)
end;

procedure TmsProxyShapeClass.TransformDrawOptionsContext(var theCtx: TmsDrawOptionsContext);
begin
 Assert(f_ShapeClass <> nil);
 f_ShapeClass.TransformDrawOptionsContext(theCtx);
 if f_FillColor.rIsSet then
  theCtx.rFillColor := f_FillColor.rValue;
end;

procedure TmsProxyShapeClass.RegisterInMarshal(aMarshal: TmsJSONMarshal);
begin
 Assert(f_ShapeClass <> nil);
 f_ShapeClass.RegisterInMarshal(aMarshal);
end;

procedure TmsProxyShapeClass.RegisterInUnMarshal(aMarshal: TmsJSONUnMarshal);
begin
 Assert(f_ShapeClass <> nil);
 f_ShapeClass.RegisterInUnMarshal(aMarshal);
end;

function TmsProxyShapeClass.IsNullClick: Boolean;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_ShapeClass.IsNullClick;
end;

function TmsProxyShapeClass.ButtonShape: ImsShape;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_ShapeClass.ButtonShape;
end;

function TmsProxyShapeClass.IsOurInstance(const aShape: ImsShape): Boolean;
begin
 Assert(f_ShapeClass <> nil);
 Assert(aShape.ShapeClass <> nil);
 Result := aShape.ShapeClass.Name = Self.f_Name;
// Result := aShape.ShapeClass.Name = f_ShapeClass.Name;
end;

function TmsProxyShapeClass.NullClick(const aHolder: ImsDiagrammsHolder): Boolean;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_ShapeClass.NullClick(aHolder);
end;

function TmsProxyShapeClass.SetFillColor(aColor: TAlphaColor): ImsTunableShapeClass;
begin
 Result := Self;
 f_FillColor.rIsSet := true;
 f_FillColor.rValue := aColor;
end;

end.
