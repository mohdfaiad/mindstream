unit msProxyShapeClass;

interface

uses
 System.UITypes,
 msInterfaces,
 msShape,
 msInterfacedRefcounted,
 msShapeClassPrim
 ;

type
 TmsProxyShapeClass = class(TmsShapeClassPrim, ImsShapeClass)
 private
  f_ShapeClass : MCmsShape;
  f_Name : TmsShapeClassName;
  f_Stereotype : TmsShapeClassName;
 private
  constructor CreateInner(const aName : String; const aShapeClass: MCmsShape);
 protected
  function IsTool: Boolean;
  function IsLineLike: Boolean;
  function Creator: ImsShapeCreator; override;
  function GetName: String; override;
  function Stereotype: TmsShapeStereotype; override;
  function ParentMC: ImsShapeClass; override;
  function AsMC: ImsShapeClass; override;
  procedure RegisterInMarshal(aMarshal: TmsJSONMarshal);
  procedure RegisterInUnMarshal(aMarshal: TmsJSONUnMarshal);
  function IsNullClick: Boolean;
  function ButtonShape: ImsShape;
  function IsOurInstance(const aShape: ImsShape): Boolean;
  function NullClick(const aHolder: ImsDiagrammsHolder): Boolean;
 public
  class function Create(const aName : String; const aShapeClass: MCmsShape): ImsShapeClassTuner;
 end;//TmsProxyShapeClass

implementation

uses
 msShapeCreator,
 msRegisteredShapes
 ;

// TmsProxyShapeClass

constructor TmsProxyShapeClass.CreateInner(const aName : String; const aShapeClass: MCmsShape);
begin
 f_ShapeClass := aShapeClass;
 f_Stereotype := aName;
 f_Name := f_Stereotype;
 inherited Create;
end;

class function TmsProxyShapeClass.Create(const aName : String; const aShapeClass: MCmsShape): ImsShapeClassTuner;
begin
 Result := CreateInner(aName, aShapeClass);
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

function TmsProxyShapeClass.GetName: String;
begin
 Assert(f_ShapeClass <> nil);
 Result := String(f_Name);
end;

function TmsProxyShapeClass.Stereotype: TmsShapeStereotype;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_Stereotype;
end;

function TmsProxyShapeClass.ParentMC: ImsShapeClass;
begin
 Result := f_ShapeClass;
end;

function TmsProxyShapeClass.AsMC: ImsShapeClass;
begin
 Result := Self;
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
 Result := Self.f_Name.EQ(aShape.ShapeClass.Name);
end;

function TmsProxyShapeClass.NullClick(const aHolder: ImsDiagrammsHolder): Boolean;
begin
 Assert(f_ShapeClass <> nil);
 Result := f_ShapeClass.NullClick(aHolder);
end;

end.
