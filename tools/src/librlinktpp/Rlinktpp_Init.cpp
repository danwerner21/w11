// $Id: Rlinktpp_Init.cpp 375 2011-04-02 07:56:47Z mueller $
//
// Copyright 2011- by Walter F.J. Mueller <W.F.J.Mueller@gsi.de>
//
// This program is free software; you may redistribute and/or modify it under
// the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 2, or at your option any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY, without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for complete details.
// 
// Revision History: 
// Date         Rev Version  Comment
// 2011-03-20   372   1.0.2  renamed ..tcl -> ..tpp
// 2011-03-19   371   1.0.1  moved Bvi into librtoolstcl
// 2011-02-11   360   0.1    First draft
// ---------------------------------------------------------------------------

/*!
  \file
  \version $Id: Rlinktpp_Init.cpp 375 2011-04-02 07:56:47Z mueller $
  \brief   Implemenation of Rlinktpp_Init .
*/

#include "tcl.h"

#include <stdexcept>

#include "librtcltools/RtclClassOwned.hpp"
#include "RtclRlinkConnect.hpp"

using namespace std;
using namespace Retro;

//------------------------------------------+-----------------------------------
extern "C" int Rlinktpp_Init(Tcl_Interp* interp) 
{
  int irc;

  // use stubs
  const char* vers = Tcl_InitStubs(interp, TCL_VERSION, 0);
  if (vers == NULL) return TCL_ERROR;
  
  // declare package name and version
  irc = Tcl_PkgProvide(interp, "rlinktpp", "1.0.0");
  if (irc != TCL_OK) return irc;

  try {
    // register class commands
    RtclClassOwned<RtclRlinkConnect>::CreateClass(interp, "rlinkconnect",
                                                  "RlinkConnect");
    return TCL_OK;

  } catch (exception& e) {
    Tcl_AppendResult(interp, "-E: exception caught in Rlinktpp_Init: \"", 
                     e.what(), "\"", NULL);
  }
  return TCL_ERROR;
}

