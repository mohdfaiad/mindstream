unit ForToolbarShapesTest;
{/ - ��� "���������" �������������� ����� (https: /ru.wikipedia.org/wiki/%D0%98%D0%BD%D1%82%D0%B5%D0%B3%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D0%BE%D0%B5_%D1%82%D0%B5%D1%81%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5)}

interface

uses
  TestFrameWork
  ;

type
  TForToolbarShapesTest = class(TTestCase)
   published
    procedure ShapesRegistredCount;
    procedure TestFirstShape;
    procedure TestIndexOfTmsLine;
  end;//TForToolbarShapesTest

implementation

uses
  SysUtils,
  msShapesForToolbar,
  msShape,
  msLine,
  FMX.Objects,
  FMX.Graphics
  ;

procedure TForToolbarShapesTest.ShapesRegistredCount;
var
 l_Result : integer;
begin
 l_Result := 0;
 TmsShapesForToolbar.IterateShapes(
  procedure (aShapeClass: RmsShape)
  begin
   Assert(aShapeClass.IsForToolbar);
   Inc(l_Result);
  end
 );
 CheckTrue(l_Result = 19, ' Expected 19 - Get ' + IntToStr(l_Result));
end;

procedure TForToolbarShapesTest.TestFirstShape;
begin
 CheckTrue(TmsShapesForToolbar.Instance.First = TmsLine);
end;

procedure TForToolbarShapesTest.TestIndexOfTmsLine;
begin
 CheckTrue(TmsShapesForToolbar.Instance.IndexOf(TmsLine) = 0);
end;

initialization
 TestFramework.RegisterTest(TForToolbarShapesTest.Suite);
end.



