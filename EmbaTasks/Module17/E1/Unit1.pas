unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    btnDoIt: TButton;
    pnlMain: TPanel;
    memMain: TMemo;
    pnlTop: TPanel;
    edtCh1: TEdit;
    edtCh2: TEdit;
    memPositiveNum: TMemo;
    memNegativeNum: TMemo;
    lblSum: TLabel;
    lblSumNum: TLabel;
    lblAvg: TLabel;
    lblAvgNum: TLabel;
    lblQuantiy: TLabel;
    lblQuantityNumPos: TLabel;
    lblMax: TLabel;
    lblMaxNum: TLabel;
    lblMin: TLabel;
    lblMinNum: TLabel;
    lblQuantityNeg: TLabel;
    lblQuantityNumNeg: TLabel;
    procedure btnDoItClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

Const
  n = 20;

Type
  array_n_elements = array [1 .. n] of integer;

procedure SetArrayRange(var ch1, ch2: integer);
begin
  ch1 := StrToInt(fmMain.edtCh1.Text);
  ch2 := StrToInt(fmMain.edtCh2.Text);
end;

procedure FillArray(var a: array_n_elements; rMin, rMax: integer);
var
  i: integer;
begin
  randomize;
  For i := 1 to n do
    a[i] := random(rMax - rMin) + rMin;
end;

procedure OutputArray(a: array_n_elements; n: integer);
var
  i: integer;
begin
  fmMain.memMain.Clear;
  for i := 0 to n - 1 do
    fmMain.memMain.Lines.Append(IntToStr(a[i + 1]));
end;

function max(a: array_n_elements): integer;
var
  i, m: integer;
begin
  m := a[1];
  for i := 1 to n do
    if a[i] > m then
      m := a[i];
  max := m;
end;

function min(a: array_n_elements): integer;
var
  i, m: integer;
begin
  m := a[1];
  for i := 1 to n do
    if a[i] < m then
      m := a[i];
  min := m;
end;

function sum(a: array_n_elements): integer;
var
  i : integer;
begin
  Result := 0;
  for i := 1 to n do
    Result := Result + a[i];
end;

procedure SplitArray(a: array_n_elements);
var
  i : Integer;
begin
  fmMain.memPositiveNum.Clear;
  fmMain.memNegativeNum.Clear;

  for i := 1 to n do
  begin
    if a[i] < 0 then
      fmMain.memNegativeNum.Lines.Append(IntToStr(a[i]))
    else
      fmMain.memPositiveNum.Lines.Append(IntToStr(a[i]));
  end;
end;

procedure GetQuantity(var AquantityPos, AquantityNeg : integer; a: array_n_elements);
var
  i : integer;
begin
  AquantityPos := 0;
  AquantityNeg := 0;

  for i := 1 to n do
    if a[i] < 0 then
      Inc(AquantityNeg)
    else
      Inc(AquantityPos)
end;

procedure TfmMain.btnDoItClick(Sender: TObject);
var
  rMin, rMax: integer;
  Amax, Amin,
  Asum,
  AquantityPos,
  AquantityNeg : integer;
  Aavg : double;
  a: array_n_elements;
begin
  SetArrayRange(rMin, rMax); //Set range of array values
  FillArray(a, rMin, rMax);  //Fill array with numbers from the specified	range
  OutputArray(a, n); //Output array
  Asum := sum(a); // Get Sum
  Aavg := Asum / n; // Get Avg
  GetQuantity(AquantityPos, AquantityNeg, a); // Get Quantity of negative and positive elements
  Amax := max(a); //Find maximal element Amax
  Amin := min(a); //Find minimal element Amin

  lblSumNum.Caption := IntToStr(ASum);
  lblAvgNum.Caption := FloatToStr(Aavg);
  lblQuantityNumPos.Caption := IntToStr(AquantityPos);
  lblQuantityNumNeg.Caption := IntToStr(AquantityNeg);
  lblMaxNum.Caption := IntToStr(Amax);
  lblMinNum.Caption := IntToStr(Amin);

  SplitArray(a);
end;
end.