unit l3ByteList;
 
{$Include l3Define.inc}

interface

uses
  l3SimpleDataContainer,
  l3Types,
  l3Memory,
  l3Interfaces,
  l3Core,
  l3Except,
  Classes
  ;

type
 _ItemType_ = Byte;
 _l3AtomicList_Parent_ = Tl3SimpleDataContainer;
 {$Define l3Items_IsProto}
 {$Include l3AtomicList.imp.pas}
 Tl3ByteList = class(_l3AtomicList_)
 end;//Tl3ByteList

implementation

uses
  l3Base,
  l3MinMax,
  RTLConsts,
  SysUtils
  ;

type _Instance_R_ = Tl3ByteList;

{$Include l3AtomicList.imp.pas}

end.