#include "FiveWin.ch"
#include "Factu.ch" 

static oWndBrowser
static cEvents             := ""

//-------------------------------------------------------------//

Function OpenWebBrowser( oWndMain )

   local cFile
   local oActiveX

   DEFAULT oWndMain        := oWnd()

   if ( "TERMINAL" $ cParamsMain() ) // .or. !IsInternet() )

      cFile                := FullCurDir() + "web\index.html" 

      if !File( cFile )
         Return nil
      end if

   else

      cFile                := __GSTBROWSER__

   end if

   if !Empty( oWndMain ) .and. isInternet()

      oWndBrowser          := TWindow():New( -28, -6, GetSysMetrics( 1 ) - 208, GetSysMetrics( 0 ) + 10, "", , , , , , .f., .f., , , , , .f., .f., .f., .f., .t. )

      oActiveX             := TActiveX():New( oWndBrowser, "Shell.Explorer" )
      oActiveX:bOnEvent    := { | event, aParams, pParams | EventInfo( event, aParams, pParams, oActiveX ) }

      oWndBrowser:oClient  := oActiveX // To fill the entire window surface

      oActiveX:Do( "Navigate", cFile )

      SetParent( oWndBrowser:hWnd, oWndMain:oWndClient:hWnd )

      oWndBrowser:Activate( , , , , , , , , , , , , , , , , {|| .f. } )

      oWndMain:SetFocus()

   end if

return nil

//-------------------------------------------------------------//

Function EventInfo( event, aParams, pParams, oActiveX )

   local cParam
   local uParam
   local cCommand

   for each uParam in aParams

      if cValToChar( event ) == 'BeforeNavigate2'

         cParam      := cValToChar( uParam )

         if ( "index.html" $ cParam .and. "#" $ cParam )

            cCommand := SubStr( cParam, At( "#", cParam ) + 1 )

            if !Empty( cCommand )
               bChar2Block( cCommand )
            end if

         end if

      end if

   next

Return ( nil )

//-------------------------------------------------------------//

Function CloseWebBrowser( oWnd )

   local oBlock
   local oError

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DEFAULT oWnd            := oWnd()

   if !Empty( oWnd ) .and. !Empty( oWndBrowser )

      oWndBrowser:bValid   := {|| .t. }

      if !Empty( oWnd:oWndClient )
         oWnd:oWndClient:End()
         oWnd:oWndClient   := nil
      end if

   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

Return nil

//-------------------------------------------------------------//
/*
function EventInfo( event, aParams, pParams, oActiveX )

   local n
   local cMsg  := "Event: " + cValToChar( event ) + CRLF

   cMsg        += "Params: " + CRLF

   for n = 1 to Len( aParams )
      cMsg     += cValToChar( aParams[ n ] ) + CRLF
   next

return cMsg + CRLF
*/
//-------------------------------------------------------------//