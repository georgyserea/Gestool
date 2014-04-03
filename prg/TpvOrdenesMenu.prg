#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TpvOrdenesMenu FROM TDet

   DATA oBrwArticulosOrden

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD lPreSave()

   METHOD PreSaveDetails()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "TpvOrdMnu"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "ordenes menu"

      FIELD NAME "cCodMnu" TYPE "C" LEN 03  DEC 0 COMMENT "C�digo menu"                    OF oDbf
      FIELD NAME "cCodOrd" TYPE "C" LEN 02  DEC 0 COMMENT "C�digo orden"                   OF oDbf

      INDEX TO ( cFileName ) TAG "cCodMnu" ON "cCodMnu"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodOrd" ON "cCodOrd"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cMnuOrd" ON "cCodMnu + cCodOrd"                NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen             := .t.
   local oError
   local oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive     := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::bOnPreSaveDetail   := {|| ::PreSaveDetails() }

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf            := nil
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD Resource()

   local oDlg
   local oGetOrd

   // Caja de dialogo-------------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "OrdenComanda"

      REDEFINE GET   oGetOrd ;
         VAR         ::oDbfVir:cCodOrd ;
         BITMAP      "Lupa" ;
         ID          100 ;
         IDTEXT      101 ;
         OF          oDlg

      oGetOrd:bWhen     := {|| ::nMode == APPD_MODE }
      oGetOrd:bValid    := {|| ::oParent:oOrdenComandas:Existe( oGetOrd, oGetOrd:oHelpText ) }
      oGetOrd:bHelp     := {|| ::oParent:oOrdenComandas:Buscar( oGetOrd ) }

      // Browse de odenes de comanda------------------------------------------

      ::oBrwArticulosOrden                := IXBrowse():New( oDlg )

      ::oBrwArticulosOrden:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwArticulosOrden:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oParent:oDetArticuloMenu:oDbfVir:SetBrowse( ::oBrwArticulosOrden ) 

      ::oBrwArticulosOrden:nMarqueeStyle  := 6
      ::oBrwArticulosOrden:cName          := "Lineas de menus de articulos"
      ::oBrwArticulosOrden:lFooter        := .f.

      ::oBrwArticulosOrden:CreateFromResource( 400 )

      with object ( ::oBrwArticulosOrden:AddCol() )
         :cHeader          := "C�digo"
         :bStrData         := {|| ::oParent:oDetArticuloMenu:oDbfVir:cCodArt }
         :nWidth           := 100
      end with

      with object ( ::oBrwArticulosOrden:AddCol() )
         :cHeader          := "Art�culo"
         :bStrData         := {|| retArticulo( ::oParent:oDetArticuloMenu:oDbfVir:cCodArt, ::oParent:oDbfArticulo:cAlias ) }
         :nWidth           := 240
      end with

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         ACTION   ( ::oParent:oDetArticuloMenu:Append( ::oBrwArticulosOrden ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         ACTION   ( ::oParent:oDetArticuloMenu:Del( ::oBrwArticulosOrden ) )

      // Botones------------------------------------------------------------------

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if ::nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oDlg ) } )
      end if

      oDlg:bStart    := {|| if( ::nMode != APPD_MODE, oGetOrd:lValid(), ) }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave( oDlg )

   if Empty( ::oDbfVir:cCodOrd )
      MsgStop( "C�digo del orden no puede estar vacio" )
      Return ( .f. )
   end if
  
   msgAlert( ::oDbfVir:cCodOrd, "::oDbfVir:cCodOrd" )

   while !::oParent:oDetArticuloMenu:oDbfVir:eof()
      ::oParent:oDetArticuloMenu:oDbfVir:cCodOrd   := ::oDbfVir:cCodOrd
      ::oParent:oDetArticuloMenu:oDbfVir:skip()
   end while

RETURN ( oDlg:End( IDOK ) )

//----------------------------------------------------------------------------//

METHOD PreSaveDetails()

   ::oDbfVir:cCodMnu                               := ::oParent:oDbf:cCodMnu

RETURN ( Self )

//--------------------------------------------------------------------------//

