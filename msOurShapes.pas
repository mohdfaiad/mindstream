unit msOurShapes;

interface

implementation

uses
  msLine,
  msRectangle,
  msCircle,
  msRoundedRectangle,
  msUseCaseLikeEllipse,
  msTriangle,
  msDashDotLine,
  msDashLine,
  msDotLine,
  msLineWithArrow,
  msTriangleDirectionRight,
  msRegisteredShapes,
  msRedRectangle,
  msGreenRectangle,
  msPolygonShape,

  // utility shapes
  msMover,
  msPicker,
  msUpToParent,
  msSwapParents,
  msShapeRemover,

  // special shapes
  msPointCircle,
  msSmallTriangle,
  msGreenCircle,

  // shapes for toolbar buttons
  msBlackTriangle,
  msMoverIcon,

  // SVG Shapes
  msSVG_UHO
  ;

procedure RegisterOurShapes;
begin
 TmsRegisteredShapes.Instance.Register([
  TmsLine,
  TmsRectangle,
  TmsCircle,
  TmsRoundedRectangle,
  TmsUseCaseLikeEllipse,
  TmsTriangle,
  TmsDashDotLine,
  TmsDashLine,
  TmsDotLine,
  TmsLineWithArrow,
  TmsTriangleDirectionRight,
  TmsRedRectangle,
  TmsGreenRectangle,

  // special shapes
  TmsPointCircle,
  TmsSmallTriangle,
  TmsGreenCircle,

  // utility shapes
  TmsMover,
  TmsPicker,
  TmsUpToParent,
  TmsSwapParents,
  TmsShapeRemover,

  // shapes for buttons
  TmsBlackTriangle,
  TmsMoverIcon,

  // SVG Shapes
  TmsSVG_UHO
 ]);
end;

initialization
 RegisterOurShapes;

end.
