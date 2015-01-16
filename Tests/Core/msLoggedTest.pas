unit msLoggedTest;

interface

uses
 TestFramework,
 msCoreObjects
 ;

type
  TmsLoggedTest = class abstract(TTestCase)
  protected
    procedure OutToFileAndCheck(aLambda: TmsLogLambda);
    function TestResultsFileName: String; virtual;
    function MakeFileName(const aTestName: string; const aTestFolder: string): String; virtual;
    function ContextName: String; virtual;
    procedure CheckFileWithEtalon(const aFileName: String);
    function InnerFolders: String; virtual;
  end;//TmsLoggedTest

implementation

uses
 SysUtils,
 msStreamUtils,
 Windows
 ;

// TmsLoggedTest

function TmsLoggedTest.MakeFileName(const aTestName: string; const aTestFolder: string): String;
var
 l_Folder : String;
begin
 l_Folder := ExtractFilePath(ParamStr(0)) + 'TestResults\' + aTestFolder;
 ForceDirectories(l_Folder);
 Result := l_Folder + ClassName + '_' + aTestName + ContextName;
end;

function TmsLoggedTest.ContextName: String;
begin
 Result := '';
end;

procedure TmsLoggedTest.CheckFileWithEtalon(const aFileName: String);
var
 l_FileNameEtalon : String;
begin
 l_FileNameEtalon := aFileName + '.etalon' + ExtractFileExt(aFileName);
 if FileExists(l_FileNameEtalon) then
 begin
  CheckTrue(msCompareFiles(l_FileNameEtalon, aFileName));
 end//FileExists(l_FileNameEtalon)
 else
 begin
  CopyFile(PWideChar(aFileName),PWideChar(l_FileNameEtalon),True);
 end;//FileExists(l_FileNameEtalon)
end;

function TmsLoggedTest.TestResultsFileName: String;
begin
 Result := MakeFileName(Name, InnerFolders);
end;

function TmsLoggedTest.InnerFolders: String;
begin
 Result := '';
end;

procedure TmsLoggedTest.OutToFileAndCheck(aLambda: TmsLogLambda);
var
 l_FileNameTest : String;
begin
 l_FileNameTest := TestResultsFileName;
 TmsLog.Log(l_FileNameTest,
  procedure (aLog: TmsLog)
  begin
   aLambda(aLog);
  end
 );
 CheckFileWithEtalon(l_FileNameTest);
end;

end.
