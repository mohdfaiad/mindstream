unit msDiagramm;

interface

uses
 {$Include msItemsHolder.mixin.pas}
 ,
 FMX.Graphics,
 Generics.Collections,
 System.SysUtils,
 System.Types,
 System.UITypes,
 msShape,
 msPointCircle,
 System.Classes,
 FMX.Objects,
 msRegisteredShapes,
 FMX.Dialogs,
 System.JSON,
 msCoreObjects,
 msSerializeInterfaces,
 msInterfacedNonRefcounted,
 msInterfacedRefcounted
 ;

type
 TmsShapeList = class(TList<ImsShape>)
 public
  function ShapeByPt(const aPoint: TPointF): ImsShape;
 end; // TmsShapeList

 ImsDiagramm = interface
  function toObject: TObject;
 end;//ImsDiagramm

 TmsItemsHolderParent = TmsInterfacedRefcounted{TmsInterfacedNonRefcounted};
 TmsItemGet = ImsShape;
 TmsItemSet = TmsShape;
 TmsItemsList = TmsShapeList;
 {$Include msItemsHolder.mixin.pas}
 TmsDiagramm = class(TmsItemsHolder, ImsDiagramm, ImsShapeByPt, ImsShapesController)
 // - �������� ��������� ImsObjectWrap.
 //   ������ - ���� TmsDiagramm ��� �������� ��������, �� �� ������.
 //   � ���� ����� ImsSerializable, �� - AV.
 //   ��� ��� ����� ������ ��������� ������.
 private
  [JSONMarshalled(False)]
  FCurrentClass: RmsShape;
  [JSONMarshalled(False)]
  FCurrentAddedShape: ImsShape;
  [JSONMarshalled(False)]
  FCanvas: TCanvas;
  [JSONMarshalled(False)]
  FOrigin: TPointF;
  fName: String;
 private
  procedure DrawTo(const aCanvas: TCanvas; const aOrigin: TPointF);
  function CurrentAddedShape: ImsShape;
  procedure BeginShape(const aStart: TPointF);
  procedure EndShape(const aFinish: TPointF);
  function ShapeIsEnded: Boolean;
  class function AllowedShapes: TmsRegisteredShapes;
  procedure CanvasChanged(aCanvas: TCanvas);
  function ShapeByPt(const aPoint: TPointF): ImsShape;
  procedure RemoveShape(const aShape: ImsShape);
  property CurrentClass: RmsShape read FCurrentClass write FCurrentClass;
 public
  constructor Create(anImage: TImage; const aName: String);
  procedure ResizeTo(anImage: TImage);
  procedure ProcessClick(const aStart: TPointF);
  procedure Clear;
  procedure Invalidate;
  procedure AllowedShapesToList(aList: TStrings);
  procedure SelectShape(aList: TStrings; anIndex: Integer);
  property Name: String read fName write fName;
  function CurrentShapeClassIndex: Integer;
  procedure Serialize;
  procedure DeSerialize;
  procedure Assign(const anOther : TmsDiagramm);
 end;//TmsDiagramm

implementation

uses
 {$Include msItemsHolder.mixin.pas}
 ,
 msMover,
 msCircle,
 msDiagrammMarshal
 ;

{$Include msItemsHolder.mixin.pas}

const
 c_FileName = '.json';

class function TmsDiagramm.AllowedShapes: TmsRegisteredShapes;
begin
 Result := TmsRegisteredShapes.Instance;
end;

procedure TmsDiagramm.AllowedShapesToList(aList: TStrings);
var
 l_Class: RmsShape;
begin
 aList.Clear;
 for l_Class in AllowedShapes do
  if l_Class.IsForToolbar then
   aList.AddObject(l_Class.ClassName, TObject(l_Class));
end;

function TmsDiagramm.CurrentShapeClassIndex: Integer;
begin
 Result := AllowedShapes.IndexOf(FCurrentClass);
end;

procedure TmsDiagramm.SelectShape(aList: TStrings; anIndex: Integer);
begin
 CurrentClass := RmsShape(aList.Objects[anIndex]);
end;

procedure TmsDiagramm.Serialize;
begin
 TmsDiagrammMarshal.Serialize(Self.Name + c_FileName, self);
end;

procedure TmsDiagramm.ProcessClick(const aStart: TPointF);
begin
 if ShapeIsEnded then
  // - �� �� ��������� ��������� - ���� ��� ��������
  BeginShape(aStart)
 else
  EndShape(aStart);
end;

procedure TmsDiagramm.BeginShape(const aStart: TPointF);
begin
 assert(CurrentClass <> nil);
 FCurrentAddedShape := CurrentClass.Create(TmsMakeShapeContext.Create(aStart, Self));
 if (FCurrentAddedShape <> nil) then
 begin
  Items.Add(FCurrentAddedShape);
  if not FCurrentAddedShape.IsNeedsSecondClick then
   // - ���� �� ���� SecondClick, �� ��� �������� - ��������
   FCurrentAddedShape := nil;
  Invalidate;
 end; // FCurrentAddedShape <> nil
end;

procedure TmsDiagramm.Clear;
begin
 if (f_Items <> nil) then
  f_Items.Clear;
 Invalidate;
end;

constructor TmsDiagramm.Create(anImage: TImage; const aName: String);
begin
 inherited Create;
 FCurrentAddedShape := nil;
 FCanvas := nil;
 FOrigin := TPointF.Create(0, 0);
 ResizeTo(anImage);
 FCurrentClass := AllowedShapes.First;
 fName := aName;
end;

procedure TmsDiagramm.ResizeTo(anImage: TImage);
begin
 if (anImage <> nil) then
 begin
  anImage.Bitmap := TBitmap.Create(Round(anImage.Width), Round(anImage.Height));
  CanvasChanged(anImage.Bitmap.Canvas);
 end;//anImage <> nil
end;

procedure TmsDiagramm.CanvasChanged(aCanvas: TCanvas);
begin
 FCanvas := aCanvas;
 Invalidate;
end;

function TmsDiagramm.CurrentAddedShape: ImsShape;
begin
 Result := FCurrentAddedShape;
end;

procedure TmsDiagramm.Assign(const anOther : TmsDiagramm);
begin
 inherited Assign(anOther);
 Self.Name := anOther.Name;
 Self.Invalidate;
end;

procedure TmsDiagramm.DeSerialize;
begin
 Clear;
 try
  TmsDiagrammMarshal.DeSerialize(Self.Name + c_FileName, Self);
 except
  on EFOpenError do
   Exit;
 end;//try..except
end;

procedure TmsDiagramm.DrawTo(const aCanvas: TCanvas; const aOrigin: TPointF);
var
 l_Shape: ImsShape;
begin
 aCanvas.BeginScene;
 try
  Assert(f_Items <> nil);
  for l_Shape in f_Items do
   l_Shape.DrawTo(TmsDrawContext.Create(aCanvas, aOrigin));
 finally
  aCanvas.EndScene;
 end; // try..finally
end;

procedure TmsDiagramm.EndShape(const aFinish: TPointF);
begin
 assert(CurrentAddedShape <> nil);
 CurrentAddedShape.EndTo(TmsEndShapeContext.Create(aFinish, Self));
 FCurrentAddedShape := nil;
 Invalidate;
end;

procedure TmsDiagramm.Invalidate;
begin
 if (FCanvas <> nil) then
 begin
  FCanvas.BeginScene;
  try
   FCanvas.Clear(TAlphaColorRec.Null);
   DrawTo(FCanvas, FOrigin);
  finally
   FCanvas.EndScene;
  end;//try..finally
 end;//FCanvas <> nil
end;

function TmsDiagramm.ShapeIsEnded: Boolean;
begin
 Result := (CurrentAddedShape = nil);
end;

function TmsDiagramm.ShapeByPt(const aPoint: TPointF): ImsShape;

begin
 Result := f_Items.ShapeByPt(aPoint);
end;

procedure TmsDiagramm.RemoveShape(const aShape: ImsShape);
begin
 Assert(f_Items <> nil);
 f_Items.Remove(aShape);
end;

function TmsShapeList.ShapeByPt(const aPoint: TPointF): ImsShape;
var
 l_Shape: ImsShape;
 l_Index: Integer;
begin
 Result := nil;
 for l_Index := Self.Count - 1 downto 0 do
 begin
  l_Shape := Self.Items[l_Index];
  if l_Shape.ContainsPt(aPoint) then
  begin
   Result := l_Shape;
   Exit;
  end; // l_Shape.ContainsPt(aPoint)
 end; // for l_Index
end;

end.
