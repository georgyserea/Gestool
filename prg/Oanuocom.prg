#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OAnuOCom FROM TPrvPgo

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AnuPgoFields()

   ::AddTmpIndex( "cCodPgo", "cCodPgo" )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacPrvP := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFANUPGOB" )
      return .f.
   end if

   ::CreateFilter( aItmCompras(), { ::oAlbPrvT, ::oFacPrvT }, .t. )

   /*
   Monta los a�os
   */

   ::oDefYea()

   /*
   Monta formas de pago
   */

   if !::oDefFpgInf( 70, 80, 90, 100, 920 )
      return .f.
   end if

   ::oDefExcInf()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""
   local aTot     := {}

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "A�o     : " + AllTrim( Str( ::nYeaInf ) ) },;
                     {|| "F. pago : " + if( ::lAllFpg, "Todos", AllTrim( ::cFpgDes ) + " > " + AllTrim( ::cFpgHas ) ) } }

   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )

   cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllFpg
      cExpHead       += ' .and. cCodPgo >= "' + ::cFpgDes + '" .and. cCodPgo <= "' + ::cFpgHas + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof()

      if Year( ::oAlbPrvT:dFecAlb ) == ::nYeaInf                                                      .AND.;
         lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

            while ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb .AND. ! ::oAlbPrvL:eof()

               if !( ::lExcCero .AND. nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oAlbPrvT:cCodPgo )
                     ::oDbf:Blank()
                     ::oDbf:cCodPgo := ::oFacPrvT:cCodPago
                     ::oDbf:cNomPgo := cNbrFPago( ::oFacPrvT:cCodPago, ::oDbfFpg )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oAlbPrvT:dFecAlb, nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oAlbPrvL:Skip()

            end while

         end if

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   ::oAlbPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ) )

   /*Facturas*/

   ::oFacPrvT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllFpg
      cExpHead       += ' .and. cCodPago >= "' + ::cFpgDes + '" .and. cCodPago <= "' + ::cFpgHas + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   ::oFacPrvT:GoTop()

   while !::oFacPrvT:Eof()

      if Year( ::oFacPrvT:dFecFac ) == ::nYeaInf                                                        .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvT:lFacGas

            aTot              := aTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

            if !::oDbf:Seek( ::oFacPrvT:cCodPago )
               ::oDbf:Blank()
               ::oDbf:cCodPgo := ::oFacPrvT:cCodPago
               ::oDbf:cNomPgo := cNbrFPago( ::oFacPrvT:cCodPago, ::oDbfFpg )
               ::oDbf:Insert()
            end if

            ::AddImporte( ::oFacPrvT:dFecFac, aTot[1] )

         else

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

                  if !( ::lExcCero .AND. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                     if !::oDbf:Seek( ::oFacPrvT:cCodPago )
                        ::oDbf:Blank()
                        ::oDbf:cCodPgo := ::oFacPrvT:cCodPago
                        ::oDbf:cNomPgo := cNbrFPago( ::oFacPrvT:cCodPago, ::oDbfFpg )
                        ::oDbf:Insert()
                     end if

                     ::AddImporte( ::oFacPrvT:dFecFac, nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  end if

                  ::oFacPrvL:Skip()

               end while

            end if

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//