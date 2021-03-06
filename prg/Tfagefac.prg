#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TflAgeFac FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }
   DATA  oIndice     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD AddTipVta()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodAge", "C",  3, 0,  {|| "@!" },         "Cod. age.",       .f., "C�digo agente",        3 )
   ::AddField ( "cNomAge", "C", 50, 0,  {|| "@!" },         "Agente",          .f., "Nombre agente",       25 )
   ::AddField ( "cCodFam", "C", 16, 0,  {|| "@!" },         "Cod. fam.",       .f., "C�digo fam�lia",       8 )
   ::AddField ( "cDesFam", "C",  8, 0,  {|| "@!" },         "Familia",         .f., "Nombre fam�lia",      20 )
   ::AddField ( "cRefArt", "C", 18, 0,  {|| "@!" },         "C�digo art�culo",       .t., "C�digo art�culo",     14 )
   ::AddField ( "cDesArt", "C", 50, 0,  {|| "@!" },         "Art�culo",        .t., "Art�culo",            35 )
   ::FldPropiedades()
   ::AddField ( "nUndCaj", "N", 16, 6,  {|| MasUnd () },    cNombreCajas(),    .f., cNombreCajas(),        12 )
   ::AddField ( "nUndArt", "N", 16, 6,  {|| MasUnd () },    cNombreUnidades(), .f., cNombreUnidades(),     12 )
   ::AddField ( "nCajUnd", "N", 16, 6,  {|| MasUnd () },    "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(), 12 )
   ::AddField ( "nBasCom", "N", 16, 6,  {|| ::cPicOut },    "Base",            .t., "Base comisi�n",       12 )
   ::AddField ( "nTotCom", "N", 16, 6,  {|| ::cPicOut },    "Comisi�n",        .t., "Importe comisi�n",    12 )
   ::AddField ( "nPreMed", "N", 16, 6,  {|| ::cPicImp },    "Pre. Med.",       .f., "Precio medio",        12, .f. )
   ::AddField ( "cDocMov", "C", 14, 0,  {|| "" },           "Factura",         .f., "Factura",             14 )
   ::AddField ( "dFecMov", "D",  8, 0,  {|| "" },           "Fecha",           .f., "Fecha",                8 )
   ::AddField ( "cTipVen", "C", 20, 0,  {|| "@!" },         "Venta",           .f., "Tipo de venta",       20 )

   ::AddTmpIndex ( "CCODAGE", "CCODAGE + CCODFAM + CREFART" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente  : " + Rtrim( ::oDbf:cCodAge ) + "-" + oRetFld( ::oDbf:cCodAge, ::oDbfAge ) }, {||"Total agente..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodFam }, {|| "Fam�lia : " + Rtrim( ::oDbf:cCodFam ) + "-" + Rtrim( ::oDbf:cDesFam ) }, {||"Total fam�lia..."} )


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE


   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oDbfTvta ) .and. ::oDbfTvta:Used()
      ::oDbfTvta:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oDbfTvta := nil
   ::oDbfCli  := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local oTipVen
   local oTipVen2
   local cEstado     := "Todas"
   local This        := Self

   if !::StdResource( "INF_GEN17C" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefFamInf( 110, 120, 130, 140, 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   REDEFINE CHECKBOX ::lTvta ;
      ID       260 ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   REDEFINE GET oTipVen VAR ::cTipVen ;
      VALID    ( cTVta( oTipVen, This:oDbfTvta:cAlias, oTipVen2 ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwTVta( oTipVen, This:oDbfTVta:cAlias, oTipVen2 ) ) ;
      ID       270 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen2 VAR ::cTipVen2 ;
      ID       280 ;
      WHEN     ( .F. ) ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""
   local bTipVen  := {|| if( !Empty( ::cTipVen ), ::oFacCliL:cTipMov == ::cTipVen, .t. ) }
   local lExcCero := .f.

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {{||"Fecha   : "   + Dtoc( Date() ) },;
                     {|| "Periodo : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                     {|| if ( ::lTvta,( if (!Empty( ::cTipVen ), "Tipo de venta: " + ::cTipVen2, "Tipo de venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }


   /*
   Facturas
    */
   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )                                                                  .AND.;
         ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

         while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND.;
               ! ::oFacCliL:eof()

            if !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL:cAlias ) == 0 ) .and.;
               !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

               /*
               Preguntamos y tratamos el tipo de venta
               */

               if ::lTvta

                  if ( !Empty( ::cTipVen ) .and. ::oFacCliL:cTipMov == ::cTipVen )            .OR.;
                     Empty( ::cTipVen )

                     if ::oDbf:Seek( ::oFacCliT:cCodAge + ::oFacCliL:cCodFam + ::oFacCliL:cRef )

                         ::oDbf:Load()
                         ::AddTipVta( ::oFacCli:cTipMov )
                         ::oDbf:Save()

                     else

                         ::oDbf:Append()

                         ::oDbf:cCodFam := ::oFacCliL:cCodFam
                         ::oDbf:cDesFam := RetFamilia( ::oFacCliL:cCodFam, ::oDbfFam:cAlias )
                         ::oDbf:cCodAge := ::oFacCliT:cCodAge
                         ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
                         ::oDbf:CDOCMOV := ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:nNumFac ) + "/" + ::oFacCliT:cSufFac
                         ::oDbf:CREFART := ::oFacCliL:CREF
                         ::oDbf:CDESART := ::oFacCliL:cDetalle
                         ::oDbf:cCodPr1 := ::oFacCliL:cCodPr1
                         ::oDbf:cNomPr1 := retProp( ::oFacCliL:cCodPr1 )
                         ::oDbf:cCodPr2 := ::oFacCliL:cCodPr2
                         ::oDbf:cNomPr2 := retProp( ::oFacCliL:cCodPr2 )
                         ::oDbf:cValPr1 := ::oFacRecL:cValPr1
                         ::oDbf:cNomVl1 := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
                         ::oDbf:cValPr2 := ::oFacCliL:cValPr2
                         ::oDbf:cNomVl2 := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )

                         if ::oDbfAge:Seek( ::oFacCliT:cCodAge )
                            ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                         end if

                         ::AddTipVta( ::oFacCliL:cTipMov )

                         ::oDbf:Save()

                     end if

                  end if

               /*
               Pasamos de los tipos de ventas
               */

               else

                  if ::oDbf:Seek( ::oFacCliT:cCodAge + ::oFacCliL:cCodFam + ::oFacCliL:cRef )

                     ::oDbf:Load()

                     ::oDbf:NUNDCAJ += ::oFacCliL:NCANENT
                     ::oDbf:NUNDART += ::oFacCliL:NUNICAJA
                     ::oDbf:NCAJUND += nTotNFacCli( ::oFacCliL )
                     ::oDbf:nBasCom += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                     ::oDbf:nPreMed := ::oDbf:nBasCom / ::oDbf:nCajUnd
                     ::oDbf:nTotCom += nComLFacCli( ::oFacRecT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodFam := ::oFacCliL:cCodFam
                     ::oDbf:cDesFam := RetFamilia( ::oFacCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodAge := ::oFacCliT:cCodAge
                     ::oDbf:CDOCMOV := ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:nNumFac ) + "/" + ::oFacCliT:cSufFac
                     ::oDbf:CREFART := ::oFacCliL:cRef
                     ::oDbf:CDESART := ::oFacCliL:cDetalle
                     ::oDbf:cCodPr1 := ::oFacCliL:cCodPr1
                     ::oDbf:cNomPr1 := retProp( ::oFacCliL:cCodPr1 )
                     ::oDbf:cCodPr2 := ::oFacCliL:cCodPr2
                     ::oDbf:cNomPr2 := retProp( ::oFacCliL:cCodPr2 )
                     ::oDbf:cValPr1 := ::oFacCliL:cValPr1
                     ::oDbf:cNomVl1 := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
                     ::oDbf:cValPr2 := ::oFacCliL:cValPr2
                     ::oDbf:cNomVl2 := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )

                     if ::oDbfAge:Seek( ::oFacCliT:cCodAge )
                     ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                     end if

                     ::oDbf:NUNDCAJ := ::oFacCliL:NCANENT
                     ::oDbf:NUNDART := ::oFacCliL:NUNICAJA
                     ::oDbf:NCAJUND := nTotNFacCli( ::oFacCliL )
                     ::oDbf:nBasCom := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                     ::oDbf:nTotCom := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreMed := ::oDbf:nBasCom / ::oDbf:nCajUnd

                     ::oDbf:Save()

                  end if

               end if

            end if

            ::oFacCliL:Skip()

         end while

      end if

      ::oFacCliT:Skip()
      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacCliT:LastRec() )

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AddTipVta( cTipMov )

   if ::oDbfTvta:Seek( cTipMov )

      ::oDbf:cTipVen    := ::oDbfTvta:cDesMov

      if ::oDbfTvta:nUndMov == 1
         ::oDbf:NUNDCAJ += ::oFacRecL:NCANENT
         ::oDbf:NCAJUND += NotCaja( ::oFacRecL:NCANENT )* ::oFacRecL:NUNICAJA
         ::oDbf:NUNDART += ::oFacRecL:NUNICAJA
      elseif ::oDbfTvta:nUndMov == 2
         ::oDbf:NUNDCAJ += ::oFacRecL:NCANENT * -1
         ::oDbf:NCAJUND += NotCaja( ::oFacRecL:NCANENT ) * ::oFacRecL:NUNICAJA * -1
         ::oDbf:NUNDART += ::oFacRecL:NUNICAJA * -1
      end if

      if ::oDbfTvta:nImpMov == 1
         ::oDbf:nBasCom += nImpLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
         ::oDbf:nTotCom += nComLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      elseif ::oDbfTvta:nImpMov == 2
         ::oDbf:nBasCom -= nImpLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
         ::oDbf:nTotCom -= nComLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      end if

   end if

RETURN nil

//---------------------------------------------------------------------------//