#include "FiveWin.Ch"
#include "Error.ch"
#include "DbStruct.ch"
#include "DbInfo.ch"
#include "Factu.ch" 
#include "Ads.ch"

#define HB_FF_AUTOINC         0x0008 /* Column is autoincrementing */

//----------------------------------------------------------------------------//

#define NNET_TIME             10

#define MODE_FILE             1
#define MODE_RECORD           2
#define MODE_APPEND           3

static aResources             := {}
static aAdsDirectory          := {}

static cLenguajeSegundario    := ""

static hTraslations           := {=>}

static scriptSystem

//--------------------------------------------------------------------------//
// Funciones para DBF's
//
//--------------------------------------------------------------------------//

FUNCTION dbSwapUp( cAlias, oBrw )

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

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:select( 0 )
      oBrw:select( 1 )
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

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:select( 0 )
      oBrw:select( 1 )
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


   if empty( xDesde )
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

   if !empty( nOrd )
      ( cAlias )->( OrdSetFocus( nOrdAct ) )
   end if

   if !empty( oGet )
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

	select( cAlias )

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

	select( cAlias )

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

   IF empty( ( cAlias )->( OrdSetFocus() ) )
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

Function cLeftPath( cPath )

   cPath             := Rtrim( cPath )

   if Right( cPath, 1 ) != "/"
      cPath          += "/"
   end if

Return ( cPath )

//----------------------------------------------------------------------------//

Function RecursiveMakeDir( cPath )

   local cRute       := ""
   local aPath       := hb_atokens( cPath, "\" )

   for each cPath in aPath 
      cRute          += cPath + "\"
      if !( ":" $ cPath ) .and. !lIsDir( cRute )
         MakeDir( cRute )
      end if 
   next

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

   if empty( cChar )

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

Return ( HB_isHash( u ) )

//---------------------------------------------------------------------------//

Function retChr( cCadena )

   local cChr     := ""

   if Valtype( cCadena ) != "C"
      Return ( cChr )
   end if

   cCadena        := AllTrim( cCadena )

   if !empty( cCadena )
      cCadena     += Space( 1 )
   end if

   while !empty( cCadena )
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

Function lselectAll( oBrw, dbf, cFieldName, lselect, lTop, lMeter )

   local nPos
   local nRecAct        := ( dbf )->( Recno() )

   DEFAULT cFieldName   := "lSndDoc"
   DEFAULT lselect      := .t.
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
         ( dbf )->( FieldPut( nPos, lselect ) )
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

   if !empty( oBrw )
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

      if empty( ( dbfTiket )->cRetMat )

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

Function msgDbfInfo( dbfAlias, cTitle )

   local oDlg
   local oTreeInfo

   if empty( dbfAlias )
      Return ( nil )      
   end if

   DEFINE DIALOG oDlg RESOURCE "dbInfo" TITLE ( cTitle )

      oTreeInfo   := TTreeView():Redefine( 100, oDlg )

   REDEFINE BUTTON ID ( IDCANCEL ) OF oDlg CANCEL ACTION ( oDlg:end() )

   oDlg:bStart    := {|| StartDbfInfo( dbfAlias, oTreeInfo ) }

   ACTIVATE DIALOG oDlg CENTER

Return ( nil )

//---------------------------------------------------------------------------//

Static Function StartDbfInfo( dbfAlias, oTreeInfo )

   local n := 0

   select( dbfAlias )

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
   oTreeInfo:Add( "DBI_DBFILTER     : "  + cValToChar( dbInfo( DBI_DBFILTER     ) ) )

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

	while select( cAlias ) != 0
      cAlias   := cDbfName + AllTrim( Str( n++ ) )
	end

RETURN cAlias

//---------------------------------------------------------------------------//

Function dbSeekArticuloUpperLower( uVal, nView )

   if dbSeekInOrd( uVal, "Codigo", D():Articulos( nView ) )
      return .t.
   end if 

   if dbSeekInOrd( upper( uVal ), "Codigo", D():Articulos( nView ) )
      return .t.
   end if 

   if dbSeekInOrd( lower( uVal ), "Codigo", D():Articulos( nView ) )
      return .t.
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//


Function dbSeekUpperLower( uVal, nView )

   local lReturn

   lReturn     := ( ( D():Articulos( nView ) )->( dbSeek( uVal ) ) )           .or.;
                  ( ( D():Articulos( nView ) )->( dbSeek( Lower( uVal ) ) ) )  .or.;
                  ( ( D():Articulos( nView ) )->( dbSeek( Upper( uVal ) ) ) )

Return ( lReturn )

//---------------------------------------------------------------------------//

Function dbSeekInOrd( uVal, cOrd, cAlias, lSoft, lLast )

   local nOrd
   local lRet  := .f.

   if ( cAlias )->( used() )
      nOrd     := ( cAlias )->( ordSetFocus( cOrd ) )
      lRet     := ( cAlias )->( dbSeek( uVal, lSoft, lLast ) )
      ( cAlias )->( ordSetFocus( nOrd ) )
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

      if !empty( uValue ) .and. !empty( uOrder ) .and. !empty( cAlias )

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
      aAdd( aSqlStruct, { a[1], a[2], a[3], a[4] } )
   next

Return ( aSqlStruct )

//----------------------------------------------------------------------------//

Function lExistTable( cTable, cVia )
   
   DEFAULT cVia   := cDriver()
   
   if cVia == "ADS"
      return .t.
   end if

Return ( file( cTable ) ) // dbExists( cTable ) )

//----------------------------------------------------------------------------//

Function lExistIndex( cIndex, cVia )

   DEFAULT cVia   := cDriver()

   if cVia == "ADS"
      return .t.
   end if

Return ( file( cIndex ) )

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

Function fRenameTable( cTableOld, cTableNew )

Return ( fRename( cTableOld, cTableNew ) )

//----------------------------------------------------------------------------//

Function dbSafeUnlock( cAlias )

   if ( cAlias )->( Used() )
      ( cAlias )->( dbUnLock() )
   end if

Return nil

//---------------------------------------------------------------------------//

function dbSafeLock( cAlias )

   if !( cAlias )->( Used() )
      return .f.
   end if
      
   if dbLock( cAlias )
      Return .t.
   end if

return .f.

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

         if ( len( aStruct[ i ] ) >= 9 ) .and. ( !empty( aStruct[ i, 9 ] ) )
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

   DEFAULT cVia   := cDriver()

   if cVia == "ADS"
      return .t.
   end if

Return ( fErase( cTable ) )

//----------------------------------------------------------------------------//

Function buildIndex( cDataBase, cDriver, aIndex )

   local cAlias
   local aCurrent

   dbUseArea( .t., cDriver, databaseFileName( cDataBase ), cCheckArea( "Alias", @cAlias ), .f. )

   if !( cAlias )->( neterr() )
      ( cAlias)->( __dbPack() )

      for each aCurrent in aIndex
         ( cAlias )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( cAlias )->( ordCreate( databaseFileIndex( cDataBase ), aCurrent[ 2 ], aCurrent[ 3 ], aCurrent[ 4 ] ) )
      next 

      ( cAlias )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla : " + cDataBase )
   end if

Return ( nil )

//----------------------------------------------------------------------------//
   
FUNCTION bCheck2Block( cChar, lMessage )

   local cType
	local bBlock
   local oBlock
   local oError
   local lError      := .f.

   DEFAULT lMessage  := .t.

   if empty( cChar )
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

Function setScriptSystem( cScriptSystem )

   scriptSystem   := cScriptSystem

Return ( nil )   

//---------------------------------------------------------------------------//

Function runScriptBeforeAppend()

   if !empty(scriptSystem)
      runEventScript( scriptSystem + "\beforeAppend" )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

Function runScriptAfterAppend()

   if !empty(scriptSystem)
      runEventScript( scriptSystem + "\afterAppend" )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

Function runScriptBeforeEdit()

   if !empty(scriptSystem)
      runEventScript( scriptSystem + "\beforeEdit" )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

Function runScriptAfterEdit()

   if !empty(scriptSystem)
      runEventScript( scriptSystem + "\afterEdit" )
   end if 

Return ( nil )

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

   if select( cAlias ) == 0
      return .f.
   end if

   if lDemoMode() .and. ( cAlias )->( lastRec() ) >= 50
      msgStop( "Esta usted utilizando una versi�n demo.", "El programa se abortar�" )
      return .f.
   end if

   // Script antes de a�adir---------------------------------------------------

   runScriptBeforeAppend()

   // Orden principal----------------------------------------------------------

   if empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   aTmp           := dbBlankRec( cAlias )

   aGet           := Array( ( cAlias )->( fCount() ) )

	// Bloqueamos el registro durante la edici�n-----------------------------------

   lReturn        := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, APPD_MODE, xOthers )

   if lReturn
      dbSafeUnLock( cAlias )
   end if

   if IsNum( nOrd ) .and. ( nOrd != 0 )
      ( cAlias )->( OrdSetFocus ( nOrd ) )
   end if

   // Script despues de a�adir

   runScriptAfterAppend()

   runScriptAfterEdit()

   // refrescos en pantalla

   if !empty( oBrw ) .and. ( oBrw:lActive )

      if oBrw:lFooter .and. !empty( oBrw:nFooterHeight )
         oBrw:MakeTotals()
      end if 

      oBrw:select( 0 )
      oBrw:select( 1 )
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

   if select( cAlias ) == 0
      Return .f.
   end if

   if lDemoMode() .and. ( cAlias )->( lastRec() ) >= 50
      msgStop( "Esta usted utilizando una versi�n demo.", "El programa se abortar�" )
      Return .f.
   end if

   // Script antes de a�adir

   runScriptBeforeAppend()

   // Orden principal

   nRec           := ( cAlias )->( Recno() )

   if empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   if lAdsRDD()
      ( cAlias )->( dbClearFilter() )
   end if

	// Bloqueamos el registro durante la edici�n

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

   // Script despues de a�adir

   runScriptAfterAppend()

   runScriptAfterEdit()

   // refrescos en pantalla

   if lResult .and. !empty( oBrw ) .and. ( oBrw:lActive )

      oBrw:select( 0 )
      oBrw:select( 1 )

		if oBrw:lFooter .and. !empty( oBrw:nFooterHeight )
			oBrw:MakeTotals()
		end if 

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
   local nRec 

   DEFAULT cAlias    := Alias()
   DEFAULT bWhen     := "" //{ || .t. }
   DEFAULT bValid    := "" //{ || .t. }

   if select( cAlias ) == 0 .OR. ( ( cAlias )->( LastRec() ) == 0 )
      return .f.
   end if

   // Script antes de a�adir

   runScriptBeforeEdit()

   // Orden principal

   if empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd           := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   nRec              := ( cAlias )->( Recno() )

   if !( cAlias )->( eof() )
      if dbDialogLock( cAlias )
         aTmp        := dbScatter( cAlias )
         aGet        := array( ( cAlias )->( fCount() ) )
         lResult     := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, EDIT_MODE, xOthers )
         dbSafeUnLock( cAlias )
      end if
   end if

   if isNum( nOrd ) .and. nOrd != 0
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

   // Script despues de a�adir

   runScriptAfterEdit()

   // refrescos en pantalla

   if lResult .and. oBrw != nil

      oBrw:select( 0 )
      oBrw:select( 1 )

		if oBrw:lFooter .and. !empty( oBrw:nFooterHeight )
			oBrw:MakeTotals()
		end if 

      oBrw:Refresh()

   end if

   if isNum( nRec )
      ( cAlias )->( dbGoto( nRec ) )
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

	IF select( cAlias ) == 0
		RETURN .F.
	END IF

   if empty( ( cAlias )->( OrdSetFocus() ) )
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
         case aStruct[ i, DBS_TYPE ] == "C"
            AAdd( aBlank, Space( aStruct[ i, DBS_LEN ] ) )
         case aStruct[ i, DBS_TYPE ] == "M"
            AAdd( aBlank, "" )            // Space( aStruct[ i, DBS_LEN ] )
         case aStruct[ i, DBS_TYPE ] == "N"
            AAdd( aBlank, Val( "0." + Replicate( "0", aStruct[ i, DBS_DEC ] ) ) )
         case aStruct[ i, DBS_TYPE ] == "L"
            AAdd( aBlank, .F. )
         case aStruct[ i, DBS_TYPE ] == "D"
            AAdd( aBlank, GetSysDate() )  // CtoD( "" ) )
         case aStruct[ i, DBS_TYPE ] == "@"
            AAdd( aBlank, DateTime() )  
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
   local oWaitMeter

   DEFAULT cAlias    := Alias()
   DEFAULT lMaster   := .f.
   DEFAULT lTactil   := .f.

   if select( cAlias ) == 0 .or. ( cAlias )->( LastRec() ) == 0
      return ( .f. )
   end if

   // Cuantos registros marcados tenemos---------------------------------------

   if !empty( oBrw ) .and. ( "XBROWSE" $ oBrw:ClassName() )

      nMarked        := len( oBrw:aselected )
      if nMarked > 1
         cTxt        := "� Desea eliminar definitivamente " + AllTrim( Trans( nMarked, "999999" ) ) + " registros ?"
      end if

      if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( cTxt, "Confirme supresi�n", lTactil )

         oWaitMeter        := TWaitMeter():New( "Eliminando registros", "Espere por favor..." )
         oWaitMeter:run()
         oWaitMeter:setTotal( len( oBrw:aselected ) )

         for each nRec in ( oBrw:aselected )

            ( cAlias )->( dbGoTo( nRec ) )

            if !empty( bPreBlock )
               lTrigger    := CheckEval( bPreBlock )
            end if

            if !isLogic( lTrigger ) .or. lTrigger

               dbDel( cAlias )

               if !empty( bPostBlock )
                  checkEval( bPostBlock )
               end if

            end if

            oWaitMeter:autoInc()

         next

         oWaitMeter:end()

      end if

   else

      if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( cTxt, "Confirme supersi�n", lTactil )

         if !empty( bPreBlock )
            lTrigger    := CheckEval( bPreBlock )
         end if

         if !isLogic( lTrigger ) .or. lTrigger

            dbDel( cAlias )

            if !empty( bPostBlock )
               lTrigger := CheckEval( bPostBlock )
            end if

            lReturn     := .t.

         end if

      end if

   end if

   if !empty( oBrw )
      oBrw:select( 0 )
      oBrw:select( 1 )
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

   if select( cAlias ) == 0 .or. ( cAlias )->( LastRec() ) == 0
      return ( .f. )
   end if

   /*
   Cuantos registros marcados tenemos
   */

   if ( lDelMarked ) .and. ( "TXBROWSE" $ oBrw:ClassName() )
      nMarked           := len( oBrw:aselected )
      if nMarked > 1
         cTxt           := "� Desea eliminar definitivamente " + AllTrim( Str( nMarked, 3 ) ) + " registros ?"
      end if

      if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( cTxt, "Confirme supersi�n", lBig )
         for each nRec in oBrw:aselected

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

         if !empty( oBrw )
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
      oBrw:select( 0 )
      oBrw:select( 1 )
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

      if !empty( bCodeBlock ) .and. Valtype( bCodeBlock ) == "B"
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

   if ( cAlias )->( dbRLock() ) //dbLock( cAlias )
      ( cAlias )->( dbDelete() )
      ( cAlias )->( dbUnLock() )
   else
      msgStop( "No he podido bloquear.")
   end if

   ( cAlias )->( dbSkip( 0 ) )

Return nil

//---------------------------------------------------------------------------//

Function dbLockDelete( cAlias )

   if dbLock( cAlias )
      ( cAlias )->( dbDelete() )
      ( cAlias )->( dbUnLock() )
   else 
      Return .f.
   end if

Return .t.

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

FUNCTION WinGather( aTmp, aGet, cAlias, oBrw, nMode, bPostAction, lempty )

   local lAdd     := ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

	DEFAULT lempty	:= .t.

	CursorWait()

   if dbDialogLock( cAlias, lAdd )
      aEval( aTmp, { | uTmp, n | ( cAlias )->( fieldPut( n, uTmp ) ) } )
      dbSafeUnLock( cAlias )
   end if

   ( cAlias )->( dbCommit() )

   if lempty
      aCopy( dbBlankRec( cAlias ), aTmp )
      if !empty( aGet )
         aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )
      end if
   end if

   if bPostAction != nil
		Eval( bPostAction )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

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

   local aStatus  := { ( cAlias )->( Recno() ), ( cAlias )->( ordsetfocus() ) }

   DEFAULT lInit  := .f.

   if lInit
      ( cAlias )->( OrdSetFocus( 1 ) )
      ( cAlias )->( dbGoTop() )
   end if

return ( aStatus )

//--------------------------------------------------------------------------//

Function hGetStatus( cAlias, uOrder )

   local hStatus  := { "Alias" => cAlias, "Recno" => ( cAlias )->( Recno() ), "Order" => ( cAlias )->( OrdSetFocus() ) }

   if !isNil( uOrder )
      ( cAlias )->( OrdSetFocus( uOrder ) )
      ( cAlias )->( dbGoTop() )
   end if

Return ( hStatus )

//--------------------------------------------------------------------------//

Function hSetStatus( hStatus )

   ( HGet( hStatus, "Alias" ) )->( ordsetfocus( HGet( hStatus, "Order" ) ) )
   ( HGet( hStatus, "Alias" ) )->( dbgoto(      HGet( hStatus, "Recno" ) ) )

Return nil

//--------------------------------------------------------------------------//
/*
Comprueba si existe una clave
*/

FUNCTION notValid( oGet, uAlias, lRjust, cChar, nTag, nLen )

   local lReturn  := .t.

   if !validKey( oGet, uAlias, lRjust, cChar, nTag, nLen )
      msgStop( "Clave existente", "Aviso del sistema" )
      lReturn     := .f.
   end if

RETURN lReturn

//-------------------------------------------------------------------------//

FUNCTION validKey( oGet, uAlias, lRjust, cChar, nTag, nLen )

   local nOldTag
   local cAlias
   local cFilter
   local lReturn  := .t.
   local xClave   := oGet:VarGet()

   DEFAULT uAlias := Alias()
   DEFAULT lRjust := .f.
	DEFAULT cChar	:= "0"
	DEFAULT nTag   := 1

   if isObject( uAlias )
      cAlias      := uAlias:cAlias
   else
      cAlias      := uAlias
   end if

   cFilter        := ( cAlias )->( dbFilter() )
   ( cAlias )->( dbClearFilter() )

   nOldTag        := ( cAlias )->( OrdSetFocus( nTag ) )

   /*
	Cambiamos el tag y guardamos el anterior
	*/

   if empty( ( cAlias )->( OrdSetFocus() ) )
      MsgInfo( "Indice no disponible, comprobaci�n imposible" )
      return .t.
   end if

   if lRjust
      if ischar( xClave ) .and. at( ".", xClave ) != 0
         PntReplace( oGet, cChar, nLen )
      else 
         RJustObj( oGet, cChar, nLen )
      end if
   end if

   xClave         := oGet:VarGet()

   if Existe( xClave, cAlias )
      lReturn     := .f.
   end if

	( cAlias )->( OrdSetFocus( nOldTag ) )

   if !empty(cFilter)
      ( cAlias )->( dbSetFilter( {|| &cFilter }, cFilter ) )
   end if


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

Function databaseFileName( cFile )

Return ( cFile + ".Dbf" )

//--------------------------------------------------------------------------//

Function databaseFileIndex( cFile )

Return ( cFile + ".Cdx" )

//--------------------------------------------------------------------------//

Function databaseFileMemo( cFile )

Return ( cFile + ".Fpt" )

//--------------------------------------------------------------------------//

Function dbfErase( cFileName )

   if empty( cFileName )
      return .t.
   end if

   if dbExists( cFileName )
      dbDrop( cFileName )
   end if

   if file( databaseFileName( cFileName ) )
      if ferase( databaseFileName( cFileName ) ) == -1
         Return .f.
      end if
   end if

   if file( databaseFileIndex( cFileName ) )
      if fErase( databaseFileIndex( cFileName ) ) == -1
         Return .f.
      end if
   end if

   if file( databaseFileMemo( cFileName ) )
      if fErase( databaseFileMemo( cFileName ) ) == -1
         Return .f.
      end if
   end if

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
   local cFlt  := ( dbfTmp )->( dbFilter() )
   local nNum  := Str( nNumLin, 4 )

   if !empty( cFlt )
      ( dbfTmp )->( dbSetFilter() )
   end if 

   if ( dbfTmp )->( dbSeek( nNum ) )
      while Str( ( dbfTmp )->nNumLin, 4 ) == nNum .and. ( !( dbfTmp )->( Eof() ) )
         if ( dbfTmp )->lKitChl      
            ( dbfTmp )->( dbDelete() )
         end if 
         ( dbfTmp )->( dbSkip() )
         SysRefresh()
      end while
   end if 

   if !empty( cFlt )
      ( dbfTmp )->( dbSetFilter( c2Block( cFlt ), cFlt ) )
   end if 

   ( dbfTmp )->( OrdSetFocus( nOrd ) )
   ( dbfTmp )->( dbGoTo( nRec ) )

   if !empty( oBrw )
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

   if empty( xHasta )
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

   if !empty( nOrd )
      ( cAlias )->( OrdSetFocus( nOrdAct ) )
   end if

   if !empty( oGet )
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

	IF select( cAlias ) == 0
		RETURN .F.
	END IF

   if empty( ( cAlias )->( OrdSetFocus() ) )
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

Return ( abs( nTotal - nCobrado ) >= nDiferencia )

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

         if !empty( xField1 )
            ( cAliDestino )->( FieldPut( 1, xField1 ) )
         end if

         if !empty( xField2 )
            ( cAliDestino )->( FieldPut( 2, xField2 ) )
         end if

         if !empty( xField3 )
            ( cAliDestino )->( FieldPut( 3, xField3 ) )
         end if

         if !empty( xField4 )
            ( cAliDestino )->( FieldPut( 4, xField4 ) )
         end if

         if !empty( xField5 )
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

         if !empty( xField1 )
            ( cAliDestino )->( FieldPut( 1, xField1 ) )
         end if

         if !empty( xField2 )
            ( cAliDestino )->( FieldPut( 2, xField2 ) )
         end if

         if !empty( xField3 )
            ( cAliDestino )->( FieldPut( 3, xField3 ) )
         end if

         if !empty( xField4 )
            ( cAliDestino )->( FieldPut( 4, xField4 ) )
         end if

         if !empty( xField5 )
            ( cAliDestino )->( FieldPut( 5, xField5 ) )
         end if

         dbSafeUnLock( cAliDestino )

         lPass       := .t.

      end if

   end if

Return ( lPass )

//----------------------------------------------------------------------------//

FUNCTION appendRegisterByHash( cAliOrigen, cAliDestino, hHash )

   local lPass    := .f.

   ( cAliDestino )->( dbAppend(.t.) )

   if !( cAliDestino )->( NetErr() )

      passField( cAliOrigen, cAliDestino )

      passHash( cAliDestino, hHash )

      ( cAliDestino )->( dbUnLock() )

      lPass       := .t.

   end if

Return ( lPass )

//----------------------------------------------------------------------------//

FUNCTION EditPass( cAliOrigen, cAliDestino, hHash )

   if ( cAliDestino )->( dbRLock() )

      PassField( cAliOrigen, cAliDestino )

      PassHash( cAliDestino, hHash )
      
      dbSafeUnLock( cAliDestino )

   end if

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION PassField( cAliOrigen, cAliDestino )

   local i
   local uValue
   local cFieldName
   local nFieldPosition
   local nFieldTotal    := ( cAliDestino )->( fcount() )

   for i := 1 to nFieldTotal

      cFieldName        := ( cAliDestino )->( fieldname( i ) )
      nFieldPosition    := ( cAliOrigen  )->( fieldpos( cFieldName ) )

      if nFieldPosition != 0
         uValue         := ( cAliOrigen )->( fieldget( nFieldPosition ) )
         ( cAliDestino )->( fieldput( i, uValue ) )
      end if

   next

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION PassHash( cAliDestino, hHash )

   local h
   local nPos

   if empty(hHash)
      Return ( .t. )
   end if 

   for each h in hHash
      nPos     := ( cAliDestino )->( fieldpos( h:__enumKey() ) )
      if nPos != 0
         ( cAliDestino )->( fieldput( nPos, h:__enumValue() ) )
      end if
   next

Return ( .t. )

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

   lValid            := empty( cMail ) .or. HB_RegExMatch( "[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}", cMail, .f. )

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

Function IsInteger( u )

Return ( u - int( u ) == 0 )

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

   if !empty( oWnd:oMenu )
      oWnd:oMenu:Disable()
   end if

   if !empty( oWnd:oTop:oTop )
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

   if !empty( oWnd:oMenu )
      oWnd:oMenu:Enable()
   end if

   if !empty( oWnd:oTop:oTop )
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

   if empty( aAdsDirectory )
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

         Return .t.

      end if

   next

Return .f.

//----------------------------------------------------------------------------//

function DbDialog( cTitle )

   local j
   local n
   local oDlg
   local oGet
   local oFont
   local oError
   local oBlock
   local nTarget
   local nAreas      := 0
   local cErrorLog

   DEFAULT cTitle    := "Bases de datos abiertas"

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if lAis()
      msgStop( TDataCenter():GetAllLocksTablesUsers() )
   end if

   for n = 1 to 255
      if !empty( alias( n ) )
         nAreas++
      end if 
   next 

   oFont             := TFont():New( "Ms Sans Serif", 0, -10, .f., .f. )

   DEFINE DIALOG     oDlg ;
         SIZE        300, 200 + If( IsWinNT(), 50, 0 ) ;
         TITLE       cTitle + ":" + str( nAreas) ;
         FONT        oFont

   cErrorLog         := CRLF + "DataBases in use" + CRLF + "================" + CRLF

   for n = 1 to nAreas

      if ! empty( Alias( n ) )

         cErrorLog   += CRLF + Str( n, 3 ) + ": " + If( select() == n,"=> ", "   " ) + ;
                        PadR( Alias( n ), 15 ) + Space( 20 ) + "RddName: " + ;
                        ( Alias( n ) )->( RddName() ) + CRLF
         cErrorLog   += "     ==============================" + CRLF
         cErrorLog   += "     RecNo    RecCount    BOF   EOF" + CRLF
         cErrorLog   += "    " + Transform( ( Alias( n ) )->( RecNo() ), "99999" ) + ;
                        "      " + Transform( ( Alias( n ) )->( RecCount() ), "99999" ) + ;
                        "      " + cValToChar( ( Alias( n ) )->( BoF() ) ) + ;
                        "   " + cValToChar( ( Alias( n ) )->( EoF() ) ) + CRLF + CRLF
         cErrorLog   += "     Indexes in use " + Space( 23 ) + "TagName" + CRLF

         for j = 1 to 15

            if ! empty( ( Alias( n ) )->( IndexKey( j ) ) )

               cErrorLog   += Space( 8 ) + ;
                              If( ( Alias( n ) )->( OrdNumber() ) == j, "=> ", "   " ) + ;
                              PadR( ( Alias( n ) )->( IndexKey( j ) ), 35 ) + ;
                              ( Alias( n ) )->( OrdName( j ) ) + ;
                              CRLF
            endif

         next

         cErrorLog   += CRLF + "     Relations in use" + CRLF

         for j = 1 to 8

            if ! empty( ( nTarget := ( Alias( n ) )->( DbRselect( j ) ) ) )

               cErrorLog += Space( 8 ) + Str( j ) + ": " + ;
                            "TO " + ( Alias( n ) )->( DbRelation( j ) ) + ;
                            " INTO " + Alias( nTarget ) + CRLF
               // uValue = ( Alias( n ) )->( DbRelation( j ) )
               // cErrorLog += cValToChar( &( uValue ) ) + CRLF

            endif

         next

      endif

   next

   memoWritex( "dbDialog.log", cErrorLog )

   @ 0, 0 GET oGet VAR cErrorLog ;
         MULTILINE ;
         OF       oDlg ;
         FONT     oFont ;
         SIZE     149, 100

   @ 87 + If( IsWinNT(), 24, 0 ), 60 BUTTON "&Quit" ;
         OF       oDlg ;
         ACTION   ( oDlg:End() );
         SIZE     30, 12 ;
         PIXEL ;
         FONT     oFont ;
         DEFAULT

   ACTIVATE DIALOG oDlg CENTERED

   oFont:End()

   RECOVER USING oError

      msgStop( cErrorLog, ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN NIL

//---------------------------------------------------------------------------//

Function getTraslation( cText )

   local cTraslation    := ""

   if HHasKey( hTraslations, cText )
      cTraslation       := HGet( hTraslations, cText )
   else 
      cTraslation       := GetPvProfString( "Traslations", cText, "", cIniAplication() )      
      if !empty( cTraslation )
         hSet( hTraslations, cText, cTraslation )   
      end if
   end if 

return ( if( !empty( cTraslation ), cTraslation, cText ) )   

//---------------------------------------------------------------------------//

Function ValToMoney( cMoney )

Return ( Val( StrTran( cMoney, ",", "." ) ) )

//--------------------------------------------------------------------------//

Function LineDown( cAlias, oBrw )

Return ( lineReposition( cAlias, oBrw, .f. ) )

//--------------------------------------------------------------------------//

Function LineDownOld( cAlias, oBrw )

Return ( lineRepositionOld( cAlias, oBrw, .f. ) )

//--------------------------------------------------------------------------//

Function LineUp( cAlias, oBrw )

Return ( lineReposition( cAlias, oBrw, .t. ) )

//--------------------------------------------------------------------------//

Function LineUpOld( cAlias, oBrw )

Return ( lineRepositionOld( cAlias, oBrw, .t. ) )

//--------------------------------------------------------------------------//

Function lineReposition( cAlias, oBrw, lUp )

   local nOrdNum  
   local nRecNum  
   local nOldNum
   local nNewNum
   local currentAlias

   DEFAULT lUp    := .t.

   if ( cAlias )->( fieldpos( "nPosPrint" ) ) == 0
      Return .f.
   end if

   nOrdNum        := ( cAlias )->( OrdSetFocus( "nPosPrint" ) )

   if ( lUp .and. ( cAlias )->( OrdKeyNo() ) == 1 )
      ( cAlias )->( OrdSetFocus( nOrdNum ) )   
      Return .f.
   end if 

   if ( !lUp .and. ( cAlias )->( OrdKeyNo() ) == ( cAlias )->( OrdKeyCount() ) )
      ( cAlias )->( OrdSetFocus( nOrdNum ) )   
      Return .f.
   end if

   CursorWait()

   nRecNum        := ( cAlias )->( RecNo() )
   nOldNum        := ( cAlias )->nPosPrint

   if lUp
      ( cAlias )->( dbSkip(-1) )
   else 
      ( cAlias )->( dbSkip() )
   end if 

   nNewNum        := ( cAlias )->nPosPrint

   // cambio de lineas

   swapLines( nOldNum, nNewNum, cAlias )

   // orden anterior

   ( cAlias )->( OrdSetFocus( nOrdNum ) )
   ( cAlias )->( dbGoTo( nRecNum ) )

   CursorWE()

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:select( 0 )
      oBrw:select( 1 )
      oBrw:SetFocus()
   end if

Return ( nil )

//--------------------------------------------------------------------------//

Function lineRepositionOld( cAlias, oBrw, lUp )

   local nOrdNum  
   local nRecNum  
   local nOldNum
   local nNewNum
   local currentAlias
   
   DEFAULT lUp    := .t.

   if ( cAlias )->( fieldpos( "nNumLin" ) ) == 0
      Return .f.
   end if

   nOrdNum        := ( cAlias )->( OrdSetFocus( "nNumLin" ) )

   if ( lUp .and. ( cAlias )->( OrdKeyNo() ) == 1 )
      ( cAlias )->( OrdSetFocus( nOrdNum ) )   
      Return .f.
   end if 

   if ( !lUp .and. ( cAlias )->( OrdKeyNo() ) == ( cAlias )->( OrdKeyCount() ) )
      ( cAlias )->( OrdSetFocus( nOrdNum ) )   
      Return .f.
   end if

   CursorWait()

   nRecNum        := ( cAlias )->( RecNo() )
   nOldNum        := ( cAlias )->nNumLin

   if lUp
      ( cAlias )->( dbSkip(-1) )
   else 
      ( cAlias )->( dbSkip() )
   end if 

   nNewNum        := ( cAlias )->nNumLin

   // cambio de lineas

   swapLines( nOldNum, nNewNum, cAlias )

   // orden anterior

   ( cAlias )->( OrdSetFocus( nOrdNum ) )
   ( cAlias )->( dbGoTo( nRecNum ) )

   CursorWE()

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:select( 0 )
      oBrw:select( 1 )
      oBrw:SetFocus()
   end if

Return ( nil )

//--------------------------------------------------------------------------//

Static Function swapLines( nOldNum, nNewNum, cAlias ) 

   lineMove( nOldNum, -1, cAlias )
   lineMove( nNewNum, nOldNum, cAlias )
   lineMove( -1, nNewNum, cAlias )

Return ( nil )

//--------------------------------------------------------------------------//

Static Function swapLinesOld( nOldNum, nNewNum, cAlias ) 

   lineMoveOld( nOldNum, -1, cAlias )
   lineMoveOld( nNewNum, nOldNum, cAlias )
   lineMoveOld( -1, nNewNum, cAlias )

Return ( nil )

//--------------------------------------------------------------------------//

Static Function LineMove( nOldNum, nNewNum, cAlias )

   local ordenAnterior  := ( cAlias )->( ordsetfocus( 0 ) )

   ( cAlias )->( dbgotop() )
   while !( cAlias )->( eof() )

      if ( cAlias )->nPosPrint == nOldNum
         ( cAlias )->nPosPrint := nNewNum
      end if

      ( cAlias )->( dbSkip() )

   end while

   ( cAlias )->( ordsetfocus( ordenAnterior ) )

Return nil

//--------------------------------------------------------------------------//

Static Function LineMoveOld( nOldNum, nNewNum, cAlias )

   local ordenAnterior  := ( cAlias )->( ordsetfocus( 0 ) )

   ( cAlias )->( dbgotop() )
   while !( cAlias )->( eof() )

      if ( cAlias )->nNumLin == nOldNum
         ( cAlias )->nNumLin := nNewNum
      end if

      ( cAlias )->( dbSkip() )

   end while

   ( cAlias )->( ordsetfocus( ordenAnterior ) )

Return nil

//--------------------------------------------------------------------------//

Function DeleteFilesToDirectory( cPath )

   local cDirectory
   local aDirectory     := Directory( cPath + "/*.*" )

   for each cDirectory in aDirectory
      ERASE ( cPath + "/" + cDirectory[ 1 ] )
   next

Return .t.   

//--------------------------------------------------------------------------//

Function PutBrackets( cText )

Return ( "[" + QuitBrackets( cText ) + "]" )   

//--------------------------------------------------------------------------//

Function QuitBrackets( cText )

   cText    := strtran( cText, "[", "" )
   cText    := strtran( cText, "]", "" )

Return ( alltrim( cText ) )

//--------------------------------------------------------------------------//

Function DateToString( dDate )
      
   local cDateFrm := Set( 4, "yyyy/mm/dd" )
   local strDate  := if( dDate != NIL, dtos( dDate ), dtos( date() ) )
   Set( 4, cDateFrm )

Return( strDate )

//---------------------------------------------------------------------------//

Function DlgWait( nRetardo )

   local nSeconds

   DEFAULT nRetardo  := 0.1

   nSeconds          := Seconds() + nRetardo

   while nSeconds >= Seconds()
   end while

RETURN ( nil )

//---------------------------------------------------------------------------//

Function nRedondeaVenta( nValor )

Return ( Round( nValor, nRouDiv() ) )

//---------------------------------------------------------------------------//

Function nCalculaDescuentoVenta( nValor, nDescuento )

   local nTotalDescuento   := 0

   if nDescuento != 0
      nValor               := nRedondeaVenta( nValor )
      nTotalDescuento      := nValor * nDescuento / 100
      nTotalDescuento      := nRedondeaVenta( nTotalDescuento )
   end if 

Return ( nTotalDescuento )

//---------------------------------------------------------------------------//

Function nRestaDescuentoVenta( nValor, nDescuento )

   nValor -= nCalculaDescuentoVenta( nValor, nDescuento )

Return ( nValor )

//---------------------------------------------------------------------------//

Function setLenguajeSegundario( cLenguaje )

   if !empty( cLenguaje )
      cLenguajeSegundario  := cLenguaje
   end if

Return( .t. )

//---------------------------------------------------------------------------//

Function getLenguajeSegundario()

return cLenguajeSegundario

//---------------------------------------------------------------------------//

Function fieldGetByName( cFieldName )

   if empty( alias() )
      Return ""
   end if 

Return ( ( alias() )->( fieldget( fieldpos( cFieldName ) ) ) )

//---------------------------------------------------------------------------//

Function hGetDefault( hash, key, default )

   if hhaskey( hash, key )
      Return ( hGet( hash, key ) )
   end if 

Return ( default )

//---------------------------------------------------------------------------//
   
CLASS excluyentArray

   CLASSDATA  aArray       INIT {}

   Method Init()           INLINE ( ::aArray := {} )
   Method Add(uValue)      INLINE ( if( aScan( ::aArray, uValue ) == 0, aAdd( ::aArray, uValue ), ) )
   Method Get(n)           INLINE ( if( empty(n), ::aArray, ::aArray[ n ] ) )
   Method empty()          INLINE ( empty( ::aArray ) )

END CLASS

//---------------------------------------------------------------------------//

Function CaptureSignature( cFile )

   local oDlg
   local oSig
   local lPaint      := .f.
   local hDC
   local lReset      := .f.
   local oBrush
   local nPenWidth   := 4
   local oPenSig
   local nTop        := 2
   local nBottom     := 0
   local aCoord
   local nColor      := CLR_WHITE

   oBrush            := TBrush():New( , nColor )

   DEFINE DIALOG oDlg TITLE "Firma" PIXEL RESOURCE "DLG_SIGNATURE"

   DEFINE PEN oPenSig WIDTH nPenWidth COLOR CLR_BLACK

   REDEFINE SAY oSig ;
      ID       200 ;
      PROMPT   "" ;
      OF       oDlg
      
      oSig:nClrPane  := nRgb( 255,255,255 )
      oSig:oBrush    := oBrush

   REDEFINE BUTTON ;
      ID       100 ;
      OF       oDlg ;
      UPDATE;
      ACTION   ( oSig:SaveToBmp( cFile ), oDlg:End( IDOK ) )

   REDEFINE BUTTON ;
      ID       101 ;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   REDEFINE BUTTON ;
      ID       102 ;
      OF       oDlg ;
      ACTION   (  lPaint := .f., ;
                  fillRect( hDC, GetClientRect( oSig:hWnd ), oBrush:hBrush ), ;
                  oSig:refresh( .t. ) )

   oSig:lWantClick := .t.
   
   // Fixed row, col to y, x conversion, x/y designation was reversed

   oSig:bLButtonUp := { | y, x, z | DoDraw( hDC, x, y, lPaint := .f.,, oPenSig ) }
   
   // Added limits to Top and Bottom in case users draw off canvas
   
   oSig:bMMoved    := { | y, x, z | ( if( y >= nBottom .or. y <= nTop , lReset := .t., lReset := .f. ), ;
                                          DoDraw( hDC, x, y , lPaint, lReset, oPenSig ) ) }
   oSig:bLClicked  := { | y, x, z | DoDraw( hDC, x, y, lPaint := .t., .t., oPenSig  ) }
   
   // if button released when not on Signature area
   
   oDlg:bLButtonUp := { || lPaint := .f. }

   ACTIVATE DIALOG oDlg CENTER ;
      ON INIT  (  aCoord         := GetCoors( oSig:hWnd ), ;
                  nBottom        := aCoord[3] - aCoord[1] - 2, ;
                  hDC            := GetDC( oSig:hWnd ),;
                  oSig:nClrPane  := nColor ) ;
      VALID ( releaseDC( oSig:hWnd, hDC ), .t. )

   RELEASE PEN oPenSig

Return ( oDlg:nResult == IDOK )

Static Function DoDraw( hDc, x, y, lPaint, lReset, oPen )
   
   if ! lPaint .or. ( lReset != nil .and. lReset )
      MoveTo( hDC, x, y )
   else
      LineTo( hDc, x, y, oPen:hPen )
   endif

   sysRefresh()

Return nil

Function signatureToMemo( )

   local hBmp
   local cMemo
   local cFile    := cPatTmp() + "signature.bmp"  

   if captureSignature( cFile ) .and. file( cFile ) 

      hBmp        := readBitMap( 0, cFile )
      if !empty( hBmp )
         cMemo    := bmpToStr( hBmp )
      end if 

      deleteObject( hBmp )
   
   else 
   
      msgStop( "Error al guardar la firma.")
   
   end if 

Return ( cMemo )

//----------------------------------------------------------------------------//

function MsgCombo( cTitle, cText, aItems, uVar, cBmpFile, cResName )

   local oDlg, oBmp, oCbx
   local lOk      := .f.
   local cItem

   DEFAULT cTitle := "Title"
   DEFAULT cText  := "Valor"
   DEFAULT aItems := { "One", "Two", "Three" }

   cItem          := aItems[1]

   DEFINE DIALOG oDlg FROM 10, 20 TO 18, 59.5 TITLE cTitle

   if ! empty( cBmpFile ) .or. ! empty( cResName )

      if ! empty( cBmpFile )
         @ 1, 1 BITMAP oBmp FILENAME cBmpFile SIZE 20, 20 NO BORDER OF oDlg
      endif

      if ! empty( cResName )
         @ 1, 1 BITMAP oBmp RESOURCE cResName SIZE 20, 20 NO BORDER OF oDlg
      endif

      @ 0.5, 6 SAY cText OF oDlg SIZE 250, 10
      
      @ 1.6, 4 COMBOBOX oCbx VAR cItem ;
      SIZE 120, 12 ;
      ITEMS aItems ;

   else   
      
      @ 0.5, 3.3 SAY cText OF oDlg SIZE 250, 10

      @ 1.6, 2.3 COMBOBOX oCbx VAR cItem ;
      SIZE 120, 12 ;
      ITEMS aItems ;

   endif   

   @ 2.25, 7.5 - If( oBmp == nil, 2, 0 ) BUTTON "&Ok"  OF oDlg SIZE 35, 12 ;
      ACTION ( oDlg:End(), lOk := .t. ) DEFAULT

   @ 2.25, 16.5 - If( oBmp == nil, 2, 0 ) BUTTON "&Cancel" OF oDlg SIZE 35, 12 ;
      ACTION ( oDlg:End(), lOk := .f. )

   ACTIVATE DIALOG oDlg CENTERED

   if lOk
      uVar := cItem
   endif

Return lOk

//----------------------------------------------------------------------------//

Function debug( uValue, cTitle )

Return ( msgAlert( hb_valtoexp( uValue ), cTitle ) )

//----------------------------------------------------------------------------//

Function setCustomFilter( cExpresionFilter )

   if lAIS()
      ( select() )->( adsSetAOF( cExpresionFilter ) ) 
   else 
      ( select() )->( dbSetFilter( bCheck2Block( cExpresionFilter ), cExpresionFilter ) )
   end if 

Return ( nil )

//----------------------------------------------------------------------------//

Function quitCustomFilter()

   if lAIS()
      ( select() )->( adsClearAOF() ) 
   else 
      ( select() )->( dbSetFilter() )
   end if 

Return ( nil )

//----------------------------------------------------------------------------//

Function dbCustomKeyCount()

   if lAIS()
      Return ( ( select() )->( adsKeyCount( , , ADS_RESPECTFILTERS ) ) )
   end if 

Return ( ( select() )->( ordkeycount() ) )

//----------------------------------------------------------------------------//
