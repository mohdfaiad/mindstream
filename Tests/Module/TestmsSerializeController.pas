unit TestmsSerializeController;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework,
  msSerializeController,
  Data.DBXJSONReflect,
  JSON,
  FMX.Objects,
  msDiagramm,
  msShape
  ;

type
  TmsDiagrammCheck = reference to procedure (aDiagramm : TmsDiagramm);
  TmsShapeClassCheck = reference to procedure (aShapeClass : RmsShape);

  TestTmsSerializeControllerPrim = class abstract(TTestCase)
  protected
    function MakeFileName(const aTestName: String; aShapeClass: RmsShape): String;
    procedure SaveDiagrammAndCheck(aShapeClass: RmsShape; aDiagramm: TmsDiagramm);
    procedure CreateDiagrammWithShapeAndSaveAndCheck(aShapeClass: RmsShape);
    procedure DeserializeDiargammAndCheck(aCheck: TmsDiagrammCheck; aShapeClass: RmsShape);
    procedure TestDeSerializeForShapeClass(aShapeClass: RmsShape);
    procedure TestDeSerializeViaShapeCheckForShapeClass(aShapeClass: RmsShape);
  end;//TestTmsSerializeControllerPrim

  TestTmsSerializeController = class abstract(TestTmsSerializeControllerPrim)
  protected
    function ShapeClass: RmsShape; virtual; abstract;
  published
    procedure TestSerialize;
    procedure TestDeSerialize;
    procedure TestDeSerializeViaShapeCheck;
  end;//TestTmsSerializeController

  TestTmsSerializeControllerForAll = class(TestTmsSerializeControllerPrim)
  protected
    procedure CheckShapes(aCheck: TmsShapeClassCheck);
  published
    procedure TestSerialize;
    procedure TestDeSerialize;
  end;//TestTmsSerializeControllerForAll

  TestSerializeTriangle = class(TestTmsSerializeController)
  protected
    function ShapeClass: RmsShape; override;
  end;//TestSerializeTriangle

  TestSerializeRectangle = class(TestTmsSerializeController)
  protected
    function ShapeClass: RmsShape; override;
  end;//TestSerializeRectangle

  TestSerializeCircle = class(TestTmsSerializeController)
  protected
    function ShapeClass: RmsShape; override;
  end;//TestSerializeCircle

  TestSerializeRoundedRectangle = class(TestTmsSerializeController)
  protected
    function ShapeClass: RmsShape; override;
  end;//TestSerializeRoundedRectangle

implementation

 uses
  System.SysUtils,
  msTriangle,
  msRectangle,
  msCircle,
  msRoundedRectangle,
  msRegisteredShapes,
  msMover,
  System.Types,
  System.Classes,
  Winapi.Windows
  ;

function TestSerializeTriangle.ShapeClass: RmsShape;
begin
 Result := TmsTriangle;
end;

function TestSerializeRectangle.ShapeClass: RmsShape;
begin
 Result := TmsRectangle;
end;

function TestSerializeCircle.ShapeClass: RmsShape;
begin
 Result := TmsCircle;
end;

function TestSerializeRoundedRectangle.ShapeClass: RmsShape;
begin
 Result := TmsRoundedRectangle;
end;

 const
  c_DiagramName = 'First Diagram';

function TestTmsSerializeControllerPrim.MakeFileName(const aTestName: String; aShapeClass: RmsShape): String;
begin
 Result := ExtractFilePath(ParamStr(0)) + ClassName + '_' + aTestName + '_' + aShapeClass.ClassName + '.json';
end;

procedure TestTmsSerializeControllerPrim.SaveDiagrammAndCheck(aShapeClass: RmsShape; aDiagramm: TmsDiagramm);
var
 l_FileSerialized, l_FileEtalon: TStringList;
 l_FileNameTest : String;
 l_FileNameEtalon : String;
begin
 l_FileNameTest := MakeFileName(Name, aShapeClass);
 TmsSerializeController.Serialize(l_FileNameTest, aDiagramm);

 l_FileNameEtalon := l_FileNameTest + '.etalon.json';
 if FileExists(l_FileNameEtalon) then
 begin
  l_FileSerialized := TStringList.Create;
  l_FileSerialized.LoadFromFile(l_FileNameTest);

  l_FileEtalon := TStringList.Create;
  l_FileEtalon.LoadFromFile(l_FileNameEtalon);

  CheckTrue(l_FileEtalon.Equals(l_FileSerialized));

  FreeAndNil(l_FileSerialized);
  FreeAndNil(l_FileEtalon);
 end
 else
 begin
  CopyFile(PWideChar(l_FileNameTest),PWideChar(l_FileNameEtalon),True);
 end;
end;

procedure TestTmsSerializeControllerPrim.CreateDiagrammWithShapeAndSaveAndCheck(aShapeClass: RmsShape);
var
 l_Diagramm: TmsDiagramm;
 l_Image: TImage;
begin
 l_Image:= TImage.Create(nil);
 try
  l_Diagramm := TmsDiagramm.Create(l_Image, c_DiagramName);
  try
   l_Diagramm.ShapeList.Add(aShapeClass.Create(TmsMakeShapeContext.Create(TPointF.Create(10, 10),nil)));
   SaveDiagrammAndCheck(aShapeClass, l_Diagramm);
  finally
   FreeAndNil(l_Image);
  end;
 finally
  FreeAndNil(l_Diagramm);
 end;//try..finally
end;

procedure TestTmsSerializeController.TestSerialize;
begin
 CreateDiagrammWithShapeAndSaveAndCheck(ShapeClass);
end;

procedure TestTmsSerializeControllerPrim.DeserializeDiargammAndCheck(aCheck: TmsDiagrammCheck; aShapeClass: RmsShape);
var
 l_Diagramm : TmsDiagramm;
 l_FileNameTest: string;
begin
 l_FileNameTest := MakeFileName('TestSerialize', aShapeClass);
 l_Diagramm := TmsSerializeController.DeSerialize(l_FileNameTest);
 try
  aCheck(l_Diagramm);
 finally
  FreeAndNil(l_Diagramm);
 end;//try..finally
end;

procedure TestTmsSerializeControllerPrim.TestDeSerializeForShapeClass(aShapeClass: RmsShape);
begin
 DeserializeDiargammAndCheck(
  procedure (aDiagramm: TmsDiagramm)
  begin
   SaveDiagrammAndCheck(aShapeClass, aDiagramm);
  end
 , aShapeClass
 );
end;

procedure TestTmsSerializeController.TestDeSerialize;
begin
 TestDeSerializeForShapeClass(ShapeClass);
end;

procedure TestTmsSerializeControllerPrim.TestDeSerializeViaShapeCheckForShapeClass(aShapeClass: RmsShape);
begin
 DeserializeDiargammAndCheck(
  procedure (aDiagramm: TmsDiagramm)
  begin
   Check(aDiagramm.ShapeList <> nil);
   Check(aDiagramm.ShapeList.Count = 1);
   Check(aDiagramm.ShapeList[0].HackInstance.ClassType = aShapeClass);
  end
 , aShapeClass
 );
end;

procedure TestTmsSerializeController.TestDeSerializeViaShapeCheck;
begin
 TestDeSerializeViaShapeCheckForShapeClass(ShapeClass);
end;

procedure TestTmsSerializeControllerForAll.CheckShapes(aCheck: TmsShapeClassCheck);
var
 l_ShapeClass : RmsShape;
begin
 for l_ShapeClass in TmsRegisteredShapes.Instance do
 begin
  if not l_ShapeClass.InheritsFrom(TmsMover) then
   aCheck(l_ShapeClass);
 end;//for l_ShapeClass
end;

procedure TestTmsSerializeControllerForAll.TestSerialize;
begin
 CheckShapes(
  procedure (aShapeClass: RmsShape)
  begin
   CreateDiagrammWithShapeAndSaveAndCheck(aShapeClass);
  end
 );
end;

procedure TestTmsSerializeControllerForAll.TestDeSerialize;
begin
 CheckShapes(
  procedure (aShapeClass: RmsShape)
  begin
   TestDeSerializeForShapeClass(aShapeClass);
  end
 );
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestSerializeTriangle.Suite);
  RegisterTest(TestSerializeRectangle.Suite);
  RegisterTest(TestSerializeCircle.Suite);
  RegisterTest(TestSerializeRoundedRectangle.Suite);
  RegisterTest(TestTmsSerializeControllerForAll.Suite);
end.

