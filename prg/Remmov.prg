#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

#define IDFOUND            3
#define _MENUITEM_         "01050"

memvar oDbf
memvar cDbf
memvar lEnd
memvar oThis
memvar cDbfCol
memvar oDbfCol
memvar cDbfPro
memvar cDbfFam
memvar cDbfMov
memvar cDbfArt
memvar cDbfAge
memvar nPagina
memvar nTotMov
memvar cPouDivRem
memvar cPorDivRem

static oRemesas
static oMenu

static cTmpLin
static dbfTmpLin

static dbfRemMov
static dbfHisMov
static dbfTMov
static dbfAge
static dbfArticulo
static dbfCount
static dbfPro
static dbfTblPro
static dbfAlbCliT
static dbfAlbCliL
static dbfFacCliT
static dbfFacCliL


//---------------------------------------------------------------------------//

CLASS TRemMovAlm FROM TMasDet

   DATA  oArt
   DATA  oArtKit
   DATA  oUsr
   DATA  oDbfDoc
   DATA  oDbfCnt
   DATA  oDelega
   DATA  aCal
   DATA  cMru              INIT  "Pencil_Package_16"
   DATA  cBitmap           INIT  Rgb( 128, 57, 123 )
   DATA  oAlmacenOrigen
   DATA  oAlmacenDestino
   DATA  oFam
   DATA  oTipArt
   DATA  oPro
   DATA  oTblPro
   DATA  oArtCom
   DATA  oTMov
   DATA  oStock

   DATA  oPedPrvT
   DATA  oPedPrvL
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oAlbPrvS
   DATA  oFacPrvT
   DATA  oFacPrvL
   DATA  oFacPrvS
   DATA  oRctPrvT
   DATA  oRctPrvL
   DATA  oRctPrvS
   DATA  oPedCliT
   DATA  oPedCliL
   DATA  oPedCliR
   DATA  oAlbCliT
   DATA  oAlbCliL
   DATA  oAlbCliS
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oFacCliS
   DATA  oFacRecT
   DATA  oFacRecL
   DATA  oFacRecS
   DATA  oTikCliT
   DATA  oTikCliL
   DATA  oTikCliS
   DATA  oHisMov
   DATA  oHisMovS
   DATA  oDbfAge
   DATA  oDbfBar
   DATA  oDbfEmp

   DATA  oAlmOrg
   DATA  oAlmDes
   DATA  oCodMov
   DATA  oFecRem
   DATA  oTimRem
   DATA  oSufRem
   DATA  oNumRem

   DATA  oCodAge

   DATA  oDbfProLin
   DATA  oDbfProMat
   DATA  oDbfProSer
   DATA  oDbfMatSer

   DATA  cText
   DATA  oSender
   DATA  lSelectSend
   DATA  lSelectRecive
   DATA  cIniFile
   DATA  lSuccesfullSend

   DATA  lReclculado                                     INIT .f.

   DATA  nNumberSend                                     INIT  0
   DATA  nNumberRecive                                   INIT  0

   DATA  oDlgImport
   DATA  lFamilia                                        INIT  .t.
   DATA  oFamiliaInicio
   DATA  cFamiliaInicio
   DATA  oFamiliaFin
   DATA  cFamiliaFin

   DATA  lArticulo                                       INIT  .t.
   DATA  oArticuloInicio
   DATA  cArticuloInicio
   DATA  oArticuloFin
   DATA  cArticuloFin

   DATA  lTipoArticulo                                   INIT  .t.
   DATA  oTipoArticuloInicio
   DATA  cTipoArticuloInicio
   DATA  oTipoArticuloFin
   DATA  cTipoArticuloFin

   DATA  oMtrStock
   DATA  nMtrStock

   DATA  oMeter
   DATA  nMeter

   DATA  oRadTipoMovimiento

   DATA  lOpenFiles                                      INIT  .f.

   DATA  oBtnKit
   DATA  oBtnImportarInventario

   DATA  oDetMovimientos
   DATA  oDetSeriesMovimientos

   DATA  memoInventario
   DATA  aInventarioErrors                               INIT  {}

   METHOD New( cPath, cDriver, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Initiate( cText, oSender )                     CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD OpenService( lExclusive )
   METHOD CloseService()
   METHOD CloseIndex()

   METHOD Reindexa( oMeter )

   METHOD GetNewCount()

   METHOD DefineFiles()
   METHOD DefineCalculate()

   METHOD Resource( nMode )
   METHOD Activate()

   METHOD AppendDet( oDlg )
   METHOD EditDetalleMovimientos( oDlg )
   METHOD DeleteDet( oDlg )

   METHOD lSave()
   METHOD RecalcularPrecios()                            INLINE   ( ::oDetMovimientos:RecalcularPrecios(), ::oBrwDet:Refresh() )

   METHOD ShwAlm( oSay, oBtnImp )

   METHOD nTotRemMov( lPic )

   METHOD Search()

   METHOD lSelAll( lSel )

   METHOD lSelAllMov( lSel )                             VIRTUAL
   METHOD lSelMov()

   METHOD lSelAllDoc( lSel )
   METHOD lSelDoc()

   METHOD cTextoMovimiento()                             INLINE   { "Entre almacenes", "Regularizaci�n", "Objetivos", "Consolidaci�n" }[ Min( Max( ( ::oDbf:nArea )->nTipMov, 1 ), 4 ) ]

   METHOD LoadAlmacen( nMode )
   METHOD ImportAlmacen( nMode, oDlg )

   METHOD nClrText()

   METHOD ShowKit( lSet )

   METHOD DataReport( oFr )
   METHOD VariableReport( oFr )
   METHOD DesignReportRemMov( oFr, dbfDoc )
   METHOD PrintReportRemMov( nDevice, nCopies, cPrinter, dbfDoc )

   METHOD GenRemMov( lPrinter, cCaption, cCodDoc, cPrinter )
   METHOD bGenRemMov( lImprimir, cTitle, cCodDoc )
   METHOD lGenRemMov( oBrw, oBtn, lImp )
   METHOD EPage( oInf, cCodDoc )

   METHOD Save()
   METHOD Load()

   METHOD nGetNumberToSend()
   METHOD SetNumberToSend()   INLINE   WritePProString( "Numero", ::cText, cValToChar( ::nNumberSend ), ::cIniFile )
   METHOD IncNumberToSend()   INLINE   WritePProString( "Numero", ::cText, cValToChar( ++::nNumberSend ), ::cIniFile )

   METHOD CreateData()
   METHOD RestoreData()
   METHOD SendData()
   METHOD ReciveData()
   METHOD Process()

   METHOD cMostrarSerie() 

   METHOD Report()            INLINE   TInfRemMov():New( "Remesas de movimientos", , , , , , { ::oDbf, ::oDetMovimientos:oDbf, ::oArt } ):Play()

   METHOD ActualizaStockWeb( cNumDoc )

   METHOD GenerarEtiquetas()

   METHOD importarInventario()

   METHOD porcesarInventario()

   METHOD showInventarioErrors()

   METHOD procesarArticuloInventario( cInventario )

   METHOD insertaArticuloRemesaMovimiento( cCodigo, nUnidades )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem ) CLASS TRemMovAlm

   DEFAULT cPath           := cPatEmp()
   DEFAULT cDriver         := cDriver()
   DEFAULT oWndParent      := oWnd()
   DEFAULT oMenuItem       := "01050"

   ::nLevel                := nLevelUsr( oMenuItem )

   ::cPath                 := cPath
   ::cDriver               := cDriver
   ::oWndParent            := oWndParent
   ::oDbf                  := nil

   ::lAutoActions          := .f.

   ::cNumDocKey            := "nNumRem"
   ::cSufDocKey            := "cSufRem"

   ::cPicUnd               := MasUnd()

   ::bFirstKey             := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem }
   ::bWhile                := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDetMovimientos:oDbf:nNumRem, 9 ) + ::oDetMovimientos:oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof() }

   ::oDetMovimientos       := TDetMovimientos():New( cPath, cDriver, Self )
   ::addDetail( ::oDetMovimientos )

   ::oDetSeriesMovimientos := TDetSeriesMovimientos():New( cPath, cDriver, Self )
   ::AddDetail( ::oDetSeriesMovimientos )

   ::oDetSeriesMovimientos:bOnPreSaveDetail  := {|| ::oDetSeriesMovimientos:SaveDetails() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Initiate( cText, oSender ) CLASS TRemMovAlm

   ::cText              := cText
   ::oSender            := oSender
   ::cIniFile           := cPatEmp() + "Empresa.Ini"
   ::lSuccesfullSend    := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD GetNewCount() CLASS TRemMovAlm

   ::oDbf:nNumRem       := nNewDoc( nil, ::oDbf:nArea, "nMovAlm", nil, ::oDbfCnt:nArea )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TRemMovAlm

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE DATABASE ::oDbf FILE "REMMOVT.DBF" CLASS "TRemMovT" ALIAS "RemMovT" PATH ( cPath ) VIA ( cDriver ) COMMENT "Movimientos de almac�n"

      FIELD NAME "lSelDoc"             TYPE "L" LEN  1  DEC 0                                                                                COMMENT ""                                HIDE  OF ::oDbf
      FIELD CALCULATE NAME "Send16"             LEN  1  DEC 0                             VAL {|| ::oDbf:lSelDoc } BITMAPS "Sel16", "Nil16"  COMMENT { "Enviar", "Lbl16" , 3 } COLSIZE 20    OF ::oDbf
      FIELD NAME "nNumRem"             TYPE "N" LEN  9  DEC 0 PICTURE "999999999"         DEFAULT  0                                         COMMENT "N�mero"           COLSIZE 80           OF ::oDbf
      FIELD NAME "cSufRem"             TYPE "C" LEN  2  DEC 0 PICTURE "@!"                DEFAULT  RetSufEmp()                               COMMENT "Delegaci�n"       COLSIZE 40           OF ::oDbf
      FIELD NAME "nTipMov"             TYPE "N" LEN  1  DEC 0                                                                                COMMENT "Tipo del movimiento"             HIDE  OF ::oDbf
      FIELD CALCULATE NAME "cTipMov"            LEN 12  DEC 0                             VAL ( ::cTextoMovimiento() )                       COMMENT "Tipo"             COLSIZE 90           OF ::oDbf
      FIELD NAME "cCodUsr"             TYPE "C" LEN  3  DEC 0                             DEFAULT  cCurUsr()                                 COMMENT "C�digo usuario"                  HIDE  OF ::oDbf
      FIELD NAME "cCodDlg"             TYPE "C" LEN  2  DEC 0                                                                                COMMENT ""                                HIDE  OF ::oDbf
      FIELD NAME "cCodAge"             TYPE "C" LEN  3  DEC 0                                                                                COMMENT "C�digo agente"                   HIDE  OF ::oDbf
      FIELD NAME "cCodMov"             TYPE "C" LEN  2  DEC 0                                                                                COMMENT "Tipo de movimiento"              HIDE  OF ::oDbf
      FIELD NAME "dFecRem"             TYPE "D" LEN  8  DEC 0                             DEFAULT  Date()                                    COMMENT "Fecha"            COLSIZE 80           OF ::oDbf
      FIELD NAME "cTimRem"             TYPE "C" LEN  6  DEC 0 PICTURE "@R 99:99:99"       DEFAULT  getSysTime()                              COMMENT "Hora"             COLSIZE 60           OF ::oDbf
      FIELD NAME "cAlmOrg"             TYPE "C" LEN 16  DEC 0 PICTURE "@!"                                                                   COMMENT "Alm. org."        COLSIZE 60           OF ::oDbf
      FIELD CALCULATE NAME "cNomAlmOrg"         LEN 20  DEC 0 PICTURE "@!"                VAL ( oRetFld( ( ::oDbf:nArea )->cAlmOrg, ::oAlmacenOrigen, "cNomAlm" ) )                              HIDE  OF ::oDbf
      FIELD NAME "cAlmDes"             TYPE "C" LEN 16  DEC 0 PICTURE "@!"                                                                   COMMENT "Alm. des."        COLSIZE 60           OF ::oDbf
      FIELD CALCULATE NAME "cNomAlmDes"         LEN 20  DEC 0 PICTURE "@!"                VAL ( oRetFld( ( ::oDbf:nArea )->cAlmDes, ::oAlmacenDestino, "cNomAlm" ) )                              HIDE  OF ::oDbf
      FIELD NAME "cCodDiv"             TYPE "C" LEN  3  DEC 0 PICTURE "@!"                HIDE                                               COMMENT "Div."                                  OF ::oDbf
      FIELD NAME "nVdvDiv"             TYPE "N" LEN 13  DEC 6 PICTURE "@E 999,999.999999" HIDE                                               COMMENT "Cambio de la divisa"                   OF ::oDbf
      FIELD NAME "cComMov"             TYPE "C" LEN 100 DEC 0 PICTURE "@!"                                                                   COMMENT "Comentario"       COLSIZE 240          OF ::oDbf
      FIELD NAME "nTotRem"             TYPE "N" LEN 16  DEC 6 PICTURE "@E 999,999,999,999.99"   ALIGN RIGHT                                  COMMENT "Importe"          COLSIZE 100          OF ::oDbf

      INDEX TO "RemMovT.Cdx" TAG "cNumRem"   ON "Str( nNumRem ) + cSufRem"   COMMENT "N�mero"   NODELETED OF ::oDbf
      INDEX TO "RemMovT.Cdx" TAG "dFecRem"   ON "Dtos( dFecRem ) + cTimRem"  COMMENT "Fecha"    NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//
//
// Campos calculados
//

METHOD DefineCalculate() CLASS TRemMovAlm 

   ::aCal  := {}

   aAdd( ::aCal, { "( RetFld( ( cDbfCol )->cRefMov, cDbfArt, 'Nombre' ) )",   "C",100, 0, "Nombre art�culo",  "",             "" } )
   aAdd( ::aCal, { "nTotNMovAlm( oDbfCol )",                                  "N", 16, 6, "Total unidades",   "cPorDivRem",   "" } )
   aAdd( ::aCal, { "nTotLMovAlm( oDbfCol )",                                  "N", 16, 6, "Total importe",    "cPorDivRem",   "" } )

RETURN ( ::aCal )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TRemMovAlm 

   local oSnd
   local oDel
   local oImp
   local oPrv

   if nAnd( ::nLevel, 1 ) == 0

      /*
      Cerramos todas las ventanas----------------------------------------------
      */

      if ::oWndParent != nil
         ::oWndParent:CloseAll()
      end if

      ::CreateShell( ::nLevel )

      // ::oWndBrw:oBrw:bDup  := nil

      DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B";

         ::oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecAdd() );
         ON DROP  ( ::oWndBrw:RecAdd() );
         TOOLTIP  "(A)�adir";
         BEGIN GROUP ;
         HOTKEY   "A" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "DUP" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDup() );
         TOOLTIP  "(D)uplicar";
         HOTKEY   "D" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecZoom() );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z" ;
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL oDel RESOURCE "DEL" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

         DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( ::Del( .t., .f. ), ::oWndBrw:Refresh() );
            TOOLTIP  "Solo cabecera" ;
            FROM     oDel ;
            CLOSED ;
            LEVEL    ACC_DELE

         DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( ::Del( .f., .t. ), ::oWndBrw:Refresh() );
            TOOLTIP  "Solo detalle" ;
            FROM     oDel ;
            CLOSED ;
            LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "IMP" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Report() ) ;
         TOOLTIP  "(L)istado" ;
         HOTKEY   "L" ;
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL oImp RESOURCE "IMP" OF ::oWndBrw ;
         ACTION   ( ::GenRemMov( .t. ) ) ;
			TOOLTIP 	"(I)mprimir";
         HOTKEY   "I";
         LEVEL    ACC_IMPR

      ::lGenRemMov( ::oWndBrw:oBrw, oImp, .t. )

      DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF ::oWndBrw ;
         ACTION   ( ::GenRemMov( .f. ) ) ;
         TOOLTIP  "(P)revisualizar";
         HOTKEY   "P";
         LEVEL    ACC_IMPR

      ::lGenRemMov( ::oWndBrw:oBrw, oPrv, .f. )

      DEFINE BTNSHELL RESOURCE "RemoteControl_" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::GenerarEtiquetas() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL oSnd RESOURCE "LBL" OF ::oWndBrw ;
         ACTION   ( ::lSelMov(), ::oWndBrw:Refresh() );
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "LBL" OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( ::lSelAll( .t. ) );
            TOOLTIP  "Todos" ;
            FROM     oSnd ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "LBL" OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( ::lSelAll( .f. ) );
            TOOLTIP  "Ninguno" ;
            FROM     oSnd ;
            LEVEL    ACC_EDIT

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TRemMovAlm 

   local oError
   local oBlock               

   DEFAULT lExclusive         := .f.

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !::lOpenFiles

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

      DATABASE NEW ::oDelega     PATH ( cPatDat() ) FILE "Delega.Dbf"      VIA ( cDriver() ) SHARED INDEX "Delega.Cdx"

      DATABASE NEW ::oUsr        PATH ( cPatDat() ) FILE "Users.Dbf"       VIA ( cDriver() ) SHARED INDEX "Users.Cdx"

      DATABASE NEW ::oTMov       PATH ( cPatDat() ) FILE "TMOV.DBF"        VIA ( cDriver() ) SHARED INDEX "TMov.Cdx"

      DATABASE NEW ::oAlmacenOrigen    FILE "ALMACEN.DBF"   ALIAS "ALMACEN"   PATH ( cPatAlm() )   VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

      DATABASE NEW ::oAlmacenDestino   FILE "ALMACEN.DBF"   ALIAS "ALMACEN"   PATH ( cPatAlm() )   VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

      DATABASE NEW ::oArtCom     FILE "ARTDIV.DBF"    ALIAS "ARTDIV"    PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"

      DATABASE NEW ::oPro        FILE "PRO.DBF"       ALIAS "PRO"       PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "PRO.CDX"

      DATABASE NEW ::oTblPro     FILE "TBLPRO.DBF"    ALIAS "TBLPRO"    PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "TBLPRO.CDX"

      DATABASE NEW ::oFam        FILE "FAMILIAS.DBF"  ALIAS "FAMILIAS"  PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

      DATABASE NEW ::oArt        FILE "ARTICULO.DBF"  ALIAS "ARTICULO"  PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oArtKit     FILE "ARTKIT.DBF"    ALIAS "ARTKIT"    PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

      DATABASE NEW ::oDbfAge     FILE "AGENTES.DBF"  PATH ( cPatCli() )   VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

      DATABASE NEW ::oPedPrvT    FILE "PEDPROVT.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

      DATABASE NEW ::oPedPrvL    FILE "PEDPROVL.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"
      ::oPedPrvL:SetOrder( "cRef" )

      DATABASE NEW ::oAlbPrvT    FILE "ALBPROVT.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

      DATABASE NEW ::oAlbPrvL    FILE "ALBPROVL.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"
      ::oAlbPrvL:SetOrder( "cRef" )

      DATABASE NEW ::oAlbPrvS    FILE "AlbPrvS.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "AlbPrvS.CDX"

      DATABASE NEW ::oFacPrvT    FILE "FACPRVT.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

      DATABASE NEW ::oFacPrvL    FILE "FACPRVL.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"
      ::oFacPrvL:SetOrder( "cRef" )

      DATABASE NEW ::oFacPrvS    FILE "FACPRVS.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "FACPRVS.CDX"

      DATABASE NEW ::oRctPrvT    FILE "RctPrvT.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "RctPrvT.CDX"

      DATABASE NEW ::oRctPrvL    FILE "RctPrvL.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "RctPrvL.CDX"
      ::oRctPrvL:SetOrder( "cRef" )

      DATABASE NEW ::oRctPrvS    FILE "RctPrvS.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "RctPrvS.CDX"

      ::oPedCliT := TDataCenter():oPedCliT()

      DATABASE NEW ::oPedCliL    PATH ( cPatEmp() ) FILE "PedCliL.DBF" VIA ( cDriver() ) SHARED INDEX "PedCliL.CDX"
      ::oPedCliL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oPedCliR    PATH ( cPatEmp() ) FILE "PedCliR.DBF" VIA ( cDriver() ) SHARED INDEX "PedCliR.CDX"

      ::oAlbCliT := TDataCenter():oAlbCliT()

      DATABASE NEW ::oAlbCliL    PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
      ::oAlbCliL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oAlbCliS    PATH ( cPatEmp() ) FILE "ALBCLIS.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIS.CDX"

      ::oFacCliT := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL    PATH ( cPatEmp() ) FILE "FacCliL.DBF" VIA ( cDriver() ) SHARED INDEX "FacCliL.CDX"
      ::oFacCliL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oFacCliS    PATH ( cPatEmp() ) FILE "FacCliS.DBF" VIA ( cDriver() ) SHARED INDEX "FacCliS.CDX"

      DATABASE NEW ::oFacRecT    PATH ( cPatEmp() ) FILE "FacRecT.DBF" VIA ( cDriver() ) SHARED INDEX "FacRecT.CDX"

      DATABASE NEW ::oFacRecL    PATH ( cPatEmp() ) FILE "FacRecL.DBF" VIA ( cDriver() ) SHARED INDEX "FacRecL.CDX"
      ::oFacRecL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oFacRecS    PATH ( cPatEmp() ) FILE "FacRecS.DBF" VIA ( cDriver() ) SHARED INDEX "FacRecS.CDX"

      DATABASE NEW ::oTikCliT    PATH ( cPatEmp() ) FILE "TikeT.DBF" VIA ( cDriver() ) SHARED INDEX "TikeT.CDX"

      DATABASE NEW ::oTikCliL    PATH ( cPatEmp() ) FILE "TikeL.DBF" VIA ( cDriver() ) SHARED INDEX "TikeL.CDX"
      ::oTikCliL:OrdSetFocus( "cCbaTil" )

      DATABASE NEW ::oTikCliS    PATH ( cPatEmp() ) FILE "TikeS.DBF"       VIA ( cDriver() ) SHARED INDEX "TikeS.CDX"

      DATABASE NEW ::oHisMov     PATH ( cPatEmp() ) FILE "HisMov.DBF"      VIA ( cDriver() ) SHARED INDEX "HisMov.CDX"
      ::oHisMov:OrdSetFocus( "cRefMov" )

      DATABASE NEW ::oHisMovS    PATH ( cPatEmp() ) FILE "MovSer.Dbf"      VIA ( cDriver() ) SHARED INDEX "MovSer.Cdx"

      DATABASE NEW ::oDbfBar     PATH ( cPatArt() ) FILE "ArtCodebar.Dbf"  VIA ( cDriver() ) SHARED INDEX "ArtCodebar.Cdx"

      DATABASE NEW ::oDbfDoc     PATH ( cPatEmp() ) FILE "RDocumen.Dbf"    VIA ( cDriver() ) SHARED INDEX "RDocumen.Cdx"
      ::oDbfDoc:OrdSetFocus( "cTipo" )

      DATABASE NEW ::oDbfCnt     PATH ( cPatEmp() ) FILE "nCount.Dbf"      VIA ( cDriver() ) SHARED INDEX "nCount.Cdx"

      DATABASE NEW ::oDbfEmp     PATH ( cPatDat() ) FILE "EMPRESA.DBF"     VIA ( cDriver() ) SHARED INDEX "EMPRESA.CDX"

      DATABASE NEW ::oDbfProLin  PATH ( cPatEmp() ) FILE "PROLIN.DBF"      VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

      DATABASE NEW ::oDbfProMat  PATH ( cPatEmp() ) FILE "PROMAT.DBF"      VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

      DATABASE NEW ::oDbfProSer  PATH ( cPatEmp() ) FILE "ProSer.Dbf"      VIA ( cDriver() ) SHARED INDEX "ProSer.Cdx"

      DATABASE NEW ::oDbfMatSer  PATH ( cPatEmp() ) FILE "MatSer.Dbf"      VIA ( cDriver() ) SHARED INDEX "MatSer.Cdx"

      ::oTipArt           := TTipArt():Create( cPatArt() )
      ::oTipArt:OpenFiles()

      ::oStock             := TStock():Create( cPatGrp() )
      if !::oStock:lOpenFiles()
         ::lOpenFiles      := .f.
      end if

      ::lLoadDivisa()

      ::nView              := D():CreateView() 

      D():ArticuloPrecioPropiedades( ::nView )

      D():PropiedadesLineas( ::nView )

      D():Propiedades( ::nView )

      D():Documentos( ::nView ) 

      ::lOpenFiles         := .t.

   end if

   RECOVER USING oError

      ::lOpenFiles         := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !::lOpenFiles
      ::CloseFiles()
   end if

RETURN ( ::lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRemMovAlm 

   ::CloseDetails()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if ::oAlmacenOrigen != nil .and. ::oAlmacenOrigen:Used()
      ::oAlmacenOrigen:End()
   end if

   if ::oAlmacenDestino != nil .and. ::oAlmacenDestino:Used()
      ::oAlmacenDestino:End()
   end if

   if ::oArt != nil .and. ::oArt:Used()
      ::oArt:End()
   end if

   if ::oArtKit != nil .and. ::oArtKit:Used()
      ::oArtKit:End()
   end if

   if ::oFam != nil .and. ::oFam:Used()
      ::oFam:End()
   end if

   if ::oPro != nil .and. ::oPro:Used()
      ::oPro:End()
   end if

   if ::oTblPro != nil .and. ::oTblPro:Used()
      ::oTblPro:End()
   end if

   if ::oArtCom != nil .and. ::oArtCom:Used()
      ::oArtCom:End()
   end if

   if ::oTMov != nil .and. ::oTMov:Used()
      ::oTMov:End()
   end if

   if ::oPedPrvT != nil .and. ::oPedPrvT:Used()
      ::oPedPrvT:End()
   end if

   if ::oPedPrvL != nil .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if

   if ::oAlbPrvT != nil .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if ::oAlbPrvL != nil .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if ::oAlbPrvS != nil .and. ::oAlbPrvS:Used()
      ::oAlbPrvS:End()
   end if

   if ::oFacPrvT != nil .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if ::oFacPrvL != nil .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if ::oFacPrvS != nil .and. ::oFacPrvS:Used()
      ::oFacPrvS:End()
   end if

   if ::oRctPrvT != nil .and. ::oRctPrvT:Used()
      ::oRctPrvT:End()
   end if

   if ::oRctPrvL != nil .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if

   if ::oRctPrvS != nil .and. ::oRctPrvS:Used()
      ::oRctPrvS:End()
   end if

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliR ) .and. ::oPedCliR:Used()
      ::oPedCliR:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oAlbCliS ) .and. ::oAlbCliS:Used()
      ::oAlbCliS:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oFacCliS ) .and. ::oFacCliS:Used()
      ::oFacCliS:End()
   end if

   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if

   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oTikCliS ) .and. ::oTikCliS:Used()
      ::oTikCliS:End()
   end if

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if ::oStock != nil
      ::oStock:End()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if ::oDbfAge != nil .and. ::oDbfAge:Used()
      ::oDbfAge:End()
   end if

   if ::oDbfBar != nil .and. ::oDbfBar:Used()
      ::oDbfBar:End()
   end if

   if ::oDelega != nil .and. ::oDelega:Used()
      ::oDelega:End()
   end if

   if ::oUsr != nil .and. ::oUsr:Used()
      ::oUsr:End()
   end if

   if ::oDbfDoc != nil .and. ::oDbfDoc:Used()
      ::oDbfDoc:End()
   end if

   if ::oDbfCnt != nil .and. ::oDbfCnt:Used()
      ::oDbfCnt:End()
   end if

   if ::oDbfEmp != nil .and. ::oDbfEmp:Used()
      ::oDbfEmp:End()
   end if

   if ::oDbfProLin != nil .and. ::oDbfProLin:Used()
      ::oDbfProLin:End()
   end if

   if ::oDbfProMat != nil .and. ::oDbfProMat:Used()
      ::oDbfProMat:End()
   end if

   if ::oDbfProSer != nil .and. ::oDbfProSer:Used()
      ::oDbfProSer:End()
   end if

   if ::oDbfMatSer != nil .and. ::oDbfMatSer:Used()
      ::oDbfMatSer:End()
   end if

   if ::oBandera != nil
      ::oBandera:End()
   end if

   if !empty( ::oTipArt )
      ::oTipArt:end()
   end if

   if !isNil( ::nView )
      D():DeleteView( ::nView )
   end if 

   ::oDbf               := nil
   ::oAlmacenOrigen     := nil
   ::oAlmacenDestino    := nil
   ::oArt               := nil
   ::oArtKit            := nil
   ::oFam               := nil
   ::oPro               := nil
   ::oTblPro            := nil
   ::oArtCom            := nil
   ::oTMov              := nil
   ::oStock             := nil
   ::oAlbPrvT           := nil
   ::oAlbPrvL           := nil
   ::oAlbPrvS           := nil
   ::oFacPrvT           := nil
   ::oRctPrvT           := nil
   ::oRctPrvL           := nil
   ::oPedCliT           := nil
   ::oPedCliL           := nil
   ::oPedCliR           := nil
   ::oAlbCliT           := nil
   ::oAlbCliL           := nil
   ::oFacCliT           := nil
   ::oFacCliL           := nil
   ::oTikCliT           := nil
   ::oTikCliL           := nil
   ::oHisMov            := nil
   ::oDbfDiv            := nil
   ::oDbfAge            := nil
   ::oDbfBar            := nil
   ::oDbfDoc            := nil
   ::oTipArt            := nil
   ::oDbfEmp            := nil
   ::oDbfProLin         := nil
   ::oDbfProMat         := nil

   ::oBandera           := nil

   ::lOpenFiles         := .f.

   ::nView              := nil 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TRemMovAlm 

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

   RECOVER USING oError

      lOpen             := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de remesas de movimientos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TRemMovAlm

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::CloseDetails()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseIndex() CLASS TRemMovAlm  

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:OrdListClear()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TRemMovAlm

   local oDlg
   local oSay        := Array( 7 )
   local cSay        := Array( 7 )
   local oBtnImp
   local oBmpGeneral

   // Ordeno oDbfVir por el numero de linea------------------------------------

   ::oDetMovimientos:oDbfVir:OrdSetFocus( "nNumLin" )

   if nMode == APPD_MODE
      ::oDbf:lSelDoc := .t.
      ::oDbf:cCodUsr := cCurUsr()
      ::oDbf:cCodDlg := oRetFld( cCurUsr(), ::oUsr, "cCodDlg" )
   end if

   cSay[ 1 ]         := oRetFld( ::oDbf:cAlmOrg, ::oAlmacenOrigen )
   cSay[ 2 ]         := oRetFld( ::oDbf:cAlmDes, ::oAlmacenDestino )
   cSay[ 3 ]         := oRetFld( ::oDbf:cCodMov, ::oTMov )
   cSay[ 5 ]         := oRetFld( cCodEmp() + ::oDbf:cCodDlg, ::oDelega, "cNomDlg" )
   cSay[ 6 ]         := Rtrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, 2 ) ) + ", " + Rtrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, 3 ) )
   cSay[ 7 ]         := oRetFld( ::oDbf:cCodUsr, ::oUsr )

   DEFINE DIALOG oDlg RESOURCE "RemMov" TITLE LblTitle( nMode ) + "movimientos de almac�n"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "movimiento_almacen_48_alpha" ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET ::oNumRem VAR ::oDbf:nNumRem ;
			ID 		100 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "nNumRem" ):cPict ;
			OF 		oDlg

      REDEFINE GET ::oSufRem VAR ::oDbf:cSufRem ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "cSufRem" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oFecRem VAR ::oDbf:dFecRem ;
         ID       120 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oTimRem VAR ::oDbf:cTimRem ;
         ID       121 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ( ::oDbf:FieldByName( "cTimRem" ):cPict );
         VALID    ( iif(   !validTime( ::oDbf:cTimRem  ),;
                           ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                           .t. ) );
         OF       oDlg

      REDEFINE GET ::oDbf:cCodUsr ;
         ID       220 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         ID       230 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET ::oDbf:cCodDlg ;
         ID       240 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
         ID       250 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE RADIO ::oRadTipoMovimiento ;
         VAR      ::oDbf:nTipMov ;
         ID       130, 131, 132, 133 ;
         WHEN     ( nMode == APPD_MODE ) ; // .and. Empty( ::oDetMovimientos:oDbfVir:OrdKeyCount()
         ON CHANGE( ::ShwAlm( oSay, oBtnImp ) ) ;
         OF       oDlg

      REDEFINE GET ::oCodMov VAR ::oDbf:cCodMov ;
         ID       140 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oCodMov:bValid     := {|| cTMov( ::oCodMov, ::oTMov:cAlias, oSay[ 3 ] ) }
      ::oCodMov:bHelp      := {|| BrwTMov( ::oCodMov, ::oTMov:cAlias, oSay[ 3 ] ) }

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] UPDATE ;
         ID       141 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE SAY oSay[ 4 ] PROMPT "Almac�n origen" ;
         ID       152 ;
         OF       oDlg

      REDEFINE GET ::oAlmOrg VAR ::oDbf:cAlmOrg UPDATE ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oDbf:FieldByName( "cAlmOrg" ):cPict ;
         BITMAP   "LUPA" ;
			OF 		oDlg
      ::oAlmOrg:bValid     := {|| cAlmacen( ::oAlmOrg, ::oAlmacenOrigen:cAlias, oSay[1] ) }
      ::oAlmOrg:bHelp      := {|| BrwAlmacen( ::oAlmOrg, oSay[1] ) }

      REDEFINE GET oSay[ 1 ] VAR cSay[ 1 ] ;
         UPDATE ;
         ID       151 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET ::oAlmDes VAR ::oDbf:cAlmDes UPDATE ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oDbf:FieldByName( "cAlmDes" ):cPict ;
         BITMAP   "LUPA" ;
			OF 		oDlg

      ::oAlmDes:bValid     := {|| cAlmacen( ::oAlmDes, ::oAlmacenDestino:cAlias, oSay[2] ) }
      ::oAlmDes:bHelp      := {|| BrwAlmacen( ::oAlmDes, oSay[2] ) }

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] UPDATE ;
         ID       161 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      ::oDefDiv( 190, 191, 192, oDlg, nMode )

      REDEFINE GET ::oDbf:cComMov ;
         ID       170 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oCodAge VAR ::oDbf:cCodAge;
         ID       210;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

         ::oCodAge:bValid  := {|| cAgentes( ::oCodAge, ::oDbfAge:cAlias, oSay[ 6 ] ) }
         ::oCodAge:bHelp   := {|| BrwAgentes( ::oCodAge, oSay[ 6 ] ) }

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
         ID       211;
         WHEN     .f.;
         OF       oDlg

       /*
       Botones de acceso________________________________________________________________
       */

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !Empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::AppendDet( oDlg ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !Empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::EditDetalleMovimientos( oDlg ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !Empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::DeleteDet() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::Search() )

      REDEFINE BUTTON ;
         ID       507 ;
         OF       oDlg ;
         WHEN     ( nMode == APPD_MODE ) ;
         ACTION   ( ::lSelDoc() )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oDlg ;
         WHEN     ( nMode == APPD_MODE ) ;
         ACTION   ( ::lSelAll( .t. ) )

      REDEFINE BUTTON ;
         ID       505 ;
         OF       oDlg ;
         WHEN     ( nMode == APPD_MODE ) ;
         ACTION   ( ::lSelAll( .f. ) )

      REDEFINE BUTTON ::oBtnKit ;
         ID       508 ;
         OF       oDlg ;
         ACTION   ( ::ShowKit( .t. ) )

      REDEFINE BUTTON ::oBtnImportarInventario ;
         ID       509 ;
         OF       oDlg ;
         ACTION   ( ::importarInventario() )

      REDEFINE BUTTON oBtnImp ;
         ID       506 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !Empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::ImportAlmacen( nMode, oDlg ) )

      ::oBrwDet               := IXBrowse():New( oDlg )

      ::oBrwDet:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwDet:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwDet:nMarqueeStyle := 6
      ::oBrwDet:lHScroll      := .f.
      ::oBrwDet:lFooter       := .t.
      if nMode != ZOOM_MODE
         ::oBrwDet:bLDblClick := {|| ::EditDetalleMovimientos( oDlg ) }
      end if

      ::oBrwDet:cName         := "Detalle movimientos de almac�n"

      ::oDetMovimientos:oDbfVir:SetBrowse( ::oBrwDet )

      ::oBrwDet:CreateFromResource( 180 )

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Se.  Seleccionado"
         :bStrData      := {|| "" }
         :bEditValue    := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "lSelDoc" ) }
         :nWidth        := 24
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "N�mero"
         :bStrData      := {|| if( ::oDetMovimientos:oDbfVir:FieldGetByName( "lKitEsc" ), "", Trans( ::oDetMovimientos:oDbfVir:FieldGetByName( "nNumLin" ), "@EZ 9999" ) ) }
         :nWidth        := 60
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "C�digo"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cRefMov" ) }
         :nWidth        := 100
         :cSortOrder    := "cRefMov"
         :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Nombre"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cNomMov" ) }
         :nWidth        := 300
         :cSortOrder    := "cNomMov"
         :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Prop. 1"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cValPr1" ) }
         :nWidth        := 40
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Prop. 2"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cValPr2" ) }
         :nWidth        := 40
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader       := "Nombre propiedad 1"
         :bEditValue    := {|| nombrePropiedad( ::oDetMovimientos:oDbfVir:FieldGetByName( "cCodPr1" ), ::oDetMovimientos:oDbfVir:FieldGetByName( "cValPr1" ), ::nView ) }
         :nWidth        := 60
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader       := "Nombre propiedad 2"
         :bEditValue    := {|| nombrePropiedad( ::oDetMovimientos:oDbfVir:FieldGetByName( "cCodPr2" ), ::oDetMovimientos:oDbfVir:FieldGetByName( "cValPr2" ), ::nView ) }
         :nWidth        := 60
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Lote"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cLote" ) }
         :nWidth        := 80
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Serie"
         :bStrData      := {|| ::cMostrarSerie() }
         :nWidth        := 80
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Unidades"
         :bEditValue    := {|| nTotNMovAlm( ::oDetMovimientos:oDbfVir ) }
         :bFooter       := {|| ::oDetMovimientos:nTotUnidadesVir( .t. ) }
         :cEditPicture  := ::cPicUnd
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Unidades ant."
         :bEditValue    := {|| nTotNMovOld( ::oDetMovimientos:oDbfVir ) }
         :cEditPicture  := ::cPicUnd
         :lHide         := .t.
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with
      
   if !oUser():lNotCostos()

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Importe"
         :bEditValue    := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "nPreDiv" ) }
         :cEditPicture  := ::cPinDiv
         :nWidth        := 100
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Total"
         :bEditValue    := {|| nTotLMovAlm( ::oDetMovimientos:oDbfVir ) }
         :bFooter       := {|| ::oDetMovimientos:nTotRemVir( .t. ) }
         :cEditPicture  := ::cPirDiv
         :nWidth        := 100
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

   end if      

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Total peso"
         :bEditValue    := {|| ( nTotNMovAlm( ::oDetMovimientos:oDbfVir ) * ::oDetMovimientos:oDbfVir:nPesoKg ) }
         :bFooter       := {|| ::oDetMovimientos:nTotPesoVir() }
         :cEditPicture  := MasUnd()
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Total volumen"
         :bEditValue    := {|| ( nTotNMovAlm( ::oDetMovimientos:oDbfVir ) * ::oDetMovimientos:oDbfVir:nVolumen ) }
         :bFooter       := {|| ::oDetMovimientos:nTotVolumenVir() }
         :cEditPicture  := MasUnd()
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
         :lHide         := .t.
      end with

      ::nMeter          := 0
      ::oMeter          := TApoloMeter():ReDefine( 400, { | u | if( pCount() == 0, ::nMeter, ::nMeter := u ) }, 10, oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if  ( ::lSave( nMode ),;
                        ( ::EndResource( .t., nMode, oDlg ), oDlg:End( IDOK ) ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

      REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         ACTION   ( ::RecalcularPrecios() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| ::AppendDet( oDlg ) } )
         oDlg:AddFastKey( VK_F3, {|| ::EditDetalleMovimientos( oDlg ) } )
         oDlg:AddFastKey( VK_F4, {|| ::DeleteDet() } )
         oDlg:AddFastKey( VK_F5, {|| if( ::lSave( nMode ), ( ::EndResource( .t., nMode, oDlg ), oDlg:End( IDOK ) ), ) } )
      end if

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Movimientosalmacen" ) } )

      oDlg:bStart := {|| ::ShwAlm( oSay, oBtnImp ), ::ShowKit( .f. ), ::oBrwDet:Load() }

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:End()

   if oDlg:nResult != IDOK
      ::EndResource( .f., nMode )
   end if

   /*
   Guardamos los datos del browse----------------------------------------------
   */

   ::oBrwDet:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD Search() CLASS TRemMovAlm

	local oDlg
	local oIndice
   local cIndice  := "C�digo"
   local aIndice  := { "C�digo", "Nombre" }
	local oCadena
   local xCadena  := space( 100 )
   local nOrdAnt  := ::oDetMovimientos:oDbfVir:OrdSetFocus( "cRefMov" )

   DEFINE DIALOG oDlg RESOURCE "sSearch"

	REDEFINE GET oCadena VAR xCadena ;
      ID          100 ;
      OF          oDlg
      
      oCadena:bChange   := {|| oCadena:Assign(), ::oDetMovimientos:oDbfVir:Seek( Rtrim( xCadena ), .t. ), ::oBrwDet:Refresh() }

	REDEFINE COMBOBOX oIndice ;
      VAR         cIndice ;
      ITEMS       aIndice ;
      ID          101 ;
      OF          oDlg

   oIndice:bChange      := {||   ::oDetMovimientos:oDbfVir:OrdSetFocus( if( oIndice:nAt == 1, "cRefMov", "cNomMov" ) ),;
                                 ::oBrwDet:Refresh(),;
                                 oCadena:SetFocus(),;
                                 oCadena:SelectAll() }

	REDEFINE BUTTON ;
		ID 		   510 ;
		OF          oDlg ;
      ACTION      ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

   ::oDetMovimientos:oDbfVir:OrdSetFocus( nOrdAnt )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD lSave( nMode ) CLASS TRemMovAlm

   if Empty( ::oDbf:cCodAge ) .and. lRecogerAgentes()
      MsgStop( "C�digo de agente no puede estar vac�o." )
      ::oCodAge:SetFocus()
      Return .f.
   end if

   if ::oDbf:nTipMov == 1

      if Empty( ::oDbf:cAlmOrg )
         MsgStop( "Almac�n origen no puede estar vac�o." )
         ::oAlmOrg:SetFocus()
         Return .f.
      end if

      if ::oDbf:cAlmDes == ::oDbf:cAlmOrg
         MsgStop( "Almac�n origen y destino no pueden ser iguales." )
         ::oAlmOrg:SetFocus()
         Return .f.
      end if

   else

      if Empty( ::oDbf:cAlmDes )
         MsgStop( "Almac�n destino no puede estar vac�o." )
         ::oAlmDes:SetFocus()
         Return .f.
      end if

   end if

   if !::oDetMovimientos:oDbfVir:LastRec() > 0
      MsgStop( "No puede hacer un movimiento de almac�n sin l�neas." )
      Return .f.
   end if

   /*
   Guardamos el valor del total------------------------------------------------
   */

   ::oDbf:nTotRem    := ::oDetMovimientos:nTotRemVir()

   /*
   Colocamos los valores del meter---------------------------------------------
   */

   ::oMeter:nTotal   := ::nRegisterToProcess()

Return .t.

//---------------------------------------------------------------------------//

METHOD GenRemMov( lPrinter, cCaption, cCodDoc, cPrinter, nCopies ) CLASS TRemMovAlm

   local oInf
   local oDevice
   local nNumRem

   DEFAULT lPrinter     := .f.
   DEFAULT cCaption     := "Imprimiendo remesas de movimientos"
   DEFAULT cCodDoc      := cFormatoDocumento(   nil, "nMovAlm", ::oDbfCnt:cAlias )
   DEFAULT nCopies      := nCopiasDocumento(    nil, "nMovAlm", ::oDbfCnt:cAlias )

   if ::oDbf:Lastrec() == 0
      return nil
   end if

   if Empty( cCodDoc )
      cCodDoc           := "RM1"
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( ::nView ) )
      return nil
   end if

   nNumRem              := Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem

   private oThis        := Self

   ::oDbf:GetStatus( .t. )

   ::oDbf:Seek( nNumRem )
   ::oDetMovimientos:oDbf:Seek( nNumRem )
   ::oDetSeriesMovimientos:oDbf:Seek( nNumRem )

   ::oDbfAge:Seek( ::oDbf:cCodAge )

   if lVisualDocumento( cCodDoc, D():Documentos( ::nView ) )

      public nTotMov       := ::nTotRemMov( .t. )

      ::PrintReportRemMov( if( lPrinter, IS_PRINTER, IS_SCREEN ), nCopies, cPrinter, D():Documentos( ::nView ) )

   else

      msgStop( "El documento " + cCodDoc + " no es un formato valido.", "Formato obsoleto" )

   end if

   ::oDbf:SetStatus()

Return Nil

//----------------------------------------------------------------------------//

METHOD EPage( oInf, cCodDoc ) CLASS TRemMovAlm 

	private nPagina		:= oInf:nPage
	private lEnd			:= oInf:lFinish

   PrintItems( cCodDoc, oInf )

Return ( Self )

//----------------------------------------------------------------------------//

Function aDocRemMov()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Almac�n",               "AL" } )
   aAdd( aDoc, { "Divisas",               "DV" } )
   aAdd( aDoc, { "Remesas movimientos",   "RM" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

METHOD lSelAll( lSel ) CLASS TRemMovAlm 

   local nOrdAnt        := ::oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   DEFAULT lSel         := .t.

   ::oDbf:GetStatus()
   ::oDetMovimientos:oDbf:GetStatus()

   ::oDbf:GoTop()
   while !::oDbf:Eof()

      /*
      Marcamos la cabecera-----------------------------------------------------
      */

      ::oDbf:Load()
      ::oDbf:lSelDoc := lSel
      ::oDbf:Save()

      /*
      Marcamos las lineas------------------------------------------------------
      */

      ::oDetMovimientos:oDbf:GoTop()

      if ::oDetMovimientos:oDbf:Seek( Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem )

         while Str( ::oDetMovimientos:oDbf:nNumRem ) + ::oDetMovimientos:oDbf:cSufRem == Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof()

            ::oDetMovimientos:oDbf:fieldPutByName( "lSndDoc", ::oDbf:lSelDoc )

            ::oDetMovimientos:oDbf:Skip()

         end while

      end if

      ::oDbf:Skip()

   end while

   ::oDbf:SetStatus()

   ::oDetMovimientos:oDbf:SetStatus()

   ::oDetMovimientos:oDbf:OrdSetFocus( nOrdAnt )

   if !Empty( ::oWndBrw )
      ::oWndBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

METHOD lSelMov() CLASS TRemMovAlm 

   local nOrdAnt  := ::oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   ::oDbf:Load()
   ::oDbf:lSelDoc := !::oDbf:lSelDoc
   ::oDbf:Save()

   ::oDetMovimientos:oDbf:GetStatus()

   ::oDetMovimientos:oDbf:GoTop()

   if ::oDetMovimientos:oDbf:Seek( Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem )

      while Str( ::oDetMovimientos:oDbf:nNumRem ) + ::oDetMovimientos:oDbf:cSufRem == Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof()

         ::oDetMovimientos:oDbf:Load()
         ::oDetMovimientos:oDbf:lSndDoc    := ::oDbf:lSelDoc
         ::oDetMovimientos:oDbf:Save()

         ::oDetMovimientos:oDbf:Skip()

      end while

   end if

   ::oDetMovimientos:oDbf:SetStatus()

   ::oDetMovimientos:oDbf:OrdSetFocus( nOrdAnt )

Return( .t. )

//---------------------------------------------------------------------------//

METHOD CreateData() CLASS TRemMovAlm 

   local lSnd        := .t.
   local oRemMov
   local oRemMovTmp
   local cFileName

   if ::oSender:lServer
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando movimientos de almac�n" )

   oRemMov           := TRemMovAlm():New( cPatEmp(), cDriver() )
   oRemMov:OpenService()

   oRemMov:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   // Creamos todas las bases de datos relacionadas con Articulos

   oRemMovTmp        := TRemMovAlm():New( cPatSnd(), cLocalDriver() )
   oRemMovTmp:OpenService()

   oRemMovTmp:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   // Creamos todas las bases de datos relacionadas con Articulos

   while !oRemMov:oDbf:eof()

      if oRemMov:oDbf:lSelDoc

         lSnd  := .t.

         dbPass( oRemMov:oDbf:nArea, oRemMovTmp:oDbf:nArea, .t. )

         ::oSender:SetText( alltrim( str( oRemMov:oDbf:nNumRem, 9 ) ) + "/" + oRemMov:oDbf:cSufRem )

         if oRemMov:oDetMovimientos:oDbf:Seek( str( oRemMov:oDbf:nNumRem, 9 ) + oRemMov:oDbf:cSufRem )

            while Str( oRemMov:oDbf:nNumRem, 9 ) + oRemMov:oDbf:cSufRem == Str( oRemMov:oDetMovimientos:oDbf:nNumRem, 9 ) + oRemMov:oDetMovimientos:oDbf:cSufRem .and. !oRemMov:oDetMovimientos:oDbf:Eof()
               dbPass( oRemMov:oDetMovimientos:oDbf:nArea, oRemMovTmp:oDetMovimientos:oDbf:nArea, .t. )
               oRemMov:oDetMovimientos:oDbf:Skip()
            end while

         end if

      end if

      oRemMov:oDbf:Skip()

   end while

   /*
   Cerrar ficheros temporales--------------------------------------------------
   */

   oRemMov:CloseService()
   oRemMov:End()

   oRemMovTmp:CloseService()
   oRemMovTmp:End()

   if lSnd

      /*
      Comprimir los archivos
      */

      ::oSender:SetText( "Comprimiendo movimientos de almac�n" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos en " + Rtrim( cFileName ) )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay movimientos de almac�n para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD RestoreData() CLASS TRemMovAlm 

   local oRemMov

   if ::lSuccesfullSend

      oRemMov  := TRemMovAlm():Create( cPatEmp() )
      oRemMov:OpenService()

      oRemMov:oDbf:GoTop()

      while !oRemMov:oDbf:Eof()

         if oRemMov:oDbf:lSelDoc
            oRemMov:oDbf:Load()
            oRemMov:oDbf:lSelDoc := .f.
            oRemMov:oDbf:Save()
         end if

         oRemMov:oDbf:Skip()

      end while

      oRemMov:CloseService()

      oRemMov:End()

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD SendData() CLASS TRemMovAlm 

   local cFileName

   if ::oSender:lServer
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if file( cPatOut() + cFileName )

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::lSuccesfullSend := .t.
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero enviado " + cFileName )
      else
         ::oSender:SetText( "ERROR fichero no enviado" )
      end if

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD ReciveData() CLASS TRemMovAlm 

   local n
   local aExt

   if ::oSender:lServer
      aExt        := aRetDlgEmp()
   else
      aExt        := { "All" }
   end if

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo movimientos de almac�n" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "MovAlm*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Movimientos de almac�n recibidos" )

Return Self

//----------------------------------------------------------------------------//

METHOD Process() CLASS TRemMovAlm

   local m
   local oAlm
   local oBlock
   local oError
   local oRemMov
   local oRemMovTmp
   local dbfRemMovTmp
   local dbfRemMovFix
   local aFiles               := Directory( cPatIn() )

   DATABASE NEW oAlm PATH ( cPatAlm() ) FILE "ALMACEN.DBF" VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Importando movimientos de almac�n" )

   for m := 1 to len( aFiles )

      oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      /*
      descomprimimos el fichero
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         /*
         Ficheros temporales---------------------------------------------------
         */

         ::oSender:SetText( "Procesando fichero " + cPatIn() + aFiles[ m, 1 ] )

         if file( cPatSnd() + "RemMovT.Dbf" )

            oRemMovTmp        := TRemMovAlm():New( cPatSnd(), cLocalDriver() )
            oRemMovTmp:OpenService( .f. )

            oRemMovTmp:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

            oRemMov           := TRemMovAlm():New( cPatEmp(), cDriver() )
            oRemMov:OpenService()

            oRemMov:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

            dbfRemMovTmp      := oRemMovTmp:oDbf:cAlias
            dbfRemMovFix      := oRemMov:oDbf:cAlias

            /*
            Ponemos los valores de las delegaciones----------------------------
            */

            oRemMovTmp:oDbf:GoTop()
            while !oRemMovTmp:oDbf:Eof()

               if Empty( oRemMovTmp:oDbf:cSufRem )
                  oRemMovTmp:oDbf:FieldPutByName( "cSufRem", "00" )
               end if 

               oRemMovTmp:oDbf:Skip()

            end while 

            oRemMovTmp:oDetMovimientos:oDbf:GoTop()
            while !oRemMovTmp:oDetMovimientos:oDbf:Eof()

               if Empty( oRemMovTmp:oDetMovimientos:oDbf:cSufRem )
                  oRemMovTmp:oDetMovimientos:oDbf:FieldPutByName( "cSufRem", "00" )
               end if 

               oRemMovTmp:oDetMovimientos:oDbf:Skip()

            end while 

            /*
            Trasbase de turnos-------------------------------------------------------
            */

            oRemMovTmp:oDbf:GoTop()
            while !oRemMovTmp:oDbf:eof()

               do case
               case oAlm:Seek( oRemMovTmp:oDbf:cAlmOrg ) .and. oAlm:Seek( oRemMovTmp:oDbf:cAlmDes )

                  if oRemMov:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem )
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .f. )
                     ::oSender:SetText( "Reemplazado : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  else
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .t. )
                     ::oSender:SetText( "A�adido     : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  end if

               case oAlm:Seek( oRemMovTmp:oDbf:cAlmOrg ) .and. !oAlm:Seek( oRemMovTmp:oDbf:cAlmDes )

                  if oRemMov:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem )
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .f. )
                     ::oSender:SetText( "Reemplazado : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  else
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .t. )
                     ::oSender:SetText( "A�adido     : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  end if

                  ::oSender:SetText( "No existe almacen destino : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  oRemMov:oDbf:FieldPutByName( "cAlmDes", Space( 16 ) )

               case !oAlm:Seek( oRemMovTmp:oDbf:cAlmOrg ) .and. oAlm:Seek( oRemMovTmp:oDbf:cAlmDes ) //

                  if oRemMov:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem )
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .f. )
                     ::oSender:SetText( "Reemplazado : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  else
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .t. )
                     ::oSender:SetText( "A�adido     : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  end if

                  ::oSender:SetText( "No existe almacen origen : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  oRemMov:oDbf:FieldPutByName( "cAlmOrg", Space( 16 ) )

               end case

               /*
               Vaciamos las lineas---------------------------------------------
               */

               if oRemMovTmp:oDbf:nNumRem != 0
                  while oRemMov:oDetMovimientos:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem ) .and. !oRemMov:oDetMovimientos:oDbf:eof()
                     oRemMov:oDetMovimientos:oDbf:Delete(.f.)
                  end while
               end if

               /*
               Trasbase de lineas de turnos------------------------------------
               */

               if oRemMovTmp:oDetMovimientos:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem )

                  while Str( oRemMovTmp:oDetMovimientos:oDbf:nNumRem, 9 ) + oRemMovTmp:oDetMovimientos:oDbf:cSufRem == Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem .and. !oRemMovTmp:oDetMovimientos:oDbf:eof()

                     do case
                     case oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAliMov ) .and. oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAloMov )

                        dbPass( oRemMovTmp:oDetMovimientos:oDbf:cAlias, oRemMov:oDetMovimientos:oDbf:cAlias, .t. )

                     case !oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAliMov ) .and. oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAloMov )

                        dbPass( oRemMovTmp:oDetMovimientos:oDbf:cAlias, oRemMov:oDetMovimientos:oDbf:cAlias, .t. )
                        oRemMov:oDetMovimientos:oDbf:FieldPutByName( "cAliMov", Space( 16 ) )

                     case oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAliMov ) .and. !oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAloMov )

                        dbPass( oRemMovTmp:oDetMovimientos:oDbf:cAlias, oRemMov:oDetMovimientos:oDbf:cAlias, .t. )
                        oRemMov:oDetMovimientos:oDbf:FieldPutByName( "cAloMov", Space( 16 ) )

                     end case

                     oRemMovTmp:oDetMovimientos:oDbf:Skip()

                  end while

               end if

               oRemMovTmp:oDbf:Skip()

            end while

            /*
            Finalizando--------------------------------------------------------
            */

            oRemMov:CloseService()
            oRemMov:End()

            oRemMovTmp:CloseService()
            oRemMovTmp:End()

            ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

         else

            ::oSender:SetText( "Faltan ficheros" )

            if !File( cPatSnd() + "RemMovT.Dbf" )
               ::oSender:SetText( "Falta " + cPatSnd() + "RemMovT.Dbf" )
            end if

         end if

      end if

       RECOVER USING oError

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

   if !Empty( oAlm ) .and. oAlm:Used()
      oAlm:End()
   end if

Return Self

//----------------------------------------------------------------------------//

METHOD nGetNumberToSend() CLASS TRemMovAlm

   ::nNumberSend     := GetPvProfInt( "Numero", ::cText, ::nNumberSend, ::cIniFile )

Return ( ::nNumberSend )

//----------------------------------------------------------------------------//

METHOD Save() CLASS TRemMovAlm

   WritePProString( "Envio",     ::cText, cValToChar( ::lSelectSend ), ::cIniFile )
   WritePProString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Load() CLASS TRemMovAlm

   ::lSelectSend     := ( Upper( GetPvProfString( "Envio",     ::cText, cValToChar( ::lSelectSend ),   ::cIniFile ) ) == ".T." )
   ::lSelectRecive   := ( Upper( GetPvProfString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile ) ) == ".T." )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD lGenRemMov( oBrw, oBtn, lImp ) CLASS TRemMovAlm

   local bAction

   DEFAULT lImp   := .f.

   if !( D():Documentos( ::nView ) )->( dbSeek( "RM" ) )

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ( D():Documentos( ::nView ) )->cTipo == "RM" .AND. !( D():Documentos( ::nView ) )->( eof() )

         bAction  := ::bGenRemMov( lImp, "Imprimiendo movimientoo de almac�n", ( D():Documentos( ::nView ) )->Codigo )

         ::oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( D():Documentos( ::nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( ::nView ) )->( dbskip() )

      end do

   end if

RETURN nil

//---------------------------------------------------------------------------//

METHOD bGenRemMov( lImprimir, cTitle, cCodDoc ) CLASS TRemMovAlm

   local bGen
   local lImp  := by( lImprimir )
   local cTit  := by( cTitle    )
   local cCod  := by( cCodDoc   )

   bGen        := {|| ::GenRemMov( lImp, cTit, cCod ) }

RETURN ( bGen )

//---------------------------------------------------------------------------//

METHOD Reindexa() CLASS TRemMovAlm

   if Empty( ::oDbf )
      ::oDbf      := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   ::oDbf:Activate( .f., .t., .f. )

   ::oDbf:Pack()

   ::oDbf:End()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD AppendDet( oDlg ) CLASS TRemMovAlm 

   local nDetalle

   while .t.

      ::oDetMovimientos:oDbfVir:Blank()

      nDetalle    := ::oDetMovimientos:Resource( APPD_MODE )

      do case
      case nDetalle == IDOK

         ::oDetMovimientos:oDbfVir:Insert()
         ::oDetMovimientos:AppendKit()

         if !empty( ::oBrwDet )
            ::oBrwDet:Refresh()
         end if 

         if lEntCon()
            loop
         else
            exit
         end if

      case nDetalle == IDFOUND

         ::oDetMovimientos:oDbfVir:Cancel()

         if !empty( ::oBrwDet )
            ::oBrwDet:Refresh()
         end if 

         if lEntCon()
            loop
         else
            exit
         end if

      case nDetalle == IDCANCEL

         ::oDetMovimientos:oDbfVir:Cancel()

         if !empty( ::oBrwDet )
            ::oBrwDet:Refresh()
         end if 

         exit

      end if

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EditDetalleMovimientos( oDlg ) CLASS TRemMovAlm 

   if ::oDetMovimientos:oDbfVir:OrdKeyCount() == 0
      Return ( Self )
   end if

   ::oDetMovimientos:oDbfVir:Load()

   if ::oDetMovimientos:Resource( EDIT_MODE ) == IDOK
      ::oDetMovimientos:oDbfVir:Save()
   else 
      ::oDetMovimientos:oDbfVir:Cancel()
   end if

   if !empty( ::oBrwDet )
      ::oBrwDet:Refresh()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteDet() CLASS TRemMovAlm 

   local nNum
   local nNumLin
   local nNumRec
   local nMarked
   local cTxtDel

   if ::oDetMovimientos:oDbfVir:OrdKeyCount() == 0
      Return ( Self )
   end if

   nMarked           := len( ::oBrwDet:aSelected )
   if nMarked > 1
      cTxtDel        := "� Desea eliminar definitivamente " + AllTrim( Str( nMarked, 3 ) ) + " registros ?"
   else
      cTxtDel        := "� Desea eliminar el registro en curso ?"
   end if

   if oUser():lNotConfirmDelete() .or.  ApoloMsgNoYes(cTxtDel, "Confirme supersi�n" )

      for each nNum in ( ::oBrwDet:aSelected )

         ::oDetMovimientos:oDbfVir:GoTo( nNum )

         nNumLin        := ::oDetMovimientos:oDbfVir:nNumLin
         nNumRec        := ::oDetMovimientos:oDbfVir:Recno()

         /*
         Ahora voy a borrar los registros de los escandallos-------------------
         */

         ::oDetMovimientos:oDbfVir:GoTop()

         while !::oDetMovimientos:oDbfVir:Eof()
            if !Empty( nNumLin ) .and. ( ::oDetMovimientos:oDbfVir:nNumLin == nNumLin )
               ::oDetMovimientos:oDbfVir:Delete(.f.)
            end if
            ::oDetMovimientos:oDbfVir:Skip()
         end while

         ::oDetMovimientos:oDbfVir:GoTo( nNumRec )

         /*
         Ahora el registro padre-----------------------------------------------
         */

         ::oDetMovimientos:oDbfVir:Delete()

         ::oBrwDet:Refresh()

      next

   end if

   if ::oDetMovimientos:oDbfVir:OrdKeyCount() == 0
      ::oRadTipoMovimiento:Enable()
   end if

   ::oBrwDet:Select()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ImportAlmacen( nMode, oDlg ) CLASS TRemMovAlm 

   // oDlg:Disable()

   ::cFamiliaInicio        := dbFirst( ::oFam, 1 )
   ::cFamiliaFin           := dbLast ( ::oFam, 1 )
   ::cArticuloInicio       := dbFirst( ::oArt, 1 )
   ::cArticuloFin          := dbLast ( ::oArt, 1 )
   ::cTipoArticuloInicio   := dbFirst( ::oTipArt:oDbf, 1 )
   ::cTipoArticuloFin      := dbLast ( ::oTipArt:oDbf, 1 )

   DEFINE DIALOG ::oDlgImport RESOURCE "ImportAlmacen"

      REDEFINE CHECKBOX ::lFamilia ;
         ID       200 ;
         OF       ::oDlgImport ;

      REDEFINE GET ::oFamiliaInicio VAR ::cFamiliaInicio ;
         ID       210 ;
         IDTEXT   220 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lFamilia ) ;
         OF       ::oDlgImport ;

      ::oFamiliaInicio:bValid    := {|| cFamilia( ::oFamiliaInicio, ::oFam:cAlias, ::oFamiliaInicio:oHelpText ) }
      ::oFamiliaInicio:bHelp     := {|| brwFamilia( ::oFamiliaInicio, ::oFamiliaInicio:oHelpText ) }

      REDEFINE GET ::oFamiliaFin VAR ::cFamiliaFin ;
         ID       230 ;
         IDTEXT   240 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lFamilia ) ;
         OF       ::oDlgImport ;

      ::oFamiliaFin:bValid       := {|| cFamilia( ::oFamiliaFin, ::oFam:cAlias, ::oFamiliaFin:oHelpText ) }
      ::oFamiliaFin:bHelp        := {|| brwFamilia( ::oFamiliaFin, ::oFamiliaFin:oHelpText ) }

      REDEFINE CHECKBOX ::lTipoArticulo ;
         ID       370 ;
         OF       ::oDlgImport ;

      REDEFINE GET ::oTipoArticuloInicio VAR ::cTipoArticuloInicio ;
         ID       350 ;
         IDTEXT   351 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lTipoArticulo ) ;
         OF       ::oDlgImport ;

      ::oTipoArticuloInicio:bValid    := {|| ::oTipArt:lValid( ::oTipoArticuloInicio, ::oTipoArticuloInicio:oHelpText ) }
      ::oTipoArticuloInicio:bHelp     := {|| ::oTipArt:Buscar( ::oTipoArticuloInicio ) }

      REDEFINE GET ::oTipoArticuloFin VAR ::cTipoArticuloFin ;
         ID       360 ;
         IDTEXT   361 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lTipoArticulo ) ;
         OF       ::oDlgImport ;

      ::oTipoArticuloFin:bValid       := {|| ::oTipArt:lValid( ::oTipoArticuloFin, ::oTipoArticuloFin:oHelpText ) }
      ::oTipoArticuloFin:bHelp        := {|| ::oTipArt:Buscar( ::oTipoArticuloFin ) }

      REDEFINE CHECKBOX ::lArticulo ;
         ID       300 ;
         OF       ::oDlgImport ;

      REDEFINE GET ::oArticuloInicio VAR ::cArticuloInicio ;
         ID       310 ;
         IDTEXT   320 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lArticulo ) ;
         OF       ::oDlgImport ;

      ::oArticuloInicio:bValid    := {|| cArticulo( ::oArticuloInicio, ::oArt:cAlias, ::oArticuloInicio:oHelpText ) }
      ::oArticuloInicio:bHelp     := {|| brwArticulo( ::oArticuloInicio, ::oArticuloInicio:oHelpText ) }

      REDEFINE GET ::oArticuloFin VAR ::cArticuloFin ;
         ID       330 ;
         IDTEXT   340 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lArticulo ) ;
         OF       ::oDlgImport ;

      ::oArticuloFin:bValid       := {|| cArticulo( ::oArticuloFin, ::oArt:cAlias, ::oArticuloFin:oHelpText ) }
      ::oArticuloFin:bHelp        := {|| brwArticulo( ::oArticuloFin, ::oArticuloFin:oHelpText ) }

      REDEFINE APOLOMETER ::oMtrStock ;
         VAR      ::nMtrStock ;
         PROMPT   "" ;
         ID       400 ;
         OF       ::oDlgImport

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlgImport ;
         ACTION   ( ::loadAlmacen( nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlgImport ;
         ACTION   ( ::oDlgImport:End() )

   ::oDlgImport:bStart  := {|| ::oFamiliaInicio:lValid(), ::oFamiliaFin:lValid(), ::oArticuloInicio:lValid(), ::oArticuloFin:lValid(), ::oTipoArticuloInicio:lValid(), ::oTipoArticuloFin:lValid() }

   ::oDlgImport:AddFastKey( VK_F5, {|| ::loadAlmacen( nMode ) } )

   ACTIVATE DIALOG ::oDlgImport CENTER

   // oDlg:Enable()

Return nil

//---------------------------------------------------------------------------//

METHOD loadAlmacen( nMode ) CLASS TRemMovAlm 

   local nPreMed
   local cCodFam
   local cCodAlm
   local cCodTip
   local sStkAlm
   local aStkAlm
   local nNumLin

   CursorWait()

   ::oDlgImport:Disable()

   cCodAlm              := ::oDbf:cAlmDes

   if ( nMode == APPD_MODE ) .and. ( ::oDbf:nTipMov >= 2 )

      ::oMtrStock:cText    := "Importando art�culos "
      ::oMtrStock:nTotal   := ::oArt:OrdKeyCount() 
      
      ::oMtrStock:Refresh()

      ::oArt:GoTop()
      while !::oArt:eof()

      if ( ::lFamilia      .or. ( ::oArt:Familia >= ::cFamiliaInicio        .and. ::oArt:Familia <= ::cFamiliaFin ) )      .and.;
         ( ::lTipoArticulo .or. ( ::oArt:cCodTip >= ::cTipoArticuloInicio   .and. ::oArt:cCodTip <= ::cTipoArticuloFin ) ) .and.;
         ( ::lArticulo     .or. ( ::oArt:Codigo >= ::cArticuloInicio        .and. ::oArt:Codigo <= ::cArticuloFin ) )

         aStkAlm           := ::oStock:aStockArticulo( ::oArt:Codigo, cCodAlm )

         for each sStkAlm in aStkAlm

            if sStkAlm:nUnidades != 0

               if  ::oDetMovimientos:oDbfVir:Append()
   
                  ::oDetMovimientos:oDbfVir:Blank()
      
                  ::oDetMovimientos:oDbfVir:lSelDoc   := .t.
      
                  ::oDetMovimientos:oDbfVir:cRefMov   := sStkAlm:cCodigo
                  ::oDetMovimientos:oDbfVir:cNomMov   := RetArticulo( sStkAlm:cCodigo, ::oArt:cAlias )
                  ::oDetMovimientos:oDbfVir:cCodPr1   := sStkAlm:cCodigoPropiedad1
                  ::oDetMovimientos:oDbfVir:cCodPr2   := sStkAlm:cCodigoPropiedad2
                  ::oDetMovimientos:oDbfVir:cValPr1   := sStkAlm:cValorPropiedad1
                  ::oDetMovimientos:oDbfVir:cValPr2   := sStkAlm:cValorPropiedad2
                  ::oDetMovimientos:oDbfVir:cLote     := sStkAlm:cLote
                  ::oDetMovimientos:oDbfVir:nUndAnt   := sStkAlm:nUnidades
      
                  ::oDetMovimientos:oDbfVir:nNumRem   := ::oDbf:nNumRem
                  ::oDetMovimientos:oDbfVir:cSufRem   := ::oDbf:cSufRem
                  
                  nNumLin                             := nLastNum( ::oDetMovimientos:oDbfVir:cAlias )
                  ::oDetMovimientos:oDbfVir:nNumLin   := nNumLin
      
                  ::oDetMovimientos:oDbfVir:dFecMov   := ::oDbf:dFecRem
                  ::oDetMovimientos:oDbfVir:cTimMov   := ::oDbf:cTimRem
   
                  ::oDetMovimientos:oDbfVir:nTipMov   := ::oDbf:nTipMov
                  ::oDetMovimientos:oDbfVir:cCodMov   := ::oDbf:cCodMov
                  ::oDetMovimientos:oDbfVir:cAliMov   := ::oDbf:cAlmDes
                  ::oDetMovimientos:oDbfVir:cAloMov   := Space( 16 )

                  if !Empty( sStkAlm:cNumeroSerie )

                     ::oDetSeriesMovimientos:oDbfVir:Append()

                     ::oDetSeriesMovimientos:oDbfVir:Blank()

                     ::oDetSeriesMovimientos:oDbfVir:nNumRem   := ::oDbf:nNumRem
                     ::oDetSeriesMovimientos:oDbfVir:cSufRem   := ::oDbf:cSufRem
                     ::oDetSeriesMovimientos:oDbfVir:dFecRem   := ::oDbf:dFecRem
                     ::oDetSeriesMovimientos:oDbfVir:nNumLin   := nNumLin
                     ::oDetSeriesMovimientos:oDbfVir:cCodArt   := sStkAlm:cCodigo
                     ::oDetSeriesMovimientos:oDbfVir:cAlmOrd   := ::oDbf:cAlmDes
                     ::oDetSeriesMovimientos:oDbfVir:cNumSer   := sStkAlm:cNumeroSerie

                     ::oDetSeriesMovimientos:oDbfVir:Save()

                  end if

                  ::oDetMovimientos:oDbfVir:nUndMov   := 0
      
                  if !uFieldEmpresa( "lCosAct" )
      
                     nPreMed                          := ::oStock:nPrecioMedioCompra( sStkAlm:cCodigo, cCodAlm, nil, GetSysDate() )
      
                     if nPreMed == 0
                        nPreMed                       := nCosto( sStkAlm:cCodigo, ::oArt:cAlias, ::oArtKit:cAlias )
                     end if
      
                  else
      
                     nPreMed                          := nCosto( sStkAlm:cCodigo, ::oArt:cAlias, ::oArtKit:cAlias )
   
                  end if
      
                  ::oDetMovimientos:oDbfVir:nPreDiv    := nPreMed
      
                  ::oDetMovimientos:oDbfVir:Save()
      
               end if
            
            end if

         next
      
      end if
   
      ::oArt:Skip()
   
      ::oMtrStock:Set( ::oArt:OrdKeyNo() ) 
   
      end while

   end if

   ::oDetMovimientos:oDbfVir:GoTop()
   
   ::oBrwDet:Refresh()
   
   ::oMtrStock:Set( ::oArt:OrdKeyCount() )

   ::oDlgImport:Enable()
   ::oDlgImport:End()

   CursorWE()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nClrText() CLASS TRemMovAlm 

   local cClr

   if ::oDbfVir:lKitEsc
      cClr     := CLR_GRAY
   else
      cClr     := CLR_BLACK
   end if

RETURN cClr

//---------------------------------------------------------------------------//

METHOD ShowKit( lSet ) CLASS TRemMovAlm 

   local lShwKit     := lShwKit()

   if lSet
      lShwKit        := !lShwKit
   end if

   if lShwKit
      SetWindowText( ::oBtnKit:hWnd, "Mostrar Esc&ll." )
      ::oDetMovimientos:oDbfVir:SetFilter( "!lKitEsc" )
   else
      SetWindowText( ::oBtnKit:hWnd, "Ocultar Esc&ll." )
      ::oDetMovimientos:oDbfVir:KillFilter()
   end if

   if lSet
      lShwKit( lShwKit )
   end if

   ::oBrwDet:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ShwAlm( oSay, oBtnImp ) CLASS TRemMovAlm 

   if ::oDbf:nTipMov >= 2
      oSay[ 1 ]:Hide()
      oSay[ 4 ]:Hide()
      ::oAlmOrg:Hide()
      oSay[ 1 ]:cText( Space(16) )
      ::oAlmOrg:cText( Space(16) )
      if !Empty( oBtnImp )
         oBtnImp:Show()
      end if
   else
      oSay[ 1 ]:Show()
      oSay[ 4 ]:Show()
      ::oAlmOrg:Show()
      if !Empty( oBtnImp )
         oBtnImp:Hide()
      end if
   end if

return .t.

//---------------------------------------------------------------------------//
/*
Total de la remesa
*/

METHOD nTotRemMov( lPic ) CLASS TRemMovAlm 

   local nTot     := 0

   if !Empty( ::oDbf ) .and. ::oDbf:Used() .and. !Empty( ::oDetMovimientos ) .and. ::oDetMovimientos:oDbf:Used()

      if ::oDetMovimientos:oDbf:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDetMovimientos:oDbf:nNumRem, 9 ) + ::oDetMovimientos:oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof()
            nTot  +=  nTotLMovAlm( ::oDetMovimientos:oDbf )
            ::oDetMovimientos:oDbf:Skip()
         end while
      end if

   end if

RETURN ( if( IsTrue( lPic ), Trans( nTot, ::cPirDiv ), nTot ) )

//--------------------------------------------------------------------------//

FUNCTION RemMovAlm( oMenuItem, oWnd ) 

   DEFAULT  oMenuItem   := "01050"
   DEFAULT  oWnd        := oWnd()

   if Empty( oRemesas )

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Movimientos de almac�n", ProcName() )

      oRemesas          := TRemMovAlm():New( cPatEmp(), cDriver(), oWnd, oMenuItem )
      if !Empty( oRemesas )
         oRemesas:Play()
      end if

      oRemesas          := nil

   end if

RETURN NIL

//--------------------------------------------------------------------------//

METHOD lSelAllDoc( lSel ) CLASS TRemMovAlm 

   DEFAULT lSel         := .t.

   ::oDbfVir:GetStatus()

   ::oDbfVir:GoTop()
   while !::oDbfVir:Eof()
      ::oDbfVir:lSelDoc := lSel
      ::oDbfVir:Skip()
   end while

   ::oDbfVir:SetStatus()

   ::oBrwDet:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

METHOD lSelDoc() CLASS TRemMovAlm 

   ::oDbfVir:Load()
   ::oDbfVir:lSelDoc := !::oDbfVir:lSelDoc
   ::oDbfVir:Save()

   ::oBrwDet:Refresh()

RETURN nil

//--------------------------------------------------------------------------//
//  [ trim( CallHbFunc( 'oTInfGen', ['nombrePrimeraPropiedad()'] ) ) ]

METHOD DataReport( oFr ) CLASS TRemMovAlm 

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Movimiento", ::oDbf:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Movimiento", cObjectsToReport( ::oDbf ) )

   if !Empty( ::oDetMovimientos )
      oFr:SetWorkArea(     "Lineas de movimientos", ::oDetMovimientos:oDbf:nArea )
      oFr:SetFieldAliases( "Lineas de movimientos", cObjectsToReport( ::oDetMovimientos:oDbf ) )
   end if

   oFr:SetWorkArea(     "Empresa", ::oDbfEmp:nArea )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Almac�n origen", ::oAlmacenOrigen:nArea )
   oFr:SetFieldAliases( "Almac�n origen", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Almac�n destino", ::oAlmacenDestino:nArea )
   oFr:SetFieldAliases( "Almac�n destino", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Agentes", ::oDbfAge:nArea )
   oFr:SetFieldAliases( "Agentes", cItemsToReport( aItmAge() ) )
   
   if !Empty( ::oDetMovimientos )
      oFr:SetWorkArea(     "Art�culos", ::oArt:nArea )
      oFr:SetFieldAliases( "Art�culos", cItemsToReport( aItmArt() ) )

      oFr:SetMasterDetail( "Movimiento",              "Lineas de movimientos",   {|| Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem } )
      oFr:SetMasterDetail( "Lineas de movimientos",   "Art�culos",               {|| ::oDetMovimientos:oDbf:cRefMov } )
   end if

   oFr:SetMasterDetail( "Movimiento",                 "Empresa",               {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Movimiento",                 "Almac�n origen",        {|| ::oDbf:cAlmOrg } )
   oFr:SetMasterDetail( "Movimiento",                 "Almac�n destino",       {|| ::oDbf:cAlmDes } )
   oFr:SetMasterDetail( "Movimiento",                 "Agentes",               {|| ::oDbf:cCodAge } )

   oFr:SetResyncPair(   "Movimiento",                 "Empresa" )
   oFr:SetResyncPair(   "Movimiento",                 "Almac�n origen" )
   oFr:SetResyncPair(   "Movimiento",                 "Almac�n destino" )
   oFr:SetResyncPair(   "Movimiento",                 "Agentes" )

   if !Empty( ::oDetMovimientos )
      oFr:SetResyncPair(   "Movimiento",              "Lineas de movimientos" )
      oFr:SetResyncPair(   "Lineas de movimientos",   "Art�culos" )
   end if

Return nil

//---------------------------------------------------------------------------//

METHOD VariableReport( oFr ) CLASS TRemMovAlm 

   oFr:DeleteCategory(  "Movimiento" )
   oFr:DeleteCategory(  "Lineas de movimientos" )

   /*
   Creaci�n de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Movimiento",              "Total movimiento",                 "GetHbVar('nTotMov')" )
   oFr:AddVariable(     "Movimiento",              "Tipo de movimiento formato texto", "CallHbFunc('cTipoMovimiento')" )
   oFr:AddVariable(     "Movimiento",              "Almac�n origen",                   "CallHbFunc('cTipoMovimiento')" )
   oFr:AddVariable(     "Movimiento",              "Almac�n destino",                  "CallHbFunc('cTipoMovimiento')" )

   oFr:AddVariable(     "Lineas de movimientos",   "Detalle del art�culo",             "CallHbFunc('cNombreArticuloMovimiento')" )

   oFr:AddVariable(     "Lineas de movimientos",   "Nombre primera propiedad",         "CallHbFunc('nombrePrimeraPropiedadMovimientosAlmacen')" )
   oFr:AddVariable(     "Lineas de movimientos",   "Nombre segunda propiedad",         "CallHbFunc('nombreSegundaPropiedadMovimientosAlmacen')" )

   oFr:AddVariable(     "Lineas de movimientos",   "Total unidades",                   "CallHbFunc('nUnidadesLineaMovimiento')" )
   oFr:AddVariable(     "Lineas de movimientos",   "Total linea movimiento",           "CallHbFunc('nImporteLineaMovimiento')" )

Return nil

//---------------------------------------------------------------------------//

METHOD DesignReportRemMov( oFr, dbfDoc ) CLASS TRemMovAlm 

   if ::OpenFiles()

      private oThis        := Self
      public nTotMov       := ::nTotRemMov()

      /*
      Zona de datos------------------------------------------------------------
      */

      ::DataReport( oFr )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Movimiento" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de movimientos" )
         oFr:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

         oFr:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
         oFr:SetProperty(     "PieDocumento",      "Top", 930 )
         oFr:SetProperty(     "PieDocumento",      "Height", 110 )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport( oFr )

      /*
      Dise�o de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el dise�ador----------------------------------------------------
      */

      oFr:DestroyFr()

      /*
      Cierra ficheros----------------------------------------------------------
      */

      ::CloseFiles()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD PrintReportRemMov( nDevice, nCopies, cPrinter, dbfDoc ) CLASS TRemMovAlm 

   local oFr

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Dise�ador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport( oFr )

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case nDevice == IS_SCREEN
            oFr:ShowPreparedReport()

         case nDevice == IS_PRINTER
            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:Print()

         case nDevice == IS_PDF
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:DoExport(     "PDFExport" )

      end case

   end if

   /*
   Destruye el dise�ador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//

METHOD ActualizaStockWeb( cNumDoc ) CLASS TRemMovAlm

   local nRec
   local nOrdAnt

   if uFieldEmpresa( "lRealWeb" )

      /*
      Materiales producidos----------------------------------------------------
      */

      nRec     := ::oDetMovimientos:oDbf:Recno()
      nOrdAnt  := ::oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

      with object ( TComercio():New())

         if ::oDetMovimientos:oDbf:Seek( cNumDoc )

            while Str( ::oDetMovimientos:oDbf:nNumRem ) + ::oDetMovimientos:oDbf:cSufRem == cNumDoc .and. !::oDetMovimientos:oDbf:Eof()

               if oRetfld( ::oDetMovimientos:oDbf:cRefMov, ::oArt, "lPubInt", "Codigo" )

                  :ActualizaStockProductsPrestashop( ::oDetMovimientos:oDbf:cRefMov, ::oDetMovimientos:oDbf:cCodPr1, ::oDetMovimientos:oDbf:cCodPr2, ::oDetMovimientos:oDbf:cValPr1, ::oDetMovimientos:oDbf:cValPr2 )

               end if                  

               ::oDetMovimientos:oDbf:Skip()

            end while

        end if
        
      end with

      ::oDetMovimientos:oDbf:OrdSetFocus( nOrdAnt )
      ::oDetMovimientos:oDbf:GoTo( nRec )
   
   end if 

Return .f.   

//---------------------------------------------------------------------------//

METHOD cMostrarSerie() CLASS TRemMovAlm

   local nNumRec     := ::oDetSeriesMovimientos:oDbfVir:Recno()
   local nOrdAnt     := ::oDetSeriesMovimientos:oDbfVir:OrdSetFocus( "cNumOrd" )
   local cResultado  := ""
   local i           := 0

   if ::oDetSeriesMovimientos:oDbfVir:Seek( str(::oDetMovimientos:oDbfVir:nNumRem) + ::oDetMovimientos:oDbfVir:cSufRem + str( ::oDetMovimientos:oDbfVir:nNumLin ) )

      while (str(::oDetSeriesMovimientos:oDbfVir:nNumRem) + ::oDetSeriesMovimientos:oDbfVir:cSufRem + str( ::oDetSeriesMovimientos:oDbfVir:nNumLin ) ) == (str( ::oDetMovimientos:oDbfVir:nNumRem ) + ::oDetMovimientos:oDbfVir:cSufRem + str (::oDetMovimientos:oDbfVir:nNumLin ) ) .and. !::oDetSeriesMovimientos:oDbfVir:Eof() .and. i <= 1

         if i == 0
            cResultado  = "[" + AllTrim( ::oDetSeriesMovimientos:oDbfVir:cNumSer ) + "] "
         else
            cResultado  = "[...]"
         end if

         i  += 1

         ::oDetSeriesMovimientos:oDbfVir:Skip()

      end while

   end if

   ::oDetSeriesMovimientos:oDbfVir:OrdSetFocus( nOrdAnt )
   ::oDetSeriesMovimientos:oDbfVir:Goto( nNumRec )

RETURN ( cResultado )

//---------------------------------------------------------------------------//

METHOD GenerarEtiquetas CLASS TRemMovAlm

   local oLabelGenetator

   /*
   Tomamos el estado de la tabla-----------------------------------------------
   */

   ::oDbf:GetStatus()

   /*
   Instanciamos la clase-------------------------------------------------------
   */

   oLabelGenetator      := TLabelGeneratorMovimientosAlmacen():New( Self )
   oLabelGenetator:Dialog()

   /*
   Dejamos la tabla como estaba------------------------------------------------
   */

   ::oDbf:SetStatus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD importarInventario( ) CLASS TRemMovAlm

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "IMPORTAR_INVENTARIO" 

      REDEFINE GET ::memoInventario ;
         MEMO ;
         ID       110 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::porcesarInventario(), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::porcesarInventario(), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

Return ( Self )

//---------------------------------------------------------------------------//

METHOD porcesarInventario() CLASS TRemMovAlm

   local cInventario
   local aInventario    := hb_atokens( ::memoInventario, CRLF )

   ::aInventarioErrors  := {}

   for each cInventario in aInventario
      ::procesarArticuloInventario( cInventario )
   next 

   ::showInventarioErrors()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD showInventarioErrors() CLASS TRemMovAlm

   local cErrorMessage  := ""

   if !empty( ::aInventarioErrors )
      aeval(::aInventarioErrors, {|cError| cErrorMessage += cError + CRLF } )   
      msgStop( cErrorMessage, "Errores en la importaci�n" )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD procesarArticuloInventario( cInventario ) CLASS TRemMovAlm

   local cCodigo
   local nUnidades
   local aInventario    := hb_atokens( cInventario, "," )

   if hb_isarray( aInventario ) .and. len( aInventario ) >= 2

      cCodigo           := alltrim( aInventario[ 1 ] )
      nUnidades         := val( aInventario[ 2 ] )

      if !hb_isstring( cCodigo ) 
         aadd( ::aInventarioErrors, "El c�digo del art�culo no es un valor valido." )
         Return ( Self )   
      end if 

      if !hb_isnumeric( nUnidades )
         aadd( ::aInventarioErrors, "Las unidades del art�culo no contienen un valor valido." )
         Return ( Self )   
      end if 

      ::insertaArticuloRemesaMovimiento( cCodigo, nUnidades )

   end if 

   if !empty( ::oBrwDet )
      ::oBrwDet:Refresh()
   end if 

Return ( Self )

//---------------------------------------------------------------------------//
// Trata de insertar el articulo en la remesa de moviemitnos-------------------

METHOD insertaArticuloRemesaMovimiento( cCodigo, nUnidades ) CLASS TRemMovAlm

   ::oDetMovimientos:oDbfVir:Blank()

   ::oDetMovimientos:oDbfVir:cRefMov   := cCodigo
   ::oDetMovimientos:oDbfVir:nUndMov   := nUnidades

   if ::oDetMovimientos:loadArticulo( APPD_MODE, .t. )

      ::oDetMovimientos:oDbfVir:Insert()
   
      ::oDetMovimientos:appendKit()
   
   else

      aadd( ::aInventarioErrors, "El c�digo de art�culo " + cCodigo + " no es un valor valido." )

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

function cNombreArticuloMovimiento()

Return ( RetFld( oThis:oDetMovimientos:oDbf:cRefMov, oThis:oArt:cAlias, "Nombre" ) )

//---------------------------------------------------------------------------//

function nUnidadesLineaMovimiento()

Return nTotNMovAlm( oThis:oDetMovimientos:oDbf )

//---------------------------------------------------------------------------//

function nImporteLineaMovimiento()

Return nTotLMovAlm( oThis:oDetMovimientos:oDbf )

//---------------------------------------------------------------------------//

Function cTipoMovimiento()

   local cTipo    := ""

   do case
      case oThis:oDbf:nTipMov <= 1
         cTipo    := "Entre almacenes"
      case oThis:oDbf:nTipMov == 2
         cTipo    := "Regularizaci�n"
      case oThis:oDbf:nTipMov == 3
         cTipo    := "Regularizaci�n por objetivos"
      case oThis:oDbf:nTipMov == 4
         cTipo    := "Consolidaci�n"
   end if

Return cTipo

//---------------------------------------------------------------------------//

Function cAlmacenOrigen()

Return ( oRetFld( oThis:oParent:oDbf:cAlmOrg, oThis:oParent:oAlm ) )

//---------------------------------------------------------------------------//

Function cAlmacenDestino()

Return ( oRetFld( oThis:oParent:oDbf:cAlmDes, oThis:oParent:oAlm ) )

//---------------------------------------------------------------------------//

FUNCTION rxRemMov( cPath, oMeter )

   local dbfRemMovT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "REMMOVT.DBF" )

      CreateFiles( cPath )

   end if

   fEraseIndex( cPath + "REMMOVT.CDX" )

   dbUseArea( .t., cDriver(), cPath + "REMMOVT.DBF", cCheckArea( "REMMOVT", @dbfRemMovT ), .f. )

   if !( dbfRemMovT )->( neterr() )
      ( dbfRemMovT )->( __dbPack() )

      ( dbfRemMovT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfRemMovT )->( ordCreate( cPath + "REMMOVT.CDX", "CNUMREM", "Str( NNUMREM ) + CSUFREM", {|| Str( Field->NNUMREM ) + Field->CSUFREM } ) )

      ( dbfRemMovT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfRemMovT )->( ordCreate( cPath + "REMMOVT.CDX", "DFECREM", "Dtos( DFECREM ) + CTIMREM", {|| Dtos( Field->DFECREM ) + Field->CTIMREM } ) )

      ( dbfRemMovT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "RemMovT.Dbf" )
      dbCreate( cPath + "RemMovT.Dbf", aSqlStruct( aItmRemMov() ), cDriver() )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function aItmRemMov()

   local aBase := {}

   aAdd( aBase, { "lSelDoc",   "L",   1,  0, "L�gico Seleccionado"  } )
   aAdd( aBase, { "nNumRem",   "N",   9,  0, "N�mero"               } )
   aAdd( aBase, { "cSufRem",   "C",   2,  0, "Sufijo"               } )
   aAdd( aBase, { "nTipMov",   "N",   1,  0, "Tipo del movimiento"  } )
   aAdd( aBase, { "cCodUsr",   "C",   3,  0, "C�digo usuario"       } )
   aAdd( aBase, { "cCodDlg",   "C",   2,  0, "Delegaci�n"           } )
   aAdd( aBase, { "cCodAge",   "C",   3,  0, "C�digo agente"        } )
   aAdd( aBase, { "cCodMov",   "C",   2,  0, "Tipo de movimiento"   } )
   aAdd( aBase, { "dFecRem",   "D",   8,  0, "Fecha"                } )
   aAdd( aBase, { "cTimRem",   "C",   6,  0, "Hora"                 } )
   aAdd( aBase, { "cAlmOrg",   "C",  16,  0, "Alm. org."            } )
   aAdd( aBase, { "cAlmDes",   "C",  16,  0, "Alm. des."            } )
   aAdd( aBase, { "cCodDiv",   "C",   3,  0, "Div."                 } )
   aAdd( aBase, { "nVdvDiv",   "N",  13,  6, "Cambio de la divisa"  } )
   aAdd( aBase, { "cComMov",   "C", 100,  0, "Comentario"           } )

Return ( aBase )

//---------------------------------------------------------------------------//
/*
FUNCTION IsRemMov( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "RemMovT.Dbf" )
      dbCreate( cPath + "RemMovT.Dbf", aSqlStruct( aItmRemMov() ), cDriver() )
   end if

   if !lExistTable( cPath + "HisMov.Dbf" )
      dbCreate( cPath + "HisMov.Dbf", aSqlStruct( aItmMov() ), cDriver() )
   end if

   if !lExistIndex( cPath + "RemMovT.Cdx" )
      rxRemMov( cPath )
   end if

   if !lExistIndex( cPath + "HisMov.Cdx" )
      rxHisMov( cPath )
   end if

Return ( .t. )
*/
//---------------------------------------------------------------------------//

function nTotNRemMov( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfAlbCliL

   do case
      case IsChar( uDbf )

         nTotUnd  := NotCaja( ( uDbf )->nCajMov )
         nTotUnd  *= ( uDbf )->nUndMov

      case IsObject( uDbf )

         nTotUnd  := NotCaja( uDbf:nCajMov )
         nTotUnd  *= uDbf:nUndMov

   end case

RETURN ( nTotUnd )

//---------------------------------------------------------------------------//

Static Function QuiHisMov()

   local nOrdAnt  := ( dbfHisMov )->( OrdSetFocus( "nNumRem" ) )

   /*
   Detalle---------------------------------------------------------------------
   */

   while ( ( dbfHisMov )->( dbSeek( Str( ( dbfRemMov )->nNumRem ) + ( dbfRemMov  )->cSufRem ) ) .and. !( dbfHisMov )->( eof() ) )

      if dbLock( dbfHisMov )
         ( dbfHisMov )->( dbDelete() )
         ( dbfHisMov )->( dbUnLock() )
      end if

   end while

   ( dbfHisMov )->( OrdSetFocus( nOrdAnt ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SImportaAlmacen

   DATA cCodigo         AS CHARACTER   INIT ""
   DATA cDescripcion    AS CHARACTER   INIT ""
   DATA nEntrada        AS NUMERIC     INIT 0
   DATA nSalida         AS NUMERIC     INIT 0

   METHOD SumaEntrada( n ) INLINE         ( ::nEntrada   += n )
   METHOD SumaSalida( n )  INLINE         ( ::nSalida    += n )
   METHOD Saldo()          INLINE         ( ::nEntrada - ::nSalida )

END CLASS

//---------------------------------------------------------------------------//

Function SynRemMov( cPath )

   local oBlock
   local oError
   local dFecMov
   local dbfRemMov
   local dbfHisMov
   local dbfArticulo
   local nTotRem  := 0
   local nOrdAnt

   DEFAULT cPath  := cPatEmp()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPath + "REMMOVT.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "REMMOV", @dbfRemMov ) )
   SET ADSINDEX TO ( cPath + "REMMOVT.CDX" ) ADDITIVE

   USE ( cPath + "HISMOV.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
   SET ADSINDEX TO ( cPath + "HISMOV.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   /*
   Cabeceras-------------------------------------------------------------------
   */

   ( dbfRemMov )->( ordSetFocus( 0 ) )

   ( dbfRemMov )->( dbGoTop() )
   while !( dbfRemMov )->( eof() )

      if Empty( ( dbfRemMov )->cSufRem )
         ( dbfRemMov )->cSufRem        := "00"
      end if

      ( dbfRemMov )->( dbSkip() )

   end while
   ( dbfRemMov )->( ordSetFocus( 1 ) )

   /*
   Lineas----------------------------------------------------------------------
   */

   ( dbfHisMov )->( ordSetFocus( 0 ) )

   ( dbfHisMov )->( dbGoTop() )
   while !( dbfHisMov )->( eof() )

      if Empty( ( dbfHisMov )->cSufRem )
         ( dbfHisMov )->cSufRem        := "00"
      end if

      if Empty( ( dbfHisMov )->cNomMov )
         ( dbfHisMov )->cNomMov        := RetArticulo( ( dbfHisMov )->cRefMov, dbfArticulo )
      end if 

      if Empty( ( dbfHisMov )->dFecMov )

         dFecMov                       := RetFld( Str( ( dbfHisMov )->nNumRem ) + ( dbfHisMov )->cSufRem, dbfRemMov, "dFecRem", "cNumRem" )

         if Empty( dFecMov )
            dFecMov                    := CtoD( "01/01/" + Str( Year( Date() ) ) )
         end if

         ( dbfHisMov )->dFecMov        := dFecMov

      end if

      if Empty( ( dbfHisMov )->cTimMov )
         ( dbfHisMov )->cTimMov        := RetFld( Str( ( dbfHisMov )->nNumRem ) + ( dbfHisMov )->cSufRem, dbfRemMov, "cTimRem", "cNumRem" )
      end if

      if Empty( ( dbfHisMov )->cRefMov )

         nOrdAnt                       := ( dbfArticulo )->( OrdSetFocus( "Nombre" ) )

         if ( dbfArticulo )->( dbSeek( Padr( ( dbfHisMov )->cNomMov, 100 ) ) )
            ( dbfHisMov )->cRefMov     := ( dbfArticulo )->Codigo
         end if

         ( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )

      end if

      ( dbfHisMov )->( dbSkip() )

   end while

   ( dbfHisMov )->( ordSetFocus( 1 ) )

   /*
   Rellenamos los campos de totales--------------------------------------------
   */

   ( dbfRemMov )->( dbGoTop() )
   while !( dbfRemMov )->( eof() )

      if ( dbfRemMov )->nTotRem == 0

         if dbSeekInOrd( Str( ( dbfRemMov )->nNumRem ) + ( dbfRemMov )->cSufRem, "nNumRem", dbfHisMov )

            while Str( ( dbfRemMov )->nNumRem ) + ( dbfRemMov )->cSufRem == Str( ( dbfHisMov )->nNumRem ) + ( dbfHisMov )->cSufRem .and. !( dbfHisMov )->( Eof() )

               nTotRem                 += nTotLMovAlm( dbfHisMov )

               ( dbfHisMov )->( dbSkip() )

            end while

         end if

         ( dbfRemMov )->nTotRem        := nTotRem

      end if

      nTotRem                          := 0

      ( dbfRemMov )->( dbSkip() )

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de movimientos de almac�n" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfRemMov )
   CLOSE ( dbfHisMov )
   CLOSE ( dbfArticulo )

return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetMovimientos FROM TDet

   DATA  cOldCodArt        INIT  ""
   DATA  cOldLote          INIT  ""
   DATA  cOldValPr1        INIT  ""
   DATA  cOldValPr2        INIT  ""

   DATA  nStockActual      INIT  0
   DATA  aStockActual

   DATA  oRefMov
   DATA  oValPr1
   DATA  oValPr2
   DATA  oSayVp1
   DATA  cSayVp1           INIT  ""
   DATA  oSayVp2
   DATA  cSayVp2           INIT  ""
   DATA  oSayPr1
   DATA  cSayPr1           INIT  ""
   DATA  oSayPr2
   DATA  cSayPr2           INIT  ""
   DATA  oSayCaj
   DATA  cSayCaj           INIT  ""
   DATA  oSayUnd
   DATA  cSayUnd           INIT  ""
   DATA  oSayLote
   DATA  oGetLote
   DATA  oGetDetalle
   DATA  cGetDetalle       INIT  ""

   DATA  oCajMov
   DATA  oUndMov

   DATA  oGetBultos  
   DATA  oSayBultos
   DATA  oGetFormato

   DATA  oGetStockOrigen
   DATA  oGetStockDestino

   DATA  oGetAlmacenOrigen
   DATA  oGetAlmacenDestino

   DATA  oTxtAlmacenOrigen
   DATA  oTxtAlmacenDestino

   DATA  cTxtAlmacenOrigen
   DATA  cTxtAlmacenDestino

   DATA  oPreDiv

   DATA  oBrwPrp
   DATA  oBrwStock

   DATA  oBtnSerie

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD Reindexa()

   METHOD Resource( nMode, lLiteral )
   METHOD ValidResource( nMode, oDlg, oBtn )

   METHOD RollBack()

   METHOD loadArticulo( lValidDetalle, nMode )
      METHOD getPrecioCosto() 

   METHOD Save()
   METHOD Asigna()

   METHOD AppendKit()
   METHOD ActualizaKit( nMode )

   METHOD nStockActualAlmacen( cCodAlm )

   METHOD SetDlgMode( nMode )

   METHOD aStkArticulo()

   METHOD nTotRemVir( lPic )
   METHOD nTotUnidadesVir( lPic )
   METHOD nTotVolumenVir( lPic )
   METHOD nTotPesoVir( lPic )

   METHOD RecalcularPrecios()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver, lUniqueName, cFileName ) CLASS TDetMovimientos

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "HisMov"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPatTmp() )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS "HisMov" ALIAS ( cFileName ) PATH ( cPath ) VIA ( cDriver )

      FIELD NAME "dFecMov"    TYPE "D" LEN   8 DEC 0 COMMENT "Fecha movimiento"                    OF oDbf
      FIELD NAME "cTimMov"    TYPE "C" LEN   6 DEC 0 COMMENT "Hora movimiento"                     OF oDbf
      FIELD NAME "nTipMov"    TYPE "N" LEN   1 DEC 0 COMMENT "Tipo movimiento"                     OF oDbf
      FIELD NAME "cAliMov"    TYPE "C" LEN  16 DEC 0 COMMENT "Alm. ent."                           OF oDbf
      FIELD NAME "cAloMov"    TYPE "C" LEN  16 DEC 0 COMMENT "Alm. sal."                           OF oDbf
      FIELD NAME "cRefMov"    TYPE "C" LEN  18 DEC 0 COMMENT "C�digo"                              OF oDbf
      FIELD NAME "cNomMov"    TYPE "C" LEN  50 DEC 0 COMMENT "Nombre"                              OF oDbf
      FIELD NAME "cCodMov"    TYPE "C" LEN   2 DEC 0 COMMENT "TM"                                  OF oDbf
      FIELD NAME "cCodPr1"    TYPE "C" LEN  20 DEC 0 COMMENT "C�digo propiedad 1"                  OF oDbf
      FIELD NAME "cCodPr2"    TYPE "C" LEN  20 DEC 0 COMMENT "C�digo propiedad 2"                  OF oDbf
      FIELD NAME "cValPr1"    TYPE "C" LEN  20 DEC 0 COMMENT "Valor propiedad 1"                   OF oDbf
      FIELD NAME "cValPr2"    TYPE "C" LEN  20 DEC 0 COMMENT "Valor propiedad 2"                   OF oDbf
      FIELD NAME "cCodUsr"    TYPE "C" LEN   3 DEC 0 COMMENT "C�digo usuario"                      OF oDbf
      FIELD NAME "cCodDlg"    TYPE "C" LEN   2 DEC 0 COMMENT "C�digo delegaci�n"                   OF oDbf
      FIELD NAME "lLote"      TYPE "L" LEN   1 DEC 0 COMMENT "L�gico lote"                         OF oDbf
      FIELD NAME "nLote"      TYPE "N" LEN   9 DEC 0 COMMENT "N�mero de lote"                      OF oDbf
      FIELD NAME "cLote"      TYPE "C" LEN  14 DEC 0 COMMENT "Lote"                                OF oDbf
      FIELD NAME "nCajMov"    TYPE "N" LEN  19 DEC 6 PICTURE {|| MasUnd() } COMMENT "Caj."         OF oDbf
      FIELD NAME "nUndMov"    TYPE "N" LEN  19 DEC 6 PICTURE {|| MasUnd() } COMMENT "Und."         OF oDbf
      FIELD NAME "nCajAnt"    TYPE "N" LEN  19 DEC 6 COMMENT "Caj. ant."                           OF oDbf
      FIELD NAME "nUndAnt"    TYPE "N" LEN  19 DEC 6 COMMENT "Und. ant."                           OF oDbf
      FIELD NAME "nPreDiv"    TYPE "N" LEN  19 DEC 6 PICTURE {|| PicOut() } COMMENT "Precio"       OF oDbf
      FIELD NAME "lSndDoc"    TYPE "L" LEN   1 DEC 0 COMMENT "L�gico enviar"                       OF oDbf
      FIELD NAME "nNumRem"    TYPE "N" LEN   9 DEC 0 COMMENT "N�mero remesa"                       OF oDbf
      FIELD NAME "cSufRem"    TYPE "C" LEN   2 DEC 0 COMMENT "Sufijo remesa"                       OF oDbf
      FIELD NAME "lSelDoc"    TYPE "L" LEN   1 DEC 0 COMMENT "L�gico selecionar"                   OF oDbf
      FIELD NAME "lNoStk"     TYPE "L" LEN   1 DEC 0 COMMENT "L�gico no stock"                     OF oDbf
      FIELD NAME "lKitArt"    TYPE "L" LEN   1 DEC 0 COMMENT "L�nea con escandallo"                OF oDbf
      FIELD NAME "lKitEsc"    TYPE "L" LEN   1 DEC 0 COMMENT "L�nea perteneciente a escandallo"    OF oDbf
      FIELD NAME "lImpLin"    TYPE "L" LEN   1 DEC 0 COMMENT "L�gico imprimir linea"               OF oDbf
      FIELD NAME "lKitPrc"    TYPE "L" LEN   1 DEC 0 COMMENT "L�gico precio escandallo"            OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN   9 DEC 0 COMMENT "N�mero de linea"                     OF oDbf
      FIELD NAME "mNumSer"    TYPE "M" LEN  10 DEC 0 COMMENT "Numeros de serie"                    OF oDbf
      FIELD NAME "nVolumen"   TYPE "N" LEN  16 DEC 6 COMMENT "Volumen del producto"                OF oDbf
      FIELD NAME "cVolumen"   TYPE "C" LEN   2 DEC 0 COMMENT "Unidad del volumen"                  OF oDbf
      FIELD NAME "nPesoKg"    TYPE "N" LEN  16 DEC 6 COMMENT "Peso del producto"                   OF oDbf
      FIELD NAME "cPesoKg"    TYPE "C" LEN   2 DEC 0 COMMENT "Unidad de peso del producto"         OF oDbf
      FIELD NAME "nBultos"    TYPE "N" LEN  16 DEC 0 COMMENT "N�mero de bultos en l�neas"          OF oDbf
      FIELD NAME "cFormato"   TYPE "C" LEN 100 DEC 0 COMMENT "Formato de compra/venta"             OF oDbf
      FIELD NAME "lLabel"     TYPE "L" LEN   1 DEC 0 COMMENT "L�gico para imprimir etiqueta"       OF oDbf
      FIELD NAME "nLabel"     TYPE "N" LEN  16 DEC 6 COMMENT "N�mero de etiquetas a imprimir"      OF oDbf

      INDEX TO ( cFileName ) TAG "nNumRem"      ON "Str( nNumRem ) + cSufRem"               NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "dFecMov"      ON "Dtoc( dFecMov ) + cTimMov"              NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRefMov"      ON "cRefMov + cValPr1 + cValPr2 + cLote"    NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cNomMov"      ON "cNomMov"                                NODELETED                     OF oDbf 
      INDEX TO ( cFileName ) TAG "cAloMov"      ON "cAloMov"                                NODELETED                     OF oDbf 
      INDEX TO ( cFileName ) TAG "cAliMov"      ON "cAliMov"                                NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRefAlm"      ON "cRefMov + cValPr1 + cValPr2 + cAliMov"  NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cLote"        ON "cLote"                                  NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin"      ON "Str( nNumLin )"                         NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "lSndDoc"      ON "lSndDoc"                                NODELETED                              FOR "lSndDoc"        OF oDbf
      INDEX TO ( cFileName ) TAG "nTipMov"      ON "cRefMov + Dtos( dFecMov )"              NODELETED                              FOR "nTipMov == 4"   OF oDbf
      INDEX TO ( cFileName ) TAG "cStock"       ON "cRefMov + cAliMov + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote"  NODELETED  FOR "nTipMov == 4"   OF oDbf
      INDEX TO ( cFileName ) TAG "cStkFastIn"   ON "cRefMov + cAliMov + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote"  NODELETED  OF oDbf
      INDEX TO ( cFileName ) TAG "cStkFastOu"   ON "cRefMov + cAloMov + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote"  NODELETED  OF oDbf
      INDEX TO ( cFileName ) TAG "cRef"         ON "cRefMov"                                NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRefFec"      ON "cRefMov + cLote + dTos( dFecMov )"      NODELETED                     OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive) CLASS TDetMovimientos

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::defineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

  RECOVER

     msgStop( "Imposible abrir todas las bases de datos movimientos de almacen" )
     lOpen                := .f.

  END SEQUENCE

  ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetMovimientos

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf         := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Reindexa() CLASS TDetMovimientos

   if Empty( ::oDbf )
      ::oDbf   := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   if ::OpenService( .t. )
      ::oDbf:IdxFCheck()
      ::oDbf:Pack()
   end if

   ::CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Edita las lineas de Detalle
*/

METHOD Resource( nMode ) CLASS TDetMovimientos

   local oDlg
   local oBtn
   local oSayPre
   local nStockOrigen      := 0
   local nStockDestino     := 0
   local oTotUnd
   local cSayLote          := 'Lote'
   local oBtnSer
   local oSayTotal

   if nMode == APPD_MODE
      ::oDbfVir:nNumLin    := nLastNum( ::oDbfVir:cAlias )
   end if

   ::cOldCodArt            := ::oDbfVir:cRefMov
   ::cOldValPr1            := ::oDbfVir:cValPr1
   ::cOldValPr2            := ::oDbfVir:cValPr2
   ::cOldLote              := ::oDbfVir:cLote

   ::cGetDetalle           := oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "Nombre" )

   ::aStockActual          := { { "", "", "", "", "", 0, 0, 0 } }

   ::cTxtAlmacenOrigen     := oRetFld( ::oParent:oDbf:cAlmOrg, ::oParent:oAlmacenOrigen )
   ::cTxtAlmacenDestino    := oRetFld( ::oParent:oDbf:cAlmDes, ::oParent:oAlmacenDestino )

   DEFINE DIALOG oDlg RESOURCE "LMovAlm" TITLE lblTitle( nMode ) + "lineas de movimientos de almac�n"

      REDEFINE GET ::oRefMov VAR ::oDbfVir:cRefMov ;
			ID 		100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oRefMov:bValid     := {|| if( !empty( ::oDbfVir:cRefMov ), ::loadArticulo( nMode ), .t. ) }
      ::oRefMov:bHelp      := {|| BrwArticulo( ::oRefMov, ::oGetDetalle , , , , ::oGetLote, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oValPr1, ::oValPr2  ) }

      REDEFINE GET ::oGetDetalle VAR ::oDbfVir:cNomMov ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      // Lote------------------------------------------------------------------

      REDEFINE SAY ::oSayLote VAR cSayLote ;
         ID       154;
         OF       oDlg

      REDEFINE GET ::oGetLote VAR ::oDbfVir:cLote ;
         ID       155 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oGetLote:bValid          := {|| if( !Empty( ::oDbfVir:cLote ), ::loadArticulo( nMode ), .t. ) }

      // Browse de propiedades-------------------------------------------------

      ::oBrwPrp                  := IXBrowse():New( oDlg )

      ::oBrwPrp:nDataType        := DATATYPE_ARRAY

      ::oBrwPrp:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwPrp:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwPrp:lHScroll         := .t.
      ::oBrwPrp:lVScroll         := .t.

      ::oBrwPrp:nMarqueeStyle    := 3
      ::oBrwPrp:nFreeze          := 1

      ::oBrwPrp:lRecordSelector  := .f.
      ::oBrwPrp:lFastEdit        := .t.
      ::oBrwPrp:lFooter          := .t.

      ::oBrwPrp:SetArray( {}, .f., 0, .f. )

      ::oBrwPrp:MakeTotals()

      ::oBrwPrp:CreateFromResource( 600 )

      REDEFINE GET ::oValPr1 VAR ::oDbfVir:cValPr1;
         ID       120 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oValPr1:bValid     := {|| if( lPrpAct( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias ), ::loadArticulo( nMode ), .f. ) }
      ::oValPr1:bHelp      := {|| brwPropiedadActual( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1 ) }

      REDEFINE GET ::oSayVp1 VAR ::cSayVp1;
         ID       121 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE SAY ::oSayPr1 PROMPT "Propiedad 1";
         ID       122 ;
         OF       oDlg

      REDEFINE GET ::oValPr2 VAR ::oDbfVir:cValPr2;
         ID       130 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oValPr2:bValid     := {|| if( lPrpAct( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias ), ::loadArticulo( nMode ), .f. ) }
      ::oValPr2:bHelp      := {|| brwPropiedadActual( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2 ) }

      REDEFINE GET ::oSayVp2 VAR ::cSayVp2 ;
         ID       131 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE SAY ::oSayPr2 PROMPT "Propiedad 2";
         ID       132 ;
         OF       oDlg

      REDEFINE GET ::oGetBultos VAR ::oDbfVir:nBultos;
         ID       430 ;
         SPINNER  ;
         WHEN     ( uFieldEmpresa( "lUseBultos" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd;
         OF       oDlg

      REDEFINE SAY ::oSayBultos PROMPT uFieldempresa( "cNbrBultos" );
         ID       431;
         OF       oDlg

      REDEFINE GET ::oCajMov VAR ::oDbfVir:nCajMov;
         ID       140;
			SPINNER ;
         WHEN     ( lUseCaj() .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( oTotUnd:Refresh(), oSayPre:Refresh() );
         VALID    ( oTotUnd:Refresh(), oSayPre:Refresh(), .t. );
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      REDEFINE SAY ::oSayCaj PROMPT cNombreCajas(); 
         ID       142 ;
         OF       oDlg

      REDEFINE GET ::oUndMov VAR ::oDbfVir:nUndMov ;
         ID       150;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( oTotUnd:Refresh(), oSayPre:Refresh() );
         VALID    ( oTotUnd:Refresh(), oSayPre:Refresh(), .t. );
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      REDEFINE SAY ::oSayUnd PROMPT cNombreUnidades() ;
         ID       152 ;
         OF       oDlg

      REDEFINE SAY oTotUnd PROMPT nTotNMovAlm( ::oDbfVir ) ;
         ID       160;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      REDEFINE GET ::oPreDiv ;
         VAR      ::oDbfVir:nPreDiv ;
         ID       180 ;
         IDSAY    181 ;
			SPINNER ;
         ON CHANGE( oSayPre:Refresh() ) ;
         VALID    ( oSayPre:Refresh(), .t. ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPinDiv ;
			OF 		oDlg

      REDEFINE SAY oSayTotal ;
         ID       191 ;
         OF       oDlg

      REDEFINE SAY oSayPre PROMPT nTotLMovAlm( ::oDbfVir ) ;
         ID       190 ;
         PICTURE  ::oParent:cPirDiv ;
			OF 		oDlg
     
      /*
      Almacen origen-----------------------------------------------------------
      */

      REDEFINE GET ::oGetAlmacenOrigen VAR ::oParent:oDbf:cAlmOrg ;
         ID       400 ;
         IDSAY    403 ;
         WHEN     ( .f. ) ;
         BITMAP   "Lupa" ;
         OF       oDlg

      REDEFINE GET ::oTxtAlmacenOrigen VAR ::cTxtAlmacenOrigen ;
         ID       401 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oGetStockOrigen VAR nStockOrigen ;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         ID       402 ;
         IDSAY    404 ;
         OF       oDlg

      /*
      Almacen destino-----------------------------------------------------------
      */

      REDEFINE GET ::oGetAlmacenDestino VAR ::oParent:oDbf:cAlmDes ;
         ID       410 ;
         WHEN     ( .f. ) ;
         BITMAP   "Lupa" ;
         OF       oDlg

      REDEFINE GET ::oTxtAlmacenDestino VAR ::cTxtAlmacenDestino ;
         ID       411 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oGetStockDestino VAR nStockDestino ;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         ID       412 ;
         OF       oDlg

      /*
      Peso y volumen-----------------------------------------------------------
      */

      REDEFINE GET ::oDbfVir:nPesoKg ;
         ID       200 ;
         WHEN     ( .f. ) ;
         PICTURE  "@E 999.99";
         OF       oDlg

      REDEFINE GET ::oDbfVir:cPesoKg ;
         ID       210 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:nVolumen ;
         ID       220 ;
         WHEN     ( .f. ) ;
         PICTURE  "@E 999.99";
         OF       oDlg

      REDEFINE GET ::oDbfVir:cVolumen ;
         ID       230 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oGetFormato VAR ::oDbfVir:cFormato;
         ID       440;
         OF       oDlg

      REDEFINE BUTTON ::oBtnSerie ;
         ID       500 ;
			OF 		oDlg ;
         ACTION   ( nil )

      ::oBtnSerie:bAction     := {|| ::oParent:oDetSeriesMovimientos:Resource( nMode ) }

      REDEFINE BUTTON oBtn;
         ID       510 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::ValidResource( nMode, oDlg, oBtn ) )

		REDEFINE BUTTON ;
         ID       520 ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE

         if uFieldEmpresa( "lGetLot")
            oDlg:AddFastKey( VK_RETURN, {|| ::oRefMov:lValid(), oBtn:SetFocus(), oBtn:Click() } )
         end if 

         oDlg:AddFastKey( VK_F5, {|| oBtn:Click() } )

         oDlg:AddFastKey( VK_F6, {|| ::oBtnSerie:Click() } )
         
      end if

      oDlg:bStart             := {|| ::SetDlgMode( nMode, oSayTotal, oSayPre ) }

   oDlg:Activate( , , , .t., , , {|| EdtDetMenu( Self, oDlg ) } )

   // Salida del dialogo----------------------------------------------------------

   EndEdtDetMenu()

RETURN ( oDlg:nResult )

//--------------------------------------------------------------------------//

Static Function EdtDetMenu( oThis, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar de art�culo";
               MESSAGE  "Modificar la ficha del art�culo" ;
               RESOURCE "Cube_Yellow_16";
               ACTION   ( EdtArticulo( oThis:oRefMov:VarGet() ) );

            MENUITEM    "&2. Informe de art�culo";
               MESSAGE  "Abrir el informe del art�culo" ;
               RESOURCE "Info16";
               ACTION   ( InfArticulo( oThis:oRefMov:VarGet() ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//

Static Function EndEdtDetMenu()

Return( oMenu:End() )

//---------------------------------------------------------------------------//

METHOD ValidResource( nMode, oDlg, oBtn ) CLASS TDetMovimientos

   local n
   local i
   local cLote
   local lFound
   local cRefMov
   local nCajMov
   local nUndMov
   local cCodPr1
   local cCodPr2
   local cValPr1
   local cValPr2
   local nStkAct                 := 0
   local nTotUnd                 := 0
   local dFecMov
   local cTimMov
   local nTipMov
   local cAliMov
   local cAloMov
   local cCodMov
   local lNowSer
   local lNumSer
   local nPrecioCosto
   local lArticuloPropiedades    := .f.

   oBtn:SetFocus()

   /*
   if nMode == APPD_MODE .and. !::loadArticulo( .t., nMode )
      ::oRefMov:SetFocus()
      Return .f.
   end if
   */

   if Empty( ::oDbfVir:cRefMov )
      msgstop( "C�digo de art�culo vac�o." )
      ::oRefMov:SetFocus()
      Return .f.
   end if

   // Control para numeros de serie--------------------------------------------

   lNumSer                       := retfld( ::oDbfVir:cRefMov, ::oParent:oArt:cAlias, "lNumSer" )
   lNowSer                       := ::oParent:oDetSeriesMovimientos:oDbfVir:SeekInOrd( Str( ::oDbfVir:nNumLin, 4 ) + ::oDbfVir:cRefMov, "nNumLin" )

   if ( nMode == APPD_MODE )     .and.;
      ( lNumSer )                .and.;
      (!lNowSer )                .and.;
      ( ::oParent:oDbf:nTipMov != 3 )

      MsgStop( "Tiene que introducir n�meros de serie para este art�culo." )

      ::oBtnSerie:Click()

      Return .f.

   end if

   CursorWait()

   lFound            := .f.

   do case
   case ( nMode == APPD_MODE .and. !lNumSer )

      cRefMov        := ::oDbfVir:cRefMov
      nCajMov        := ::oDbfVir:nCajMov
      nUndMov        := ::oDbfVir:nUndMov
      cLote          := ::oDbfVir:cLote
      cCodPr1        := ::oDbfVir:cCodPr1
      cCodPr2        := ::oDbfVir:cCodPr2
      cValPr1        := ::oDbfVir:cValPr1
      cValPr2        := ::oDbfVir:cValPr2
      nPrecioCosto   := ::oDbfVir:nPreDiv 

      ::oDbfVir:GetStatus()

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         if !( lNowSer )                                    .and. ; // sin numeros de serie
            ::oDbfVir:FieldGetName( "cRefMov" ) == cRefMov  .and. ;
            ::oDbfVir:FieldGetName( "cLote"   ) == cLote    .and. ;
            ::oDbfVir:FieldGetName( "cCodPr1" ) == cCodPr1  .and. ;
            ::oDbfVir:FieldGetName( "cCodPr2" ) == cCodPr2  .and. ;
            ::oDbfVir:FieldGetName( "cValPr1" ) == cValPr1  .and. ;
            ::oDbfVir:FieldGetName( "cValPr2" ) == cValPr2  .and. ;
            ::oDbfVir:FieldGetName( "nCajMov" ) == nCajMov  .and. ;
            ::oDbfVir:FieldGetName( "nPrediv" ) == nPrecioCosto

            nCajMov  += ::oDbfVir:FieldGetName( "nCajMov" )
            nUndMov  += ::oDbfVir:FieldGetName( "nUndMov" )

            ::oDbfVir:FieldPutByName( "nCajMov", nCajMov )
            ::oDbfVir:FieldPutByName( "nUndMov", nUndMov )
            ::oDbfVir:FieldPutByName( "lSelDoc", .t. )

            if ::oDbfVir:FieldGetName( "lKitArt" )
               ::ActualizaKit( nMode )
            end if


            lFound   := .t.

            exit

         end if

         ::oDbfVir:Skip()

      end while

      ::oDbfVir:SetStatus()

   case nMode == EDIT_MODE

      ::ActualizaKit( nMode )

   end case

   /*
   Control de stock solo para movimeintos entre almacenes----------------------
   Avisamos en movimientos con stock bajo minimo-------------------------------
   */

   if ( ::oDbf:nTipMov == 1 )

      nTotUnd        := nTotNRemMov( ::oDbfVir )
      nStkAct        := ::nStockActualAlmacen( ::oParent:oDbf:cAlmOrg )

      if nTotUnd != 0 .and. oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "lMsgMov" )

         if ( nStkAct - nTotUnd ) < oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "nMinimo" )

            if !ApoloMsgNoYes( "El stock est� por debajo del minimo.", "�Desea continuar?" )
               return nil
            end if

         end if

      end if

   end if

   /*
   A�adimos las lineas creadas por la rejilla de datos-------------------------
   */

   if !Empty( ::oBrwPrp:Cargo )

      /*
      Tomamos algunos datos----------------------------------------------------
      */

      dFecMov  := ::oDbfVir:dFecMov
      cTimMov  := ::oDbfVir:cTimMov
      nTipMov  := ::oDbfVir:nTipMov
      cAliMov  := ::oDbfVir:cAliMov
      cAloMov  := ::oDbfVir:cAloMov
      cCodMov  := ::oDbfVir:cCodMov
      cRefMov  := ::oDbfVir:cRefMov

      /*
      Metemos las lineas por propiedades---------------------------------------
      */

      for n := 1 to len( ::oBrwPrp:Cargo )

         for i := 1 to len( ::oBrwPrp:Cargo[ n ] )

            if IsNum( ::oBrwPrp:Cargo[ n, i ]:Value ) .and. ::oBrwPrp:Cargo[ n, i ]:Value != 0

               ::oDbfVir:Append()

               ::oDbfVir:dFecMov    := dFecMov
               ::oDbfVir:cTimMov    := cTimMov
               ::oDbfVir:nTipMov    := nTipMov
               ::oDbfVir:cAliMov    := cAliMov
               ::oDbfVir:cAloMov    := cAloMov
               ::oDbfVir:cCodMov    := cCodMov
               ::oDbfVir:cRefMov    := cRefMov
               ::oDbfVir:cCodPr1    := ::oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad1
               ::oDbfVir:cCodPr2    := ::oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad2
               ::oDbfVir:cValPr1    := ::oBrwPrp:Cargo[ n, i ]:cValorPropiedad1
               ::oDbfVir:cValPr2    := ::oBrwPrp:Cargo[ n, i ]:cValorPropiedad2
               ::oDbfVir:nUndMov    := ::oBrwPrp:Cargo[ n, i ]:Value
               ::oDbfVir:cCodUsr    := cCurUsr()
               ::oDbfVir:cCodDlg    := oRetFld( cCurUsr(), ::oParent:oUsr, "cCodDlg" )
               ::oDbfVir:nCajMov    := 1
               ::oDbfVir:lSelDoc    := .t.
               ::oDbfVir:lSndDoc    := .t.
               ::oDbfVir:nNumLin    := nLastNum( ::oDbfVir:cAlias )
               ::oDbfVir:nVolumen   := oRetFld( cRefMov, ::oParent:oArt, "" )
               ::oDbfVir:cVolumen   := oRetFld( cRefMov, ::oParent:oArt, "" )
               ::oDbfVir:nPesoKg    := oRetFld( cRefMov, ::oParent:oArt, "" )
               ::oDbfVir:cPesoKg    := oRetFld( cRefMov, ::oParent:oArt, "" )

               if ( ::oBrwPrp:Cargo[ n, i ]:nPrecioCompra != 0 )
                  ::oDbfVir:nPreDiv := ::oBrwPrp:Cargo[ n, i ]:nPrecioCompra
               else
                  ::oDbfVir:nPreDiv := ::oDbfVir:nPreDiv 
               end if 

               ::oDbfVir:Save()

            end if

         next

      next

      lArticuloPropiedades          := .t.

   end if

   ::cOldCodArt                     := ""
   ::cOldValPr1                     := ""
   ::cOldValPr2                     := ""
   ::cOldLote                       := ""

   CursorWE()

   if lArticuloPropiedades
      oDlg:end( IDCANCEL )
   else
      if lFound
         oDlg:end( IDFOUND )
      else
         oDlg:end( IDOK )
      end if
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD RollBack() CLASS TDetMovimientos

   local cStm

   ::oParent:GetFirstKey()
   if ::oParent:cFirstKey != nil

      if lAIS()

         cStm        := "DELETE FROM " + cPatEmp() + "HisMov" + " WHERE nNumRem = " + alltrim( str( ::oParent:oDbf:nNumRem ) ) + " AND cSufRem = '" + ::oParent:oDbf:cSufRem + "'"
         TDataCenter():ExecuteSqlStatement( cStm, "RollBackDetMovimientos" )

      else 

         while ::oDbf:Seek( ::oParent:cFirstKey )
            ::oDbf:Delete()
            if !Empty( ::oParent ) .and. !Empty( ::oParent:oMeter )
               ::oParent:oMeter:AutoInc()
            end if
         end while

      end if 

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD loadArticulo( nMode, lSilenceMode ) CLASS TDetMovimientos

   local a
   local nPos
   local nPreMed
   local cValPr1           := ""
   local cValPr2           := ""
   local cCodArt           := ""
   local lChgCodArt        := .f.

   DEFAULT lSilenceMode    := .f.

   if empty( ::oDbfVir:cRefMov )
      if !empty( ::oBrwPrp )
         ::oBrwPrp:Hide()
      end if
      Return .t.
   end if

   // Detectamos si hay cambios en los codigos y propiedades-------------------

   lChgCodArt              := ( rtrim( ::cOldCodArt ) != rtrim( ::oDbfVir:cRefMov ) .or. ::cOldLote != ::oDbfVir:cLote .or. ::cOldValPr1 != ::oDbfVir:cValPr1 .or. ::cOldValPr2 != ::oDbfVir:cValPr2 )

   // Conversi�n a codigo interno-------------------------------------------------

   cCodArt                 := cSeekCodebar( ::oDbfVir:cRefMov, ::oParent:oDbfBar:cAlias, ::oParent:oArt:cAlias )

   // Articulos con numeros de serie no podemos pasarlo en regularizacion por objetivos

   if ( ::oParent:oDbf:nTipMov == 3 ) .and. ( retFld( cCodArt, ::oParent:oArt:cAlias, "lNumSer" ) )
      MsgStop( "Art�culos con n�meros de serie no pueden incluirse regularizaciones por objetivo." )
      Return .f.
   end if

   // Ahora buscamos por el codigo interno----------------------------------------

   if aSeekProp( @cCodArt, @cValPr1, @cValPr2, ::oParent:oArt:cAlias, ::oParent:oTblPro:cAlias ) // ::oArt:Seek( xVal ) .OR. ::oArt:Seek( Upper( xVal ) )

      CursorWait()

      if ( lChgCodArt )

         if !empty(::oRefMov)
            ::oRefMov:cText(     ::oParent:oArt:Codigo )
         else 
            ::oDbfVir:cRefMov    := ::oParent:oArt:Codigo
         end if 
         
         if !empty(::oGetDetalle)
            ::oGetDetalle:cText( ::oParent:oArt:Nombre )
         else 
            ::oDbfVir:cNomMov    := ::oParent:oArt:Nombre 
         end if 

         // Propiedades--------------------------------------------------------

         if !empty( cValPr1 ) .and. !empty( ::oValPr1 )
            ::oValPr1:cText( cValPr1 )
         else 
            ::oDbfVir:cValPr1    := cValPr1
         end if

         if !empty( cValPr2 ) .and. !empty( ::oValPr2 )
            ::oValPr2:cText( cValPr2 )
         else 
            ::oDbfVir:cValPr2    := cValPr2
         end if

         // Dejamos pasar a los productos de tipo kit-----------------------

         if ::oParent:oArt:lKitArt
            ::oDbfVir:lNoStk     := !lStockCompuestos( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias )
            ::oDbfVir:lKitArt    := .t.
            ::oDbfVir:lKitEsc    := .f.
            ::oDbfVir:lImpLin    := lImprimirCompuesto( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias )
            ::oDbfVir:lKitPrc    := !lPreciosCompuestos( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias )
         else
            ::oDbfVir:lNoStk     := ( ::oParent:oArt:nCtlStock > 1 )
            ::oDbfVir:lKitArt    := .f.
            ::oDbfVir:lKitEsc    := .f.
            ::oDbfVir:lImpLin    := .f.
            ::oDbfVir:lKitPrc    := .f.
         end if

         if ::oParent:oArt:nCajEnt != 0 .and. ::oDbfVir:nCajMov == 0
            if !empty(::oCajMov)
               ::oCajMov:cText( ::oParent:oArt:nCajEnt )
            else
               ::oDbfVir:nCajMov := ::oParent:oArt:nCajEnt
            end if 
         end if

         if ::oDbfVir:nUndMov == 0
            if !empty(::oUndMov)
               ::oUndMov:cText( max( ::oParent:oArt:nUniCaja, 1 ) )
            else
               ::oDbfVir:nUndMov := max( ::oParent:oArt:nUniCaja, 1 )
            end if
         end if

         // Peso y Volumen--------------------------------------------------------

         ::oDbfVir:nVolumen      := ::oParent:oArt:nVolumen
         ::oDbfVir:cVolumen      := ::oParent:oArt:cVolumen
         ::oDbfVir:nPesoKg       := ::oParent:oArt:nPesoKg
         ::oDbfVir:cPesoKg       := ::oParent:oArt:cUndDim

         // Lotes-----------------------------------------------------------------

         ::oDbfVir:lLote         := ::oParent:oArt:lLote

         if ::oParent:oArt:lLote
            if !empty(::oSayLote)
               ::oSayLote:Show()
            end if 
            if !empty(::oGetLote)
               ::oGetLote:Show()
            end if 
         else
            if !empty(::oSayLote)
               ::oSayLote:Hide()
            end if 
            if !empty(::oGetLote)
               ::oGetLote:Hide()
            end if 
         end if

         // Propiedades--------------------------------------------------------------

         ::oDbfVir:cCodPr1       := ::oParent:oArt:cCodPrp1
         ::oDbfVir:cCodPr2       := ::oParent:oArt:cCodPrp2

         if ( !empty( ::oDbfVir:cCodPr1 ) .or. !empty( ::oDbfVir:cCodPr2 ) )     .and.;
            ( !lEmptyProp( ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias ) .or. !lEmptyProp( ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias ) ) .and.;
            ( empty( ::oDbfVir:cValPr1 ) .or. empty( ::oDbfVir:cValPr2 ) )       .and.;
            ( uFieldEmpresa( "lUseTbl" )                                         .and.;
            ( nMode == APPD_MODE ) )

            if( !empty(::oValPr1),  ::oValPr1:Hide(),    )
            if( !empty(::oSayPr1),  ::oSayPr1:Hide(),    )
            if( !empty(::oSayVp1),  ::oSayVp1:Hide(),    )
            if( !empty(::oValPr2),  ::oValPr2:Hide(),    )
            if( !empty(::oSayPr2),  ::oSayPr2:Hide(),    )
            if( !empty(::oSayVp2),  ::oSayVp2:Hide(),    )
            if( !empty(::oSayLote), ::oSayLote:Hide(),   )
            if( !empty(::oGetLote), ::oGetLote:Hide(),   )

            setPropertiesTable( ::oParent:oArt:Codigo, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, 0, ::oUndMov, ::oBrwPrp, ::oParent:nView )
            
         else

            hidePropertiesTable( ::oBrwPrp )

            if !empty( ::oDbfVir:cCodPr1 )
               if( !empty(::oValPr1), ::oValPr1:show(), )
               if( !empty(::oSayPr1), ::oSayPr1:show(), )
               if( !empty(::oSayPr1), ::oSayPr1:setText( retProp( ::oDbfVir:cCodPr1 ) ), )
               if( !empty(::oSayVp1), ::oSayVp1:show(), )
            else
               if( !empty(::oValPr1), ::oValPr1:Hide(), )
               if( !empty(::oSayPr1), ::oSayPr1:Hide(), )
               if( !empty(::oSayVp1), ::oSayVp1:Hide(), )
            end if

            if !empty( ::oDbfVir:cCodPr2 )
               if( !empty(::oValPr2), ::oValPr2:show(), )
               if( !empty(::oSayPr2), ::oSayPr2:show(), )
               if( !empty(::oSayPr2), ::oSayPr2:setText( retProp( ::oDbfVir:cCodPr2 ) ), )
               if( !empty(::oSayVp2), ::oSayVp2:show(), )
            else
               if( !empty(::oValPr2), ::oValPr2:Hide(), )
               if( !empty(::oSayPr2), ::oSayPr2:Hide(), )
               if( !empty(::oSayVp2), ::oSayVp2:Hide(), )
            end if

            // Posicionar el foco----------------------------------------------------

            do case
               case !Empty( ::oDbfVir:cCodPr1 ) .and. Empty( ::oDbfVir:cValPr1 )
                  if( !empty(::oValPr1), ::oValPr1:SetFocus(), )

               case !Empty( ::oDbfVir:cCodPr2 ) .and. Empty( ::oDbfVir:cValPr2 )
                  if( !empty(::oValPr2), ::oValPr2:SetFocus(), )

               case ::oDbfVir:lLote
                  if( !empty(::oGetLote), ::oGetLote:SetFocus(), )

               otherwise
                  if( !empty(::oUndMov), ::oUndMov:SetFocus(), )

            end case

         end if

         // Precios de costo---------------------------------------------------

         if !empty(::oPreDiv)
            ::oPreDiv:cText( ::getPrecioCosto() )
         else
            ::oDbfVir:nPreDiv    := ::getPrecioCosto()
         end if 

         // Stock actual-------------------------------------------------------

         if !empty(::oGetStockOrigen)
            ::oParent:oStock:lPutStockActual( ::oDbfVir:cRefMov, ::oParent:oDbf:cAlmOrg, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote, .f., ::oParent:oArt:nCtlStock, ::oGetStockOrigen )
         end if 

         if !empty(::oGetStockDestino)
            ::oParent:oStock:lPutStockActual( ::oDbfVir:cRefMov, ::oParent:oDbf:cAlmDes, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote, .f., ::oParent:oArt:nCtlStock, ::oGetStockDestino )
         end if 

         // Guardamos el stock anterior----------------------------------------

         SysRefresh()

         nPos                 := aScan( ::oParent:oStock:aStocks, {|o| o:cCodigo == ::oParent:oArt:Codigo .and. o:cCodigoAlmacen == ::oParent:oDbf:cAlmDes .and. o:cValorPropiedad1 == ::oDbfVir:cValPr1 .and. o:cValorPropiedad2 == ::oDbfVir:cValPr2 .and. o:cLote == ::oDbfVir:cLote .and. o:cNumeroSerie == ::oDbfVir:mNumSer } )
         if ( nPos != 0 ) .and. isNum( ::oParent:oStock:aStocks[ nPos ]:nUnidades )
            ::oDbfVir:nUndAnt := ::oParent:oStock:aStocks[ nPos ]:nUnidades
         end if

      end if

      // Variables para no volver a ejecutar--------------------------------

      ::cOldLote              := ::oDbfVir:cLote
      ::cOldCodArt            := ::oDbfVir:cRefMov
      ::cOldValPr1            := ::oDbfVir:cValPr1
      ::cOldValPr2            := ::oDbfVir:cValPr2

      CursorWE()

   else

      if !lSilenceMode
         MsgStop( "Art�culo no encontrado." )
      end if 

      Return .f.

   end if

Return .t.

//--------------------------------------------------------------------------//

METHOD getPrecioCosto() CLASS TDetMovimientos

   local nPrecioCosto   := 0

   if !uFieldEmpresa( "lCosAct" )
      if ( ::oParent:oDbf:nTipMov == 1 )
         nPrecioCosto   := ::oParent:oStock:nCostoMedio( ::oDbfVir:cRefMov, ::oParent:oDbf:cAlmOrg, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote )
      else
         nPrecioCosto   := ::oParent:oStock:nCostoMedio( ::oDbfVir:cRefMov, ::oParent:oDbf:cAlmDes, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote )
      end if
   end if 

   if ( nPrecioCosto == 0 )
      nPrecioCosto      := nCosto( ::oDbfVir:cRefMov, ::oParent:oArt:cAlias, ::oParent:oArtKit:cAlias )
   end if

Return ( nPrecioCosto )

//--------------------------------------------------------------------------//

METHOD nStockActualAlmacen( cCodAlm ) CLASS TDetMovimientos

   local aStock      := {}
   local nTotStock   := 0

   for each aStock in ::aStockActual

      if aStock[1] == cCodAlm
         nTotStock   += aStock[6]
      end if

   next

RETURN nTotStock

//---------------------------------------------------------------------------//

METHOD SetDlgMode( nMode, oSayTotal, oSayPre ) CLASS TDetMovimientos

   ::oBrwPrp:Hide()

   if ( ::oParent:oDbf:nTipMov == 3 )
      ::oBtnSerie:Hide()
   end if

   if nMode == APPD_MODE

      ::oSayLote:Hide()
      ::oGetLote:Hide()

      ::oValPr1:Hide()
      ::oSayPr1:Hide()
      ::oSayVp1:Hide()

      ::oValPr2:Hide()
      ::oSayPr2:Hide()
      ::oSayVp2:Hide()

      if !uFieldEmpresa( "lUseBultos" )
         ::oGetBultos:Hide()
         ::oSayBultos:Hide()
      end if 

      if !lUseCaj()
         ::oCajMov:Hide()
         ::oSayCaj:Hide()
      end if

   else

      if ::oDbfVir:lLote
         ::oGetLote:Show()
         ::oSayLote:Show()
      else
         ::oGetLote:Hide()
         ::oSayLote:Hide()
      end if

      if !Empty( ::oDbfVir:cValPr1 )
         ::oSayPr1:Show()
         ::oSayVp1:Show()
         ::oValPr1:Show()
         ::oSayPr1:SetText( retProp( ::oDbfVir:cCodPr1 ) )
         lPrpAct( ::oDbfVir:cValPr1, ::oSayVp1, ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias )
      else
         ::oValPr1:Hide()
         ::oSayPr1:Hide()
         ::oSayVp1:Hide()
      end if

      if !Empty( ::oDbfVir:cValPr2 )
         ::oSayPr2:Show()
         ::oSayVp2:Show()
         ::oValPr2:Show()
         ::oSayPr2:SetText( retProp( ::oDbfVir:cCodPr2 ) )
         lPrpAct( ::oDbfVir:cValPr2, ::oSayVp2, ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias )
      else
         ::oValPr2:Hide()
         ::oSayPr2:Hide()
         ::oSayVp2:Hide()
      end if

      if !uFieldempresa( "lUseBultos" )
         ::oGetBultos:Hide()
         ::oSayBultos:Hide()
      end if

      if !lUseCaj()
         ::oCajMov:Hide()
         ::oSayCaj:Hide()
         ::oSayUnd:SetText( "Unidades" )
      end if

   end if

   /*
   Ocultamos el costo si el usuario no tiene permisos para verlo---------------
   */

   if !Empty( ::oPreDiv ) .and. oUser():lNotCostos()
      ::oPreDiv:Hide()
   end if

   if !Empty( oSayTotal ) .and. oUser():lNotCostos()
      oSayTotal:Hide()
   end if

   if !Empty( oSayPre ) .and. oUser():lNotCostos()
      oSayPre:Hide()
   end if

   /*
   Cargamos la configuracion de columnas---------------------------------------
   */

   if Empty( ::oParent:oDbf:cAlmOrg )
      ::oGetAlmacenOrigen:Hide()
      ::oTxtAlmacenOrigen:Hide()
      ::oGetStockOrigen:Hide()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppendKit() CLASS TDetMovimientos

   local nRec     := ::oDbfVir:Recno()
   local nNumLin  := ::oDbfVir:nNumLin
   local cCodArt  := ::oDbfVir:cRefMov
   local nTipMov  := ::oDbfVir:nTipMov
   local cAliMov  := ::oParent:oDbf:cAlmDes
   local cAloMov  := ::oParent:oDbf:cAlmOrg
   local cCodMov  := ::oDbfVir:cCodMov
   local nCajMov  := ::oDbfVir:nCajMov
   local nUndMov  := ::oDbfVir:nUndMov
   local nNumRem  := ::oDbfVir:nNumRem
   local cSufRem  := ::oDbfVir:cSufRem
   local cCodUsr  := ::oDbfVir:cCodUsr
   local cCodDlg  := ::oDbfVir:cCodDlg
   local nTotUnd  := 0
   local nStkAct  := 0
   local nMinimo  := 0

   if ::oParent:oArtKit:SeekInOrd( cCodArt, "cCodKit" )

      while ( ::oParent:oArtKit:cCodKit == cCodArt ) .and. !( ::oParent:oArtKit:Eof() )

         if ::oParent:oArt:SeekInOrd( ::oParent:oArtKit:cRefKit, "Codigo" ) .and. lStockComponentes( cCodArt, ::oParent:oArt:cAlias )

            nStkAct              := ::oParent:oStock:nStockAlmacen( ::oParent:oArtKit:cRefKit, cAloMov )

            ::oDbfVir:Append()

            ::oDbfVir:dFecMov    := getSysDate()
            ::oDbfVir:cTimMov    := getSysTime()
            ::oDbfVir:nTipMov    := nTipMov
            ::oDbfVir:cAliMov    := cAliMov
            ::oDbfVir:cAloMov    := cAloMov
            ::oDbfVir:cRefMov    := ::oParent:oArtKit:cRefKit
            ::oDbfVir:cNomMov    := ::oParent:oArtKit:cDesKit
            ::oDbfVir:cCodMov    := cCodMov
            ::oDbfVir:cCodPr1    := Space( 20 )
            ::oDbfVir:cCodPr2    := Space( 20 )
            ::oDbfVir:cValPr1    := Space( 20 )
            ::oDbfVir:cValPr2    := Space( 20 )
            ::oDbfVir:cCodUsr    := cCodUsr
            ::oDbfVir:cCodDlg    := cCodDlg
            ::oDbfVir:lLote      := ::oParent:oArt:lLote
            ::oDbfVir:nLote      := ::oParent:oArt:nLote
            ::oDbfVir:cLote      := ::oParent:oArt:cLote
            ::oDbfVir:nCajMov    := nCajMov
            ::oDbfVir:nUndMov    := ::oParent:oArtKit:nUndKit * nUndMov

            if nTipMov == 3
               ::oDbfVir:nCajAnt := 0
               ::oDbfVir:nUndAnt := nStkAct
            end if

            ::oDbfVir:nPreDiv    := ::oParent:oArt:pCosto
            ::oDbfVir:lSndDoc    := .t.
            ::oDbfVir:nNumRem    := nNumRem
            ::oDbfVir:cSufRem    := cSufRem
            ::oDbfVir:lSelDoc    := .t.

            ::oDbfVir:lKitArt    := .f.
            ::oDbfVir:lNoStk     := .f.
            ::oDbfVir:lImpLin    := lImprimirComponente( cCodArt, ::oParent:oArt:cAlias )
            ::oDbfVir:lKitPrc    := !lPreciosComponentes( cCodArt, ::oParent:oArt:cAlias )

            if lKitAsociado( cCodArt, ::oParent:oArt:cAlias )
               ::oDbfVir:nNumLin := nLastNum( ::oDbfVir:cAlias )
               ::oDbfVir:lKitEsc := .f.
            else
               ::oDbfVir:nNumLin := nNumLin
               ::oDbfVir:lKitEsc := .t.
            end if

            /*
            Avisamos en movimientos con stock bajo minimo-------------------------------
            */

            nTotUnd              := NotCaja( ::oDbfVir:nCajMov ) * ::oDbfVir:nUndMov
            nMinimo              := oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "nMinimo" )

            if nTotUnd != 0 .and. oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "lMsgMov" )

               if ( ( nStkAct - nTotUnd ) < nMinimo )

                  MsgStop( "El stock del componente " + AllTrim( ::oDbfVir:cRefMov ) + " - " + AllTrim( oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "Nombre" ) ) + CRLF + ;
                           "est� bajo minimo." + CRLF + ;
                           "Unidades a vender : " + AllTrim( Trans( nTotUnd, MasUnd() ) ) + CRLF + ;
                           "Stock actual : " + AllTrim( Trans( nStkAct, MasUnd() ) )      + CRLF + ;
                           "Stock minimo : " + AllTrim( Trans( nMinimo, MasUnd() ) ),;
                           "�Atenci�n!" )

               end if

            end if

            ::oDbfVir:Save()

         end if

         ::oParent:oArtKit:Skip()

      end while

   end if

   /*
   Volvemos al registro en el que estabamos y refrescamos el browse------------
   */

   ::oDbfVir:GoTo( nRec )

   ::oParent:oBrwDet:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD aStkArticulo() CLASS TDetMovimientos

   ::nStockActual       := 0

   if !Empty( ::oDbfVir:cRefMov ) .and. oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "nCtlStock" ) <= 1

      ::oParent:oStock:aStockArticulo( ::oDbfVir:cRefMov, , ::oBrwStock )

      aEval( ::oBrwStock:aArrayData, {|o| ::nStockActual += o:nUnidades } )

      ::oBrwStock:Show()

   else

      ::oBrwStock:Hide()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizaKit( nMode ) CLASS TDetMovimientos

   local nRec     := ::oDbfVir:Recno()
   local nOrdAnt  := ::oDbfVir:OrdSetFocus( "nNumLin" )
   local cRefMov  := ::oDbfVir:cRefMov
   local nNumLin  := ::oDbfVir:FieldGetName( "nNumLin" )
   local nCajMov
   local nUndMov

   do case
      case nMode == APPD_MODE
         nCajMov  := ::oDbfVir:FieldGetName( "nCajMov" )
         nUndMov  := ::oDbfVir:FieldGetName( "nUndMov" )

      case nMode == EDIT_MODE
         nCajMov  := ::oDbfVir:nCajMov
         nUndMov  := ::oDbfVir:nUndMov

   end if

   ::oDbfVir:GoTop()

   while !::oDbfVir:Eof()

      if ::oDbfVir:FieldGetName( "nNumLin" ) == nNumLin        .and.;
         ::oDbfVir:FieldGetName( "lKitEsc" )                   .and.;
         ::oParent:oArtKit:SeekInOrd( cRefMov + ::oDbfVir:FieldGetName( "cRefMov" ), "cCodRef" )

         ::oDbfVir:FieldPutByName( "nCajMov", nCajMov )
         ::oDbfVir:FieldPutByName( "nUndMov", ( nUndMov * ::oParent:oArtKit:nUndKit ) )

      end if

      ::oDbfVir:Skip()

   end while

   ::oDbfVir:OrdSetFocus( nOrdAnt )

   ::oDbfVir:GoTo( nRec )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Save() CLASS TDetMovimientos

   local nSec
   local oWaitMeter
   local nKeyCount   := ::oDbfVir:ordKeyCount()

   oWaitMeter        := TWaitMeter():New( "Guardando movimientos de almac�n", "Espere por favor..." )
   oWaitMeter:Run()
   oWaitMeter:setTotal( nKeyCount )

   /*
   Guardamos todo de manera definitiva-----------------------------------------
   */

   CursorWait()

   ::oDbfVir:KillFilter()

   ::oDbfVir:GetStatus()
   ::oDbfVir:OrdSetFocus( 0 )

   do case
   case ::oParent:oDbf:nTipMov == 1

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::oDbfVir:Load()
         ::Asigna()
         ::oDbfVir:Save()

         ::oDbf:AppendFromObject( ::oDbfVir )

         ::oDbfVir:Skip()

         oWaitMeter:setMessage( "Guardando movimiento " + alltrim( str( ::oDbfVir:OrdKeyNo() ) ) + " de " + alltrim( str( nKeyCount ) ) )
         oWaitMeter:AutoInc()

      end while

   case ::oParent:oDbf:nTipMov == 2

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::oDbfVir:Load()
         ::Asigna()
         ::oDbfVir:Save()

         ::oDbf:AppendFromObject( ::oDbfVir )

         ::oDbfVir:Skip()

         oWaitMeter:setMessage( "Guardando movimiento " + alltrim( str( ::oDbfVir:OrdKeyNo() ) ) + " de " + alltrim( str( nKeyCount ) ) )
         oWaitMeter:AutoInc()

      end while

   case ::oParent:oDbf:nTipMov == 3

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         if ::oDbfVir:lSelDoc

            ::oDbfVir:Load()
            ::Asigna()

            ::oDbfVir:lSelDoc := .f.
            ::oDbfVir:nUndMov := ( nTotNMovAlm( ::oDbfVir ) - nTotNMovOld( ::oDbfVir ) ) / NotCero( ::oDbfVir:nCajMov )
            ::oDbfVir:nUndAnt := 0
            ::oDbfVir:nCajAnt := 0

            ::oDbfVir:Save()

            ::oDbf:AppendFromObject( ::oDbfVir )

         else

            ::oDbfVir:Load()
            ::Asigna()
            ::oDbfVir:Save()

            ::oDbf:AppendFromObject( ::oDbfVir )

         end if

         ::oDbfVir:Skip()

         oWaitMeter:setMessage( "Guardando movimiento " + alltrim( str( ::oDbfVir:OrdKeyNo() ) ) + " de " + alltrim( str( nKeyCount ) ) )
         oWaitMeter:AutoInc()

      end while

   case ::oParent:oDbf:nTipMov == 4

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::Asigna()

         ::oDbf:AppendFromObject( ::oDbfVir )

         ::oDbfVir:Skip()

         oWaitMeter:setMessage( "Guardando movimiento " + alltrim( str( ::oDbfVir:OrdKeyNo() ) ) + " de " + alltrim( str( nKeyCount ) ) )
         oWaitMeter:AutoInc()

      end while

   end case

   ::oDbfVir:SetStatus()

   oWaitMeter:end()

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//

METHOD Asigna() CLASS TDetMovimientos

   ::oDbfVir:nNumRem    := ::oParent:oDbf:nNumRem
   ::oDbfVir:cSufRem    := ::oParent:oDbf:cSufRem
   ::oDbfVir:dFecMov    := ::oParent:oDbf:dFecRem
   ::oDbfVir:cTimMov    := ::oParent:oDbf:cTimRem
   ::oDbfVir:nTipMov    := ::oParent:oDbf:nTipMov
   ::oDbfVir:cCodMov    := ::oParent:oDbf:cCodMov
   ::oDbfVir:cAliMov    := ::oParent:oDbf:cAlmDes
   ::oDbfVir:cAloMov    := ::oParent:oDbf:cAlmOrg
   ::oDbfVir:cCodUsr    := ::oParent:oDbf:cCodUsr
   ::oDbfVir:cCodDlg    := ::oParent:oDbf:cCodDlg
   ::oDbfVir:lSndDoc    := .t.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotRemVir( lPic ) CLASS TDetMovimientos

   local nTot     := 0

   DEFAULT lPic   := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:eof()
         nTot     += nTotLMovAlm( ::oDbfVir )
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nTot, ::oParent:cPirDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotUnidadesVir( lPic ) CLASS TDetMovimientos

   local nTot     := 0

   DEFAULT lPic   := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:eof()
         nTot     += nTotNMovAlm( ::oDbfVir )
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nTot, ::oParent:cPicUnd ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotPesoVir( lPic ) CLASS TDetMovimientos

   local nPeso    := 0

   DEFAULT lPic   := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:Eof()
         nPeso    += ( NotCaja( ::oDbfVir:nCajMov ) * ::oDbfVir:nUndMov ) * ::oDbfVir:nPesoKg
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nPeso, MasUnd() ), nPeso ) )

//---------------------------------------------------------------------------//

METHOD nTotVolumenVir( lPic ) CLASS TDetMovimientos

   local nVolumen    := 0

   DEFAULT lPic      := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:Eof()
         nVolumen    += ( NotCaja( ::oDbfVir:nCajMov ) * ::oDbfVir:nUndMov ) * ::oDbfVir:nVolumen
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nVolumen, MasUnd() ), nVolumen ) )

//---------------------------------------------------------------------------//

METHOD RecalcularPrecios() CLASS TDetMovimientos

   local nRecno

   if !msgYesNo( "�Desea recalcular los precios de costo?", "Confirme")
      Return .f.
   end if 

   CursorWait()

   nRecno   := ::oDbfVir:Recno()

   ::oDbfVir:GoTop()
   while !::oDbfVir:Eof()
      ::oDbfVir:FieldPutByName( "nPreDiv", ::getPrecioCosto() )
      ::oDbfVir:Skip()
   end while

   ::oDbfVir:GoTo( nRecno )

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetSeriesMovimientos FROM TDet

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD Load( lAppend )

   METHOD Save()

   METHOD RollBack()

   METHOD Resource( nMode, lLiteral )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver, lUniqueName, cFileName ) CLASS TDetSeriesMovimientos

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "MovSer"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cDriver ) COMMENT "N�meros de serie de movimientos de almacen"

      FIELD NAME "nNumRem"    TYPE "N" LEN  9  DEC 0 PICTURE "999999999"                        HIDE        OF oDbf
      FIELD NAME "cSufRem"    TYPE "C" LEN  2  DEC 0 PICTURE "@!"                               HIDE        OF oDbf
      FIELD NAME "dFecRem"    TYPE "D" LEN  8  DEC 0                                            HIDE        OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN 04  DEC 0 COMMENT "N�mero de l�nea"                  COLSIZE  60 OF oDbf
      FIELD NAME "cCodArt"    TYPE "C" LEN 18  DEC 0 COMMENT "Art�culo"                         COLSIZE  60 OF oDbf
      FIELD NAME "cAlmOrd"    TYPE "C" LEN 16  DEC 0 COMMENT "Almac�n"                          COLSIZE  50 OF oDbf
      FIELD NAME "lUndNeg"    TYPE "L" LEN 01  DEC 0 COMMENT "L�gico de unidades en negativo"   HIDE        OF oDbf
      FIELD NAME "cNumSer"    TYPE "C" LEN 30  DEC 0 COMMENT "N�mero de serie"                  HIDE        OF oDbf

      INDEX TO ( cFileName ) TAG "cNumOrd" ON "Str( nNumRem ) + cSufRem + Str( nNumLin )"       NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodArt" ON "cCodArt + cAlmOrd + cNumSer"                     NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cNumSer" ON "cNumSer"                                         NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin" ON "Str( nNumLin ) + cCodArt"                        NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetSeriesMovimientos

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetSeriesMovimientos

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf         := nil
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Save() CLASS TDetSeriesMovimientos

   local nNumRem  := ::oParent:oDbf:nNumRem
   local cSufRem  := ::oParent:oDbf:cSufRem
   local dFecRem  := ::oParent:oDbf:dFecRem
   local cAlmDes  := ::oParent:oDbf:cAlmDes

   ::oDbfVir:OrdSetFocus( 0 )

   ( ::oDbfVir:nArea )->( dbGoTop() )
   while !( ::oDbfVir:nArea )->( eof() )

      ( ::oDbf:nArea )->( dbAppend() )

      if !( ::oDbf:nArea )->( NetErr() )

         ( ::oDbf:nArea )->nNumRem  := nNumRem
         ( ::oDbf:nArea )->cSufRem  := cSufRem
         ( ::oDbf:nArea )->dFecRem  := dFecRem
         ( ::oDbf:nArea )->cAlmOrd  := cAlmDes
         ( ::oDbf:nArea )->nNumLin  := ( ::oDbfVir:nArea )->nNumLin
         ( ::oDbf:nArea )->cCodArt  := ( ::oDbfVir:nArea )->cCodArt
         ( ::oDbf:nArea )->lUndNeg  := ( ::oDbfVir:nArea )->lUndNeg
         ( ::oDbf:nArea )->cNumSer  := ( ::oDbfVir:nArea )->cNumSer

         ( ::oDbf:nArea )->( dbUnLock() )

      end if

      ( ::oDbfVir:nArea )->( dbSkip() )

      if !Empty( ::oParent ) .and. !Empty( ::oParent:oMeter )
         ::oParent:oMeter:AutoInc()
      end if

   end while

   ::Cancel()

   if !Empty( ::oParent ) .and. !Empty( ::oParent:oMeter )
      ::oParent:oMeter:Refresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD RollBack() CLASS TDetSeriesMovimientos

   local cKey  := ::oParent:cFirstKey
   local nArea := ::oDbf:nArea

   if cKey != nil

      while ( nArea )->( dbSeek( cKey ) ) // ::oDbf:Seek( cKey )

         if ( nArea )->( dbRlock() )
            ( nArea )->( dbDelete() )     // ::oDbf:Delete( .f. )
         end if

         if !Empty( ::oParent ) .and. !Empty( ::oParent:oMeter )
            ::oParent:oMeter:AutoInc()
         end if

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetSeriesMovimientos

   ::oDbfVir:GetStatus()
   ::oDbfVir:OrdSetFocus( "nNumLin" )

   with object ( TNumerosSerie() )

      :nMode            := nMode

      :lCompras         := ( ::oParent:oDbf:nTipMov != 1 )

      :cCodArt          := ::oParent:oDetMovimientos:oDbfVir:cRefMov

      :nNumLin          := ::oParent:oDetMovimientos:oDbfVir:nNumLin
      :cCodAlm          := ::oParent:oDbf:cAlmDes

      :nTotalUnidades   := nTotNMovAlm( ::oParent:oDetMovimientos:oDbfVir )

      :oStock           := ::oParent:oStock

      :uTmpSer          := ::oDbfVir

      :Resource()

   end with

   ::oDbfVir:SetStatus()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Load( lAppend )

   DEFAULT lAppend   := .f.

   ::nRegisterLoaded := 0

   if Empty( ::oDbfVir )
      ::oDbfVir      := ::DefineFiles( cPatTmp(), cLocalDriver(), .t. )
   end if

   if !( ::oDbfVir:Used() )
      ::oDbfVir:Activate( .f., .f. )
   end if

   ::oDbfVir:Zap()   

   if ::oParent:cFirstKey != nil

      if ( lAppend ) .and. ::oDbf:Seek( ::oParent:cFirstKey )

         while !Empty( ::oDbf:OrdKeyVal() ) .and. ( str( ::oDbf:nNumRem ) + ::oDbf:cSufRem == ::oParent:cFirstKey ) .and. !( ::oDbf:Eof() )

            if ::bOnPreLoad != nil
               Eval( ::bOnPreLoad, Self )
            end if

            ::oDbfVir:AppendFromObject( ::oDbf )

            ::nRegisterLoaded++

            if ::bOnPostLoad != nil
               Eval( ::bOnPostLoad, Self )
            end if

            ::oDbf:Skip()

         end while

      end if

   end if

   ::oDbfVir:GoTop()

Return ( Self )

//---------------------------------------------------------------------------//

Function AppMovimientosAlmacen()

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

   if oRemMovAlm:OpenFiles()

      oRemMovAlm:Append()

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

return .t.

//---------------------------------------------------------------------------//

Function EditMovimientosAlmacen( cNumParte, oBrw )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:Edit( oBrw )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*funcion para hacer zoom un parte desde fuera de la clase*/

function ZoomMovimientosAlmacen( cNumParte, oBrw )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:Zoom( oBrw )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*funcion para eliminar un parte desde fuera de la clase*/

function DelMovimientosAlmacen( cNumParte, oBrw )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:Del( oBrw )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*
funcion para imprimir un parte desde fuera de la clase
*/

function PrnMovimientosAlmacen( cNumParte )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:GenRemMov( IS_PRINTER )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
funcion para visualizar un parte desde fuera de la clase
*/

function VisMovimientosAlmacen( cNumParte )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:GenRemMov( IS_SCREEN )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

Function nTotNMovOld( uDbf )

   local nTotUnd  := 0

   do case
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCajAnt ) * ( uDbf )->nUndAnt
   case ValType( uDbf ) == "O"
      nTotUnd     := NotCaja( uDbf:nCajAnt ) * uDbf:nUndAnt
   end case

RETURN ( nTotUnd )

//-------------------------------------------------------------------------//

Function nTotLMovAlm( uDbf )

   local nTotUnd  := nTotNMovAlm( uDbf )

   do case
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCajMov ) * ( uDbf )->nUndMov * ( uDbf )->nPreDiv
   case ValType( uDbf ) == "O"
      nTotUnd     := NotCaja( uDbf:nCajMov ) * uDbf:nUndMov * uDbf:nPreDiv
      // nTotUnd     := NotCaja( uDbf:FieldGetByName( "nCajMov" ) ) * uDbf:FieldGetByName( "nUndMov" ) * uDbf:FieldGetByName( "nPreDiv" )
   end case

RETURN ( nTotUnd )

//---------------------------------------------------------------------------//

Function nTotNMovAlm( uDbf )

   local nTotUnd  := 0

   do case
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCajMov ) * ( uDbf )->nUndMov
   case ValType( uDbf ) == "O"
      nTotUnd     := NotCaja( uDbf:nCajMov ) * uDbf:nUndMov
   end case

RETURN ( nTotUnd )

//-------------------------------------------------------------------------//

function nTotVMovAlm( cCodArt, dbfMovAlm, cCodAlm )

   local nTotVta  := 0
   local nOrd     := ( dbfMovAlm )->( OrdSetFocus( "cRefMov" ) )
   local nRec     := ( dbfMovAlm )->( Recno() )

   if ( dbfMovAlm )->( dbSeek( cCodArt ) )

      while ( dbfMovAlm )->cRefMov == cCodArt .and. !( dbfMovAlm )->( eof() )

         if !( dbfMovAlm )->lNoStk

            if cCodAlm != nil

               if cCodAlm == ( dbfMovAlm )->cAliMov
                  nTotVta  += nTotNMovAlm( dbfMovAlm )
               end if

               if cCodAlm == ( dbfMovAlm )->cAloMov
                  nTotVta  -= nTotNMovAlm( dbfMovAlm )
               end if

            else

               if !Empty( ( dbfMovAlm )->cAliMov )
                  nTotVta  += nTotNMovAlm( dbfMovAlm )
               end if

               if !Empty( ( dbfMovAlm )->cAloMov )
                  nTotVta  -= nTotNMovAlm( dbfMovAlm )
               end if

            end if

         end if

         ( dbfMovAlm )->( dbSkip() )

      end while

   end if

   ( dbfMovAlm )->( dbGoTo( nRec ) )
   ( dbfMovAlm )->( OrdSetFocus( nOrd ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

Function cTextoMovimiento( dbfHisMov )

Return ( { "Entre almacenes", "Regularizaci�n", "Objetivos", "Consolidaci�n" }[ Min( Max( ( dbfHisMov )->nTipMov, 1 ), 4 ) ] )

//---------------------------------------------------------------------------//

FUNCTION ZooMovAlm( nNumRec, oBrw )

RETURN NIL

//----------------------------------------------------------------------------//

Function nombrePrimeraPropiedadMovimientosAlmacen()

Return ( nombrePropiedad( oThis:oDetMovimientos:oDbf:FieldGetByName( "cCodPr1" ), oThis:oDetMovimientos:oDbf:FieldGetByName( "cValPr1" ), oThis:nView ) )

//---------------------------------------------------------------------------//

Function nombreSegundaPropiedadMovimientosAlmacen()

Return ( nombrePropiedad( oThis:oDetMovimientos:oDbf:FieldGetByName( "cCodPr2" ), oThis:oDetMovimientos:oDbf:FieldGetByName( "cValPr2" ), oThis:nView ) )

//---------------------------------------------------------------------------//

Function DesignLabelRemesasMovimientosAlmacen( oFr, cDoc )

   local oLabel
   local oRemesasMovimientos

   oRemesasMovimientos  := TRemMovAlm():New( cPatEmp(), cDriver() )
   if !oRemesasMovimientos:Openfiles()
      Return ( nil )
   end if 

   oLabel               := TLabelGeneratorMovimientosAlmacen():New( oRemesasMovimientos )

   // Zona de datos---------------------------------------------------------
   
   oLabel:createTempLabelReport()
   oLabel:loadTempLabelReport()      
   oLabel:dataLabel( oFr )

   // Paginas y bandas------------------------------------------------------

   if !empty( ( cDoc )->mReport )
      oFr:LoadFromBlob( ( cDoc )->( Select() ), "mReport")
   else
      oFr:AddPage(         "MainPage" )
      oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
      oFr:SetProperty(     "MasterData",  "Top",      200 )
      oFr:SetProperty(     "MasterData",  "Height",   100 )
      oFr:SetObjProperty(  "MasterData",  "DataSet",  "Lineas de movimientos de almac�n" )
   end if

   oFr:DesignReport()
   oFr:DestroyFr()

   oLabel:DestroyTempReport()
   oLabel:End()

   oRemesasMovimientos:CloseFiles()

Return ( nil )

//---------------------------------------------------------------------------//
