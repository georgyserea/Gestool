#ifndef __PDA__
#include "FiveWin.Ch"
#include "Error.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif
#include "DbStruct.ch"
#include "DbInfo.ch"
#include "Factu.ch"

#define HB_FF_AUTOINC         0x0008 /* Column is autoincrementing */

//----------------------------------------------------------------------------//

#define NNET_TIME             10

#define MODE_FILE             1
#define MODE_RECORD           2
#define MODE_APPEND           3

static hStatus        

static aResources             := {}
static aAdsDirectory          := {}


//--------------------------------------------------------------------------//
// Funciones para DBF's
//
//--------------------------------------------------------------------------//

#ifndef __PDA__

FUNCTION DbSwapUp( cAlias, oBrw )

	local aRecNew
   local aRecOld  := dbScatter( cAlias )
   local nOrdNum  := ( cAlias )->( OrdSetFocus( 0 ) )
   local nRecNum  := ( cAlias )->( RecNo() )

   ( cAlias )->( dbSkip( -1 ) )

   if ( cAlias )->( Bof() )
		Tone(300,1)
		( cAlias )->( dbGoTo( nRecNum ) )
   else
      aRecNew     := dbScatter( cAlias )
      ( cAlias )->( dbSkip( 1 ) )
      dbGather( aRecNew, cAlias )
      ( cAlias )->( dbSkip( -1 ) )
      dbGather( aRecOld, cAlias )
   end if

   ( cAlias )->( OrdSetFocus( nOrdNum ) )

   if !Empty( oBrw )
      oBrw:Refresh()
      oBrw:Select( 0 )
      oBrw:Select( 1 )
      oBrw:SetFocus()
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION dbSwapDown( cAlias, oBrw )

	local aRecNew
   local aRecOld  := dbScatter( cAlias )
   local nOrdNum  := ( cAlias )->( OrdSetFocus( 0 ) )
   local nRecNum  := ( cAlias )->( RecNo() )

   ( cAlias )->( dbSkip() )

   if ( cAlias )->( Eof() )

      Tone( 300, 1 )
		( cAlias )->( dbGoTo( nRecNum ) )

   else

      aRecNew     := dbScatter( cAlias )
      ( cAlias )->( dbSkip( -1 ) )

      dbGather( aRecNew, cAlias )
      ( cAlias )->( dbSkip() )

      dbGather( aRecOld, cAlias )

   end if

   ( cAlias )->( OrdSetFocus( nOrdNum ) )

   if !Empty( oBrw )
      oBrw:Refresh()
      oBrw:Select( 0 )
      oBrw:Select( 1 )
      oBrw:SetFocus()
   end if

Return nil

//--------------------------------------------------------------------------//

FUNCTION DBTrans( cAliOrigen, cAliDestino, lApp )

	local i
	local nField 	:= (cAliOrigen)->( Fcount() )

	DEFAULT lApp	:= .f.

	IF lApp
		(cAliDestino)->( dbAppend() )
   ELSE
      (cAliDestino)->( dbRLock() )
   END IF

	for i = 1 to nField
		(cAliDestino)->( FieldPut( i, (cAliOrigen)->( FieldGet( i ) ) ) )
	next

   ( cAliDestino )->( dbUnLock() )

RETURN NIL

//----------------------------------------------------------------------------//
/*
Bloquea un fichero
*/

FUNCTION DBFLock( cAlias )

	if DBLock( cAlias, MODE_FILE )
      return .T.
   endif

   while ApoloMsgNoYes( "Fichero Bloquedo," + CRLF + "� Reintentar ?" )

		if DBLock( cAlias, MODE_FILE )
         return .T.
		else
			loop
		endif

   enddo

RETURN .F.

//--------------------------------------------------------------------------//

Function aBlankArray( aBlank, cAlias )

   local i
   local aStruct  := ( cAlias )->( dbStruct() )

   for i = 1 to ( cAlias )->( fCount() )
      Do Case
         Case aStruct[ i, DBS_TYPE ] == "C"
            aBlank[ i ] := Space( aStruct[ i, DBS_LEN ] )
         Case aStruct[ i, DBS_TYPE ] == "M"
            aBlank[ i ] := ""             // Space( aStruct[ i, DBS_LEN ] )
         Case aStruct[ i, DBS_TYPE ] == "N"
            aBlank[ 1 ] := Val( "0." + Replicate( "0", aStruct[ i, DBS_DEC ] ) )
         Case aStruct[ i, DBS_TYPE ] == "L"
            aBlank[ 1 ] := .f.
         Case aStruct[ i, DBS_TYPE ] == "D"
            aBlank[ 1 ] := GetSysDate()   // CtoD( "" ) )
      End Case
   next

RETURN aBlank

//--------------------------------------------------------------------------//
/*
Comprueba que no exista el mismo nombre de fichero
*/

FUNCTION cFilName( cFilName )

	local n := 1

	while file( cFilName + rjust( str( n ), "0", 2 ) )
		n++
	end

RETURN ( cFilName + rjust( str( n ), "0", 2 ) )

//---------------------------------------------------------------------------//

/*
Busca el primero valido dentro de un indice y desde un valor
como origen
*/

FUNCTION dbFirst( cAlias, nField, oGet, xDesde, nOrd )

	local xValRet
   local nPosAct
   local nOrdAct

   DEFAULT cAlias := Alias()
	DEFAULT nField	:= 1

   /*
   Para TDBF-------------------------------------------------------------------
   */

   if IsObject( cAlias )
      cAlias      := cAlias:cAlias
   end if

   nPosAct        := ( cAlias )->( Recno() )

   if nOrd != nil
      nOrdAct     := ( cAlias )->( OrdSetFocus( nOrd ) )
   end if


   if Empty( xDesde )
      ( cAlias )->( dbGoTop() )
   else
      ( cAlias )->( dbSeek( xDesde, .t. ) ) // Busqueda suuuuave
      if ( cAlias )->( eof() )
         ( cAlias )->( dbGoTop() )
      end if
   end if

   if IsChar( nField )
      nField      := ( cAlias )->( FieldPos( nField ) )
   end if

   xValRet        := ( cAlias )->( FieldGet( nField ) )

   ( cAlias )->( dbGoTo( nPosAct ) )

   if !Empty( nOrd )
      ( cAlias )->( OrdSetFocus( nOrdAct ) )
   end if

   if !Empty( oGet )
		oGet:cText( xValRet )
      Return .t.
   end if

Return ( xValRet )

//--------------------------------------------------------------------------//

/*
Busca el primero valido dentro de un indice
*/

FUNCTION dbFirstIdx( cAlias, nOrden, oGet, xDesde )

	local xValRet

	DEFAULT cAlias := Alias()

	IF nOrden == NIL
		nOrden := ( cAlias )->( OrdSetFocus() )
	ELSE
		( cAlias )->( OrdSetFocus( nOrden ) )
	END IF

	Select( cAlias )

	IF xDesde == NIL
		(cAlias)->( DbGoTop() )
	ELSE
		(cAlias)->( DbSeek( xDesde, .T. ) )	// Busqueda suuuuave
		IF (cAlias)->(Eof())
			(cAlias)->(DbGoTop())
		END
	END

	xValRet	:= Eval( Compile( (cAlias)->( OrdKey( nOrden ) ) ) )

	IF oGet != NIL
		oGet:cText( xValRet )
		RETURN .T.
	END

RETURN ( xValRet )

//--------------------------------------------------------------------------//

/*
Busca el ultimo registro dentro de un indice
*/

FUNCTION dbLastIdx( cAlias, nOrden, oGet, xHasta )

	LOCAL xValRet

	DEFAULT cAlias := Alias()

	IF nOrden == NIL
		nOrden := ( cAlias )->( OrdSetFocus() )
	ELSE
		( cAlias )->( OrdSetFocus( nOrden ) )
	END IF

	Select( cAlias )

	IF xHasta == NIL
		(cAlias)->(DbGoBottom())
	ELSE
		(cAlias)->( DbSeek( xHasta, .T. ) )
		IF (cAlias)->( Eof() )
			(cAlias)->(DbGoBottom())
		END
	END

	xValRet := Eval( Compile( (cAlias)->( OrdKey( nOrden ) ) ) )

	IF oGet != NIL
		oGet:cText( xValRet )
		RETURN .T.
	END

RETURN ( xValRet )

//--------------------------------------------------------------------------//

/*
Devuelva una array con todos los tags de un indice
*/

FUNCTION DBRetIndex( cAlias )

	local aIndexes := { "<Ninguno>" }
	local cIndice
   local i        := 1

   IF Empty( ( cAlias )->( OrdSetFocus() ) )
		RETURN aIndexes
	END IF

   while .t.
      cIndice     := ( cAlias )->( OrdName( i ) )

      if cIndice != ""
         aAdd( aIndexes, cIndice )
      else
         exit
      end if

		i++
   end while

RETURN aIndexes

//--------------------------------------------------------------------------//

FUNCTION aDbfToArr( cAlias, nField )

   local aTabla   := {}

	DEFAULT cAlias := Alias()
	DEFAULT nField := 1

   ( cAlias )->( dbGoTop() )
   while !( cAlias )->( Eof() )
      aAdd( aTabla, cValToChar( ( cAlias )->( FieldGet( nField ) ) ) )
      ( cAlias )->( dbSkip() )
   end while
   ( cAlias )->( dbGoTop() )

RETURN aTabla

//--------------------------------------------------------------------------//

/*
Cambia el indice y coloca en los valores correspondientes en las
variables pasadas
*/

FUNCTION ChangeIndex( cAlias, nRadOrden, oGetDesde, oGetHasta )

	DEFAULT cAlias    := Alias()
	DEFAULT nRadOrden := ( cAlias )->( OrdSetFocus() )

	IF oGetDesde != NIL
		oGetDesde:cText( DBFirstIdx( cAlias, nRadOrden ) )
	END IF

	IF oGetHasta != NIL
		oGetHasta:cText( DBLastIdx( cAlias, nRadOrden ) )
	END IF

RETURN .T.

//---------------------------------------------------------------------------//

FUNCTION oExiste( oClave, cAlias )

RETURN Existe( oClave:varGet(), cAlias )

//-------------------------------------------------------------------------//

FUNCTION oNotExiste( oClave, cAlias )

RETURN ( !Existe( oClave:varGet(), cAlias ) )

//---------------------------------------------------------------------------//

function cNoExt( cFullFile )

   local cNameFile := AllTrim( cFullFile )
   local n         := AT( ".", cNameFile )

return AllTrim( if( n > 0, left( cNameFile, n - 1 ), cNameFile ) )

//----------------------------------------------------------------------------//

FUNCTION cNoPathInt( cFileName )

RETURN Alltrim( SubStr( cFileName, RAt( "/", cFileName ) + 1 ) )

//----------------------------------------------------------------------------//

FUNCTION cOnlyPath( cFileName )

RETURN Alltrim( SubStr( cFileName, 1, RAt( "\", cFileName ) ) )

//----------------------------------------------------------------------------//

FUNCTION cDrivePath( cFileName )

RETURN SubStr( cFileName, 1, RAt( ":", cFileName ) + 1 )

//----------------------------------------------------------------------------//

FUNCTION cFirstPath( cPath )

   local nAt     := At( "\", cPath )

   if nAT == 0
      nAt        := At( "/", cPath )
   end if

RETURN SubStr( cPath, 1, nAt - 1 )

//----------------------------------------------------------------------------//

Function cLastPath( cFileName )

   local cLastPath   := cOnlyPath( cFileName )
   local n           := Rat( "\", SubStr( cLastPath, 1, Len( cLastPath ) - 1 ) ) + 1

Return ( SubStr( cLastPath, n ) )

//----------------------------------------------------------------------------//

Function cPath( cPath )

   cPath             := Rtrim( cPath )

   if Right( cPath, 1 ) != "\"
      cPath          += "\"
   end if

Return ( cPath )

//----------------------------------------------------------------------------//

FUNCTION EvalGet( aGet, nMode )

	local i
   local nLen  := len( aGet )

   for i = 1 to nLen

      if ValType( aGet[i] ) == "O"
         if "GET" $ aGet[ i ]:ClassName()
            aGet[ i ]:lValid()
         end if
      end if

   next

Return nil

//-------------------------------------------------------------------------//

FUNCTION bChar2Block( cChar, lLogic, lMessage, lHard )

	local bBlock
   local oBlock
   local oError
   local lError      := .f.

   DEFAULT lLogic    := .f.
   DEFAULT lMessage  := .t.
   DEFAULT lHard     := .f.

   if Empty( cChar )

      if lLogic
         bBlock      := {|| .t.}
      else
         bBlock      := {|| "" }
      end if

      return ( bBlock )

   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Esto es para probar la expresion-----------------------------------------

      if Type( cChar ) == "UE" .or. ;
         Type( cChar ) == "UI"

         lError      := .t.
         */

         if ValType( cChar ) == "C"
            cChar    := Rtrim( cChar )
            bBlock   := &( "{||" + cChar + "}" )

         elseif ValType( cChar ) == "N"
            bBlock   := {|| cChar }

         end if

         /*
         Probamos la expresion-------------------------------------------------
         */

         Eval( bBlock )

      /*
      end if
      */

   RECOVER USING oError

      lError         := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

   if lError

      if lMessage
         msgStop( "Expresi�n incorrecta " + cChar + CRLF + ErrorMessage( oError ), "bChar2Block" + Type( cChar ) )
      end if

      if lHard
         bBlock      := nil
      else
         if lLogic
            bBlock   := {|| .t.}
         else
            bBlock   := {|| "" }
         end if
      end if

   end if

RETURN ( bBlock )

//---------------------------------------------------------------------------//

// Marca registro a bajo nivel en el espacio de la marca del deleted
// si lo consigue devuelve .t.

function SetMarkRec( cMark, nRec  )

   local nRecNo   := RecNo()
   local nHdl     := DbfHdl()
   local nOffSet  := 0

   nRec           := if( ValType( nRec )  != "N", RecNo(), nRec  )
   cMark          := if( ValType( cMark ) != "C", "#",     cMark )

   nOffSet        := ( RecSize() * ( nRec - 1 ) ) + Header()

   FSeek( nHdl, nOffSet, 0 )
   FWrite( nHdl, cMark, 1 )

   DbGoTo( nRecNo )

return( FError() == 0 )

//---------------------------------------------------------------------------//
// Invierte la marca del registro

function ChgMarked( cMark, nRec )

   if lMarked( cMark, nRec )
      SetMarkRec( Space( 1 ), nRec )
   else
      SetMarkRec( cMark, nRec )
   end if

return ( nil )

//---------------------------------------------------------------------------//
// Marca registro a bajo nivel en el espacio de la marca del deleted
// si lo consigue devuelve .t.

function SetAllMark( cMark, cAlias )

   local nRecNo   := ( cAlias )->( RecNo() )

   cMark          := if( ValType( cMark ) != "C", "#", cMark )

   ( cAlias )->( dbGoTop() )
   while !( cAlias )->( eof() )

      ( cAlias )->( SetMarkRec( cMark ) )
      ( cAlias )->( dbSkip() )

   end while

   ( cAlias )->( DbGoTo( nRecNo ) )

return ( nil )

//---------------------------------------------------------------------------//

function SkipFor( nWantMoved, cAlias, bFor )

   local nMoved   := 0

   if nWantMoved < 0

      while nMoved > nWantMoved .and. !( cAlias )->( bof() )
         ( cAlias )->( dbSkip( -1 ) )
         if ( cAlias )->( Eval( bFor ) )
            nMoved--
         end if
      end while

   else

      while nMoved < nWantMoved .and. !( cAlias )->( eof() )
         ( cAlias )->( dbSkip() )
         if ( cAlias )->( Eval( bFor ) )
            nMoved++
         end if
      end while


   end if

return ( nMoved )

//---------------------------------------------------------------------------//

function NotMinus( nUnits )

return ( if( nUnits < 0, 0, nUnits ) )

//--------------------------------------------------------------------------//

Function cDateTime()

Return ( Dtos( Date() ) + Left( StrTran( Time(), ":","" ), 4 ) )

//----------------------------------------------------------------------------//

Function lNegativo( nNum )

Return ( -0.1 > nNum )

//---------------------------------------------------------------------------//

Function IsArray( u )

Return ( Valtype( u ) == "A" )

//---------------------------------------------------------------------------//

Function IsHash( u )

Return ( Valtype( u ) == "H" )

//---------------------------------------------------------------------------//

Function retChr( cCadena )

   local cChr     := ""

   if Valtype( cCadena ) != "C"
      Return ( cChr )
   end if

   cCadena        := AllTrim( cCadena )

   if !Empty( cCadena )
      cCadena     += Space( 1 )
   end if

   while !Empty( cCadena )
      cChr        += Chr( Val( SubStr( cCadena, 1, At( " ", cCadena ) ) ) )
      cCadena     := SubStr( cCadena, At( " ", cCadena ) + 1 )
   end while

Return ( cChr )

//---------------------------------------------------------------------------//

Function DateToJuliano( dFecha )

   local dInicial

   DEFAULT dFecha := Date()

   dInicial       := Ctod( "01/01/" + AllTrim( Str( Year( dFecha ) ) ) )

Return ( dFecha - dInicial + 1 )

//---------------------------------------------------------------------------//

Function JulianoToDate( nYear, nJuliana )

   local dFecIni

   DEFAULT nYear     := Year( Date() )
   DEFAULT nJuliana  := 0

   dFecIni           := Ctod( "01/01/" + Str( nYear, 4, 0 ) )

Return ( dFecIni + nJuliana - 1 )

//---------------------------------------------------------------------------//

FUNCTION addMonth( ddate, nMth )

   local nDay
   local nMonth
   local nYear
   local nLDOM

   nDay     := Day( dDate )
   nMonth   := Month( dDate )
   nYear    := Year( dDate )

   nMonth   += nmth

   if nMonth <= 0
      do while nMonth <= 0
         nMonth += 12
         nYear--
      enddo
   endif

   if nMonth > 12
      do while nMonth > 12
         nMonth -= 12
         nYear++
      enddo
   endif

   // correction for different end of months
   if nDay > ( nLDOM := lastdayom( nMonth ) )
     nDay   := nLDOM
   endif

return ( Ctod( StrZero( nDay, 2 ) + "/" + StrZero( nMonth, 2 ) + "/" + StrZero( nYear, 4 ) ) )

//---------------------------------------------------------------------------//

FUNCTION LastDayoM( xDate )

   local nMonth   := 0
   local nDays    := 0
   local lleap    := .F.

   do case
      case empty ( xDate)
         nMonth   := month( date() )

      case valtype ( xDate ) == "D"
         nMonth   := month (xdate)
         lleap    := isleap ( xdate)

      case valtype (xDate ) == "N"
         if xdate > 12
            nmonth := 0
         else
            nMonth := xDate
         endif
   endcase

   if nmonth != 0
      ndays       := daysInmonth( nMonth, lleap )
   endif

return ndays

//---------------------------------------------------------------------------//

FUNCTION isLeap ( ddate )

   local nYear
   local nMmyr
   local nCyYr
   local nQdYr
   local lRetval

   if empty ( ddate )
     ddate  := date()
   endif

   nYear    := year (ddate)
   nCyYr    := nYear / 400
   nMmyr    := nYear /100
   nQdYr    := nYear / 4

   do case
      case int (nCyYr) == nCyYr
         lRetVal := .T.

      case int (nMmyr) == nMmyr
         lRetVal := .F.

      case int (nQdYr) == nQdYr
         lRetVal := .T.

      otherwise
         lRetVal := .F.
   endcase

return lRetVal

//---------------------------------------------------------------------------//

FUNCTION daysInmonth ( nMonth, lLeap )

   local nday := 0

   do case
   case nMonth == 2 .and. lLeap
      nday  := 29
   case nMonth == 2 .and. !lLeap
      nday  := 28
   case nMonth == 4 .or. nMonth == 6 .or. nMonth == 9 .or. nMonth == 11
      nday  := 30
   otherwise
      nday  := 31
   endcase

return nday

//---------------------------------------------------------------------------//

/*
Selecciona todos los registros
*/

Function lSelectAll( oBrw, dbf, cFieldName, lSelect, lTop, lMeter )

   local nPos
   local nRecAct        := ( dbf )->( Recno() )

   DEFAULT cFieldName   := "lSndDoc"
   DEFAULT lSelect      := .t.
   DEFAULT lTop         := .t.
   DEFAULT lMeter       := .f.

   if lMeter
      CreateWaitMeter( nil, nil, ( dbf )->( OrdKeyCount() ) )
   else
      CursorWait()
   end if

   if lTop
      ( dbf )->( dbGoTop() )
   end if

   while !( dbf )->( eof() )

      if dbLock( dbf )
         nPos           := ( dbf )->( FieldPos( cFieldName ) )
         ( dbf )->( FieldPut( nPos, lSelect ) )
         dbSafeUnLock( dbf )
      end if

      ( dbf )->( dbSkip() )

      if lMeter
         RefreshWaitMeter( ( dbf )->( OrdKeyNo() ) )
      else
         SysRefresh()
      end if

   end do

   ( dbf )->( dbGoTo( nRecAct ) )

   if lMeter
      EndWaitMeter()
   else
      CursorWE()
   end if

   if !Empty( oBrw )
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

Return nil

//---------------------------------------------------------------------------//

Function ChangeField( dbfAlias, xField, xValue, oBrowse )

   if ( dbfAlias )->( dbRLock() )
      ( dbfAlias )->( FieldPut( ( dbfAlias )->( FieldPos( xField ) ), xValue ) )
      ( dbfAlias )->( dbCommit() )
      ( dbfAlias )->( dbUnLock() )
   end if

   if oBrowse != nil
      oBrowse:Refresh()
   end if

Return nil

//---------------------------------------------------------------------------//

Function Capitalize( cChar )

Return ( Upper( Left( cChar, 1 ) ) + Rtrim( Lower( SubStr( cChar, 2 ) ) ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDesdeHasta

   DATA  cSerieInicio   INIT "A"
   DATA  cSerieFin      INIT "A"
   DATA  nNumeroInicio  INIT 0
   DATA  nNumeroFin     INIT 0
   DATA  cSufijoInicio  INIT Space( 2 )
   DATA  cSufijoFin     INIT Space( 2 )
   DATA  dFechaInicio   INIT Date()
   DATA  dFechaFin      INIT Date()
   DATA  nRadio         INIT 1

   Method Init()  CONSTRUCTOR

   Method cNumeroInicio()  INLINE ::cSerieInicio + Str( ::nNumeroInicio ) + ::cSufijoInicio

END CLASS

//---------------------------------------------------------------------------//

Method Init( cSerie, nNumero, cSufijo, dFecha )

   DEFAULT cSerie       := "A"
   DEFAULT nNumero      := 0
   DEFAULT cSufijo      := Space( 2 )
   DEFAULT dFecha       := Date()

   ::cSerieInicio       := cSerie
   ::cSerieFin          := cSerie
   ::nNumeroInicio      := nNumero
   ::nNumeroFin         := nNumero
   ::cSufijoInicio      := cSufijo
   ::cSufijoFin         := cSufijo
   ::dFechaInicio       := dFecha
   ::dFechaFin          := dFecha

Return ( Self )

//---------------------------------------------------------------------------//

Function DecimalMod( nDividend, nDivisor )

   local nMod  := Int( nDividend / nDivisor )
   nMod        := nDividend - ( nMod * nDivisor )

Return ( nMod )

//----------------------------------------------------------------------------//

Function LTrans( Exp, cSayPicture )

Return ( Ltrim( Trans( Exp, cSayPicture ) ) )

//----------------------------------------------------------------------------//
/*
No borrar esta version es para el Garrido
*/

Function cNumTiket( cCodAlb, dbfAlbCliT )

   local oBlock
   local oError
   local dbfTiket
   local cNumTiq  := ""
   local cNumDoc  := cCodAlb

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTiket ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE
   ( dbfTiket )->( OrdSetFocus( "CNUMDOC" ) )

   if ( dbfTiket )->( dbSeek( cCodAlb ) )

      if Empty( ( dbfTiket )->cRetMat )

         cNumTiq     := ( dbfTiket )->cNumDoc

         if ( dbfAlbCliT )->( dbSeek( cNumTiq ) )
            cNumDoc  := ( dbfAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb
         end if

      else

         cNumTiq     := ( dbfTiket )->cNumDoc
         cNumDoc     := ( dbfTiket )->cSerTik + "/" + AllTrim( ( dbfTiket )->cNumTik ) + "/" + ( dbfTiket )->cSufTik

      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfTiket )

return ( cNumDoc )

//----------------------------------------------------------------------------//

Function MsgDbfInfo( dbfAlias, cTitle )

   local oDlg
   local oTreeInfo

   DEFINE DIALOG oDlg RESOURCE "dbInfo" TITLE ( cTitle )

      oTreeInfo   := TTreeView():Redefine( 100, oDlg )

   REDEFINE BUTTON ID ( IDCANCEL ) OF oDlg CANCEL ACTION ( oDlg:end() )

   oDlg:bStart    := {|| StartDbfInfo( dbfAlias, oTreeInfo ) }

   ACTIVATE DIALOG oDlg CENTER

Return ( nil )

Static Function StartDbfInfo( dbfAlias, oTreeInfo )

   local n := 0

   Select( dbfAlias )

   oTreeInfo:Add( "RDDI_ISDBF       : "  + cValToChar( dbInfo( RDDI_ISDBF       ) ) )
   oTreeInfo:Add( "RDDI_CANPUTREC   : "  + cValToChar( dbInfo( RDDI_CANPUTREC   ) ) )
   oTreeInfo:Add( "RDDI_DELIMITER   : "  + cValToChar( dbInfo( RDDI_DELIMITER   ) ) )
   oTreeInfo:Add( "RDDI_SEPARATOR   : "  + cValToChar( dbInfo( RDDI_SEPARATOR   ) ) )
   oTreeInfo:Add( "RDDI_TABLEEXT    : "  + cValToChar( dbInfo( RDDI_TABLEEXT    ) ) )
   oTreeInfo:Add( "RDDI_MEMOEXT     : "  + cValToChar( dbInfo( RDDI_MEMOEXT     ) ) )
   oTreeInfo:Add( "RDDI_ORDBAGEXT   : "  + cValToChar( dbInfo( RDDI_ORDBAGEXT   ) ) )
   oTreeInfo:Add( "RDDI_ORDEREXT    : "  + cValToChar( dbInfo( RDDI_ORDEREXT    ) ) )
   oTreeInfo:Add( "RDDI_ORDSTRUCTEXT: "  + cValToChar( dbInfo( RDDI_ORDSTRUCTEXT) ) )
   oTreeInfo:Add( "RDDI_LOCAL       : "  + cValToChar( dbInfo( RDDI_LOCAL       ) ) )
   oTreeInfo:Add( "RDDI_REMOTE      : "  + cValToChar( dbInfo( RDDI_REMOTE      ) ) )
   oTreeInfo:Add( "RDDI_CONNECTION  : "  + cValToChar( dbInfo( RDDI_CONNECTION  ) ) )
   oTreeInfo:Add( "RDDI_TABLETYPE   : "  + cValToChar( dbInfo( RDDI_TABLETYPE   ) ) )
   oTreeInfo:Add( "RDDI_MEMOTYPE    : "  + cValToChar( dbInfo( RDDI_MEMOTYPE    ) ) )
   oTreeInfo:Add( "RDDI_LARGEFILE   : "  + cValToChar( dbInfo( RDDI_LARGEFILE   ) ) )
   oTreeInfo:Add( "RDDI_LOCKSCHEME  : "  + cValToChar( dbInfo( RDDI_LOCKSCHEME  ) ) )
   oTreeInfo:Add( "RDDI_RECORDMAP   : "  + cValToChar( dbInfo( RDDI_RECORDMAP   ) ) )
   oTreeInfo:Add( "RDDI_ENCRYPTION  : "  + cValToChar( dbInfo( RDDI_ENCRYPTION  ) ) )
   oTreeInfo:Add( "RDDI_AUTOLOCK    : "  + cValToChar( dbInfo( RDDI_AUTOLOCK    ) ) )

   oTreeInfo:Add( "Index parameters" )
   oTreeInfo:Add( "RDDI_STRUCTORD   : "  + cValToChar( dbInfo( RDDI_STRUCTORD   ) ) )
   oTreeInfo:Add( "RDDI_STRICTREAD  : "  + cValToChar( dbInfo( RDDI_STRICTREAD  ) ) )
   oTreeInfo:Add( "RDDI_STRICTSTRUCT: "  + cValToChar( dbInfo( RDDI_STRICTSTRUCT) ) )
   oTreeInfo:Add( "RDDI_OPTIMIZE    : "  + cValToChar( dbInfo( RDDI_OPTIMIZE    ) ) )
   oTreeInfo:Add( "RDDI_FORCEOPT    : "  + cValToChar( dbInfo( RDDI_FORCEOPT    ) ) )
   oTreeInfo:Add( "RDDI_AUTOOPEN    : "  + cValToChar( dbInfo( RDDI_AUTOOPEN    ) ) )
   oTreeInfo:Add( "RDDI_AUTOORDER   : "  + cValToChar( dbInfo( RDDI_AUTOORDER   ) ) )
   oTreeInfo:Add( "RDDI_AUTOSHARE   : "  + cValToChar( dbInfo( RDDI_AUTOSHARE   ) ) )
   oTreeInfo:Add( "RDDI_MULTITAG    : "  + cValToChar( dbInfo( RDDI_MULTITAG    ) ) )
   oTreeInfo:Add( "RDDI_SORTRECNO   : "  + cValToChar( dbInfo( RDDI_SORTRECNO   ) ) )
   oTreeInfo:Add( "RDDI_MULTIKEY    : "  + cValToChar( dbInfo( RDDI_MULTIKEY    ) ) )

   oTreeInfo:Add( "Memo parameters" )
   oTreeInfo:Add( "RDDI_MEMOBLOCKSIZE: "  + cValToChar( dbInfo( RDDI_MEMOBLOCKSIZE  ) ) )
   oTreeInfo:Add( "RDDI_MEMOVERSION  : "  + cValToChar( dbInfo( RDDI_MEMOVERSION    ) ) )
   oTreeInfo:Add( "RDDI_MEMOGCTYPE   : "  + cValToChar( dbInfo( RDDI_MEMOGCTYPE     ) ) )
   oTreeInfo:Add( "RDDI_MEMOREADLOCK : "  + cValToChar( dbInfo( RDDI_MEMOREADLOCK   ) ) )
   oTreeInfo:Add( "RDDI_MEMOREUSE    : "  + cValToChar( dbInfo( RDDI_MEMOREUSE      ) ) )
   oTreeInfo:Add( "RDDI_BLOB_SUPPORT : "  + cValToChar( dbInfo( RDDI_BLOB_SUPPORT   ) ) )

   oTreeInfo:Add( "OrderInfo" )
   oTreeInfo:Add( "DBOI_CONDITION    : "  + cValToChar( dbOrderInfo( DBOI_CONDITION       ) ) )
   oTreeInfo:Add( "DBOI_EXPRESSION   : "  + cValToChar( dbOrderInfo( DBOI_EXPRESSION      ) ) )
   oTreeInfo:Add( "DBOI_POSITION     : "  + cValToChar( dbOrderInfo( DBOI_POSITION        ) ) )

   oTreeInfo:Add( "DBOI_NAME         : "  + cValToChar( dbOrderInfo( DBOI_NAME            ) ) )
   oTreeInfo:Add( "DBOI_NUMBER       : "  + cValToChar( dbOrderInfo( DBOI_NUMBER          ) ) )
   oTreeInfo:Add( "DBOI_BAGNAME      : "  + cValToChar( dbOrderInfo( DBOI_BAGNAME         ) ) )
   oTreeInfo:Add( "DBOI_BAGEXT       : "  + cValToChar( dbOrderInfo( DBOI_BAGEXT          ) ) )
   oTreeInfo:Add( "DBOI_INDEXEXT     : "  + cValToChar( dbOrderInfo( DBOI_INDEXEXT        ) ) )
   oTreeInfo:Add( "DBOI_INDEXNAME    : "  + cValToChar( dbOrderInfo( DBOI_INDEXNAME       ) ) )
   oTreeInfo:Add( "DBOI_ORDERCOUNT   : "  + cValToChar( dbOrderInfo( DBOI_ORDERCOUNT      ) ) )
   oTreeInfo:Add( "DBOI_FILEHANDLE   : "  + cValToChar( dbOrderInfo( DBOI_FILEHANDLE      ) ) )
   oTreeInfo:Add( "DBOI_ISCOND       : "  + cValToChar( dbOrderInfo( DBOI_ISCOND          ) ) )
   oTreeInfo:Add( "DBOI_ISDESC       : "  + cValToChar( dbOrderInfo( DBOI_ISDESC          ) ) )
   oTreeInfo:Add( "DBOI_UNIQUE       : "  + cValToChar( dbOrderInfo( DBOI_UNIQUE          ) ) )
   oTreeInfo:Add( "DBOI_FULLPATH     : "  + cValToChar( dbOrderInfo( DBOI_FULLPATH        ) ) )
   oTreeInfo:Add( "DBOI_KEYTYPE      : "  + cValToChar( dbOrderInfo( DBOI_KEYTYPE         ) ) )
   oTreeInfo:Add( "DBOI_KEYSIZE      : "  + cValToChar( dbOrderInfo( DBOI_KEYSIZE         ) ) )
   oTreeInfo:Add( "DBOI_KEYCOUNT     : "  + cValToChar( dbOrderInfo( DBOI_KEYCOUNT        ) ) )
   oTreeInfo:Add( "DBOI_HPLOCKING    : "  + cValToChar( dbOrderInfo( DBOI_HPLOCKING       ) ) )
   oTreeInfo:Add( "DBOI_LOCKOFFSET   : "  + cValToChar( dbOrderInfo( DBOI_LOCKOFFSET      ) ) )
   oTreeInfo:Add( "DBOI_KEYVAL       : "  + cValToChar( dbOrderInfo( DBOI_KEYVAL          ) ) )
   oTreeInfo:Add( "DBOI_SCOPETOP     : "  + cValToChar( dbOrderInfo( DBOI_SCOPETOP        ) ) )
   oTreeInfo:Add( "DBOI_SCOPEBOTTOM  : "  + cValToChar( dbOrderInfo( DBOI_SCOPEBOTTOM     ) ) )
   oTreeInfo:Add( "DBOI_SCOPETOPCLEAR: "  + cValToChar( dbOrderInfo( DBOI_SCOPETOPCLEAR   ) ) )
   oTreeInfo:Add( "DBOI_SCOPEBOTTOMCLEAR:"+ cValToChar( dbOrderInfo( DBOI_SCOPEBOTTOMCLEAR) ) )
   oTreeInfo:Add( "DBOI_CUSTOM       : "  + cValToChar( dbOrderInfo( DBOI_CUSTOM          ) ) )
   //oTreeInfo:Add( "DBOI_SKIPUNIQUE   : "  + cValToChar( dbOrderInfo( DBOI_SKIPUNIQUE      ) ) )
   oTreeInfo:Add( "DBOI_KEYSINCLUDED : "  + cValToChar( dbOrderInfo( DBOI_KEYSINCLUDED    ) ) )
   oTreeInfo:Add( "DBOI_KEYGOTO      : "  + cValToChar( dbOrderInfo( DBOI_KEYGOTO         ) ) )
   oTreeInfo:Add( "DBOI_KEYGOTORAW   : "  + cValToChar( dbOrderInfo( DBOI_KEYGOTORAW      ) ) )
   oTreeInfo:Add( "DBOI_KEYNO        : "  + cValToChar( dbOrderInfo( DBOI_KEYNO           ) ) )
   oTreeInfo:Add( "DBOI_KEYNORAW     : "  + cValToChar( dbOrderInfo( DBOI_KEYNORAW        ) ) )
   oTreeInfo:Add( "DBOI_KEYCOUNTRAW  : "  + cValToChar( dbOrderInfo( DBOI_KEYCOUNTRAW     ) ) )

Return ( nil )

//---------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//
/*Parte de c�digo comun a PDA y a la aplicaci�n normal*/
//----------------------------------------------------------------------------//

FUNCTION cNoPath( cFileName )

RETURN Alltrim( SubStr( cFileName, RAt( "\", cFileName ) + 1 ) )

//----------------------------------------------------------------------------//

FUNCTION cNoPathLeft( cFileName )

   local nAt     := At( "\", cFileName )

   if nAT == 0
      nAt        := At( "/", cFileName )
   end if

   RETURN Alltrim( SubStr( cFileName, nAt + 1 ) )

//----------------------------------------------------------------------------//

/*
Checks for a possible area name conflict
*/

FUNCTION cCheckArea( cDbfName, cAlias )

   local n     := 2

   cAlias      := cDbfName

	while Select( cAlias ) != 0
      cAlias   := cDbfName + AllTrim( Str( n++ ) )
	end

RETURN cAlias

//---------------------------------------------------------------------------//

Function dbSeekInOrd( uVal, cOrd, cAlias, lSoft, lLast )

   local nOrd
   local lRet        := .f.

   if ( cAlias )->( Used() )
      nOrd           := ( cAlias )->( OrdSetFocus( cOrd ) )
      lRet           := ( cAlias )->( dbSeek( uVal, lSoft, lLast ) )
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

Return ( lRet )

//---------------------------------------------------------------------------//

Function hSeekInOrd( hHash )

   local h
   local nOrd
   local lRet
   local lSoft
   local lLast
   local uValue
   local uOrder
   local cAlias

   lRet                 := .f.

   if IsHash( hHash )

      if HHasKey( hHash, "Value" )
         uValue         := HGet( hHash, "Value" )  
      end if  

      if HHasKey( hHash, "Order" )
         uOrder         := HGet( hHash, "Order" ) 
      end if 

      if HHasKey( hHash, "Alias" )
         cAlias         := HGet( hHash, "Alias" ) 
      end if 

      if HHasKey( hHash, "Soft" )
         lSoft          := HGet( hHash, "Soft" ) 
      end if 

      if HHasKey( hHash, "Last" )
         lLast          := HGet( hHash, "Last" ) 
      end if 

      if !Empty( uValue ) .and. !Empty( uOrder ) .and. !Empty( cAlias )

         if ( cAlias )->( Used() )
            uOrder      := ( cAlias )->( OrdSetFocus( uOrder ) )
            lRet        := ( cAlias )->( dbSeek( uValue, lSoft, lLast ) )
            ( cAlias )->( OrdSetFocus( uOrder ) )
         end if

      end if 

   end if 

Return ( lRet )

//---------------------------------------------------------------------------//


Function aSqlStruct( aStruct )

   local a
   local aSqlStruct  := {}

   for each a in aStruct
      if a[2] == "+"

         ? a[1]
         ? "N"
         ? a[3]
         ? a[4]
         ? HB_FF_AUTOINC
         ? 1

         aAdd( aSqlStruct, { a[1], "N", a[3], a[4], HB_FF_AUTOINC, 1 } )
      else
         aAdd( aSqlStruct, { a[1], a[2], a[3], a[4] } )
      end if
   next

Return ( aSqlStruct )

//----------------------------------------------------------------------------//

Function lExistTable( cTable, cVia )

   if lAIS()
      return .t.
   end if

Return ( File( cTable ) ) // dbExists( cTable ) )

//----------------------------------------------------------------------------//

Function lExistIndex( cIndex, cVia )

   if lAIS()
      return .t.
   end if

Return ( File( cIndex ) )

//----------------------------------------------------------------------------//

Function fEraseTable( cTable, cVia )

   local lErase   := .t.

   if !lExistTable( cTable )
      Return ( lErase )
   end if 

   lErase         := ( fErase( cTable ) == 0 )
   if !lErase
      MsgStop( "Imposible eliminar el fichero " + cTable + ". C�digo de error " + Str( fError() ) )
   end if

Return ( lErase )

//----------------------------------------------------------------------------//

Function fRenameTable( cTableOld, cTableNew, cVia )

#ifdef __SQLLIB__
   DEFAULT cVia   := cDriver()

   if cVia == "SQLRDD"
      Return ( SR_RenameTable( cTableOld, cTableNew ) )
   end if
#endif

Return ( fRename( cTableOld, cTableNew ) )

//----------------------------------------------------------------------------//

Function dbSafeUnlock( cAlias )

   // if ( cAlias )->( Used() )
      ( cAlias )->( dbUnLock() )
   // end if

Return nil

//----------------------------------------------------------------------------//

FUNCTION dbAppendDefault( cAliOrigen, cAliDestino, aStruct )

	local i
   local cNom
	local	xVal
   local nPos
   local lPass    := .f.
   local nField   := ( cAliDestino )->( fCount() )

   ( cAliDestino )->( dbAppend() )

   if ( cAliDestino )->( !NetErr() )

      for i := 1 to nField

         if ( len( aStruct[ i ] ) >= 9 ) .and. ( !Empty( aStruct[ i, 9 ] ) )
            ( cAliDestino )->( FieldPut( i, aStruct[ i, 9 ] ) )
         end if

      next

      for i := 1 to nField

         cNom     := ( cAliDestino )->( FieldName( i ) )
         nPos     := ( cAliOrigen  )->( FieldPos( cNom ) )

         if nPos != 0
            xVal  := ( cAliOrigen )->( FieldGet( nPos ) )
            ( cAliDestino )->( FieldPut( i, xVal ) )
         end if

      next

      dbSafeUnLock( cAliDestino )

      lPass    := .t.

   end if

Return ( lPass )

//----------------------------------------------------------------------------//

Function fEraseIndex( cTable, cVia )

#ifdef __SQLLIB__
   DEFAULT cVia   := cDriver()

   if cVia == "SQLRDD"
      Return ( SR_DropIndex( cTable ) )
   end if
#endif

Return ( fErase( cTable ) )

//----------------------------------------------------------------------------//

FUNCTION bCheck2Block( cChar, lMessage )

   local cType
	local bBlock
   local oBlock
   local oError
   local lError      := .f.

   DEFAULT lMessage  := .t.

   if Empty( cChar )
      return ( bBlock )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      cType          := Type( cChar )

      if cType != "UE" //  .and. cType != "UI" ) // UI

         cChar       := Rtrim( cChar )
         bBlock      := &( "{||" + cChar + "}" )

      else

         lError      := .t.

      end if

   RECOVER USING oError

      lError         := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

   if lError

      if lMessage
         msgStop( "Expresi�n incorrecta " + cChar, "Tipo de expresi�n " + Type( cChar ) )
      end if

      bBlock         := nil

   end if

RETURN ( bBlock )

//---------------------------------------------------------------------------//

/*
A�ade regsitros a la base de datos
	- oBrw. Browse de procedencia
	- bEdit. Codeblock a ejecutar en la edicion
	- cAlias. Pues eso
	- bWhen. Codeblock con la funcion When
	- bValid.  "   "   con la funcion Valid
	- xOthers. Mas parametros.
	- bPostAction. Accion a evaluar despues de A�adir
*/

FUNCTION WinAppRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local lReturn     := .f.
   local nOrd        := 0

   DEFAULT cAlias    := Alias()
   DEFAULT bWhen     := "" //{ || .t. }
   DEFAULT bValid    := "" //{ || .t. }

   if Select( cAlias ) == 0
      return .f.
   end if

   if lDemoMode() .and. ( cAlias )->( lastRec() ) >= 50
      msgStop( "Esta usted utilizando una versi�n demo.", "El programa se abortar�" )
      return .f.
   end if

   if Empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   aTmp           := dbBlankRec( cAlias )

   aGet           := Array( ( cAlias )->( fCount() ) )

	/*
	Bloqueamos el registro durante la edici�n-----------------------------------
	*/

   lReturn        := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, APPD_MODE, xOthers )

   if lReturn
      dbSafeUnLock( cAlias )
   end if

   if IsNum( nOrd ) .and. ( nOrd != 0 )
      ( cAlias )->( OrdSetFocus ( nOrd ) )
   end if

   if lReturn .and. !Empty( oBrw ) .and. ( oBrw:lActive )
      oBrw:Select( 0 )
      oBrw:Select( 1 )
      oBrw:Refresh()
   end if

RETURN lReturn

//-------------------------------------------------------------------------//

/*
Duplica registros a la base de datos
	- oBrw. Browse de procedencia
	- bEdit. Codeblock a ejecutar en la edicion
	- cAlias. Pues eso
	- bWhen. Codeblock con la funcion When
	- bValid.  "   "   con la funcion Valid
	- xOthers. Mas parametros.
	- bPostAction. Accion a evaluar despues de A�adir
*/

FUNCTION WinDupRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local nRec
   local lResult  := .f.
   local nOrd     := 0

   if Select( cAlias ) == 0
      Return .f.
   end if

   if lDemoMode() .and. ( cAlias )->( lastRec() ) >= 50
      msgStop( "Esta usted utilizando una versi�n demo.", "El programa se abortar�" )
      Return .f.
   end if

   nRec           := ( cAlias )->( Recno() )

   if Empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   if lAdsRDD()
      ( cAlias )->( dbClearFilter() )
   end if

   /*
	Bloqueamos el registro durante la edici�n
	*/

   if !( cAlias )->( eof() )

      aTmp        := dbScatter( cAlias )

      aGet        := Array( ( cAlias )->( fCount() ) )

      lResult     := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, DUPL_MODE, xOthers )

      if lResult
         dbSafeUnLock( cAlias )
      end if

   end if

   if IsNum( nOrd ) .and. nOrd != 0
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

   if !lResult
      ( cAlias )->( dbGoTo( nRec ) )
   end if

   if lResult .and. !Empty( oBrw ) .and. ( oBrw:lActive )
      oBrw:Select( 0 )
      oBrw:Select( 1 )
      oBrw:Refresh()
   end if

RETURN lResult

//-------------------------------------------------------------------------//

/*
Edita regsitros a la base de datos
	- oBrw. Browse de procedencia
	- bEdit. Codeblock a ejecutar en la edicion
	- cAlias. Pues eso
	- bWhen. Codeblock con la funcion When
	- bValid.  "   "   con la funcion Valid
	- xOthers. Mas parametros.
	- bPostAction. Accion a evaluar despues de A�adir
*/

FUNCTION WinEdtRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local lResult     := .f.
   local nOrd        := 0

   DEFAULT cAlias    := Alias()
   DEFAULT bWhen     := "" //{ || .t. }
   DEFAULT bValid    := "" //{ || .t. }

   if Select( cAlias ) == 0 .OR. ( ( cAlias )->( LastRec() ) == 0 )
      return .f.
   end if

   if Empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd           := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   if !( cAlias )->( eof() )
      if dbDialogLock( cAlias )
         aTmp        := dbScatter( cAlias )
         aGet        := Array( ( cAlias )->( fCount() ) )
         lResult     := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, EDIT_MODE, xOthers )
         dbSafeUnLock( cAlias )
      end if
   end if

   if ValType( nOrd ) == "N" .and. nOrd != 0
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

   if lResult .and. oBrw != nil
      oBrw:Refresh()
      oBrw:Select( 0 )
      oBrw:Select( 1 )
   end if

RETURN lResult

//-------------------------------------------------------------------------//

/*
Edita regsitros a la base de datos
	- oBrw. 		Browse de procedencia
	- bEdit. 	Codeblock a ejecutar en la edicion
	- cAlias.	Pues eso
	- bWhen. 	Codeblock con la funcion When
	- bValid.  	"   "   con la funcion Valid
	- xOthers. 	Mas parametros.
*/

FUNCTION WinZooRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local lResult     := .f.
   local nOrd        := 0

   DEFAULT cAlias    := Alias()
   DEFAULT bWhen     := "" //{ || .t. }
   DEFAULT bValid    := "" //{ || .t. }

	IF Select( cAlias ) == 0
		RETURN .F.
	END IF

   if Empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   IF !( cAlias )->( eof() )
      aTmp        := DBScatter( cAlias )
      aGet        := Array( (cAlias)->(fCount()) )
      lResult     := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, ZOOM_MODE, xOthers )
	END IF

   if ValType( nOrd ) == "N" .and. nOrd != 0
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

RETURN lResult

//---------------------------------------------------------------------------//
/*
Lee del disco un registro desde un array
*/

FUNCTION dbScatter( cAlias )

   local i
   local aField := {}
   local nField := ( cAlias )->( fCount() )

   // Creating requested field array-------------------------------------------

   for i := 1 to nField
      aAdd( aField, ( cAlias )->( FieldGet( i ) ) )
	next

RETURN aField

//----------------------------------------------------------------------------//

/*
Lee del disco un registro desde un array
*/

FUNCTION aScatter( cAlias, aTmp )

   aEval( aTmp, {|x,n| aTmp[ n ] := ( cAlias )->( FieldGet( n ) ) } )

RETURN aTmp

//----------------------------------------------------------------------------//
/*
Bloquea un registro, diferencianado caso de estar a�adiendo
registros
*/

FUNCTION dbDialogLock( cAlias, lAppend )

   DEFAULT lAppend   := .f.

   if DBLock( cAlias, If( lAppend, MODE_APPEND, MODE_RECORD ) )
      return .t.
	endif

   while ApoloMsgNoYes( "Registro bloqueado," + CRLF + "� Reintentar ?" )

		if DBLock( cAlias, If( lAppend, MODE_APPEND, MODE_RECORD ) )
         return .t.
		else
			loop
		endif

   enddo

Return .f.

//--------------------------------------------------------------------------//
/*
Devuelve un array con un registro en blanco, del alias pasado como argumento
*/

Function dbBlankRec( cAlias )

   local i
   local aBlank   := {}
   local aStruct  := ( cAlias )->( dbStruct() )

   for i = 1 to ( cAlias )->( fCount() )

      do case
         Case aStruct[ i, DBS_TYPE ] == "C"
            AAdd( aBlank, Space( aStruct[ i, DBS_LEN ] ) )
         Case aStruct[ i, DBS_TYPE ] == "M"
            AAdd( aBlank, "" )            // Space( aStruct[ i, DBS_LEN ] )
         Case aStruct[ i, DBS_TYPE ] == "N"
            AAdd( aBlank, Val( "0." + Replicate( "0", aStruct[ i, DBS_DEC ] ) ) )
         Case aStruct[ i, DBS_TYPE ] == "L"
            AAdd( aBlank, .F. )
         Case aStruct[ i, DBS_TYPE ] == "D"
            AAdd( aBlank, GetSysDate() )  // CtoD( "" ) )
      end case

   next

RETURN aBlank

//--------------------------------------------------------------------------//
/*
Bloquea un registro
*/

Function dbLock( cAlias, nMode )

   local i

   DEFAULT nMode  := MODE_RECORD

	for i = 1 to NNET_TIME

      if nMode == MODE_APPEND

         ( cAlias )->( dbAppend() )
         if !NetErr()
            return .t.
			endif

		else

         if ( cAlias )->( dbRLock() )
				return .t.
			end if

		endif

	next

Return .f.

//--------------------------------------------------------------------------//
/*
Paremetro lMaster, para solicitar permisos de ususrio master antes de
eliminar el registro
*/

FUNCTION WinDelRec( oBrw, cAlias, bPreBlock, bPostBlock, lMaster, lTactil )

   local nRec        := 0
   local cTxt        := "�Desea eliminar el registro en curso?"
   local nMarked     := 0
   local lReturn     := .f.
   local lTrigger    := .t.

   DEFAULT cAlias    := Alias()
   DEFAULT lMaster   := .f.
   DEFAULT lTactil   := .f.

   if Select( cAlias ) == 0 .or. ( cAlias )->( LastRec() ) == 0
      return ( .f. )
   end if

   /*
   Cuantos registros marcados tenemos
   */

   if !Empty( oBrw ) .and. ( "XBROWSE" $ oBrw:ClassName() )

      nMarked        := len( oBrw:aSelected )
      if nMarked > 1
         cTxt        := "� Desea eliminar definitivamente " + AllTrim( Trans( nMarked, "999999" ) ) + " registros ?"
      end if

      if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( cTxt, "Confirme supresi�n", lTactil )

         CursorWait()

         for each nRec in ( oBrw:aSelected )

            ( cAlias )->( dbGoTo( nRec ) )

            if !Empty( bPreBlock )
               lTrigger    := CheckEval( bPreBlock )
            end if

            if Valtype( lTrigger ) != "L" .or. lTrigger

               dbDel( cAlias )

               if !Empty( bPostBlock )
                  CheckEval( bPostBlock )
               end if

               // oBrw:Refresh()

            end if

         next

         CursorWE()

      end if

   else

      if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( cTxt, "Confirme supersi�n", lTactil )

         if !Empty( bPreBlock )
            lTrigger    := CheckEval( bPreBlock )
         end if

         if Valtype( lTrigger ) != "L" .or. lTrigger

            dbDel( cAlias )

            if !Empty( bPostBlock )
               lTrigger := CheckEval( bPostBlock )
            end if

            lReturn     := .t.

         end if

      end if

   end if

   if !Empty( oBrw )
      oBrw:Select( 0 )
      oBrw:Select( 1 )
      oBrw:Refresh()
      oBrw:SetFocus() // .t. )
   end if

RETURN ( lReturn )

//--------------------------------------------------------------------------//

/*
Confirmaci�n de la supresi�n de un registro
*/

FUNCTION dbDelRec( oBrw, cAlias, bPreBlock, bPostBlock, lDelMarked, lBig )

   local nRec           := 0
   local cTxt           := "�Desea eliminar el registro en curso?"
   local nMarked        := 0
   local lReturn        := .f.

   DEFAULT cAlias       := Alias()
   DEFAULT lDelMarked   := .f.
   DEFAULT lBig         := .f.

   if Select( cAlias ) == 0 .or. ( cAlias )->( LastRec() ) == 0
      return ( .f. )
   end if

   /*
   Cuantos registros marcados tenemos
   */

   if ( lDelMarked ) .and. ( "TXBROWSE" $ oBrw:ClassName() )
      nMarked           := len( oBrw:aSelected )
      if nMarked > 1
         cTxt           := "� Desea eliminar definitivamente " + AllTrim( Str( nMarked, 3 ) ) + " registros ?"
      end if

      if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( cTxt, "Confirme supersi�n", lBig )
         for each nRec in oBrw:aSelected

            ( cAlias )->( dbGoTo( nRec ) )

            CheckEval( bPreBlock )
            dbDel( cAlias )
            CheckEval( bPostBlock )

            if( !( cAlias )->( eof() ), oBrw:GoUp(), )
            oBrw:Refresh()
            oBrw:SetFocus()

         next

      end if

   else
      if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( cTxt, "Confirme supersi�n" )

         CheckEval( bPreBlock )

         DelRecno( cAlias, oBrw )

         CheckEval( bPostBlock )

         if !Empty( oBrw )
            oBrw:Refresh()
         end if

         lReturn        := .t.

      end if

   end if

RETURN ( lReturn )

//--------------------------------------------------------------------------//

FUNCTION DelRecno( cAlias, oBrw, lDelMarked )

   local nRec
   local nNtx

   DEFAULT lDelMarked:= .f.

   if lDelMarked

      ( cAlias )->( dbGoTop() )
      while !( cAlias )->( eof() )
         if ( cAlias )->( lMarked() ) .and.  dbLock( cAlias, .f. )
            ( cAlias )->( dbDelete() )
            dbSafeUnLock( cAlias )
         end if
      end do

   else

      dbDel( cAlias )

   end if

   if oBrw != nil
      oBrw:Select( 0 )
      oBrw:Select( 1 )
      oBrw:SetFocus()
   end if

Return nil

//------------------------------------------------------------------------//

Function CheckEval( bCodeBlock )

   local oBlock
   local oError
   local lCheckEval  := .t.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !Empty( bCodeBlock ) .and. Valtype( bCodeBlock ) == "B"
         lCheckEval  := Eval( bCodeBlock )
      end if

   RECOVER USING oError

      lCheckEval     := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCheckEval )

//--------------------------------------------------------------------------//

function nGetAllMark( cMark, cAlias )

   local nNum     := 0
   local nRecNo   := ( cAlias )->( RecNo() )

   cMark          := if( ValType( cMark ) != "C", "#", cMark )

   ( cAlias )->( dbGoTop() )
   while !( cAlias )->( eof() )

      if ( cAlias )->( lMarked( cMark ) )
         ++nNum
      end if
      ( cAlias )->( dbSkip() )

   end while

   ( cAlias )->( dbGoTo( nRecNo ) )

return ( nNum )

//---------------------------------------------------------------------------//

Function dbDel( cAlias )

   if dbLock( cAlias )
      ( cAlias )->( dbDelete() )
      ( cAlias )->( dbUnLock() )
   end if

   ( cAlias )->( dbSkip( 0 ) )

   /*
   if ( cAlias )->( Eof() )
      ( cAlias )->( dbGoBottom() )
   end if
   */

Return nil

//---------------------------------------------------------------------------//
// Esta marcado el registro?

function lMarked( cMark, nRec )

    cMark := if( ValType( cMark ) == "C", cMark, "#" )

return( GetMarkRec( cMark, nRec ) == cMark )

//---------------------------------------------------------------------------//
// Extrae la marca del registro a bajo nivel del espacio de la marca de deleted

function GetMarkRec( nRec )

   local nRecNo   := RecNo()
   local nHdl     := DbfHdl()
   local nOffSet  := 0
   local cMark    := " "

   nRec           := if( ValType( nRec )  != "N", RecNo(), nRec  )
   nOffSet        := ( RecSize() * ( nRec - 1 ) ) + Header()

   FSeek( nHdl, nOffSet, 0 )
   FRead( nHdl, @cMark, 1  )

   DbGoTo( nRecNo )

return( cMark )

//---------------------------------------------------------------------------//

FUNCTION WinGather( aTmp, aGet, cAlias, oBrw, nMode, bPostAction, lEmpty )

   local lAdd     := ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

	DEFAULT lEmpty	:= .t.

	CursorWait()

   if dbDialogLock( cAlias, lAdd )
      aEval( aTmp, { | uTmp, n | ( cAlias )->( fieldPut( n, uTmp ) ) } )
      dbSafeUnLock( cAlias )
   end if

   if lEmpty
      aCopy( dbBlankRec( cAlias ), aTmp )
      if !Empty( aGet )
         aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )
      end if
   end if

   if bPostAction != nil
		Eval( bPostAction )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

   ( cAlias )->( dbCommit() )

   CursorWe()

Return ( nil )

//--------------------------------------------------------------------------//

FUNCTION dbCopy( cAliOrigen, cAliDestino, lApp )

	local i
	local nField 	:= (cAliOrigen)->( Fcount() )

	DEFAULT lApp	:= .f.

	IF lApp
		(cAliDestino)->( dbAppend() )
   ELSE
      (cAliDestino)->( dbRLock() )
	END IF

	for i = 1 to nField
		(cAliDestino)->( FieldPut( i, (cAliOrigen)->( FieldGet( i ) ) ) )
	next

   IF !lApp
      dbSafeUnLock( cAliDestino )
	END IF

RETURN NIL

//---------------------------------------------------------------------------//

function NotCero( nUnits )

return ( if( nUnits != 0, nUnits, 1 ) )

//--------------------------------------------------------------------------//

function NotCaja( nUnits )

   if !lCalCaj()
      nUnits   := 1
   end if

return ( if( nUnits == 0, 1, nUnits ) )

//--------------------------------------------------------------------------//

function SetStatus( cAlias, aStatus )

   ( cAlias )->( OrdSetFocus( aStatus[ 2 ] ) )
   ( cAlias )->( dbGoTo( aStatus[ 1 ] ) )

return nil

//--------------------------------------------------------------------------//

function aGetStatus( cAlias, lInit )

   local aStatus  := { ( cAlias )->( Recno() ), ( cAlias )->( OrdSetFocus() ) }

   DEFAULT lInit  := .f.

   if lInit
      ( cAlias )->( OrdSetFocus( 1 ) )
      ( cAlias )->( dbGoTop() )
   end if

return ( aStatus )

//--------------------------------------------------------------------------//

Function hGetStatus( cAlias, lInit )

   hStatus        := { "Alias" => cAlias, "Recno" => ( cAlias )->( Recno() ), "Order" => ( cAlias )->( OrdSetFocus() ) }

   DEFAULT lInit  := .f.

   if lInit
      ( cAlias )->( OrdSetFocus( 1 ) )
      ( cAlias )->( dbGoTop() )
   end if

Return ( hStatus )

//--------------------------------------------------------------------------//

Function hSetStatus()

   ( HGet( hStatus, "Alias" ) )->( OrdSetFocus( HGet( hStatus, "Order" ) ) )
   ( HGet( hStatus, "Alias" ) )->( dbGoTo(      HGet( hStatus, "Recno" ) ) )

Return nil

//--------------------------------------------------------------------------//
/*
Comprueba si existe una clave
*/

FUNCTION NotValid( oGet, uAlias, lRjust, cChar, nTag, nLen )

   local nOldTag
   local cAlias
   local lReturn  := .t.
   local xClave   := oGet:VarGet()

   DEFAULT uAlias := Alias()
   DEFAULT lRjust := .f.
	DEFAULT cChar	:= "0"
	DEFAULT nTag   := 1

   if ValType( uAlias ) == "O"
      cAlias      := uAlias:cAlias
   else
      cAlias      := uAlias
   end if

   nOldTag        := ( cAlias )->( OrdSetFocus( nTag ) )

   /*
	Cambiamos el tag y guardamos el anterior
	*/

   if Empty( ( cAlias )->( OrdSetFocus() ) )
      MsgInfo( "Indice no disponible, comprobaci�n imposible" )
      return .t.
   end if

	IF ValType( xClave ) == "C" .AND. At( ".", xClave ) != 0
		PntReplace( oGet, cChar, nLen )
	ELSEIF lRjust
		RJustObj( oGet, cChar, nLen )
	END IF

   xClave         := oGet:VarGet()

   if Existe( xClave, cAlias )
      msgStop( "Clave existente", "Aviso del sistema" )
      lReturn     := .f.
   end if

	( cAlias )->( OrdSetFocus( nOldTag ) )

RETURN lReturn

//-------------------------------------------------------------------------//

FUNCTION ValidKey( oGet, uAlias, lRjust, cChar, nTag, nLen )

   local nOldTag
   local cAlias
   local lReturn  := .t.
   local xClave   := oGet:VarGet()

   DEFAULT uAlias := Alias()
   DEFAULT lRjust := .f.
	DEFAULT cChar	:= "0"
	DEFAULT nTag   := 1

   if ValType( uAlias ) == "O"
      cAlias      := uAlias:cAlias
   else
      cAlias      := uAlias
   end if

   nOldTag        := ( cAlias )->( OrdSetFocus( nTag ) )

   /*
	Cambiamos el tag y guardamos el anterior
	*/

   if Empty( ( cAlias )->( OrdSetFocus() ) )
      MsgInfo( "Indice no disponible, comprobaci�n imposible" )
      return .t.
   end if

   if lRjust
		RJustObj( oGet, cChar, nLen )
   end if

   xClave         := oGet:VarGet()

   if Existe( xClave, cAlias )
      msgStop( "Clave existente", "Aviso del sistema" )
      lReturn     := .f.
   end if

	( cAlias )->( OrdSetFocus( nOldTag ) )

RETURN lReturn

//-------------------------------------------------------------------------//

/*
Comprueba la existencia anterior de una clave
*/

FUNCTION Existe( xClave, cAlias, nOrd )

   local nRec
   local lFound

	DEFAULT cAlias := Alias()
   DEFAULT nOrd   := ( cAlias )->( OrdSetFocus() )

   nRec           := ( cAlias )->( Recno() )
   nOrd           := ( cAlias )->( OrdSetFocus( nOrd ) )

   lFound         := ( cAlias )->( dbSeek( xClave ) )

   ( cAlias )->( OrdSetFocus( nOrd ) )
   ( cAlias )->( dbGoTo( nRec ) )

RETURN ( lFound )

//-------------------------------------------------------------------------//

FUNCTION LblTitle( nMode )

   local cTitle   := ""

   do case
      case nMode  == APPD_MODE
         cTitle   := "A�adiendo "
      case nMode  == EDIT_MODE
         cTitle   := "Modificando "
      case nMode  == ZOOM_MODE
         cTitle   := "Visualizando "
      case nMode  == DUPL_MODE
         cTitle   := "Duplicando "
   end case

RETURN ( cTitle )

//----------------------------------------------------------------------------//

Function dbAppe( cAlias )

   ( cAlias )->( dbAppend() )
   if !( cAlias )->( NetErr() )
      return .t.
   endif

Return .f.

//--------------------------------------------------------------------------//

Function dbfErase( cFileName )

   if Empty( cFileName )
      return .t.
   end if

   if dbExists( cFileName )
      dbDrop( cFileName )
   end if

   if file( cFileName + ".Dbf" )
      if fErase( cFileName + ".Dbf" ) == -1
         Return .f.
      end if
   end if

   if file( cFileName + ".Cdx" )
      if fErase( cFileName + ".Cdx" ) == -1
         Return .f.
      end if
   end if

   if file( cFileName + ".Fpt" )
      if fErase( cFileName + ".Fpt" ) == -1
         Return .f.
      end if
   end if

#ifdef __SQLLIB__

   if lExistTable( cFileName )
      sr_DropTable( cFileName )
   end if

   if lExistTable( cFileName + ".Dbf" )
      sr_DropTable( cFileName + ".Dbf" )
   end if

#endif

Return .t.

//---------------------------------------------------------------------------//

Function dbfRename( cFileNameOld, cFileNameNew )

   if file( cFileNameOld + ".Dbf" )
      if fRename( cFileNameOld + ".Dbf", cFileNameNew + ".Dbf" ) == -1
         //MsgStop( "No se pudo renombrar el fichero " + cFileNameOld + ".Dbf" )
         Return .f.
      end if
   end if

   if file( cFileNameOld + ".Cdx" )
      if fRename( cFileNameOld + ".Cdx", cFileNameNew + ".Cdx" ) == -1
         //MsgStop( "No se pudo renombrar el fichero " + cFileNameOld + ".Cdx" )
         Return .f.
      end if
   end if

   if file( cFileNameOld + ".Fpt" )
      if fRename( cFileNameOld + ".Fpt", cFileNameNew + ".Fpt" ) == -1
         MsgStop( "No se pudo renombrar el fichero " + cFileNameOld + ".Fpt" )
         Return .f.
      end if
   end if

Return .t.

//---------------------------------------------------------------------------//

Function dbDelKit( oBrw, dbfTmp, nNumLin )

   local nRec  := ( dbfTmp )->( Recno() )
   local nOrd  := ( dbfTmp )->( OrdSetFocus( "nNumLin" ) )

   while ( dbfTmp )->( dbSeek( Str( nNumLin, 4 ) ) )
      ( dbfTmp )->( dbDelete() )
      SysRefresh()
   end while

   ( dbfTmp )->( OrdSetFocus( nOrd ) )
   ( dbfTmp )->( dbGoTo( nRec ) )

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

Return nil

//---------------------------------------------------------------------------- //

FUNCTION cGetNewFileName( cName, cExt, lExt, cPath )

   local cTemp
   local nId      := Val( cCurUsr() )

   DEFAULT cExt   := { "Dbf", "Cdx", "Fpt" }
   DEFAULT lExt   := .f.
   DEFAULT cPath  := ""

   cTemp          := cName + cCurUsr()

   if Valtype( cExt ) == "A"

      while File( cPath + cTemp + "." + cExt[ 1 ] ) .or. File( cPath + cTemp + "." + cExt[ 2 ] ) .or. File( cPath + cTemp + "." + cExt[ 3 ] )
         cTemp    := cName + StrZero( ++nId, 3 )
      end

   else

      while File( cPath + cTemp + "." + cExt )
         cTemp    := cName + StrZero( ++nId, 3 )
      end

   end if

   if lExt
      cTemp       += "." + cExt
   end if

RETURN cTemp

//----------------------------------------------------------------------------//

Function CommitTransaction()

   if lAds() .or. lAIS()
      Return ( AdsCommitTransaction() )
   end if

Return ( .t. )

//----------------------------------------------------------------------------//

Function BeginTransaction()

   if lAds() .or. lAIS()
      Return ( AdsBeginTransaction() )
   end if

Return ( .t. )

//----------------------------------------------------------------------------//

Function RollBackTransaction()

   if lAds() .or. lAIS()
      Return ( AdsRollback() )
   end if

Return ( .t. )

//----------------------------------------------------------------------------//

Function Div( nDividend, nDivisor )

Return( if( nDivisor != 0, ( nDividend / nDivisor ), 0 ) )

//----------------------------------------------------------------------------//

FUNCTION cFileBitmap( cPath, cFileName )

   local cFileBitmap

   if At( ":", cFileName ) != 0
      cFileBitmap       := Rtrim( cFileName )
   else
      cFileBitmap       := Rtrim( cPath ) + Rtrim( cFileName )
   end if

RETURN ( cFileBitmap )

//----------------------------------------------------------------------------//

/*
Busca el ultimo registro dentro de un indice
*/

FUNCTION dbLast( cAlias, nField, oGet, xHasta, nOrd )

   local xValRet
   local nPosAct
   local nOrdAct

   DEFAULT cAlias := Alias()
	DEFAULT nField	:= 1

   /*
   Para TDBF-------------------------------------------------------------------
   */

   if IsObject( cAlias )
      cAlias      := cAlias:cAlias
   end if

   nPosAct        := ( cAlias )->( Recno() )

   /*
   Ordenes especiales----------------------------------------------------------
   */

   if nOrd != nil
      nOrdAct     := ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

   if Empty( xHasta )
      ( cAlias )->( dbGoBottom() )
   else
      ( cAlias )->( dbSeek( xHasta, .t., .t. ) )
      if ( cAlias )->( eof() )
         ( cAlias )->( dbGoBottom() )
      end if
   end if

   if IsChar( nField )
      nField      := ( cAlias )->( FieldPos( nField ) )
   end if
   xValRet        := ( cAlias )->( FieldGet( nField ) )

   /*
   Ordenes especiales----------------------------------------------------------
   */

   ( cAlias )->( dbGoTo( nPosAct ) )

   if !Empty( nOrd )
      ( cAlias )->( OrdSetFocus( nOrdAct ) )
   end if

   if !Empty( oGet )
		oGet:cText( xValRet )
      return .t.
   end if

Return ( xValRet )

//--------------------------------------------------------------------------//

Function IsNil( u )

Return ( u == nil )

//---------------------------------------------------------------------------//

FUNCTION WinMulRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local lReturn     := .f.
   local nOrd        := 0

   DEFAULT cAlias    := Alias()
   DEFAULT bWhen     := "" //{ || .t. }
   DEFAULT bValid    := "" //{ || .t. }

	IF Select( cAlias ) == 0
		RETURN .F.
	END IF

   if Empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   aTmp           := dbBlankRec( cAlias )
   aGet           := Array( ( cAlias)->( fCount() ) )

	/*
	Bloqueamos el registro durante la edici�n
	*/

   lReturn        := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, MULT_MODE, xOthers )
   if lReturn
      dbSafeUnLock( cAlias )
   end if

   if ValType( nOrd ) == "N" .and. nOrd != 0
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

RETURN ( lReturn )

//-------------------------------------------------------------------------//

Function lMayorIgual( nTotal, nCobrado, nDiferencia )

   DEFAULT nDiferencia  := 0

   nTotal               := Abs( nTotal )
   nCobrado             := Abs( nCobrado )

Return ( ( nTotal >= nCobrado ) .and. ( ( nTotal - nCobrado ) >= nDiferencia ) )

//---------------------------------------------------------------------------//

Function lDiferencia( nTotal, nCobrado, nDiferencia )

   DEFAULT nDiferencia  := 0

Return ( Abs( nTotal - nCobrado ) >= nDiferencia )

//---------------------------------------------------------------------------//

FUNCTION dbPass( cAliOrigen, cAliDestino, lApp, xField1, xField2, xField3, xField4, xField5 )

	local i
   local cNom
	local	xVal
   local nPos
   local lPass    := .f.
   local nField   := ( cAliDestino )->( fCount() )

	DEFAULT lApp	:= .f.

   if lApp

      ( cAliDestino )->( dbAppend() )

      if ( cAliDestino )->( !NetErr() )

         for i = 1 to nField

            cNom     := ( cAliDestino )->( FieldName( i ) )
            nPos     := ( cAliOrigen  )->( FieldPos( cNom ) )

            if nPos != 0
               xVal  := ( cAliOrigen )->( FieldGet( nPos ) )
               ( cAliDestino )->( FieldPut( i, xVal ) )
            end if

         next

         if !Empty( xField1 )
            ( cAliDestino )->( FieldPut( 1, xField1 ) )
         end if

         if !Empty( xField2 )
            ( cAliDestino )->( FieldPut( 2, xField2 ) )
         end if

         if !Empty( xField3 )
            ( cAliDestino )->( FieldPut( 3, xField3 ) )
         end if

         if !Empty( xField4 )
            ( cAliDestino )->( FieldPut( 4, xField4 ) )
         end if

         if !Empty( xField5 )
            ( cAliDestino )->( FieldPut( 5, xField5 ) )
         end if

         ( cAliDestino )->( dbUnLock() )

         lPass       := .t.

      end if

   else

      if ( cAliDestino )->( dbRLock() )

         for i = 1 to nField

            cNom     := ( cAliDestino )->( FieldName( i ) )
            nPos     := ( cAliOrigen  )->( FieldPos( cNom ) )

            if nPos != 0
               xVal  := ( cAliOrigen )->( FieldGet( nPos ) )
               ( cAliDestino )->( FieldPut( i, xVal ) )
            end if

         next

         if !Empty( xField1 )
            ( cAliDestino )->( FieldPut( 1, xField1 ) )
         end if

         if !Empty( xField2 )
            ( cAliDestino )->( FieldPut( 2, xField2 ) )
         end if

         if !Empty( xField3 )
            ( cAliDestino )->( FieldPut( 3, xField3 ) )
         end if

         if !Empty( xField4 )
            ( cAliDestino )->( FieldPut( 4, xField4 ) )
         end if

         if !Empty( xField5 )
            ( cAliDestino )->( FieldPut( 5, xField5 ) )
         end if

         dbSafeUnLock( cAliDestino )

         lPass       := .t.

      end if

   end if

Return ( lPass )

//----------------------------------------------------------------------------//

Function IsTrue( u )

Return ( Valtype( u ) == "L" .and. u )

//---------------------------------------------------------------------------//

Function IsFalse( u )

Return ( Valtype( u ) == "L" .and. !u )

//---------------------------------------------------------------------------//

Function ValidEmailAddress( cMail, lMessage )

   local lValid      := .t.

   DEFAULT lMessage  := .f.

   lValid            := Empty( cMail ) .or. HB_RegExMatch( "[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}", cMail, .f. )

   if !lValid .and. lMessage
      MsgStop( "La direcci�n de mail introducida no es correcta" )
   end if

Return ( lValid )

//---------------------------------------------------------------------------//

Function IsChar( u )

Return ( Valtype( u ) == "C" )

//---------------------------------------------------------------------------//

Function IsNum( u )

Return ( Valtype( u ) == "N" )

//---------------------------------------------------------------------------//

Function IsLogic( u )

Return ( Valtype( u ) == "L" )

//----------------------------------------------------------------------------//

Function IsObject( u )

Return ( Valtype( u ) == "O" )

//----------------------------------------------------------------------------//

Function IsDate( u )

Return ( Valtype( u ) == "D" )

//---------------------------------------------------------------------------//

Function IsBlock( u )

Return ( Valtype( u ) == "B" )

//---------------------------------------------------------------------------//
/*
Escribe un registro de disco
*/

Function dbGather( aField, cAlias, lAppend )

   local i

   DEFAULT lAppend := .f.

   if dbLock( cAlias, If( lAppend, MODE_APPEND, MODE_RECORD ) )
      for i := 1 to Len( aField )
         ( cAlias )->( FieldPut( i, aField[ i ] ) )
      next
      dbSafeUnlock( cAlias )
   end if

   //( cAlias )->( dbCommit() )

Return Nil

//----------------------------------------------------------------------------//

Function DisableMainWnd( oWnd )

   local oBlock

   DEFAULT oWnd   := oWnd()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( oWnd:oMenu )
      oWnd:oMenu:Disable()
   end if

   if !Empty( oWnd:oTop:oTop )
      oWnd:oTop:oTop:Disable()
   end if

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nil )

//---------------------------------------------------------------------------//

Function EnableMainWnd( oWnd )

   local oBlock

   DEFAULT oWnd   := oWnd()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( oWnd:oMenu )
      oWnd:oMenu:Enable()
   end if

   if !Empty( oWnd:oTop:oTop )
      oWnd:oTop:oTop:Enable()
   end if

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nil )

//---------------------------------------------------------------------------//

Function IsLock( cAlias )

   local n
   local a  := ( cAlias )->( dbRLockList() )

   for each n in a

      if ( n == ( cAlias )->( Recno() ) )
         Return .t.
      end if
   end if

Return .f.

//--------------------------------------------------------------------------//

Function pdaLockSemaphore( cAlias )

   local h
   local cFile := cPatLog() + Alltrim( Str( ( cAlias )->( Recno() ) ) ) + ".txt"

   if !file( cFile )
      h        := fCreate( cFile, 0 )
      if h != -1
         fClose( h )
      end if
   end if

Return .t.

//--------------------------------------------------------------------------//

Function pdaUnLockSemaphore( cAlias )

   local cFile := cPatLog() + Alltrim( Str( ( cAlias )->( Recno() ) ) ) + ".txt"

   if file( cFile )
      fErase( cFile )
   end if

Return .t.

//--------------------------------------------------------------------------//

Function pdaIsLockSemaphore( cAlias )

Return ( file( cPatLog() + Alltrim( Str( ( cAlias )->( Recno() ) ) ) + ".txt" ) )

//--------------------------------------------------------------------------//

Function AdsFile( cFile )

   local cAdsFile

   if Empty( aAdsDirectory )
      aAdsDirectory  := AdsDirectory()
   end if

   for each cAdsFile in aAdsDirectory

      if ( cAdsFile == cFile )
         return .t.
      end if

   next

Return .f.

//--------------------------------------------------------------------------//

Function ApoloBreak( oError )

Return ( if( oError:GenCode == EG_ZERODIV, 0, Break( oError ) ) )

//---------------------------------------------------------------------------//

Function Quoted( cString )

Return ( "'" + cString + "'" )

//---------------------------------------------------------------------------//

Function Chiled( cString )

Return ( Space( 3 ) + "<" + Alltrim( cString ) + ">" )

//---------------------------------------------------------------------------//

Function lChangeStruct( cAlias, aStruct )

   local i
   local aAliasStruct   

   if ( cAlias )->( fCount() ) != len( aStruct )
      Return .t.
   end if 

   aAliasStruct         := ( cAlias )->( dbStruct() ) 

   for i := 1 to ( cAlias )->( fCount() )

      if Upper( aAliasStruct[ i, DBS_NAME ] ) != Upper( aStruct[ i, DBS_NAME ] ) .or. ;
         aAliasStruct[ i, DBS_TYPE ] != aStruct[ i, DBS_TYPE ] .or. ;
         aAliasStruct[ i, DBS_LEN  ] != aStruct[ i, DBS_LEN  ] .or. ;
         aAliasStruct[ i, DBS_DEC  ] != aStruct[ i, DBS_DEC  ]

         msgAlert( aAliasStruct[ i, DBS_NAME ], str( i ) )
         msgAlert( aStruct[      i, DBS_NAME ], str( i ) )
         msgAlert( aAliasStruct[ i, DBS_TYPE ], str( i ) )
         msgAlert( aStruct[      i, DBS_TYPE ], str( i ) )
         msgAlert( aAliasStruct[ i, DBS_LEN ], str( i ) )
         msgAlert( aStruct[      i, DBS_LEN ], str( i ) )
         msgAlert( aAliasStruct[ i, DBS_DEC ], str( i ) )
         msgAlert( aStruct[      i, DBS_DEC ], str( i ) )

         Return .t.

      end if

   next

Return .f.

//----------------------------------------------------------------------------//

/*
function AddResource( nHResource, cType )


   AAdd( aResources, { cType, nHResource, ProcName( 3 ), ProcLine( 3 ) } )

return nil

//----------------------------------------------------------------------------//

function DelResource( nHResource )

   local nAt

   if ( nAt := AScan( aResources, { | aRes | aRes[ 2 ] == nHResource } ) ) != 0
      ADel( aResources, nAt )
      ASize( aResources, Len( aResources ) - 1 )
   endif

return nil

//----------------------------------------------------------------------------//

function CheckRes()

   local cInfo := "", n

   for n = 1 to Len( aResources )
      cInfo += aResources[ n, 1 ] + "," + Chr( 9 ) + Str( aResources[ n, 2 ] ) + "," + Chr( 9 ) + ;
               aResources[ n, 3 ] + "," + Chr( 9 ) + Str( aResources[ n, 4 ] ) + CRLF
   next

   MsgInfo( cInfo )

return nil

//----------------------------------------------------------------------------//

#pragma BEGINDUMP

#include <hbapi.h>
#include <hbvm.h>
#include <windows.h>

void RegisterResource( HANDLE hRes, LPSTR szType )
{
   hb_vmPushSymbol( hb_dynsymGetSymbol( "ADDRESOURCE" ) );
   hb_vmPushNil();
   hb_vmPushLong( ( LONG ) hRes );
   hb_vmPushString( szType, strlen( szType ) );
   hb_vmFunction( 2 );
}

void pascal DelResource( HANDLE hResource )
{
   hb_vmPushSymbol( hb_dynsymGetSymbol( "DELRESOURCE" ) );
   hb_vmPushNil();
   hb_vmPushLong( ( LONG ) hResource );
   hb_vmFunction( 1 );
}

#pragma ENDDUMP
*/