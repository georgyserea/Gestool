/******************************************************************************
Script2 creado a Pepsi Inma, para crear y mandar el informe que necesita
******************************************************************************/

#include ".\Include\Factu.ch"
#define CRLF chr( 13 ) + chr( 10 )

static dbfArticulo
static dbfClient
static dbfFacCliT
static dbfFacCliL
static dbfDiv
static dbfKit
static dbfIva
static lOpenFiles       := .f.

static dFecOrg
static dFecDes
static cCliOrg
static cCliDes          
static cConcesionario
static cGetDir
static cFamilia
static cPicture

//---------------------------------------------------------------------------//

function InicioHRB()

   /*
   Abrimos los ficheros necesarios---------------------------------------------
   */

   if !OpenFiles( .f. )
      return .f.
   end if

   /*
   Damos valores por defacto a las variables-----------------------------------
   */

   dFecOrg        := cTod( "01/04/2016" )
   dFecDes        := cTod( "30/04/2016" )
   cCliOrg        := dbFirst( dbfClient )
   cCliDes        := dbLast( dbfClient )
   cConcesionario := "607333"
   cGetDir        := "c:\ficheros\"
   cFamilia       := Padr( "1", 16 )
   cPicture       := "@E 999999.999"

   CursorWait()

   /*
   Importamos los datos necesarios---------------------------------------------
   */
   
   Exportacion()

   CursorWe()

   /*
   Cerramos los ficheros abiertos anteriormente--------------------------------
   */

   CloseFiles()

return .t.

//---------------------------------------------------------------------------//

static function OpenFiles()

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros' )
      Return ( .f. )
   end if

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles  := .t.

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIT.DBF" )  NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" )  ADDITIVE

      USE ( cPatEmp() + "FACCLIL.DBF" )  NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" )  ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   RECOVER USING oError

      lOpenFiles           := .f.

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

   CursorWE()

return ( lOpenFiles )

//--------------------------------------------------------------------------//

static function CloseFiles()

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if dbfClient != nil
      ( dbfClient )->( dbCloseArea() )
   end if

   if dbfFacCliT != nil
      ( dbfFacCliT )->( dbCloseArea() )
   end if

   if dbfFacCliL != nil
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if

   if dbfKit != nil
      ( dbfKit )->( dbCloseArea() )
   end if

   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if

   dbfArticulo    := nil
   dbfClient      := nil
   dbfFacCliT     := nil
   dbfFacCliL     := nil
   dbfDiv         := nil
   dbfKit         := nil
   dbfIva         := nil

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function Exportacion()

   local n
   local nRec           := ( dbfFacCliT )->( Recno() )
   local nOrdAnt        := ( dbfFacCliT )->( OrdSetFocus( "dFecFac" ) )
   local nRecL          := ( dbfFacCliL )->( Recno() )
   local nOrdAntL       := ( dbfFacCliL )->( OrdSetFocus( "nNumFac" ) )
   local cTextoFinal    := ""
   local cTextoCliente  := ""
   local oMeter
   local nHand
   local cNameFile
   local aClientes      := {}
   local nImporte       := 0
   local nPromo         := 0
   local aArticulo      := {}
   local nTotUniVen     := 0
   local nTotUniReg     := 0
   local nImpReg        := 0
   local nImpDto        := 0
   local aLinea         := {}

   CursorWait()

   oMeter               := TWaitMeter():New( , , ( dbfFacCliT )->( LastRec() ) )

   /*
   Vamos la primera vuelta para los clientes-----------------------------------
   */

   while !( dbfFacCliT )->( Eof() )

      if ( ( dbfFacCliT )->dFecFac >= dFecOrg .and.;
         ( dbfFacCliT )->dFecFac <= dFecDes ) .and.;
         ( ( dbfFacCliT )->cCodCli >= cCliOrg .and.;
         ( dbfFacCliT )->cCodCli <= cCliDes )

         if ( dbfFacCliL )->( dbSeek( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )

            while ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac == ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac .and.;
                  !( dbfFacCliL )->( Eof() )

                  if ( dbfFacCliL )->cCodFam == cFamilia

                     if aScan( aClientes, ( dbfFacCliT )->cCodCli ) == 0

                        cTextoCliente  += cConcesionario
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cCodCli )
                        cTextoCliente  += ";"
                        
                        if ( dbfClient )->( dbSeek( ( dbfFacCliT )->cCodCli ) )

                           if !Empty( ( dbfClient )->NbrEst )

                              cTextoCliente  += AllTrim( ( dbfClient )->NbrEst )

                           else

                              cTextoCliente  += AllTrim( ( dbfFacCliT )->cNomCli )

                           end if

                        else

                           cTextoCliente  += AllTrim( ( dbfFacCliT )->cNomCli )

                        end if

                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cDirCli )
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cPosCli )
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cPobCli )
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cDniCli )
                        cTextoCliente  += CRLF

                        aAdd( aClientes, ( dbfFacCliT )->cCodCli )

                     end if
                         
                  end if   

               ( dbfFacCliL )->( dbSkip() )

            end while

         end if

      end if

      ( dbfFacCliT )->( dbSkip() )
      
      oMeter:oProgress:AutoInc()

   end while

   /*
   Damos una segunda vuelta para los artículos---------------------------------
   */

   ( dbfFacCliT )->( dbGoTop() )

   while !( dbfFacCliT )->( Eof() )

      if ( ( dbfFacCliT )->dFecFac >= dFecOrg .and.;
         ( dbfFacCliT )->dFecFac <= dFecDes ) .and.;
         ( ( dbfFacCliT )->cCodCli >= cCliOrg .and.;
         ( dbfFacCliT )->cCodCli <= cCliDes )

         if ( dbfFacCliL )->( dbSeek( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )

            while ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac == ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac .and.;
                  !( dbfFacCliL )->( Eof() )

                  if ( dbfFacCliL )->cCodFam == cFamilia

                     if ( dbfFacCliL )->nPreUnit != 0

                        nTotUniVen        := ( dbfFacCliL )->nUniCaja
                        nTotUniReg        := 0
                        nImpReg           := 0
                        if ( dbfFacCliL )->nDto != 0
                           nImpDto        := ( dbfFacCliL )->nUniCaja * ( ( dbfFacCliL )->nPreUnit * ( dbfFacCliL )->nDto ) / 100
                        else 
                           nImpDto        := 0 
                        end if

                     else

                        nTotUniVen        := ( dbfFacCliL )->nUniCaja
                        nTotUniReg        := ( dbfFacCliL )->nUniCaja
                        if ( dbfArticulo )->( dbSeek( ( dbfFacCliL )->cRef ) )
                           nImpReg        := ( dbfFacCliL )->nUniCaja * nRetPreArt( ( dbfFacCliL )->nTarLin, ( dbfFacCliT )->cDivFac, ( dbfFacCliT )->lIvaInc, dbfArticulo, dbfDiv, dbfKit, dbfIva )
                        end if
                        nImpDto           := 0

                     end if

                     if Len( aArticulo ) == 0

                        aAdd( aArticulo, { ( dbfFacCliL )->cRef, nTotUniVen, nTotUniReg, nImpReg, nImpDto } )

                     else
                     
                        n     := aScan( aArticulo, {|x| x[1] == ( dbfFacCliL )->cRef } )

                        if n == 0



                           aAdd( aArticulo, { ( dbfFacCliL )->cRef, nTotUniVen, nTotUniReg, nImpReg, nImpDto } )

                        else

                           aArticulo[n, 2]   += nTotUniVen
                           aArticulo[n, 3]   += nTotUniReg
                           aArticulo[n, 4]   += nImpReg
                           aArticulo[n, 5]   += nImpDto

                        end if

                     end if   
                         
                  end if

               ( dbfFacCliL )->( dbSkip() )

            end while

         end if

      end if

      /*
      Lo pasamos al fichero----------------------------------------------------
      */

      if Len( aArticulo ) != 0

         for each aLinea in aArticulo
       
            cTextoFinal       += Str( Year( ( dbfFacCliT )->dFecFac ) ) + "-" + PadL( month( ( dbfFacCliT )->dFecFac ), 2, "0" ) + "-" + PadL( Day( ( dbfFacCliT )->dFecFac ), 2, "0" )
            cTextoFinal       += ";"
            cTextoFinal       += cConcesionario
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( ( dbfFacCliT )->cCodCli )
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( aLinea[1] )
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Trans( aLinea[2], cPicture ) )
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Trans( aLinea[3], cPicture ) ) //Unidades promocion
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Trans( aLinea[4], cPicture ) ) //Importe promoción
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Trans( ( aLinea[5] + aLinea[4] ) , cPicture ) ) //Total Importe Promoción
            cTextoFinal       += CRLF

         next

      end if   

      ( dbfFacCliT )->( dbSkip() )

      nTotUniVen     := 0
      nTotUniReg     := 0
      nImpReg        := 0
      nImpDto        := 0
      aArticulo      := {}

      oMeter:oProgress:AutoInc()

   end while

   oMeter:End()

   ( dbfFacCliT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfFacCliL )->( OrdSetFocus( nOrdAntL ) )
   ( dbfFacCliL )->( dbGoTo( nRecL ) )
   ( dbfFacCliT )->( dbGoTo( nRec ) )

   if !Empty( cTextoFinal )

      cNameFile            :=  cGetDir + Right( cConcesionario, 5 ) + PadL( month( Date() ), 2, "0" ) + "A.csv"

      fErase( cNameFile )
      nHand       := fCreate( cNameFile )
      fWrite( nHand, cTextoFinal )
      fClose( nHand )

      MsgInfo( "Fichero consumos exportado correctamente en " + cGetDir )

   end if   

   if !Empty( cTextoCliente )

      cNameFile            :=  cGetDir + Right( cConcesionario, 5 ) + PadL( month( Date() ), 2, "0" ) + "C.csv"

      fErase( cNameFile )
      nHand       := fCreate( cNameFile )
      fWrite( nHand, cTextoCliente )
      fClose( nHand )

      MsgInfo( "Fichero clientes exportado correctamente en " + cGetDir )

   end if

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//