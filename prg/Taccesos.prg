#include "FiveWin.Ch"
#include "Factu.ch" 

#define RB_SETBKCOLOR   (WM_USER +  19) // sets the default BK color

//----------------------------------------------------------------------------//

CLASS TAcceso

   DATA  cDbf
   DATA  lOpenFiles        INIT  .f.

   DATA  oBmpLogo

   DATA  oImageList
   DATA  oImageListBig

   DATA  oTree
   DATA  oReBar
   DATA  oToolBar
   DATA  oSearchBar
   DATA  oOfficeBar
   DATA  oFavoritosBar
   DATA  oFavoritosGroup

   DATA  oGet
   DATA  cGet              INIT  Space( 200 )

   DATA  oComboBox
   DATA  cComboBox
   DATA  aComboBox         INIT  {}

   DATA  oComboFilter
   DATA  cComboFilter      INIT  __txtFilters__
   DATA  aComboFilter      INIT  {__txtFilters__}

   DATA  oYearComboBox
   DATA  cYearComboBox     INIT  "[Todos]"
   DATA  aYearComboBox     INIT  {}
   DATA  lYearComboBox     INIT  .t.

   DATA  oButtonFilter
   DATA  oButtonAddFilter
   DATA  oButtonEditFilter

   DATA  aAccesos

   DATA  lBig              INIT  .f.
   DATA  lTactil           INIT  .f.

   DATA  aStruct           INIT  {  { "cCodUse",   "C",  3,  0, "" },;
                                    { "cOpcion",   "C", 20,  0, "" },;
                                    { "lShow",     "L",  1,  0, "" } }

   DATA  nLittleButtons

   DATA  l2k9              INIT .t.

   Method New()

   Method Add()

   Method CreateImageList()
   Method AddImageList( aAccesos )
   Method SetImageList()

   Method CreateTree()
   Method AddTree( cPrompt, nImage, Cargo )

   Method AddBitmapMasked( oAcceso )

   Method EditButtonBar()
   Method InitButtonBar()

   Method Save()
   Method SaveTree( oItem, cCurUsr, cDbf )

   Method Load()
   Method LoadTree( oItem, cOpcion, lShow )
   Method DeleteTree()
   Method Default()                       INLINE ( if( ::lOpenDatabase(), ( ::DeleteTree(), ::oTree:DeleteAll(), ::CloseDatabase(), ::CreateTree() ), ) )

   Method MakeDatabase( cPath, oMeter )
   Method ReindexDatabase( cPath, oMeter )

   Method lOpenDatabase()
   Method CloseDatabase()

   Method CreateButtonBar( oWnd )

   Method CreateFavoritosOfficeBar()

   Method CreateToolbar( aAccesos )
   Method AddToolBar( oToolBar, oAcceso )

   Method lGetShowToolBar( oAcceso, cCurUsr )

   Method lHideCarpeta( oAcceso, cCurUsr )

   Method CreateSearchBar()
   Method EndSearchBar()
   Method HideSearchBar()                 INLINE ( ::HideGet(), ::HideComboBox(), ::HideComboFilter(), ::HideButtonFilter(), ::HideAddButtonFilter(), ::HideEditButtonFilter(), ::HideYearComboBox() )

   Method InsertSearchBand()              INLINE ( ::oReBar:InsertBand( ::oSearchBar, "Buscar " ) )
   Method DeleteSearchBand()              INLINE ( ::oReBar:DeleteBand(), ::oSearchBar := nil )

   Method CreateLogo( oWnd )

   Method InsertToolBand()                INLINE ( ::oReBar:InsertBand( ::oToolBar ) )
   Method DeleteToolBand()                INLINE ( ::oReBar:DeleteBand(), ::oToolBar := nil )

   Method CreateOfficeBar()
   Method ReCreateOfficeBar()
   Method InsertOfficeBand()              INLINE ( ::oReBar:InsertBand( ::oOfficeBar ) )

   Method CreateCarpetaOfficeBar( aAccesos )
   Method CreateBotonesOfficeBar( aAcceso, oCarpeta, oGrupo )

   Method SetComboBoxItems( aItems )      INLINE ( if( !empty( ::oComboBox ), ::oComboBox:SetItems( aItems ), ) )
   Method SetComboBoxSelect( nItems )     INLINE ( if( !empty( ::oComboBox ), ( ::oGet:cText( Space( 200 ) ), ::oGet:oGet:Home(), ::oComboBox:Select( nItems ) ), ) )
   Method SetComboBoxSet( cItem )         INLINE ( if( !empty( ::oComboBox ), ( ::oComboBox:Set( cItem ) ), ) )
   Method SetComboBoxChange( bBlock )     INLINE ( if( !empty( ::oComboBox ), ( ::oComboBox:bChange := bBlock ), ) )
   Method GetComboBox()                   INLINE ( if( !empty( ::oComboBox ), ( ::oComboBox:VarGet() ), "" ) )
   Method GetComboBoxAt()                 INLINE ( if( !empty( ::oComboBox ), ( ::oComboBox:nAt ), 0 ) )

   Method DisableComboBox()               INLINE ( if( !empty( ::oComboBox ), ( ::SetComboBoxItems( {} ), ::oComboBox:Hide() ), ) )
   Method EnableComboBox( aItems )        INLINE ( if( !empty( ::oComboBox ) .and. IsArray( aItems ), ( ::SetComboBoxItems( aItems ), ::oComboBox:Show(), ::oComboBox:Enable() ), ) )
   Method HideComboBox()                  INLINE ( if( !empty( ::oComboBox ), ::oComboBox:Hide(), ) )

   Method setComboFilterItems( aItems )   INLINE ( if( !empty( ::oComboFilter ), ::oComboFilter:SetItems( aItems ), ) )
   Method setComboFilterSelect( nItems )  INLINE ( if( !empty( ::oComboFilter ), ( ::oGet:cText( Space( 200 ) ), ::oGet:oGet:Home(), ::oComboFilter:Select( nItems ) ), ) )
   Method setComboFilterSet( cItem )      INLINE ( if( !empty( ::oComboFilter ), ( ::oComboFilter:Set( cItem ) ), ) )
   Method setComboFilterChange( bBlock )  INLINE ( if( !empty( ::oComboFilter ), ( ::oComboFilter:bChange := bBlock ), ) )
   Method getComboFilter()                INLINE ( if( !empty( ::oComboFilter ), ( ::oComboFilter:VarGet() ), "" ) )
   Method getComboFilterAt()              INLINE ( if( !empty( ::oComboFilter ), ( ::oComboFilter:nAt ), 0 ) )
   Method hideComboFilter()               INLINE ( if( !empty( ::oComboFilter ), ::oComboFilter:Hide(), ) )

   Method DisableComboFilter()            INLINE ( if( !empty( ::oComboFilter ), ( ::SetComboFilterItems( {} ), ::oComboFilter:Hide() ), ) )
   Method EnableComboFilter( aItems )
   Method SetDefaultComboFilter()         INLINE ( if( !empty( ::oComboFilter ), ::oComboFilter:Set( __txtFilters__ ), ) )
   Method SetComboFilter( cItem )         INLINE ( if( !empty( ::oComboFilter ) .and. !empty( cItem ), ( ::oComboFilter:Set( cItem ), Eval( ::oComboFilter:bChange ) ), ) )

   Method SetGetChange( bBlock )          INLINE ( if( !empty( ::oGet ), ( ::oGet:bChange       := bBlock ), ) )
   Method SetGetPostKey( bBlock )         INLINE ( if( !empty( ::oGet ), ( ::oGet:bPostKey      := bBlock ), ) )
   Method SetGetValid( bBlock )           INLINE ( if( !empty( ::oGet ), ( ::oGet:bValid        := bBlock ), ) )
   Method SetGetLostFocus( bBlock )       INLINE ( if( !empty( ::oGet ), ( ::oGet:bLostFocus    := bBlock ), ) )
   Method SetGetKeyDown( bBlock )         INLINE ( if( !empty( ::oGet ), ( ::oGet:bKeyDown      := bBlock ), ) )
   Method SetGetKeyChar( bBlock )         INLINE ( if( !empty( ::oGet ), ( ::oGet:bKeyChar      := bBlock ), ) )
   Method SetGetKeyUp( bBlock )           INLINE ( if( !empty( ::oGet ), ( ::oGet:bKeyUp        := bBlock ), ) )

   Method DisableGet()                    INLINE ( if( !empty( ::oGet ), ( ::oGet:cText( Space( 200 ) ), ::oGet:Hide(), ::oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ) ), ) )
   Method EnableGet()                     INLINE ( if( !empty( ::oGet ), ( ::oGet:Enable(), ::oGet:Show(), ::oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ) ), ) )
   Method CleanGet()                      INLINE ( if( !empty( ::oGet ), ( ::oGet:cText( Space( 200 ) ), ::oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ) ), ) )
   Method SetGetFocus()                   INLINE ( if( !empty( ::oGet ), ::oGet:SetFocus(), ) )
   Method HideGet()                       INLINE ( if( !empty( ::oGet ), ::oGet:Hide(), ) )

   Method ShowButtonFilter()              INLINE ( if( !empty( ::oButtonFilter ), ::oButtonFilter:Show(), ) )
   Method HideButtonFilter()              INLINE ( if( !empty( ::oButtonFilter ), ::oButtonFilter:Hide(), ), if( !empty( ::oComboFilter ), ::oComboFilter:Select( 1 ), ) )
   Method SetKillFilter( bBlock )         INLINE ( if( !empty( ::oButtonFilter ), ( ::oButtonFilter:bAction := bBlock ), ) )

   Method ShowAddButtonFilter()           INLINE ( if( !empty( ::oButtonAddFilter ), ::oButtonAddFilter:Show(), ) )
   Method HideAddButtonFilter()           INLINE ( if( !empty( ::oButtonAddFilter ), ::oButtonAddFilter:Hide(), ) )
   Method SetAddButtonFilter( bAction )   INLINE ( if( !empty( ::oButtonAddFilter ), ( ::oButtonAddFilter:bAction := bAction ), ) )

   Method ShowEditButtonFilter()          INLINE ( if( !empty( ::oButtonEditFilter ), ::oButtonEditFilter:Show(), ) )
   Method HideEditButtonFilter()          INLINE ( if( !empty( ::oButtonEditFilter ), ::oButtonEditFilter:Hide(), ) )
   Method SetEditButtonFilter( bAction )  INLINE ( if( !empty( ::oButtonEditFilter ), ( ::oButtonEditFilter:bAction := bAction ), ) )

   Method ShowYearComboBox()              INLINE ( if( !empty( ::oYearComboBox ), ( ::lYearComboBox := .t., ::oYearComboBox:Show(), ::oYearComboBox:Set( 1 ) ), ) )
   Method HideYearComboBox()              INLINE ( if( !empty( ::oYearComboBox ), ( ::lYearComboBox := .f., ::oYearComboBox:Hide() ), ) )
   Method lAllYearComboBox()              INLINE ( if( !empty( ::oYearComboBox ), ( ::oYearComboBox:nAt == 1 ), .f. ) )
   Method cYearComboBox()                 INLINE ( if( !empty( ::oYearComboBox ), ( ::oYearComboBox:VarGet() ), "" ) )
   Method nYearComboBox()                 INLINE ( if( !empty( ::oYearComboBox ), ( Val( ::oYearComboBox:VarGet() ) ), 0 ) )
   Method SetYearComboBoxChange( bBlock ) INLINE ( if( !empty( ::oYearComboBox ), ( ::oYearComboBox:bChange  := bBlock ), ) )

   Method Disable()                       INLINE ( CursorWait(),  if( !empty( ::oOfficeBar ), ( ::oOfficeBar:Disable(), SysRefresh() ), ) )
   Method Enable()                        INLINE ( CursorWE(),    if( !empty( ::oOfficeBar ), ( ::oOfficeBar:Enable(), SysRefresh() ), ) )

   Method End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TAcceso

   local n
   local nSize

   ::aAccesos        := {}
   ::cGet            := Space( 200 )
   ::cYearComboBox   := "[Todos]"

   /*
   Rellenamos los años---------------------------------------------------------
   */

   aAdd( ::aYearComboBox, "[Todos]" )
   for n := 2000 to Year( Date() )
      aAdd( ::aYearComboBox, Str( n, 4 ) )
   next

return Self

//----------------------------------------------------------------------------//

METHOD Add() CLASS TAcceso

   local oAcceso  := TItemAcceso():New()

   aAdd( ::aAccesos, oAcceso )

return oAcceso

//----------------------------------------------------------------------------//

Method CreateImageList()

   ::oImageList         := TImageList():New( 16, 16 )
   ::oImageListBig      := TImageList():New( 32, 32 )

   ::AddImageList( ::aAccesos )

Return ( Self )

//----------------------------------------------------------------------------//

Method SetImageList( oTree )

   DEFAULT oTree        := ::oTree

   if empty( ::oImageList )
      ::CreateImageList()
   end if

   oTree:SetImagelist( ::oImageList )

Return ( Self )

//----------------------------------------------------------------------------//

Method AddImageList( aAccesos )

   local n

   DEFAULT aAccesos  := ::aAccesos

   for n := 1 to len( aAccesos )
      ::AddBitmapMasked( aAccesos[ n ] )
      if len( aAccesos[ n ]:aAccesos ) > 0
         ::AddImageList( aAccesos[ n ]:aAccesos )
      end if
   next

Return ( Self )

//----------------------------------------------------------------------------//

Method CreateTree( oTree, aAccesos )

   local n

   DEFAULT oTree     := ::oTree
   DEFAULT aAccesos  := ::aAccesos

   for n := 1 to len( aAccesos )

      if len( aAccesos[ n ]:aAccesos ) > 0
         ::CreateTree( ::AddTree( oTree, aAccesos[ n ] ), aAccesos[ n ]:aAccesos )
      else
         ::AddTree( oTree, aAccesos[ n ] )
      end if

   next

Return ( Self )

//----------------------------------------------------------------------------//

Method AddTree( oTree, oAcceso )

   local oItemTree   := oTree:Add( oAcceso:cPrompt, oAcceso:nImageList, oAcceso:cId )

   if !empty( ::oTree )
      // TvSetCheckState( ::oTree:hWnd, oItemTree:hItem, oAcceso:lShow )
      ::oTree:SetCheck( oItemTree, oAcceso:lShow ) 
   end if

Return ( oItemTree )

//----------------------------------------------------------------------------//

Method AddBitmapMasked( oAcceso )

   ::oImageList:AddMasked( TBitmap():Define( oAcceso:cBmp ), Rgb( 255, 0, 255 ) )
   ::oImageListBig:AddMasked( TBitmap():Define( oAcceso:cBmpBig ), Rgb( 255, 0, 255 ) )

   oAcceso:nImageList   := len( ::oImageList:aBitmaps ) - 1

Return nil

//---------------------------------------------------------------------------//

Method EditButtonBar( oWnd, oMenuItem )

   local oDlg
   local nLevel
   local oBmpGeneral

   DEFAULT oWnd      := oWnd()
   DEFAULT oMenuItem := "01085"

   nLevel            := nLevelUsr( oMenuItem )

   // Obtenemos el nivel de acceso

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   DEFINE DIALOG oDlg RESOURCE "ButtonBar"

   REDEFINE BITMAP oBmpGeneral ;
      ID       500 ;
      RESOURCE "Magic_wand_alpha_48" ;
      TRANSPARENT ;
      OF       oDlg

   ::oTree     := TTreeView():Redefine( 100, oDlg )

   REDEFINE BUTTON ;
      ID       3 ;
      OF       oDlg ;
      ACTION   ( ::Default() )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( ::Save(), ::ReCreateOfficeBar( oWnd() ), oDlg:End( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:End() )

   oDlg:AddFastKey( VK_F5, {|| ::Save(), ::ReCreateOfficeBar( oWnd() ), oDlg:End( IDOK ) } )

   oDlg:Activate( , , , .t., , , {|| ::InitButtonBar() } )

   if !empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method InitButtonBar()

   ::SetImageList()
   ::CreateTree()
   ::Load()

Return nil

//---------------------------------------------------------------------------//

Method Save()

   local cDbf
   local cCurUsr  := cCurUsr()

   if ::lOpenDatabase()
      ::DeleteTree( cCurUsr )
      ::SaveTree( ::oTree:aItems, cCurUsr, cDbf )
      ::CloseDatabase()
   end if

   oUser():Save( cCurUsr )

Return ( Self )

//----------------------------------------------------------------------------//

Method SaveTree( aItems, cCurUsr, cDbf )

   local n

   for n := 1 to len( aItems )

      if !empty( aItems[ n ]:aItems )

         ( ::cDbf )->( dbAppend() )
         ( ::cDbf )->cCodUse     := cCurUsr
         ( ::cDbf )->cOpcion     := aItems[ n ]:cPrompt
         ( ::cDbf )->lShow       := ::oTree:GetCheck( aItems[ n ] )         
         ( ::cDbf )->( dbUnLock() )

         ::SaveTree( aItems[ n ]:aItems, cCurUsr, cDbf )

      else

         if IsChar( aItems[ n ]:bAction )
            ( ::cDbf )->( dbAppend() )
            ( ::cDbf )->cCodUse  := cCurUsr
            ( ::cDbf )->cOpcion  := aItems[ n ]:bAction
            ( ::cDbf )->lShow    := ::oTree:GetCheck( aItems[ n ] )         
            ( ::cDbf )->( dbUnLock() )
         end if

      end if

   next

Return Self

//--------------------------------------------------------------------------//

Method Load()

   local cCurUsr  := cCurUsr()

   if ::lOpenDatabase()

      if ( ::cDbf )->( dbSeek( cCurUsr ) )

         while ( ::cDbf )->cCodUse == cCurUsr .and. !( ::cDbf )->( eof() )

            ::LoadTree( ::oTree:aItems, ( ::cDbf )->cOpcion, ( ::cDbf )->lShow )

            ( ::cDbf )->( dbSkip() )

         end while

      end if

   end if

   ::CloseDatabase()

Return Self

//--------------------------------------------------------------------------//

Method LoadTree( aItems, cOpcion, lShow )

   local n

   if empty( cOpcion )
      return nil
   end if

   for n := 1 to Len( aItems )

      if Len( aItems[ n ]:aItems ) > 0

         if !empty( aItems[ n ] ) .and. Rtrim( aItems[ n ]:cPrompt ) == Rtrim( cOpcion )

            ::oTree:SetCheck( aItems[ n ], lShow ) 

         end if

         ::LoadTree( aItems[ n ]:aItems, cOpcion, lShow )

      else

         if !empty( aItems[ n ]:bAction ) .and.  Rtrim( aItems[ n ]:bAction ) == Rtrim( cOpcion )

            ::oTree:SetCheck( aItems[ n ], lShow ) 

         end if

      end if

   next

return nil

//--------------------------------------------------------------------------//

Method MakeDatabase( cPath, oMeter )

   DEFAULT cPath     := cPatDat()

   if !empty( oMeter )
		oMeter:cText	:= "Generando Bases"
      SysRefresh()
   end if

   if !lExistTable( cPath + "UsrBtnBar.Dbf" )
      dbCreate( cPath + "UsrBtnBar.Dbf", ::aStruct, cDriver() )
   end if

   if !lExistIndex( cPath + "UsrBtnBar.Cdx" )
      ::ReindexDatabase( cPath, oMeter )
   end if

RETURN .t.

//--------------------------------------------------------------------------//

Method ReindexDatabase( cPath, oMeter )

   local dbf

   DEFAULT cPath     := cPatDat()

   if !lExistTable( cPath + "UsrBtnBar.Dbf" )
      dbCreate( cPath + "UsrBtnBar.Dbf", ::aStruct, cDriver() )
   end if

   fEraseIndex( cPath + "UsrBtnBar.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "UsrBtnBar.Dbf", cCheckArea( "UsrBtnBar", @dbf ), .f. )
   if !( dbf )->( neterr() )
      ( dbf )->( __dbPack() )

      ( dbf )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbf )->( ordCreate( cPath + "UsrBtnBar.Cdx", "cCodUse", "Field->cCodUse", {|| Field->cCodUse } ) )

      ( dbf )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbf )->( ordCreate( cPath + "UsrBtnBar.Cdx", "cOpcion", "Field->cCodUse + Field->cOpcion", {|| Field->cCodUse  + Field->cOpcion } ) )

      ( dbf )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de usuarios" )
   end if

Return Self

//--------------------------------------------------------------------------//

Method CreateButtonBar( oWnd, lCreateButtonBar )

   DEFAULT lCreateButtonBar := .t.

   ::oReBar                	:= TPanelEx():New( 0, 0, if( ::lTactil, 124, 150 ), 1000, oWnd, Rgb( 255, 255, 255 ), .f. ) 

   oWnd:oTop                := ::oReBar

   ::CreateOfficeBar( oWnd )

   if !::lTactil
      ::CreateSearchBar( oWnd )
      ::HideSearchBar()
   end if

Return Self

//--------------------------------------------------------------------------//

Method CreateToolbar( aAccesos )

   local n
   local cCurUsr              := cCurUsr()

   DEFAULT aAccesos           := ::aAccesos

   if empty( ::oToolBar )

      if ::lBig
         if ::lTactil
            ::oToolBar        := TToolBar():New( ::oReBar, 50, 50, ::oImageListBig, .t. )
         else
            ::oToolBar        := TToolBar():New( ::oReBar, 36, 36, ::oImageListBig, .t. )
         end if
      else
         ::oToolBar           := TToolBar():New( ::oReBar, 20, 20, ::oImageList, .t. )
      end if

      ::oToolBar:nWidth       := 0

      ::oToolBar:SetBrush( TBrush():New( , Rgb( 255,255,255 ) ) )

   end if

   for n := 1 to len( aAccesos )

      if len( aAccesos[ n ]:aAccesos ) > 0
         ::CreateToolbar( aAccesos[ n ]:aAccesos )
         ::oToolBar:AddSeparator()
         ::oToolBar:nWidth    += 4
      else
         ::AddToolBar( aAccesos[ n ], cCurUsr )
      end if

   next

Return ( Self )

//----------------------------------------------------------------------------//

Method CreateSearchBar( oWnd )

   @ 124, 4 GET      ::oGet ;
            VAR      ::cGet ;
            OF       ::oRebar ;
            FONT     oFontLittelTitle() ;
            PIXEL    SIZE 210, 21

   ::oGet:cBmp       := "Lupa"
   // ::oGet:bLostFocus := {|| ::oGet:cText( Space( 200 ) ), if( !empty( ::oGet:bChange ), Eval( ::oGet:bChange ), ) }

   @ 124, 220 COMBOBOX ::oComboBox ;
            VAR      ::cComboBox ;
            ITEMS    ::aComboBox ;
            STYLE    2 ;
            OF       ::oRebar ;
            FONT     oFontLittelTitle() ;
            PIXEL    SIZE 200, 30

   @ 124, 426 COMBOBOX ::oComboFilter ;
            VAR      ::cComboFilter ;
            ITEMS    ::aComboFilter ;
            STYLE    2 ;
            OF       ::oRebar ;
            FONT     oFontLittelTitle() ;
            PIXEL    SIZE 200, 30

   ::oComboFilter:Disable()

   @ 125, 632 BTNBMP ::oButtonAddFilter ;
            RESOURCE "bAddFilter16" ;
            SIZE     18, 18 ;
            OF       ::oRebar ;
            NOBORDER ;
            ACTION   ( msgStop( "Quitar filtro activo" ) )

   ::oButtonAddFilter:lTransparent 	:= .t.
   ::oButtonAddFilter:lBoxSelect 	:= .f.

   @ 125, 658 BTNBMP ::oButtonEditFilter ;
            RESOURCE "bFilter16" ;
            SIZE     18, 18 ;
            OF       ::oRebar ;
            NOBORDER ;
            ACTION   ( msgStop( "Quitar filtro activo" ) )

   ::oButtonEditFilter:lTransparent  := .t.
   ::oButtonEditFilter:lBoxSelect 	 := .f.

   @ 125, 684 BTNBMP ::oButtonFilter ;
            RESOURCE "bNoFilter16" ;
            SIZE     18, 18 ;
            OF       ::oRebar ;
            NOBORDER ;
            ACTION   ( msgStop( "Quitar filtro activo" ) )

   ::oButtonFilter:lTransparent      := .t.
   ::oButtonFilter:lBoxSelect 	     := .f.

   @ 124, 710 COMBOBOX ::oYearComboBox ;
            VAR      ::cYearComboBox ;
            ITEMS    ::aYearComboBox ;
            STYLE    3 ;
            OF       ::oRebar ;
            FONT     oFontLittelTitle() ;
            PIXEL    SIZE 60, 30

Return ( Self )

//----------------------------------------------------------------------------//

Method EndSearchBar( oWnd )

   if !empty( ::oGet )
      ::oGet:End()
   end if 

   if !empty( ::oComboBox )
      ::oComboBox:End()
   end if 

   if !empty( ::oComboFilter )
      ::oComboFilter:End()
   end if 

   if !empty( ::oButtonAddFilter )
      ::oButtonAddFilter:end()
   end if 
   
   if !empty( ::oButtonEditFilter )
      ::oButtonEditFilter:End()
   end if 

   if !empty( ::oButtonFilter )
      ::oButtonFilter:End()
   end if

   if !empty( ::oYearComboBox )
      ::oYearComboBox:End()
   end if 

Return ( Self )

//----------------------------------------------------------------------------//

Method CreateLogo()

   if empty( ::oBmpLogo )

      @ 120, ( ::oRebar:nWidth() - 138 ) ;
            BITMAP   ::oBmpLogo ;
            RESOURCE "GesTool" ;
            PIXEL ;
            NOBORDER ;
            OF       ::oRebar

   else

      ::oBmpLogo:Move( 120, ( ::oRebar:nWidth() - 138 ), 134, 32, .t. )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method AddToolBar( oAcceso, cCurUsr )

   if ::lTactil
      ::oToolBar:AddButton( oAcceso:bAction, oAcceso:nImageList + 1, AnsiToOem( oAcceso:cPrompt ), oAcceso:cPrompt )
      ::oToolBar:nWidth       += 50
   else
      if ::lGetShowToolBar( oAcceso, cCurUsr )
         ::oToolBar:AddButton( oAcceso:bAction, oAcceso:nImageList + 1, AnsiToOem( oAcceso:cPrompt ) )
         ::oToolBar:nWidth    += 23
      end if
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method lOpenDatabase()

   local oBlock
   local oError

   if ::lOpenFiles
      Return ( ::lOpenFiles )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::MakeDatabase()

      USE ( cPatDat() + "UsrBtnBar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cDbf := cCheckArea( "UsrBtnBar" ) )
      SET ADSINDEX TO ( cPatDat() + "UsrBtnBar.Cdx" ) ADDITIVE

      ::lOpenFiles   := .t.

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de barras de botones" )

      CLOSE ( ::cDbf )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( ::lOpenFiles )

//----------------------------------------------------------------------------//

Method lGetShowToolBar( oAcceso, cCurUsr )

   local lShow       := .f.

   DEFAULT cCurUsr   := cCurUsr()

   if ::lOpenFiles .and. dbSeekInOrd( cCurUsr + oAcceso:cId, "cOpcion", ::cDbf )
      lShow          := ( ::cDbf )->lShow
   else
      lShow          := oAcceso:lShow
   end if

Return ( lShow )

//----------------------------------------------------------------------------//

Method lHideCarpeta( oAcceso, cCurUsr )

   local lHide       := .f.

   DEFAULT cCurUsr   := cCurUsr()

   if ::lOpenFiles .and. dbSeekInOrd( cCurUsr + oAcceso:cPrompt, "cOpcion", ::cDbf )
      lHide          := !( ::cDbf )->lShow
   else
      lHide          := .f.
   end if

Return ( lHide )

//----------------------------------------------------------------------------//

Method CloseDatabase()

   if !empty( ::cDbf )
      ( ::cDbf )->( dbCloseArea() )
   end if

   ::lOpenFiles      := .f.

Return ( Self )

//----------------------------------------------------------------------------//

Method DeleteTree( cCurUsr )

   DEFAULT cCurUsr   := cCurUsr()

   while ( ::cDbf )->( dbSeek( cCurUsr ) )
      if( ( ::cDbf )->( dbRLock() ), ( ( ::cDbf )->( dbDelete() ), ( ::cDbf )->( dbUnLock() ) ), )
   end while

Return ( Self )

//----------------------------------------------------------------------------//

Method CreateOfficeBar( oWnd )

   local oAcceso

   ::oOfficeBar               := TDotNetBar():New( 0, 0, 1000, 120, ::oReBar, 1 )
   ::oOfficeBar:lPaintAll     := .f.
   ::oOfficeBar:lDisenio      := .f.
   ::oOfficeBar:bRClicked     := {|| ::EditButtonBar() }

   ::oOfficeBar:SetStyle( 1 )

   ::oRebar:oTop              := ::oOfficeBar

   /*
   Creamos la carpeta de favoritos---------------------------------------------
   */

   if ::lOpenDatabase()

      ::CreateFavoritosOfficeBar()

      /*
      Resto de carpetas-----------------------------------------------------------
      */

      for each oAcceso in ::aAccesos
         if len( oAcceso:aAccesos ) > 0
            ::CreateCarpetaOfficeBar( oAcceso )
         end if
      next

      ::CloseDatabase()

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ReCreateOfficeBar( oWnd )

   local oCarpeta

   /*
   Creamos la carpeta de favoritos---------------------------------------------
   */

   if ::lOpenDatabase()

      ::CreateFavoritosOfficeBar()

      /*
      Resto de carpetas-----------------------------------------------------------
      */

      for each oCarpeta in ::oOfficeBar:aCarpetas
         oCarpeta:lHide    := ::lHideCarpeta( oCarpeta )
      next

      ::oOfficeBar:GetCoords()
      ::oOfficeBar:Refresh()

      ::CloseDatabase()

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method CreateCarpetaOfficeBar( oAcceso )

   local oCarpeta

   oCarpeta                   := TCarpeta():New( ::oOfficeBar, oAcceso:cPrompt )
   oCarpeta:lHide             := ::lHideCarpeta( oAcceso )

   ::CreateBotonesOfficeBar( oAcceso:aAccesos, oCarpeta )

Return ( Self )

//----------------------------------------------------------------------------//

Method CreateBotonesOfficeBar( aAcceso, oCarpeta )

   local oBoton
   local oGrupo
   local nGroup
   local oAcceso
   local nBoton               := 0
   local nLittleButtons       := 0
   local aGrupo               := {}

   for each oAcceso in aAcceso

      if !empty( oAcceso:oGroup )

         if aScan( aGrupo, oAcceso:oGroup:cPrompt ) == 0

            nBoton            := 0
            nGroup            := ( oAcceso:oGroup:nBigItems * 60 ) + ( oAcceso:oGroup:nLittleItems * 100 ) + 6
            nLittleButtons    := 0

            oGrupo            := TDotNetGroup():New( oCarpeta, nGroup, oAcceso:oGroup:cPrompt, .f., , oAcceso:oGroup:cBigBitmap )

            aAdd( aGrupo, oAcceso:oGroup:cPrompt )

         end if

         if !empty( oGrupo )

            if !oAcceso:lLittle

               oBoton         := TDotNetButton():New( 60, oGrupo, oAcceso:cBmpBig, oAcceso:cPrompt, ++nBoton, oAcceso:bAction, , , .f., .f., .f. )

            else

               oBoton         := TDotNetButton():New( 100, oGrupo, oAcceso:cBmp, oAcceso:cPrompt, ++nBoton, oAcceso:bAction, , , .f., .f., .f. )

               nLittleButtons++

               if Mod( nLittleButtons, 3 ) != 0
                  --nBoton
               end if

            end if

            oBoton:lVisible   := !oAcceso:lHide

         end if

      end if

   next

Return ( Self )

//---------------------------------------------------------------------------//

Method CreateFavoritosOfficeBar()

   local nScan
   local oItem
   local oAcceso
   local oBoton
   local oGrupo
   local nBoton                  := 0
   local aGrupo                  := {}
   local aColor                  := { RGB( 237, 71, 0 ), RGB( 237, 71, 0 ), , Rgb( 237, 71, 0 ), CLR_WHITE }

   if ( "TCT" $ cParamsMain() ) .or. ( "TPV" $ cParamsMain() )
      Return ( Self )
   end if

   // Creamos los favoritos-----------------------------------------------------

   if empty( ::oFavoritosBar )
      ::oFavoritosBar            := TCarpeta():New( ::oOfficeBar, "FAVORITOS", , , aColor )
   else
      ::oFavoritosBar:aGrupos    := {}
   end if

   for each oAcceso in ::aAccesos

      if len( oAcceso:aAccesos ) > 0

         for each oItem in oAcceso:aAccesos

            if ::lGetShowToolBar( oItem )

               if !empty( oItem:oGroup )

                  nScan          := aScan( aGrupo, oItem:oGroup:cPrompt )
                  if nScan == 0
                     aAdd( aGrupo, oItem:oGroup:cPrompt )
                     oGrupo      := TDotNetGroup():New( ::oFavoritosBar, 6, oItem:oGroup:cPrompt, .f., , oItem:oGroup:cBigBitmap )
                     nBoton      := 0
                  end if

                  if !empty( oGrupo )

                     oBoton      := TDotNetButton():New( 60, oGrupo, oItem:cBmpBig, oItem:cPrompt, ++nBoton, oItem:bAction, , , .f., .f., .f. )

                     oGrupo:nWidth     += 60
                     oGrupo:aSize[ 1 ] := oGrupo:nWidth

                     ::oFavoritosBar:CalcSizes()
                     ::oFavoritosBar:oParent:Refresh()

                  end if

               end if

            end if

         next

      end if

   next

   oGrupo   := TDotNetGroup():New( ::oFavoritosBar, 66, "Salir", .f., , "End32" )
   
   oBoton   := TDotNetButton():New( 60, oGrupo, "End32", "Salir", 1, {|| if ( !empty( oWnd() ), oWnd():End(), ) }, , , .f., .f., .f. )

Return ( Self )

//---------------------------------------------------------------------------//

Method EnableComboFilter( aItems )

   local cItem

   if !empty( ::oComboFilter )

      ::cComboFilter       := __txtFilters__
      ::aComboFilter       := { __txtFilters__ }

      // Cargamos los filtros-----------------------------------------------

      for each cItem in aItems
         aAdd( ::aComboFilter, cItem )
      next

      ::oComboFilter:SetItems( ::aComboFilter )
      
      ::oComboFilter:Set( ::cComboFilter )

      ::oComboFilter:Show()
      ::oComboFilter:Enable()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method End()

   if !empty( ::oRebar )
      ::oRebar:End()
   end if 

   if !empty( ::oGet )
      ::oGet:End()
   end if 

   if !empty( ::oBmpLogo )
      ::oBmpLogo:End()
   end if 

   if !empty( ::oButtonAddFilter )
      ::oButtonAddFilter:End()
   end if 

   if !empty( ::oButtonEditFilter )
      ::oButtonEditFilter:End()
   end if 
   
   if !empty( ::oButtonFilter )
      ::oButtonFilter:End()
   end if 

   if !empty( ::oComboBox )
      ::oComboBox:End()
   end if 

   if !empty( ::oComboFilter )
      ::oComboFilter:End()
   end if 

   ::oRebar             := nil
   ::oGet               := nil
   ::oBmpLogo           := nil
   ::oButtonAddFilter   := nil 
   ::oButtonEditFilter  := nil 
   ::oButtonFilter      := nil 
   ::oComboBox          := nil 
   ::oComboFilter       := nil

Return ( Self )

//---------------------------------------------------------------------------//

Static Function lEndApp()

   local oBlock
   local oError

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if ( !empty( oWnd() ), oWnd():End(), )

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nil )

//---------------------------------------------------------------------------//


#pragma BEGINDUMP

#include "Windows.h"
#include "hbapi.h"

HINSTANCE GetResources( void );

//----------------------------------------------------------------------------//

HB_FUNC( GETDEFAULTFONTNAME )
{
LOGFONT lf;
GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT ) , sizeof( LOGFONT ), &lf );
hb_retc( lf.lfFaceName );
}

//----------------------------------------------------------------------------//

HB_FUNC( GETDEFAULTFONTHEIGHT )
{
LOGFONT lf;
GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT ) , sizeof( LOGFONT ), &lf );
hb_retni( lf.lfHeight );
}

HB_FUNC( GETRCDATA )   // ( cnResName, cType ) --> cResourceBytes
{
   HMODULE hExe;
   HRSRC hRes;
   HGLOBAL hglb;
   int iResName = hb_parni( 1 );

   hExe = LoadLibrary(hb_parc(2));
   if (hExe == NULL)
   {
       hb_retc("0");
       return;
   }

   hRes = FindResource(hExe, MAKEINTRESOURCE(iResName), MAKEINTRESOURCE(10) );



   if( hRes )
   {
      hglb = LoadResource( ( HINSTANCE ) GetResources(), hRes );

      if( hglb ) // && ! ( GlobalFlags( hglb ) && GMEM_DISCARDED ) )
      {

         hb_retclen( ( LPSTR ) LockResource( hglb ), SizeofResource( GetResources(), hRes ) );
         //UnlockResource( hglb );

      }
      else
         hb_retc( "" );
   }
   else
      hb_retc( "" );
}


#pragma ENDDUMP

//----------------------------------------------------------------------------//
