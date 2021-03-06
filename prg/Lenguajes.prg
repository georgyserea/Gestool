#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TLenguaje FROM TMant

   DATA cMru                  INIT "user1_message_16"

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave()

END CLASS

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "LENGUAJE.DBF" CLASS "LENGUAJE" PATH ( cPath ) VIA ( cDriver ) COMMENT "Lenguajes"

      FIELD NAME "cCodLen"    TYPE "C" LEN   4  DEC 0  COMMENT "C�digo"  DEFAULT Space( 4 )     COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomLen"    TYPE "C" LEN  50  DEC 0  COMMENT "Nombre"  DEFAULT Space( 200 )   COLSIZE 200 OF ::oDbf

      INDEX TO "LENGUAJE.CDX" TAG "CCODLEN" ON "CCODLEN" COMMENT "C�digo" NODELETED OF ::oDbf
      INDEX TO "LENGUAJE.CDX" TAG "CNOMLEN" ON "CNOMLEN" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) 

   local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Lenguajes" TITLE LblTitle( nMode ) + "lenguajes"

      REDEFINE GET oGet VAR ::oDbf:cCodLen UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNomLen UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         ACTION   (  ::lPreSave( oGet, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oDlg, nMode ) } )
   end if

   oDlg:bStart    := {|| oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( oGet, oDlg, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodLen, "cCodLen" )
         MsgStop( "C�digo ya existe " + Rtrim( ::oDbf:cCodLen ) )
         oGet:GetFocus()
         return .f.
      end if

   end if

   if Empty( ::oDbf:cNomLen )
      MsgStop( "La descripci�n del lenguaje no puede estar vac�a." )
      Return .f.
   end if

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//