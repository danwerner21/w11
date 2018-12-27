// $Id: RlinkCrc16.ipp 1091 2018-12-23 12:38:29Z mueller $
//
// Copyright 2014-2018 by Walter F.J. Mueller <W.F.J.Mueller@gsi.de>
//
// This program is free software; you may redistribute and/or modify it under
// the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY, without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for complete details.
// 
// Revision History: 
// Date         Rev Version  Comment
// 2018-12-22  1091   1.0.2  Drop empty dtors for pod-only classes
// 2018-12-18  1089   1.0.1  use c++ style casts
// 2014-11-08   602   1.0    Initial version
// ---------------------------------------------------------------------------

/*!
  \file
  \brief   Implemenation (inline) of class RlinkCrc16.
*/

// all method definitions in namespace Retro
namespace Retro {

//------------------------------------------+-----------------------------------
//! Default constructor

inline RlinkCrc16::RlinkCrc16()
  : fCrc(0)
{}

//------------------------------------------+-----------------------------------
//! FIXME_docs

inline void RlinkCrc16::Clear()
{
  fCrc = 0;
  return;
}

//------------------------------------------+-----------------------------------
//! FIXME_docs

inline void RlinkCrc16::AddData(uint8_t data)
{
  uint8_t tmp = uint8_t(fCrc>>8) ^ data;
  fCrc = (fCrc<<8) ^ fCrc16Table[tmp];
  return;
}

//------------------------------------------+-----------------------------------
//! FIXME_docs

inline uint16_t RlinkCrc16::Crc() const
{
  return fCrc;
}

} // end namespace Retro
