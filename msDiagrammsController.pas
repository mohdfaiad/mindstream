﻿unit msDiagrammsController;

interface

uses
{$Include msIvalidator.mixin.pas}
  ,
 FMX.Objects,
 FMX.ListBox,
 FMX.StdCtrls,
 FMX.Graphics,
 msDiagramms,
 System.Types,
 FMX.Forms,
 System.Classes,
 System.UITypes,
 msCoreObjects,
 msInterfacedRefcounted,
 msShape,
 msInterfaces,
 msDiagrammStack
 ;

type
 TmsIvalidatorParent = TmsInterfacedRefcounted;
{$Include msIvalidator.mixin.pas}

 TmsDiagrammsController = class(TmsIvalidator, ImsDiagrammsController)
 private
  imgMain: TPaintBox;
  cbShapes: TComboBox;
  cbDiagramm: TComboBox;
  btAddDiagramm: TButton;
  btSaveDiagramm: TButton;
  btLoadDiagramm: TButton;
  btSaveToPNG: TButton;
  f_DiagrammsRoot: ImsDiagramms;
  f_CurrentDiagramms : ImsDiagrammsList;
  f_CurrentDiagramm : ImsDiagramm;
  f_DiagrammStack: TmsDiagrammStack;
  f_Delta: TPointF;
  procedure cbDiagrammChange(Sender: TObject);
  procedure btAddDiagrammClick(Sender: TObject);
  procedure imgMainMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  procedure imgMainMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  procedure imgMainMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
  procedure imgMainMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
  procedure btSaveToPNGClick(Sender: TObject);
  procedure btSaveDiagrammClick(Sender: TObject);
  procedure btLoadDiagrammClick(Sender: TObject);
  function pm_GetCurrentDiagramm: ImsDiagramm;
  procedure pm_SetCurrentDiagramm(const aValue: ImsDiagramm);
  function pm_GetCurrentDiagramms: ImsDiagrammsList;
  procedure pm_SetCurrentDiagramms(const aValue: ImsDiagrammsList);
  procedure UpToParent;
  // - сигнализируем о том, что нам надо перейти к РОДИТЕЛЬСКОЙ диаграмме
  procedure SwapParents;
  // - сигнализируем о том, что надо ПОМЕНЯТЬ местами РОДИТЕЛЬСКИЕ диаграммы
  procedure Scroll(aDirection: TPointF);
  // - скроллинг диаграммы
  procedure ResetOrigin;
  // - восстанавливаем начальную систему координат
  procedure MouseUp(const aPoint: TPointF);
  procedure MouseMove(const aShift: TShiftState; const aClickContext: TmsClickContext);
 protected
  procedure DoInvalidateDiagramm(const aDiagramm: ImsDiagramm); override;
  procedure DoDiagrammAdded(const aDiagramms: ImsDiagrammsList; const aDiagramm: ImsDiagramm); override;
  property CurrentDiagramms: ImsDiagrammsList
   read pm_GetCurrentDiagramms
   write pm_SetCurrentDiagramms;
  constructor CreatePrim(aImage: TPaintBox;
                         aShapes: TComboBox;
                         aDiagramm: TComboBox;
                         aAddDiagramm: TButton;
                         aSaveDiagramm: TButton;
                         aLoadDiagramm: TButton;
                         aSaveToPng: TButton);
 public
  class function Create(aImage: TPaintBox;
                        aShapes: TComboBox;
                        aDiagramm: TComboBox;
                        aAddDiagramm: TButton;
                        aSaveDiagramm: TButton;
                        aLoadDiagramm: TButton;
                        aSaveToPng: TButton): ImsDiagrammsController;
  procedure Cleanup; override;
  procedure Clear;
  procedure ProcessClick(const aStart: TPointF);
  property CurrentDiagramm: ImsDiagramm
   read pm_GetCurrentDiagramm
   write pm_SetCurrentDiagramm;

  procedure SaveToPng(const aFileName: string);
  procedure DrawTo(const aCanvas: TCanvas);
  function As_ImsDiagrammsHolder: ImsDiagrammsHolder;
 end; // TmsDiagrammsController

implementation

uses
{$Include msIvalidator.mixin.pas}
  ,
 System.SysUtils,
 FMX.Types,
 msShapesForToolbar,
 Math,
 msShapeCreator,
 FMX.Dialogs,
 System.Math.Vectors;

type
 TmsDiagrammsHolder = class(TmsInterfacedRefcounted, ImsDiagrammsHolder)
 private
  f_DiagrammsController: TmsDiagrammsController;
  constructor CreatePrim(aDiagrammsController: TmsDiagrammsController);
 protected
  procedure UpToParent;
  // - сигнализируем о том, что нам надо перейти к РОДИТЕЛЬСКОЙ диаграмме
  procedure SwapParents;
  // - сигнализируем о том, что надо ПОМЕНЯТЬ местами РОДИТЕЛЬСКИЕ диаграммы
  procedure Scroll(aDirection: TPointF);
  // - скроллинг диаграммы
  procedure ResetOrigin;
  // - восстанавливаем начальную систему координат
  function pm_GetCurrentDiagramms: ImsDiagrammsList;
  procedure pm_SetCurrentDiagramms(const aValue: ImsDiagrammsList);
 public
  class function Create(aDiagrammsController: TmsDiagrammsController): ImsDiagrammsHolder;
 end; // TmsDiagrammsHolder

constructor TmsDiagrammsHolder.CreatePrim(aDiagrammsController: TmsDiagrammsController);
begin
 inherited Create;
 f_DiagrammsController := aDiagrammsController;
end;

class function TmsDiagrammsHolder.Create(aDiagrammsController: TmsDiagrammsController): ImsDiagrammsHolder;
begin
 Result := CreatePrim(aDiagrammsController);
end;

function TmsDiagrammsHolder.pm_GetCurrentDiagramms: ImsDiagrammsList;
begin
 Result := f_DiagrammsController.CurrentDiagramms;
end;

procedure TmsDiagrammsHolder.pm_SetCurrentDiagramms(const aValue: ImsDiagrammsList);
begin
 f_DiagrammsController.CurrentDiagramms := aValue;
end;

procedure TmsDiagrammsHolder.ResetOrigin;
begin
 f_DiagrammsController.ResetOrigin;
end;

procedure TmsDiagrammsHolder.UpToParent;
// - сигнализируем о том, что нам надо перейти к РОДИТЕЛЬСКОЙ диаграмме
begin
 f_DiagrammsController.UpToParent;
end;

procedure TmsDiagrammsHolder.Scroll(aDirection: TPointF);
// - скроллинг диаграммы
begin
 f_DiagrammsController.Scroll(aDirection);
end;

procedure TmsDiagrammsHolder.SwapParents;
// - сигнализируем о том, что надо ПОМЕНЯТЬ местами РОДИТЕЛЬСКИЕ диаграммы
begin
 f_DiagrammsController.SwapParents;
end;

{$Include msIvalidator.mixin.pas}
// TmsDiagrammsController

constructor TmsDiagrammsController.CreatePrim(aImage: TPaintBox; aShapes: TComboBox; aDiagramm: TComboBox; aAddDiagramm: TButton;
  aSaveDiagramm: TButton; aLoadDiagramm: TButton; aSaveToPng: TButton);
begin
 inherited Create;
 imgMain := aImage;
 cbShapes := aShapes;
 cbDiagramm := aDiagramm;
 btAddDiagramm := aAddDiagramm;
 btSaveDiagramm := aSaveDiagramm;
 btLoadDiagramm := aLoadDiagramm;
 btSaveToPNG := aSaveToPng;
 btSaveToPNG.OnClick := btSaveToPNGClick;
 cbDiagramm.OnChange := cbDiagrammChange;
 btAddDiagramm.OnClick := btAddDiagrammClick;
 btSaveDiagramm.OnClick := btSaveDiagrammClick;
 btLoadDiagramm.OnClick := btLoadDiagrammClick;
 imgMain.OnMouseDown := imgMainMouseDown;
 imgMain.OnMouseWheel := imgMainMouseWheel;
 imgMain.OnMouseUp := imgMainMouseUp;
 imgMain.OnMouseMove := imgMainMouseMove;
 imgMain.Align := TAlignLayout.Client;
 f_DiagrammsRoot := TmsDiagramms.Create;
 CurrentDiagramms := f_DiagrammsRoot;
 CurrentDiagramms.AddNewDiagramm;
end;

class function TmsDiagrammsController.Create(aImage: TPaintBox; aShapes: TComboBox; aDiagramm: TComboBox; aAddDiagramm: TButton;
  aSaveDiagramm: TButton; aLoadDiagramm: TButton; aSaveToPng: TButton): ImsDiagrammsController;
begin
 Result := CreatePrim(aImage, aShapes, aDiagramm, aAddDiagramm, aSaveDiagramm, aLoadDiagramm, aSaveToPng);
end;

procedure TmsDiagrammsController.DoInvalidateDiagramm(const aDiagramm: ImsDiagramm);
begin
 if (imgMain <> nil) then
  if (aDiagramm.EQ(CurrentDiagramm)) then
   imgMain.Repaint;
end;

function TmsDiagrammsController.pm_GetCurrentDiagramm: ImsDiagramm;
begin
 Result := f_CurrentDiagramm;
end;

procedure TmsDiagrammsController.pm_SetCurrentDiagramm(const aValue: ImsDiagramm);
begin
 if (aValue = nil) OR not aValue.EQ(f_CurrentDiagramm) then
 begin
  f_CurrentDiagramm := aValue;
  if (aValue <> nil) then
  begin
   cbDiagramm.OnChange := nil;
   cbDiagramm.ItemIndex := cbDiagramm.Items.IndexOf(aValue.Name);
   cbDiagramm.OnChange := cbDiagrammChange;
  end; // aValue <> nil
  if (f_CurrentDiagramm <> nil) then
   f_CurrentDiagramm.Invalidate;
 end; // not aValue.EQ(f_CurrentDiagramm)
end;

function TmsDiagrammsController.pm_GetCurrentDiagramms: ImsDiagrammsList;
begin
 Result := f_CurrentDiagramms;
end;

procedure TmsDiagrammsController.pm_SetCurrentDiagramms(const aValue: ImsDiagrammsList);
var
 l_Index: Integer;
begin
 if (f_CurrentDiagramms <> aValue) then
 begin
  if (f_CurrentDiagramms <> nil) then
  begin
   if (CurrentDiagramm <> nil) then
   begin
    if (f_DiagrammStack = nil) then
     f_DiagrammStack := TmsDiagrammStack.Create;
    f_DiagrammStack.Push(TmsCurrentDiagrammRec.Create(f_CurrentDiagramms, CurrentDiagramm));
   end;//CurrentDiagramm <> nil
  end;//f_CurrentDiagramms <> nil
  f_CurrentDiagramms := aValue;
  l_Index := cbShapes.ItemIndex;
  cbShapes.Items.Clear;
  cbDiagramm.Items.Clear;
  if (f_CurrentDiagramms = nil) then
   CurrentDiagramm := nil
  else
  begin
   f_CurrentDiagramms.ShapesForToolbarToList(cbShapes.Items);
   f_CurrentDiagramms.DiagrammsForToolbarToList(cbDiagramm.Items);
   CurrentDiagramm := f_CurrentDiagramms.FirstDiagramm;
   if (l_Index < 0) then
    if (cbShapes.Count > 0) then
     l_Index := 0;
   cbShapes.ItemIndex := Min(cbShapes.Count - 1, l_Index);
  end; // f_CurrentDiagramms <> nil
 end; // f_CurrentDiagramms <> aValue
end;

procedure TmsDiagrammsController.btLoadDiagrammClick(Sender: TObject);
var
 l_I : Integer;
 l_RootWasChanged : Boolean;
begin
 l_RootWasChanged := false;
 l_I := cbDiagramm.ItemIndex;
 if (f_DiagrammStack <> nil) then
  f_DiagrammStack.Clear;
 f_DiagrammsRoot.DeSerialize;
 cbDiagramm.Clear;
 Assert(f_DiagrammsRoot <> nil);
 if not f_DiagrammsRoot.EQ(CurrentDiagramms) then
 begin
  CurrentDiagramms := f_DiagrammsRoot;
  l_RootWasChanged := true;
 end;//not f_DiagrammsRoot.EQ(CurrentDiagramms)
 Assert(f_DiagrammsRoot.EQ(CurrentDiagramms));
 if not l_RootWasChanged then
  f_DiagrammsRoot.DiagrammsForToolbarToList(cbDiagramm.Items);
 Assert(f_DiagrammsRoot.FirstDiagramm <> nil);
 if l_RootWasChanged then
 begin
  CurrentDiagramm := f_DiagrammsRoot.FirstDiagramm;
  Exit;
 end;//l_RootWasChanged
 Assert(cbDiagramm.Items.Count > 0);
 Assert(l_I >= 0);
 Assert(l_I < cbDiagramm.Items.Count);
 cbDiagramm.ItemIndex := l_I;
end;

procedure TmsDiagrammsController.btSaveDiagrammClick(Sender: TObject);
begin
 f_DiagrammsRoot.Serialize;
end;

procedure TmsDiagrammsController.btSaveToPNGClick(Sender: TObject);
var
 l_SaveDialog: TSaveDialog;
begin
 l_SaveDialog := TSaveDialog.Create(nil);
 l_SaveDialog.Filter := 'PNG (*.png)|*.PNG';
 try
  l_SaveDialog.Execute;
  try
   SaveToPng(l_SaveDialog.FileName + '.png');
  except
   on E: Exception do
    ShowMessage('Произошла ошибка при сохранении картинки');
  end;

 finally
  FreeAndNil(l_SaveDialog);
 end;
end;

procedure TmsDiagrammsController.cbDiagrammChange(Sender: TObject);
begin
 Assert(CurrentDiagramms <> nil);
 CurrentDiagramm := CurrentDiagramms.SelectDiagramm(cbDiagramm.Items[cbDiagramm.ItemIndex]);
 Assert(CurrentDiagramm <> nil);
 CurrentDiagramm.Invalidate;
end;

procedure TmsDiagrammsController.btAddDiagrammClick(Sender: TObject);
begin
 CurrentDiagramms.AddNewDiagramm;
end;

procedure TmsDiagrammsController.Cleanup;
begin
 FreeAndNil(f_DiagrammStack);
 f_CurrentDiagramm := nil;
 CurrentDiagramms := nil;
 f_DiagrammsRoot := nil;
 inherited;
end;

procedure TmsDiagrammsController.Clear;
begin
 CurrentDiagramm.Clear;
end;

procedure TmsDiagrammsController.ProcessClick(const aStart: TPointF);
begin
 CurrentDiagramm.ProcessClick(TmsClickContext.Create(TmsShapesForToolbar.Instance.ByName(cbShapes.Items[cbShapes.ItemIndex]).Creator, aStart,
   Self.As_ImsDiagrammsHolder));
end;

procedure TmsDiagrammsController.ResetOrigin;
begin
 f_Delta := TPointF.Create(0, 0);
 CurrentDiagramm.Invalidate;
end;

procedure TmsDiagrammsController.SaveToPng(const aFileName: string);
begin
 f_CurrentDiagramm.SaveToPng(aFileName);
end;

procedure TmsDiagrammsController.DrawTo(const aCanvas: TCanvas);
var
 l_OriginalMatrix: TMatrix;
 l_Matrix: TMatrix;
 l_CenterPoint: TPointF;
begin
 aCanvas.BeginScene;
 l_OriginalMatrix := aCanvas.Matrix;
 l_CenterPoint := TPointF.Create(0,0);

  l_Matrix := TMatrix.Identity;
  // - СНИМАЕМ оригинальную матрицу, точнее берём ЕДИНИЧНУЮ матрицу
  // https://ru.wikipedia.org/wiki/%D0%95%D0%B4%D0%B8%D0%BD%D0%B8%D1%87%D0%BD%D0%B0%D1%8F_%D0%BC%D0%B0%D1%82%D1%80%D0%B8%D1%86%D0%B0
  l_Matrix := l_Matrix * TMatrix.CreateTranslation(-l_CenterPoint.X, -l_CenterPoint.Y);
  // - сдвигаем начало координат для фигуры
  l_Matrix := l_Matrix * TMatrix.CreateTranslation(f_Delta.X, f_Delta.Y);
  // - задаём начало координат - относительно дельты
  l_Matrix := l_Matrix * TMatrix.CreateTranslation(l_CenterPoint.X,l_CenterPoint.Y);
  // - задаём начало координат
  l_Matrix := l_Matrix * l_OriginalMatrix;
  // - ПРИМЕНЯЕМ оригинальную матрицу
  // Иначе например ОРИГИНАЛЬНЫЙ параллельный перенос - не будет работать.
  // https://ru.wikipedia.org/wiki/%D0%9F%D0%B0%D1%80%D0%B0%D0%BB%D0%BB%D0%B5%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9_%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81
 aCanvas.SetMatrix(l_Matrix);
 CurrentDiagramm.DrawTo(aCanvas);
 // - отрисовываем примитив с учётом матрицы преобразований
  aCanvas.SetMatrix(l_OriginalMatrix);
  // - восстанавливаем ОРИГИНАЛЬНУЮ матрицу
  aCanvas.EndScene;
end;

function TmsDiagrammsController.As_ImsDiagrammsHolder: ImsDiagrammsHolder;
begin
 Result := TmsDiagrammsHolder.Create(Self);
end;

procedure TmsDiagrammsController.imgMainMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
 Self.ProcessClick(TPointF.Create(X, Y));
end;


procedure TmsDiagrammsController.imgMainMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
 Self.MouseMove(Shift, TmsClickContext.Create(nil, TPointF.Create(X, Y), Self.As_ImsDiagrammsHolder));
end;

procedure TmsDiagrammsController.imgMainMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
 Self.MouseUp(TPointF.Create(X, Y));
end;

procedure TmsDiagrammsController.imgMainMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
const
 cWheelDeltaSpeed = 120;
var
 l_Delta : integer;
begin
 l_Delta := WheelDelta div cWheelDeltaSpeed * 3;
 Scroll(TPointF.Create(0, l_Delta));
end;

procedure TmsDiagrammsController.MouseMove(const aShift: TShiftState; const aClickContext: TmsClickContext);
begin
 CurrentDiagramm.MouseMove(aShift, aClickContext);
end;

procedure TmsDiagrammsController.MouseUp(const aPoint: TPointF);
begin
 CurrentDiagramm.MouseUp(TmsClickContext.Create(TmsShapesForToolbar.Instance.ByName(cbShapes.Items[cbShapes.ItemIndex]).Creator,
                         aPoint,
                         Self.As_ImsDiagrammsHolder));
end;

procedure TmsDiagrammsController.DoDiagrammAdded(const aDiagramms: ImsDiagrammsList; const aDiagramm: ImsDiagramm);
begin
 Assert(CurrentDiagramms <> nil);
 if not CurrentDiagramms.EQ(aDiagramms) then
  Exit;
 if (CurrentDiagramms <> nil) then
 begin
  if (CurrentDiagramms.IndexOf(aDiagramm) >= 0) then
  begin
   cbDiagramm.Items.Add(aDiagramm.Name);
   CurrentDiagramm := aDiagramm;
  end; // CurrentDiagramms.IndexOf(aDiagramm) >= 0
 end; // CurrentDiagramms <> nil
end;

procedure TmsDiagrammsController.UpToParent;
// - сигнализируем о том, что нам надо перейти к РОДИТЕЛЬСКОЙ диаграмме
var
 l_Prev : TmsCurrentDiagrammRec;
 l_Count : Integer;
begin
 if (f_DiagrammStack = nil) then
  Exit;
 if (f_DiagrammStack.Count <= 0) then
  Exit;
 l_Prev := f_DiagrammStack.Pop;
 l_Count := f_DiagrammStack.Count;
 CurrentDiagramms := l_Prev.rDiagramms;
 CurrentDiagramm := l_Prev.rDiagramm;
 while (l_Count < f_DiagrammStack.Count) do
  f_DiagrammStack.Pop;
end;

procedure TmsDiagrammsController.SwapParents;
// - сигнализируем о том, что надо ПОМЕНЯТЬ местами РОДИТЕЛЬСКИЕ диаграммы
var
 l_Prev : TmsCurrentDiagrammRec;
// l_Count : Integer;
begin
 if (f_DiagrammStack = nil) then
  Exit;
 if (f_DiagrammStack.Count <= 0) then
  Exit;
 l_Prev := f_DiagrammStack.Pop;
// l_Count := f_DiagrammStack.Count;
 CurrentDiagramms := l_Prev.rDiagramms;
 CurrentDiagramm := l_Prev.rDiagramm;
(* while (l_Count < f_DiagrammStack.Count) do
  f_DiagrammStack.Pop;
 f_DiagrammStack.Push(l_Prev);*)
end;

procedure TmsDiagrammsController.Scroll(aDirection: TPointF);
begin
 f_Delta := aDirection + f_Delta;
 CurrentDiagramm.Invalidate;
end;

end.
