unit kwLeftWordRefParam;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ���������� "ScriptEngine$Core"
// ������: "kwLeftWordRefParam.pas"
// ������ Delphi ���������� (.pas)
// Generated from UML model, root element: SimpleClass::Class Shared Delphi Low Level::ScriptEngine$Core::CompiledWords::TkwLeftWordRefParam
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

{$Include ..\ScriptEngine\seDefine.inc}

interface

{$If not defined(NoScripts)}
uses
  kwLeftParam,
  tfwScriptingInterfaces
  ;
{$IfEnd} //not NoScripts

{$If not defined(NoScripts)}
type
 TkwLeftWordRefParam = class(TkwLeftParam)
 public
 // overridden public methods
   function IsLeftWordRefParam(const aCtx: TtfwContext): Boolean; override;
 end;//TkwLeftWordRefParam
{$IfEnd} //not NoScripts

implementation

{$If not defined(NoScripts)}

// start class TkwLeftWordRefParam

function TkwLeftWordRefParam.IsLeftWordRefParam(const aCtx: TtfwContext): Boolean;
//#UC START# *53E389100169_53E377040339_var*
//#UC END# *53E389100169_53E377040339_var*
begin
//#UC START# *53E389100169_53E377040339_impl*
 Result := true;
//#UC END# *53E389100169_53E377040339_impl*
end;//TkwLeftWordRefParam.IsLeftWordRefParam

{$IfEnd} //not NoScripts

initialization
{$If not defined(NoScripts)}
// ����������� TkwLeftWordRefParam
 TkwLeftWordRefParam.RegisterClass;
{$IfEnd} //not NoScripts

end.