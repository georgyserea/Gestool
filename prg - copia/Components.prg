#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "RichEdit.ch" 

#define FW_BOLD                        700

//---------------------------------------------------------------------------//

CLASS DialogBuilder

   DATA aComponents                    INIT {}

   DATA nView

   DATA oDlg

   METHOD End()                        INLINE ( ::oDlg:end() )

   METHOD AddComponent( oComponent )   INLINE ( aAdd( ::aComponents, oComponent ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS ResourceBuilder FROM DialogBuilder

   DATA bInit 
   DATA bWhile                         INIT {|| .t. }
   DATA bFor                           INIT {|| .t. }
   DATA bAction   
   DATA bSkip                          INIT {|| .t. }
   DATA bExit
   DATA bStart 

   DATA nTotalPrinted                  INIT 0

   DATA oSerieInicio       
   DATA oSerieFin           

   DATA oDocumentoInicio
   DATA oDocumentoFin   

   DATA oSufijoInicio                  
   DATA oSufijoFin                     

   DATA oClienteInicio
   DATA oClienteFin
   
   DATA oGrupoClienteInicio
   DATA oGrupoClienteFin

   DATA oProveedorInicio
   DATA oProveedorFin

   DATA oGrupoProveedorInicio
   DATA oGrupoProveedorFin

   DATA oFechaInicio
   DATA oFechaFin

   DATA oImpresora

   DATA oCopias

   DATA oFormatoDocumento

   DATA oInforme

   DATA oImageList

   METHOD Serie( cSerie )                 INLINE ( ::oSerieInicio:cText( cSerie ), ::oSerieFin:cText( cSerie ) )
   METHOD Documento( cDocumento )         INLINE ( ::oDocumentoInicio:cText( cDocumento ), ::oDocumentoFin:cText( cDocumento ) )
   METHOD Sufijo( cSufijo )               INLINE ( ::oSufijoInicio:cText( cSufijo ), ::oSufijoFin:cText( cSufijo ) )
   METHOD FormatoDocumento( cFormato )    INLINE ( ::oFormatoDocumento:cText( cFormato ) )

   METHOD DocumentoInicio()               INLINE ( ::oSerieInicio:Value() + str( ::oDocumentoInicio:Value(), 9 ) + ::oSufijoInicio:Value() )
   METHOD DocumentoFin()                  INLINE ( ::oSerieFin:Value() + str( ::oDocumentoFin:Value(), 9 ) + ::oSufijoFin:Value() )

   // Metdos auxiliares para comparaciones -----------------------------------

   METHOD InRangeDocumento( uValue )      INLINE ( empty( uValue ) .or. ( uValue >= ::DocumentoInicio() .and. uValue <= ::DocumentoFin() ) )
   
   METHOD InRangeCliente( uValue )        INLINE ( empty( uValue ) .or. ( uValue >= ::oClienteInicio:Value() .and. uValue <= ::oClienteFin:Value() ) )
   METHOD InRangeGrupoCliente( uValue )   INLINE ( empty( uValue ) .or. ( uValue >= ::oGrupoClienteInicio:Value() .and. uValue <= ::oGrupoClienteFin:Value() ) )

   METHOD InRangeProveedor( uValue )      INLINE ( empty( uValue ) .or. ( uValue >= ::oProveedorInicio:Value() .and. uValue <= ::oProveedorFin:Value() ) )
   METHOD InRangeGrupoProveedor( uValue ) INLINE ( empty( uValue ) .or. ( uValue >= ::oGrupoProveedorInicio:Value() .and. uValue <= ::oGrupoProveedorFin:Value() ) )

   METHOD InRangeFecha( uValue )          INLINE ( empty( uValue ) .or. ( uValue >= ::oFechaInicio:Value() .and. uValue <= ::oFechaFin:Value() ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS PrintSeries FROM ResourceBuilder

   METHOD New( nView )

   METHOD SetCompras()
   METHOD SetVentas()

   METHOD Resource()
      METHOD StartResource()
      METHOD ActionResource()
      METHOD DisableRange()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS PrintSeries

   ::nView                 := nView

   ::oSerieInicio          := GetSerie():New( 100, Self )
   ::oSerieFin             := GetSerie():New( 110, Self )

   ::oDocumentoInicio      := GetNumero():New( 120, Self )
   ::oDocumentoFin         := GetNumero():New( 130, Self )

   ::oSufijoInicio         := GetSufijo():New( 140, Self )
   ::oSufijoFin            := GetSufijo():New( 150, Self )

   ::oFechaInicio          := GetFecha():New( 210, Self )
   ::oFechaInicio:FirstDayYear()

   ::oFechaFin             := GetFecha():New( 220, Self )

   ::oFormatoDocumento     := GetDocumento():New( 90, 91, 92, Self )

   ::oImpresora            := GetPrinter():New( 160, 161, Self )

   ::oCopias               := GetCopias():New( 170, 180, Self )

   ::oImageList            := TImageList():New( 16, 16 )
   ::oImageList:AddMasked( TBitmap():Define( "Bullet_Square_Red_16" ),    Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "Bullet_Square_Green_16" ),  Rgb( 255, 0, 255 ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetCompras()

   // Proveedores-----------------------------------------------------------------

   ::oProveedorInicio      := GetProveedor():New( 300, 310, 301, Self )
   ::oProveedorInicio:SetText( "Desde proveedor" )
   ::oProveedorInicio:First()

   ::oProveedorFin         := GetProveedor():New( 320, 330, 321, Self )
   ::oProveedorFin:SetText( "Hasta proveedor" )
   ::oProveedorFin:Last()

   // Grupo de proveedores---------------------------------------------------------

   ::oGrupoProveedorInicio := GetGrupoProveedor():New( 340, 350, 341, Self )
   ::oGrupoProveedorInicio:SetText( "Desde grupo proveedor" )
   ::oGrupoProveedorInicio:First()

   ::oGrupoProveedorFin    := GetGrupoProveedor():New( 360, 370, 361, Self )
   ::oGrupoProveedorFin:SetText( "Hasta grupo proveedor" )
   ::oGrupoProveedorFin:Last()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetVentas()

   // Clientes-----------------------------------------------------------------

   ::oClienteInicio        := GetCliente():New( 300, 310, 301, Self )
   ::oClienteInicio:SetText( "Desde cliente" )
   ::oClienteInicio:First()

   ::oClienteFin           := GetCliente():New( 320, 330, 321, Self )
   ::oClienteFin:SetText( "Hasta cliente" )
   ::oClienteFin:Last()

   // Grupo de cliente---------------------------------------------------------

   ::oGrupoClienteInicio   := GetGrupoCliente():New( 340, 350, 341, Self )
   ::oGrupoClienteInicio:SetText( "Desde grupo cliente" )
   ::oGrupoClienteInicio:First()

   ::oGrupoClienteFin      := GetGrupoCliente():New( 360, 370, 361, Self )
   ::oGrupoClienteFin:SetText( "Hasta grupo cliente" )
   ::oGrupoClienteFin:Last()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS PrintSeries

   local oBmp

   DEFINE DIALOG ::oDlg RESOURCE "ImprimirSeries" TITLE "Imprimir series de documentos"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "Printer_alpha_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   aEval( ::aComponents, {| o | o:Resource(::oDlg) } )

   ::oInforme     := TTreeView():Redefine( 400, ::oDlg )

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::ActionResource() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:end() )

   ::oDlg:AddFastKey( VK_F5, {|| ::ActionResource() } )

   ::oDlg:bStart  := {|| ::StartResource() }

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:end()   
   
   ::oImageList:End()

   ::oInforme:Destroy()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD StartResource() CLASS PrintSeries

   ::oInforme:SetImageList( ::oImageList )

   //Si usamos clientes----------------------------------------------------

   if !Empty( ::oClienteInicio ) 
      ::oClienteInicio:Valid()
   end if

   if !Empty( ::oClienteFin )
      ::oClienteFin:Valid()
   end if

   if !Empty( ::oGrupoClienteInicio )
      ::oGrupoClienteInicio:Valid()
   end if   

   if !Empty( ::oGrupoClienteFin )
      ::oGrupoClienteFin:Valid()
   end if

   //Si usamos proveedores---------------------------------------------------

   if !Empty( ::oProveedorInicio ) 
      ::oProveedorInicio:Valid()
   end if

   if !Empty( ::oProveedorFin )
      ::oProveedorFin:Valid()
   end if

   if !Empty( ::oGrupoProveedorInicio )
      ::oGrupoProveedorInicio:Valid()
   end if   

   if !Empty( ::oGrupoProveedorFin )
      ::oGrupoProveedorFin:Valid()
   end if

   ::oFormatoDocumento:Valid()

   if !Empty( ::bStart )
      Eval( ::bStart )
   end if   

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD ActionResource() CLASS PrintSeries

   local nRecno
   local nOrdAnt

   ::nTotalPrinted   := 0

   ::oDlg:disable()

   if !empty( ::bInit )
      eval( ::bInit )
   end if 

   while eval( ::bWhile )

      if eval( ::bFor )

         if !empty( ::bAction )
            eval( ::bAction )
            ++::nTotalPrinted
         end if

      end if 

      eval( ::bSkip )
          
   end while 

   if !empty( ::bExit )
      eval( ::bExit )
   end if 

   ::oDlg:enable()
   ::oDlg:end( IDOK )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD DisableRange() CLASS PrintSeries

   ::oSerieInicio:Disable()
   ::oSerieFin:Disable()

   ::oDocumentoInicio:Disable()
   ::oDocumentoFin:Disable()

   ::oSufijoInicio:Disable()
   ::oSufijoFin:Disable()

   ::oClienteInicio:Disable()
   ::oClienteFin:Disable()

   ::oGrupoClienteInicio:Disable()
   ::oGrupoClienteFin:Disable()

   ::oFechaInicio:Disable()
   ::oFechaFin:Disable()

RETURN ( Self )      

//--------------------------------------------------------------------------//

CLASS ImportarProductosProveedor FROM PrintSeries

   DATA oPorcentaje

   DATA oProceso

   METHOD New( nView )

   METHOD Resource()

   METHOD ActionResource()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS ImportarProductosProveedor

   ::nView                 := nView

   ::oFechaInicio          := GetFecha():New( 100, Self )
   ::oFechaInicio:FirstDayPreviusMonth()

   ::oFechaFin             := GetFecha():New( 110, Self )
   ::oFechaFin:LastDayPreviusMonth()

   ::oPorcentaje           := GetPorcentaje():New( 120, Self )

   ::oProceso              := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ImportarProductosProveedor

   DEFINE DIALOG ::oDlg RESOURCE "ImportarProductosProveedor"

   aEval( ::aComponents, {| o | o:Resource(::oDlg) } )

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::ActionResource() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:end() )

   ::oDlg:AddFastKey( VK_F5, {|| ::ActionResource() } )

   ACTIVATE DIALOG ::oDlg CENTER

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD ActionResource() CLASS ImportarProductosProveedor

   ::oDlg:disable()

      if !empty( ::bAction )
         eval( ::bAction )
      end if 

   ::oDlg:enable()
   ::oDlg:end( IDOK )

RETURN ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS Component

   DATA oContainer

   METHOD New( oContainer )

END CLASS

METHOD New( oContainer )
   
   ::oContainer   := oContainer

   ::oContainer:AddComponent( Self )

Return ( Self )
   
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS ComponentGet FROM Component

   DATA idGet
   DATA idSay

   DATA bValid                   INIT {|| .t. }
   DATA bHelp                    INIT {|| .t. }
   DATA bWhen                    INIT {|| .t. }

   DATA oGetControl
   DATA uGetValue                INIT Space( 12 )
   
   METHOD New( idGet, oContainer )

   METHOD Resource( oDlg )

   METHOD cText( uGetValue )     INLINE ( if( !empty( ::oGetControl ), ::oGetControl:cText( uGetValue ), ::uGetValue := uGetValue ) )
   METHOD Value()                INLINE ( ::uGetValue )

   METHOD Valid()                INLINE ( if( !empty( ::oGetControl ), ::oGetControl:lValid(), .t. ) )

   METHOD Disable()              INLINE ( ::oGetControl:Disable() )
   METHOD Enable()               INLINE ( ::oGetControl:Enable() )

END CLASS 

METHOD New( idGet, oContainer ) CLASS ComponentGet

   ::idGet  := idGet

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS ComponentGet

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      BITMAP      "LUPA" ;
      OF          oDlg

   ::oGetControl:bValid    := ::bValid
   ::oGetControl:bHelp     := ::bHelp
   ::oGetControl:bWhen     := ::bWhen

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS ComponentSay FROM Component

   DATA idSay

   DATA oSayControl
   DATA uSayValue                INIT Space( 12 )
   
   METHOD New( idSay, oContainer )

   METHOD Resource( oDlg )

   METHOD cText( uSayValue )     INLINE ( if( !empty( ::oSayControl ), ::oSayControl:SetText( uSayValue ), ::uSayValue := uSayValue ) )
   METHOD Value()                INLINE ( ::uSayValue )

   METHOD Disable()              INLINE ( ::oSayControl:Disable() )
   METHOD Enable()               INLINE ( ::oSayControl:Enable() )

END CLASS 

METHOD New( idSay, oContainer ) CLASS ComponentSay

   ::idSay        := idSay

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS ComponentSay

   REDEFINE SAY   ::oSayControl ;
      PROMPT      ::uSayValue ;
      ID          ::idSay ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS ComponentCheck FROM Component

   DATA idCheck

   DATA oCheckControl
   DATA uCheckValue

   DATA bWhen                    INIT {|| .t. }
   
   METHOD New( idCheck, lDefault, oContainer )

   METHOD Resource( oDlg )

   METHOD Value()                INLINE ( ::uCheckValue )

   METHOD Disable()              INLINE ( ::oCheckControl:Disable() )
   METHOD Enable()               INLINE ( ::oCheckControl:Enable() )

END CLASS 

METHOD New( idCheck, lDefault, oContainer ) CLASS ComponentCheck

   DEFAULT lDefault  := .t.

   ::idCheck         := idCheck

   ::uCheckValue     := lDefault

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS ComponentCheck

   REDEFINE CHECKBOX ::oCheckControl ;
      VAR            ::uCheckValue ;
      ID             ::idCheck ;
      OF             oDlg

   ::oCheckControl:bWhen     := ::bWhen

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ComponentUrlLink FROM Component

   DATA idUrlLink
   DATA bAction
   DATA cCaption

   DATA oUrlLinkControl
   
   METHOD New( idCheck, oContainer )

   METHOD Resource( oDlg )

   METHOD Disable()              INLINE ( ::oUrlLinkControl:Disable() )
   METHOD Enable()               INLINE ( ::oUrlLinkControl:Enable() )

END CLASS 

METHOD New( idUrlLink, bAction, cCaption, oContainer ) CLASS ComponentUrlLink

   ::idUrlLink    := idUrlLink
   ::bAction      := bAction
   ::cCaption     := cCaption

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS ComponentUrlLink

   ::oUrlLinkControl          := TURLLink():ReDefine( ::idUrlLink, oDlg, , ::cCaption, ::cCaption ) 
   ::oUrlLinkControl:bAction  := ::bAction

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SayCompras FROM ComponentSay

   METHOD New( idSay, oContainer )

   METHOD Resource( oDlg )

END CLASS 

METHOD New( idSay, oContainer ) CLASS SayCompras

   ::Super:New( idSay, oContainer )

   ::uSayValue    := 0

RETURN ( Self )

METHOD Resource( oDlg ) CLASS SayCompras

   REDEFINE SAY   ::oSayControl ;
      PROMPT      ::uSayValue ;
      ID          ::idSay ;
      PICTURE     ( cPorDiv() ) ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS ComponentGetSay FROM ComponentGet

   DATA idSay
   DATA idText

   DATA oSayControl        
   DATA cSayValue                INIT ""

   DATA oTextControl
   DATA cTextValue

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD Resource(oDlg)

   METHOD SetText( cText )       INLINE ( if( !empty( ::oTextControl ), ::oTextControl:SetText( cText ), ::cTextValue := cText ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS ComponentGetSay

   ::idSay        := idSay
   ::idText       := idText

   ::Super:New( idGet, oContainer )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Resource( oDlg ) CLASS ComponentGetSay

   ::Super:Resource( oDlg )

   REDEFINE GET   ::oSayControl ;
      VAR         ::cSayValue ;
      ID          ::idSay ;
      WHEN        ( .f. ) ;
      OF          oDlg

   if !Empty( ::idText )

   REDEFINE SAY   ::oTextControl ;
      PROMPT      ::cTextValue ;
      ID          ::idText ;
      OF          oDlg

   end if 

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//


CLASS GetCombo FROM Component

   DATA oControl

   DATA idCombo

   DATA uValue                   INIT "Combo" 
   DATA aValues                  INIT {"Combo"}
   
   DATA bChange

   METHOD Build( hBuilder )
   METHOD New( idGet, uValue, aValues, oContainer )

   METHOD Resource(oDlg)

   METHOD Value()                INLINE ( Eval( ::oControl:bSetGet ) )

   METHOD Disable()              INLINE ( ::oControl:Disable() )
   METHOD Enable()               INLINE ( ::oControl:Enable() )

   METHOD SetChange( bChange )   INLINE ( if( isBlock( bChange ), ::bChange := bChange, ) )
   METHOD Change()               INLINE ( if( isBlock( ::bChange ), eval( ::bChange ), ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetCombo

   local idCombo     := if( hhaskey( hBuilder, "idCombo" ),    hBuilder[ "idCombo"   ], nil )
   local uValue      := if( hhaskey( hBuilder, "uValue"),      hBuilder[ "uValue"    ], nil )
   local aValues     := if( hhaskey( hBuilder, "aValues"),     hBuilder[ "aValues"   ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idCombo, uValue, aValues, oContainer )

Return ( Self )

METHOD New( idCombo, uValue, aValues, oContainer ) CLASS GetCombo

   ::idCombo   := idCombo
   ::uValue    := uValue
   ::aValues   := aValues

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS GetCombo

   REDEFINE COMBOBOX ::oControl ;
      VAR      ::uValue ;
      ITEMS    ::aValues ;
      ID       ::idCombo ;
      OF       oDlg

   ::oControl:bChange      := {|| ::Change() }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetCliente FROM ComponentGetSay

   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( RetNumCodCliEmp() ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", RetNumCodCliEmp() ) ) )

   METHOD Top()      INLINE ( ::cText( D():Top( "Client", ::oContainer:nView ) ) )
   METHOD Bottom()   INLINE ( ::cText( D():Bottom( "Client", ::oContainer:nView ) ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetCliente

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cClient( ::oGetControl, D():Clientes( ::oContainer:nView ), ::oSayControl ) }
   ::bHelp        := {|| BrwClient( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetGrupoCliente FROM ComponentGetSay

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD First()    INLINE ( ::cText( Space( 4 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 4 ) ) )

   METHOD Top()      INLINE ( ::cText( D():GetObject( "GruposClientes", ::oContainer:nView ):Top() ) )
   METHOD Bottom()   INLINE ( ::cText( D():GetObject( "GruposClientes", ::oContainer:nView ):Bottom() ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetGrupoCliente

   ::Super:New( idGet, idSay, idText, oContainer )

   ::uGetValue    := Space( 4 )

   ::bValid       := {|| D():GruposClientes( ::oContainer:nView ):Existe( ::oGetControl, ::oSayControl, "cNomGrp", .t., .t., "0" ) }
   ::bHelp        := {|| D():GruposClientes( ::oContainer:nView ):Buscar( ::oGetControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetDocumento FROM ComponentGetSay

   DATA idBtn
   DATA cTypeDocumento              INIT Space( 2 )

   METHOD New( idGet, idSay, idBtn, oContainer )

   METHOD Resource(oDlg)

   METHOD TypeDocumento( cType )    INLINE ( if( !empty( cType ), ::cTypeDocumento := cType, ::cTypeDocumento ) )

END CLASS 

METHOD New( idGet, idSay, idBtn, oContainer ) CLASS GetDocumento

   ::Super:New( idGet, idSay, nil, oContainer )

   ::idBtn        := idBtn

   ::uGetValue    := Space( 3 )

   ::bValid       := {|| cDocumento( ::oGetControl, ::oSayControl, D():Documentos( ::oContainer:nView ) ) }
   ::bHelp        := {|| brwDocumento( ::oGetControl, ::oSayControl, ::TypeDocumento() ) }

Return ( Self )

METHOD Resource(oDlg) CLASS GetDocumento

   ::Super:Resource(oDlg)

   TBtnBmp():ReDefine( ::idBtn, "Printer_pencil_16",,,,,{|| EdtDocumento( ::uGetValue ) }, oDlg, .f., , .f.,  )

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetPrinter FROM ComponentGet

   DATA idBtn

   DATA cTypeDocumento              INIT Space( 2 )

   METHOD New( idGet, oContainer )

   METHOD Resource(oDlg)

   METHOD TypeDocumento( cType )    INLINE ( if( !empty( cType ), ::cTypeDocumento := cType, ::cTypeDocumento ) )

END CLASS 

METHOD New( idGet, idBtn, oContainer ) CLASS GetPrinter

   ::Super:New( idGet, oContainer )

   ::idBtn        := idBtn

   ::uGetValue    := PrnGetName()

Return ( Self )

METHOD Resource(oDlg) CLASS GetPrinter

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      WHEN        ( .f. ) ;
      OF          oDlg

   TBtnBmp():ReDefine( ::idBtn, "Printer_preferences_16",,,,, {|| PrinterPreferences( ::oGetControl ) }, oDlg, .f., , .f. )

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetSerie FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource(oDlg)

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetSerie

   ::Super:New( idGet, oContainer )

   ::uGetValue    := "A"

   ::bValid       := {|| ::uGetValue >= "A" .and. ::uGetValue <= "Z" }

Return ( Self )

METHOD Resource(oDlg) CLASS GetSerie

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP       ( UpSerie( ::oGetControl ) );
      ON DOWN     ( DwSerie( ::oGetControl ) );
      VALID       ( ::bValid );
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetNumero FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource(oDlg)

   METHOD SetPicture()

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetNumero

   ::Super:New( idGet, oContainer )

   ::uGetValue    := 1
   
   ::bValid       := {|| ::uGetValue >= 1 .and. ::uGetValue <= 999999999 }

Return ( Self )

METHOD Resource(oDlg) CLASS GetNumero

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "999999999" ;
      SPINNER ;
      VALID       ::bValid ;
      OF          oDlg

Return ( Self )

METHOD SetPicture( cPicture )

   ::oGetControl:oGet:Assign()
   ::oGetControl:oGet:Picture   := cPicture
   ::oGetControl:oGet:UpdateBuffer()

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetSufijo FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource(oDlg)

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetSufijo

   ::Super:New( idGet, oContainer )

   ::uGetValue    := RetSufEmp()

Return ( Self )

METHOD Resource(oDlg) CLASS GetSufijo

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "@!" ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetFecha FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource()

   METHOD FirstDayYear()         INLINE ( ::cText( BoY( Date() ) ) )
   METHOD LastDayYear()          INLINE ( ::cText( EoY( Date() ) ) )

   METHOD FirstDayMonth()        INLINE ( ::cText( BoM( Date() ) ) )
   METHOD LastDayMonth()         INLINE ( ::cText( EoM( Date() ) ) )

   METHOD FirstDayPreviusMonth() INLINE ( ::cText( BoM( AddMonth( Date(), -1 ) ) ) )
   METHOD LastDayPreviusMonth()  INLINE ( ::cText( EoM( AddMonth( Date(), -1 ) ) ) ) 

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetFecha

   ::Super:New( idGet, oContainer )

   ::uGetValue    := Date()
   
Return ( Self )

METHOD Resource(oDlg) CLASS GetFecha

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      SPINNER ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetPeriodo FROM ComponentGet

   DATA oComboPeriodo

   DATA oFechaInicio
   DATA oFechaFin

   DATA cPeriodo                 INIT "A�o en curso"
   DATA aPeriodo                 INIT {}

   METHOD Build( hBuilder )
   METHOD New( idCombo, idFechaInicio, idFechaFin, oContainer )

   METHOD CambiaPeriodo()
   METHOD CargaPeriodo()

   METHOD Resource( oContainer )

   METHOD InRange( uValue )      INLINE ( uValue >= ::oFechaInicio:Value() .and. uValue <= ::oFechaFin:Value() )

END CLASS 

METHOD Build( hBuilder ) CLASS GetPeriodo 

   local idCombo        := if( hhaskey( hBuilder, "idCombo" ),       hBuilder[ "idCombo"        ], nil )
   local idFechaInicio  := if( hhaskey( hBuilder, "idFechaInicio"),  hBuilder[ "idFechaInicio"  ], nil )
   local idFechaFin     := if( hhaskey( hBuilder, "idFechaFin"),     hBuilder[ "idFechaFin"     ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer"),     hBuilder[ "oContainer"     ], nil )

   ::New( idCombo, idFechaInicio, idFechaFin, oContainer )

Return ( Self )

METHOD New( idCombo, idFechaInicio, idFechaFin, oContainer ) CLASS GetPeriodo

   ::CargaPeriodo()

   ::oComboPeriodo            := GetCombo():New( idCombo, ::cPeriodo, ::aPeriodo, oContainer )
   ::oComboPeriodo:SetChange( {|| ::CambiaPeriodo() } )

   ::oFechaInicio             := GetFecha():New( idFechaInicio, oContainer )
   ::oFechaInicio:FirstDayYear()

   ::oFechaFin                := GetFecha():New( idFechaFin, oContainer )

Return ( Self )

METHOD Resource( oContainer ) CLASS GetPeriodo

   ::oComboPeriodo:Resource( oContainer )
   ::oFechaInicio:Resource( oContainer )
   ::oFechaFin:Resource( oContainer )

Return ( Self )

METHOD CargaPeriodo() CLASS GetPeriodo 

   ::aPeriodo                 := {}

   aAdd( ::aPeriodo, "Hoy" )
   aAdd( ::aPeriodo, "Ayer" )
   aAdd( ::aPeriodo, "Mes en curso" )
   aAdd( ::aPeriodo, "Mes anterior" )
   aAdd( ::aPeriodo, "Primer trimestre" )
   aAdd( ::aPeriodo, "Segundo trimestre" )
   aAdd( ::aPeriodo, "Tercer trimestre" )
   aAdd( ::aPeriodo, "Cuatro trimestre" )
   aAdd( ::aPeriodo, "Doce �ltimos meses" )
   aAdd( ::aPeriodo, "A�o en curso" )
   aAdd( ::aPeriodo, "A�o anterior" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CambiaPeriodo() CLASS GetPeriodo 

   local cPeriodo    := ::oComboPeriodo:Value()

   do case
      case cPeriodo == "Hoy"

         ::oFechaInicio:cText( GetSysDate() )
         ::oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Ayer"

         ::oFechaInicio:cText( GetSysDate() -1 )
         ::oFechaFin:cText( GetSysDate() -1 )

      case cPeriodo == "Mes en curso"

         ::oFechaInicio:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Mes anterior"

         ::oFechaInicio:cText( BoM( addMonth( GetSysDate(), - 1 ) ) )
         ::oFechaFin:cText( EoM( addMonth( GetSysDate(), - 1 ) ) )

      case cPeriodo == "Primer trimestre"

         ::oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Segundo trimestre"

         ::oFechaInicio:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Tercer trimestre"

         ::oFechaInicio:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Cuatro trimestre"

         ::oFechaInicio:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Doce �ltimos meses"

         ::oFechaInicio:cText( BoY( GetSysDate() ) )
         ::oFechaFin:cText( EoY( GetSysDate() ) )

      case cPeriodo == "A�o en curso"

         ::oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "A�o anterior"

         ::oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         ::oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )

   end case

RETURN ( .t. )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetRangoCliente FROM Component

   DATA oAll
   DATA oInicio
   DATA oFin

   METHOD Build( hBuilder )
   METHOD New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer )

   METHOD Resource( oContainer )

   METHOD InRange( uValue )      INLINE ( ::oAll:Value() .or. ( uValue >= ::oInicio:Value() .and. uValue <= ::oFin:Value() ) )

END CLASS 

METHOD Build( hBuilder ) CLASS GetRangoCliente 

   local idAll          := if( hhaskey( hBuilder, "idAll" ),         hBuilder[ "idAll"        ], nil )
   local idGetInicio    := if( hhaskey( hBuilder, "idGetInicio" ),   hBuilder[ "idGetInicio"  ], nil )
   local idSayInicio    := if( hhaskey( hBuilder, "idSayInicio" ),   hBuilder[ "idSayInicio"  ], nil )
   local idTextInicio   := if( hhaskey( hBuilder, "idTextInicio" ),  hBuilder[ "idTextInicio" ], nil )
   local idGetFin       := if( hhaskey( hBuilder, "idGetFin" ),      hBuilder[ "idGetFin"     ], nil )
   local idSayFin       := if( hhaskey( hBuilder, "idSayFin" ),      hBuilder[ "idSayFin"     ], nil )
   local idTextFin      := if( hhaskey( hBuilder, "idTextFin" ),     hBuilder[ "idTextFin"    ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer" ),    hBuilder[ "oContainer"   ], nil )

   ::New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer )

Return ( Self )

METHOD New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer ) CLASS GetRangoCliente

   ::oAll           := ComponentCheck():New( idAll, .t., oContainer )

   ::oInicio        := GetCliente():New( idGetInicio, idSayInicio, idTextInicio, oContainer )
   ::oInicio:SetText( "Desde" )
   ::oInicio:First()
   ::oInicio:bWhen  := {|| !::oAll:Value() }

   ::oFin           := GetCliente():New( idGetFin, idSayFin, idTextFin, oContainer )
   ::oFin:SetText( "Hasta" )
   ::oFin:Last()
   ::oFin:bWhen     := {|| !::oAll:Value() }

Return ( Self )

METHOD Resource( oDialog ) CLASS GetRangoCliente

   ::oAll:Resource( oDialog )
   ::oInicio:Resource( oDialog )
   ::oFin:Resource( oDialog )

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetRangoGrupoCliente FROM Component

   DATA oAll
   DATA oInicio
   DATA oFin

   METHOD Build( hBuilder )
   METHOD New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer )

   METHOD Resource( oContainer )

   METHOD InRange( uValue )      INLINE ( ::oAll:Value() .or. ( uValue >= ::oInicio:Value() .and. uValue <= ::oFin:Value() ) )

END CLASS 

METHOD Build( hBuilder ) CLASS GetRangoGrupoCliente 

   local idAll          := if( hhaskey( hBuilder, "idAll" ),         hBuilder[ "idAll"        ], nil )
   local idGetInicio    := if( hhaskey( hBuilder, "idGetInicio" ),   hBuilder[ "idGetInicio"  ], nil )
   local idSayInicio    := if( hhaskey( hBuilder, "idSayInicio" ),   hBuilder[ "idSayInicio"  ], nil )
   local idTextInicio   := if( hhaskey( hBuilder, "idTextInicio" ),  hBuilder[ "idTextInicio" ], nil )
   local idGetFin       := if( hhaskey( hBuilder, "idGetFin" ),      hBuilder[ "idGetFin"     ], nil )
   local idSayFin       := if( hhaskey( hBuilder, "idSayFin" ),      hBuilder[ "idSayFin"     ], nil )
   local idTextFin      := if( hhaskey( hBuilder, "idTextFin" ),     hBuilder[ "idTextFin"    ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer" ),    hBuilder[ "oContainer"   ], nil )

   ::New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer )

Return ( Self )

METHOD New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer ) CLASS GetRangoGrupoCliente

   ::oAll           := ComponentCheck():New( idAll, .t., oContainer )

   ::oInicio        := GetGrupoCliente():New( idGetInicio, idSayInicio, idTextInicio, oContainer )
   ::oInicio:SetText( "Desde" )
   ::oInicio:First()
   ::oInicio:bWhen  := {|| !::oAll:Value() }

   ::oFin           := GetGrupoCliente():New( idGetFin, idSayFin, idTextFin, oContainer )
   ::oFin:SetText( "Hasta" )
   ::oFin:Last()
   ::oFin:bWhen     := {|| !::oAll:Value() }

Return ( Self )

METHOD Resource( oDialog ) CLASS GetRangoGrupoCliente

   ::oAll:Resource( oDialog )
   ::oInicio:Resource( oDialog )
   ::oFin:Resource( oDialog )

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetRangoSeries FROM Component

   DATA oTodas
   DATA oNinguna
   DATA hObjectSerie

   METHOD Build( hBuilder )
   METHOD New( idTodas, idNinguna, idInicio, oContainer )

   METHOD Resource( oDialog )

   METHOD SelectAll()         INLINE ( if( !Empty( ::hObjectSerie ), hEval( ::hObjectSerie, {| h, o, i | o:uCheckValue := .t., o:oCheckControl:Refresh() } ), ) )

   METHOD UnselectAll()       INLINE ( if( !Empty( ::hObjectSerie ), hEval( ::hObjectSerie, {| h, o, i | o:uCheckValue := .f., o:oCheckControl:Refresh() } ), ) )

   METHOD InRange( uValue )

END CLASS 

METHOD Build( hBuilder ) CLASS GetRangoSeries 

   local idTodas        := if( hhaskey( hBuilder, "idTodas" ),          hBuilder[ "idTodas"        ], nil )
   local idNinguna      := if( hhaskey( hBuilder, "idNinguna" ),        hBuilder[ "idNinguna"      ], nil )
   local idInicio       := if( hhaskey( hBuilder, "idInicio" ),         hBuilder[ "idInicio"       ], nil )
   local bActionTodas   := if( hhaskey( hBuilder, "bActionTodas" ),     hBuilder[ "bActionTodas"   ], nil )
   local bActionNinguna := if( hhaskey( hBuilder, "bActionNinguna" ),   hBuilder[ "bActionNinguna" ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer" ),       hBuilder[ "oContainer"     ], nil )

   ::New( idTodas, idNinguna, idInicio, oContainer )

Return ( Self )

METHOD New( idTodas, idNinguna, idInicio, oContainer ) CLASS GetRangoSeries

   ::oTodas          := ComponentUrlLink():New( idTodas, {|| ::SelectAll() }, "Todas", oContainer )
   ::oNinguna        := ComponentUrlLink():New( idNinguna, {|| ::UnselectAll() }, "Ninguna", oContainer )

   ::hObjectSerie    := { "A"  =>  ComponentCheck():New( idInicio, .t., oContainer ),;
                          "B"  =>  ComponentCheck():New( idInicio + 1, .t., oContainer ),;
                          "C"  =>  ComponentCheck():New( idInicio + 2, .t., oContainer ),;
                          "D"  =>  ComponentCheck():New( idInicio + 3, .t., oContainer ),;
                          "E"  =>  ComponentCheck():New( idInicio + 4, .t., oContainer ),;
                          "F"  =>  ComponentCheck():New( idInicio + 5, .t., oContainer ),;
                          "G"  =>  ComponentCheck():New( idInicio + 6, .t., oContainer ),;
                          "H"  =>  ComponentCheck():New( idInicio + 7, .t., oContainer ),;
                          "I"  =>  ComponentCheck():New( idInicio + 8, .t., oContainer ),;
                          "J"  =>  ComponentCheck():New( idInicio + 9, .t., oContainer ),;
                          "K"  =>  ComponentCheck():New( idInicio + 10, .t., oContainer ),;
                          "L"  =>  ComponentCheck():New( idInicio + 11, .t., oContainer ),;
                          "M"  =>  ComponentCheck():New( idInicio + 12, .t., oContainer ),;
                          "N"  =>  ComponentCheck():New( idInicio + 13, .t., oContainer ),;
                          "O"  =>  ComponentCheck():New( idInicio + 14, .t., oContainer ),;
                          "P"  =>  ComponentCheck():New( idInicio + 15, .t., oContainer ),;
                          "Q"  =>  ComponentCheck():New( idInicio + 16, .t., oContainer ),;
                          "R"  =>  ComponentCheck():New( idInicio + 17, .t., oContainer ),; 
                          "S"  =>  ComponentCheck():New( idInicio + 18, .t., oContainer ),; 
                          "T"  =>  ComponentCheck():New( idInicio + 19, .t., oContainer ),; 
                          "U"  =>  ComponentCheck():New( idInicio + 20, .t., oContainer ),; 
                          "V"  =>  ComponentCheck():New( idInicio + 21, .t., oContainer ),; 
                          "W"  =>  ComponentCheck():New( idInicio + 22, .t., oContainer ),; 
                          "X"  =>  ComponentCheck():New( idInicio + 23, .t., oContainer ),; 
                          "Y"  =>  ComponentCheck():New( idInicio + 24, .t., oContainer ),; 
                          "Z"  =>  ComponentCheck():New( idInicio + 25, .t., oContainer ) }

Return ( Self )

METHOD Resource( oDialog ) CLASS GetRangoSeries

   ::oTodas:Resource( oDialog )
   ::oNinguna:Resource( oDialog )

   if !Empty( ::hObjectSerie )

      hEval( ::hObjectSerie, {| h, o, i | o:Resource( oDialog ) } )

   end if   

Return ( Self )

METHOD InRange( uValue ) CLASS GetRangoSeries

   if Empty( uValue )
      Return .f.
   end if

return ( hGet( ::hObjectSerie, uValue ):Value() )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetCopias FROM ComponentGet

   DATA idCheck 

   DATA lCopiasPredeterminadas   INIT .t.

   METHOD New( idGet, oContainer )

   METHOD Resource()

END CLASS 

METHOD New( idCheck, idGet, oContainer ) CLASS GetCopias

   ::Super:New( idGet, oContainer )

   ::idCheck      := idCheck

   ::uGetValue    := 1
   
   ::bValid       := {|| ::uGetValue >= 1 .and. ::uGetValue <= 99999 }

Return ( Self )

METHOD Resource(oDlg) CLASS GetCopias

   REDEFINE CHECKBOX ::lCopiasPredeterminadas ;
      ID          ::idCheck ;
      OF          oDlg

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "99999" ;
      SPINNER ;
      WHEN        !::lCopiasPredeterminadas ;
      VALID       ::bValid ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//

CLASS GetPorcentaje FROM ComponentGet

   DATA idGet 

   METHOD New( idGet, oContainer )

   METHOD Resource()

END CLASS 
  
METHOD New( idGet, oContainer ) CLASS GetPorcentaje

   ::Super:New( idGet, oContainer )

   ::uGetValue    := 0
   
   ::bValid       := {|| ::uGetValue >= 0 .and. ::uGetValue <= 100 }

Return ( Self )

METHOD Resource(oDlg) CLASS GetPorcentaje

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "999" ;
      SPINNER ;
      VALID       ::bValid ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

Function nLastDay( nMes )

   local cMes     := Str( if( nMes == 12, 1, nMes + 1 ), 2 )
   local cAno     := Str( if( nMes == 12, Year( Date() ) + 1, Year( Date() ) ) )

Return ( Ctod( "01/" + cMes + "/" + cAno ) - 1 )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetProveedor FROM ComponentGetSay

   METHOD Build( hBuilder ) 
   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( RetNumCodPrvEmp() ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", RetNumCodPrvEmp() ) ) )

   METHOD Top()      INLINE ( ::cText( D():Top( "Provee", ::oContainer:nView ) ) )
   METHOD Bottom()   INLINE ( ::cText( D():Bottom( "Provee", ::oContainer:nView ) ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) 

   local idGet       := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"     ], nil )
   local idSay       := if( hhaskey( hBuilder, "idSay"),       hBuilder[ "idSay"     ], nil )
   local idText      := if( hhaskey( hBuilder, "idText"),      hBuilder[ "idText"    ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetProveedor

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cProvee( ::oGetControl, D():Proveedores( ::oContainer:nView ), ::oSayControl ) }
   ::bHelp        := {|| BrwProvee( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetArticulo FROM ComponentGetSay

   METHOD Build( hBuilder ) 
   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( 18 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 18 ) ) )

   METHOD Top()      INLINE ( ::cText( D():Top( "Articulo", ::oContainer:nView ) ) )
   METHOD Bottom()   INLINE ( ::cText( D():Bottom( "Articulo", ::oContainer:nView ) ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetArticulo

   local idGet       := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"     ], nil )
   local idSay       := if( hhaskey( hBuilder, "idSay"),       hBuilder[ "idSay"     ], nil )
   local idText      := if( hhaskey( hBuilder, "idText"),      hBuilder[ "idText"    ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetArticulo

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cArticulo( ::oGetControl, D():Get( "Articulo", ::oContainer:nView ), ::oSayControl ) }
   ::bHelp        := {|| BrwArticulo( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetPropiedad FROM ComponentGetSay

   METHOD Build( hBuilder ) 
   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( 20 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 20 ) ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetPropiedad

   local idGet       := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"     ], nil )
   local idSay       := if( hhaskey( hBuilder, "idSay"),       hBuilder[ "idSay"     ], nil )
   local idText      := if( hhaskey( hBuilder, "idText"),      hBuilder[ "idText"    ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetPropiedad

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cProp( ::oGetControl, ::oSayControl ) }
   ::bHelp        := {|| brwProp( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetPropiedadActual FROM GetPropiedad

   DATA cPropiedad

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD PropiedadActual( cPropiedad )   INLINE ( iif( cPropiedad != nil, ::cPropiedad := cPropiedad, ::cPropiedad ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetPropiedadActual

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cProp( ::oGetControl, ::oSayControl ) }
   ::bHelp        := {|| brwPropiedadActual( ::oGetControl, ::oSayControl, ::PropiedadActual() ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetGrupoProveedor FROM ComponentGetSay

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD First()    INLINE ( ::cText( Space( 4 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 4 ) ) )

   METHOD Top()      INLINE ( ::cText( D():GetObject( "GruposProveedores", ::oContainer:nView ):Top() ) )
   METHOD Bottom()   INLINE ( ::cText( D():GetObject( "GruposProveedores", ::oContainer:nView ):Bottom() ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetGrupoProveedor

   ::Super:New( idGet, idSay, idText, oContainer )

   ::uGetValue    := Space( 4 )

   ::bValid       := {|| D():GruposProveedores( ::oContainer:nView ):Existe( ::oGetControl, ::oSayControl, "cNomGrp", .t., .t., "0" ) }
   ::bHelp        := {|| D():GruposProveedores( ::oContainer:nView ):Buscar( ::oGetControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetRichEdit 

   DATA oDlg

   DATA oClp

   DATA oRTF
   DATA cRTF              INIT ""

   DATA oBtnPrint
   DATA oBtnPreview
   DATA oBtnSearch
   DATA oBtnCut
   DATA oBtnCopy
   DATA oBtnPaste
   DATA oBtnUndo
   DATA oBtnRedo
   DATA oBtnBold
   DATA oBtnItalics
   DATA oBtnTextAlignLeft
   DATA oBtnTextAlignCenter
   DATA oBtnTextAlignRight
   DATA oBtnTextJustify
   DATA oBtnBullet
   DATA oBtnUnderLine
   DATA oBtnDateTime
   
   DATA oZoom
   DATA cZoom              INIT "100%"
   DATA aZoom              INIT { "500%", "200%", "150%", "100%", "75%", "50%", "25%", "10%" }
   
   DATA oFuente
   DATA cFuente            INIT "Courier New"
   DATA aFuente            INIT aGetFont( oWnd() )
   
   DATA oSize
   DATA cSize              INIT "12"
   DATA aSize              INIT { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   
   DATA aRatio             INIT { { 5, 1 }, { 2, 1 }, { 3, 2 }, { 1, 1 }, { 3, 4 }, { 1, 2 }, { 1, 4 }, { 1, 10 } }

   DATA lItalic            INIT .f.
   DATA lUnderline         INIT .f.
   DATA lBullet            INIT .f.
   DATA lBold              INIT .f.

   METHOD Redefine( id, oDlg )

   METHOD RTFRefreshButtons()

   METHOD SetText( cText ) INLINE ( ::oRTF:SetText( cText ) )
   METHOD GetText()        INLINE ( ::oRTF:GetText() )

   METHOD cText( cText )   INLINE ( ::oRTF:cText( cText ) )
   METHOD SaveAsRTF()      INLINE ( ::oRTF:SaveAsRTF() )
   METHOD SaveToFile( cFileName ); 
                           INLINE ( ::oRTF:SavetoFile( cFileName ) )

   METHOD LoadFromRTFFile( cFileName ) ;
                           INLINE ( ::oRTF:LoadFromRTFFile( cFileName ) )                           

   METHOD Paste()          INLINE ( ::oRTF:Paste() )
   METHOD Blod()           INLINE ( ::oClp:Clear(), ::oClp:SetText( "<b></b>" ), ::oRTF:Paste() )

   METHOD SetHTML()        INLINE ( ::oBtnBold:Hide() ,;
            								::oBtnItalics:Hide() ,;
            								::oBtnUnderLine:Hide() ,;
            								::oBtnTextAlignLeft:Hide() ,;
            								::oBtnTextAlignCenter :Hide() ,;
            								::oBtnTextAlignRight:Hide() ,;
            								::oBtnTextJustify:Hide() ,;
            								::oBtnBullet:Hide() ,;
            								::oBtnDateTime:Hide() )

   METHOD SetRTF()         INLINE ( ::oBtnBold:Show() ,;
            								::oBtnItalics:Show() ,;
            								::oBtnUnderLine:Show() ,;
            								::oBtnTextAlignLeft:Show() ,;
            								::oBtnTextAlignCenter :Show() ,;
            								::oBtnTextAlignRight:Show() ,;
            								::oBtnTextJustify:Show() ,;
            								::oBtnBullet:Show() ,;
            								::oBtnDateTime:Show() )

   METHOD end()            INLINE ( ::oRTF:oFont:end(), ::oRTF:end(), ::oRTF := nil )
   
END CLASS

//--------------------------------------------------------------------------//

   METHOD Redefine( id, oDlg ) CLASS GetRichEdit 

      DEFAULT id     := 600
      DEFAULT oDlg   := ::oDlg 

      DEFINE CLIPBOARD ::oClp OF oDlg FORMAT TEXT

      REDEFINE BTNBMP ::oBtnPrint ;
         ID       ( id ) ;
         WHEN     ( .t. ) ;
         OF       oDlg ;
         RESOURCE "IMP16" ;
         NOBORDER ;
         TOOLTIP  "Imprimir" ;

      ::oBtnPrint:bAction 	:= {|| ::oRTF:Print(), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnPreview ;
         ID       ( id + 1 ) ;
         WHEN     ( .t. ) ;
         OF       oDlg ;
         RESOURCE "PREV116" ;
         NOBORDER ;
         TOOLTIP  "Previsualizar" ;

      ::oBtnPreview:bAction := {|| ::oRTF:Preview( "Class TRichEdit" ) }

      REDEFINE BTNBMP ::oBtnSearch ;
         ID       ( id + 2 ) ;
         WHEN     ( .t. ) ;
         OF       oDlg ;
         RESOURCE "Bus16" ;
         NOBORDER ;
         TOOLTIP  "Buscar" ;
      
      ::oBtnSearch:bAction := {|| FindRich( ::oRTF ) } 

      REDEFINE BTNBMP ::oBtnCut ;
         ID       ( id + 3 ) ;
         WHEN     ( ! Empty( ::oRTF:GetSel() ) .and. ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "Cut_16" ;
         NOBORDER ;
         TOOLTIP  "Cortar" ;

      ::oBtnCut:bAction 	:= {|| ::oRTF:Cut(), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnCopy ;
         ID       ( id + 4 ) ;
         WHEN     ( ! Empty( ::oRTF:GetSel() ) ) ;
         OF       oDlg ;
         RESOURCE "Copy16" ;
         NOBORDER ;
         TOOLTIP  "Copiar" ;

      ::oBtnCopy:bAction	:= {|| ::oRTF:Copy(), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnPaste ;
         ID       ( id + 5 ) ;
         WHEN     ( ! Empty( ::oClp:GetText() ) .and. ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "Paste_16" ;
         NOBORDER ;
         TOOLTIP  "Pegar" ;

      ::oBtnPaste:bAction 	:= {|| ::oRTF:Paste(), ::oRTF:SetFocus() }         

      REDEFINE BTNBMP ::oBtnUndo ;
         ID       ( id + 6 ) ;
         WHEN     ( ::oRTF:SendMsg( EM_CANUNDO ) != 0 ) ;
         OF       oDlg ;
         RESOURCE "Undo1_16" ;
         NOBORDER ;
         TOOLTIP  "Deshacer" ;

      ::oBtnUndo:bAction 	:= {|| ::oRTF:Undo(), ::oRTF:SetFocus() }   

      REDEFINE BTNBMP ::oBtnRedo ;
         ID       ( id + 7 ) ;
         WHEN     ( ::oRTF:SendMsg( EM_CANREDO ) != 0 ) ;
         OF       oDlg ;
         RESOURCE "Redo_16" ;
         NOBORDER ;
         TOOLTIP  "Rehacer" ;

      ::oBtnRedo:bAction := {|| ::oRTF:Redo(), ::oRTF:SetFocus() }

      REDEFINE COMBOBOX ::oZoom ;
         VAR      ::cZoom ;
         ITEMS    ::aZoom ;
         ID       ( id + 8 ) ;
         OF       oDlg

      ::oZoom:bChange      := {|| ::oRTF:SetZoom( ::aRatio[ ::oZoom:nAt, 1 ], ::aRatio[ ::oZoom:nAt, 2 ] ), ::oRTF:SetFocus()  }
   
      REDEFINE COMBOBOX ::oFuente ;
         VAR      ::cFuente ;
         ITEMS    ::aFuente ;
         ID       ( id + 9 ) ;
         OF       oDlg

      ::oFuente:bChange    := {|| ::oRTF:SetFontName( ::oFuente:VarGet() ), ::oRTF:SetFocus() }

      REDEFINE COMBOBOX ::oSize ;
         VAR      ::cSize ;
         ITEMS    ::aSize ;
         ID       ( id + 10 ) ;
         OF       oDlg

      ::oSize:bChange      := {|| ::oRTF:SetFontSize( Val( ::oSize:VarGet() ) ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnBold ;
         ID       ( id + 11 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "Text_Bold" ;
         NOBORDER ;
         TOOLTIP  "Negrita" ;

      ::oBtnBold:bAction	:= {|| ( ::lBold  := !::lBold, ::oRTF:SetBold( ::lBold ), ::oRTF:SetFocus() ) }   

      REDEFINE BTNBMP ::oBtnItalics ;
         ID       ( id + 12 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "Text_Italics_16" ;
         NOBORDER ;
         TOOLTIP  "Cursiva" ;
         
      ::oBtnItalics:bAction 	:= {|| ( ::lItalic := !::lItalic, ::oRTF:SetItalic( ::lItalic ), ::oRTF:SetFocus() ) }

      REDEFINE BTNBMP ::oBtnUnderLine;
         ID       ( id + 13 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "Text_Underlined_16" ;
         NOBORDER ;
         TOOLTIP  "Subrayado" ;

      ::oBtnUnderLine:bAction 	:= {|| ( ::lUnderline := !::lUnderline, ::oRTF:SetUnderline( ::lUnderline ), ::oRTF:SetFocus() ) }

      REDEFINE BTNBMP ::oBtnTextAlignLeft ;
         ID       ( id + 14 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "Text_Align_Left_16" ;
         NOBORDER ;
         TOOLTIP  "Izquierda" ;

      ::oBtnTextAlignLeft:bAction 	:= {|| ::oRTF:SetAlign( PFA_LEFT ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnTextAlignCenter  ;
         ID       ( id + 15 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "Text_Center" ;
         NOBORDER ;
         TOOLTIP  "Centro" ;

      ::oBtnTextAlignCenter:bAction := {|| ::oRTF:SetAlign( PFA_CENTER ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnTextAlignRight ;
         ID       ( id + 16 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "Text_Align_Right_16" ;
         NOBORDER ;
         TOOLTIP  "Derecha" ;

      ::oBtnTextAlignRight:bAction 	:= {|| ::oRTF:SetAlign( PFA_RIGHT ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnTextJustify ;
         ID       ( id + 17 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "Text_Justified_16" ;
         NOBORDER ;
         TOOLTIP  "Justificado" ;

      ::oBtnTextJustify:bAction 	:= {|| ::oRTF:SetAlign( PFA_JUSTIFY ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnBullet ;
         ID       ( id + 18 ) ;
         WHEN     ( ! ::oRTF:lReadOnly .and. ! ::oRTF:GetNumbering() ) ;
         OF       oDlg ;
         RESOURCE "Pin_Blue_16" ;
         NOBORDER ;
         TOOLTIP  "Vi�etas" ;

      ::oBtnBullet:bAction 			:= {|| ::lBullet := !::lBullet, ::oRTF:SetBullet( ::lBullet ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnDateTime ;
         ID       ( id + 19 ) ;
         OF       oDlg ;
         RESOURCE "Calendar_16" ;
         NOBORDER ;
         TOOLTIP  "Fecha/Hora" ;

      ::oBtnDateTime:bAction 		:= {|| DateTimeRich( ::oRTF ) }

      REDEFINE RICHEDIT ::oRTF ;
         VAR      ::cRTF ;
         ID       ( id + 20 ) ;
         OF       oDlg

      ::oRTF:lHighLight 			:= .f.
      ::oRTF:bChange    			:= { || ::RTFRefreshButtons() }

   RETURN ( Self )

//--------------------------------------------------------------------------//

   METHOD RTFRefreshButtons() CLASS GetRichEdit 

      local aChar    := REGetCharFormat( ::oRTF:hWnd )
   
      ::lBold        := aChar[ 5 ] == FW_BOLD
      ::lItalic      := aChar[ 6 ]
      ::lUnderline   := aChar[ 7 ]
      ::lBullet      := REGetBullet( ::oRTF:hWnd )
   
      if ::oBtnCut:lWhen()
         ::oBtnCut:Enable()
      else
         ::oBtnCut:Disable()
      end if
   
      ::oBtnCut:Refresh()
   
      if ::oBtnCopy:lWhen()
         ::oBtnCopy:Enable()
      else
         ::oBtnCopy:Disable()
      end if
   
      ::oBtnCopy:Refresh()
   
   RETURN ( nil )

//---------------------------------------------------------------------------//




