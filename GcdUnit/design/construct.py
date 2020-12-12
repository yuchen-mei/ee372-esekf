#! /usr/bin/env python
#=========================================================================
# construct.py
#=========================================================================
# Demo with 16-bit GcdUnit
#
# Author : Priyanka Raina
# Date   : December 4, 2020
#

import os
import sys

from mflowgen.components import Graph, Step

def construct():

  g = Graph()

  #-----------------------------------------------------------------------
  # Parameters
  #-----------------------------------------------------------------------
  
  adk_name = 'skywater-130nm-adk'
  #adk_name = 'freepdk-45nm'
  adk_view = 'view-standard'

  parameters = {
    'construct_path' : __file__,
    'design_name'    : 'GcdUnit',
    'clock_period'   : 25.0,
    'adk'            : adk_name,
    'adk_view'       : adk_view,
    'topographical'  : True,
    'testbench_name' : 'GcdUnitTb',
    'strip_path'     : 'GcdUnitTb/GcdUnit_inst',
    'saif_instance'  : 'GcdUnitTb/GcdUnit_inst'
  }

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK step

  g.set_adk( adk_name )
  adk = g.get_adk_step()

  # Custom steps

  rtl           = Step( this_dir + '/rtl'           )
  constraints   = Step( this_dir + '/constraints'   )
  testbench     = Step( this_dir + '/testbench'     )
  vcs_sim       = Step( this_dir + '/synopsys-vcs-sim')
  rtl_sim       = vcs_sim.clone()
  gl_sim        = vcs_sim.clone()
  rtl_sim.set_name( 'rtl-sim' )
  gl_sim.set_name( 'gl-sim' )

  pt_power_rtl  = Step( this_dir + '/synopsys-ptpx-rtl')
  magic_drc     = Step( this_dir + '/magic-drc')

  # TODO: Use default instead
  iflow        = Step( this_dir + '/cadence-innovus-flowsetup')
  power        = Step( this_dir + '/cadence-innovus-power')
  gdsmerge     = Step( this_dir + '/mentor-calibre-gdsmerge')
 
  # Default steps

  info         = Step( 'info',                          default=True )
  dc           = Step( 'synopsys-dc-synthesis',         default=True )
  #iflow        = Step( 'cadence-innovus-flowsetup',     default=True )
  init         = Step( 'cadence-innovus-init',          default=True )
  #power        = Step( 'cadence-innovus-power',         default=True )
  place        = Step( 'cadence-innovus-place',         default=True )
  cts          = Step( 'cadence-innovus-cts',           default=True )
  postcts_hold = Step( 'cadence-innovus-postcts_hold',  default=True )
  route        = Step( 'cadence-innovus-route',         default=True )
  postroute    = Step( 'cadence-innovus-postroute',     default=True )
  signoff      = Step( 'cadence-innovus-signoff',       default=True )
  genlibdb     = Step( 'synopsys-ptpx-genlibdb',        default=True )
  #gdsmerge     = Step( 'mentor-calibre-gdsmerge',       default=True )
  pt_timing    = Step( 'synopsys-pt-timing-signoff',    default=True )
  drc          = Step( 'mentor-calibre-drc',            default=True )
  lvs          = Step( 'mentor-calibre-lvs',            default=True )
  gen_saif     = Step( 'synopsys-vcd2saif-convert',     default=True )
  gen_saif_rtl = gen_saif.clone()
  gen_saif_gl  = gen_saif.clone()
  gen_saif_rtl.set_name( 'gen-saif-rtl' )
  gen_saif_gl.set_name( 'gen-saif-gl' )
  #pt_power_rtl = Step( 'synopsys-ptpx-rtl',             default=True ) 
  pt_power_gl  = Step( 'synopsys-ptpx-gl',              default=True )
  
  # To open DRC and LVS results in calibre viewer do:
  # make debug-[DRC_STEP] or make debug-[LVS_STEP]

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info         )
  g.add_step( rtl          )
  g.add_step( testbench    )
  g.add_step( rtl_sim      )
  g.add_step( constraints  )
  g.add_step( dc           )
  g.add_step( iflow        )
  g.add_step( init         )
  g.add_step( power        )
  g.add_step( place        )
  g.add_step( cts          )
  g.add_step( postcts_hold )
  g.add_step( route        )
  g.add_step( postroute    )
  g.add_step( signoff      )
  g.add_step( genlibdb     )
  g.add_step( gdsmerge     )
  g.add_step( drc          )
  g.add_step( lvs          )
  g.add_step( pt_timing    )
  g.add_step( gen_saif_rtl )
  g.add_step( pt_power_rtl )
  g.add_step( gl_sim       )
  g.add_step( gen_saif_gl  )
  g.add_step( pt_power_gl  )
  g.add_step( magic_drc    )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------
  
  # Dynamically add edges

  rtl_sim.extend_inputs(['design.v'])
  rtl_sim.extend_inputs(['test_vectors.txt'])
  gl_sim.extend_inputs(['test_vectors.txt'])

  # Connect by name

  g.connect_by_name( adk,          dc           )
  g.connect_by_name( adk,          iflow        )
  g.connect_by_name( adk,          init         )
  g.connect_by_name( adk,          power        )
  g.connect_by_name( adk,          place        )
  g.connect_by_name( adk,          cts          )
  g.connect_by_name( adk,          postcts_hold )
  g.connect_by_name( adk,          route        )
  g.connect_by_name( adk,          postroute    )
  g.connect_by_name( adk,          signoff      )
  g.connect_by_name( adk,          genlibdb     )
  g.connect_by_name( adk,          gdsmerge     )
  g.connect_by_name( adk,          drc          )
  g.connect_by_name( adk,          magic_drc    )
  g.connect_by_name( adk,          lvs          )
  g.connect_by_name( adk,          pt_timing    )
  g.connect_by_name( adk,          pt_power_rtl )
  g.connect_by_name( adk,          pt_power_gl  )

  g.connect_by_name( rtl,          rtl_sim      ) # design.v
  g.connect_by_name( testbench,    rtl_sim      ) # testbench.sv
  g.connect_by_name( rtl_sim,      gen_saif_rtl ) # run.vcd

  g.connect_by_name( rtl,          dc           )
  g.connect_by_name( constraints,  dc           )
  g.connect_by_name( gen_saif_rtl, dc           ) # run.saif
  
  g.connect_by_name( dc,           iflow        )
  g.connect_by_name( dc,           init         )
  g.connect_by_name( dc,           power        )
  g.connect_by_name( dc,           place        )
  g.connect_by_name( dc,           cts          )
  g.connect_by_name( dc,           pt_power_rtl ) # design.namemap

  g.connect_by_name( iflow,        init         )
  g.connect_by_name( iflow,        power        )
  g.connect_by_name( iflow,        place        )
  g.connect_by_name( iflow,        cts          )
  g.connect_by_name( iflow,        postcts_hold )
  g.connect_by_name( iflow,        route        )
  g.connect_by_name( iflow,        postroute    )
  g.connect_by_name( iflow,        signoff      )
  
  g.connect_by_name( init,         power        )
  g.connect_by_name( power,        place        )
  g.connect_by_name( place,        cts          )
  g.connect_by_name( cts,          postcts_hold )
  g.connect_by_name( postcts_hold, route        )
  g.connect_by_name( route,        postroute    )
  g.connect_by_name( postroute,    signoff      )
  g.connect_by_name( signoff,      genlibdb     )
  g.connect_by_name( signoff,      gdsmerge     )
  g.connect_by_name( signoff,      drc          )
  g.connect_by_name( gdsmerge,     drc          )
  g.connect_by_name( gdsmerge,     magic_drc    )
  g.connect_by_name( signoff,      lvs          )
  g.connect_by_name( gdsmerge,     lvs          )
  g.connect_by_name( signoff,      pt_timing    )
  g.connect_by_name( signoff,      pt_power_rtl )
  g.connect_by_name( gen_saif_rtl, pt_power_rtl ) # run.saif
  g.connect_by_name( signoff,      pt_power_gl  )
  g.connect_by_name( gen_saif_gl,  pt_power_gl  ) # run.saif

  g.connect_by_name( adk,          gl_sim       )
  g.connect( signoff.o( 'design.vcs.v' ), gl_sim.i( 'design.vcs.v' ) )
  #g.connect_by_name( signoff,      gl_sim       ) # design.vcs.v
  g.connect( pt_timing.o( 'design.sdf' ), gl_sim.i( 'design.sdf' ) )
  #g.connect_by_name( pt_timing,    gl_sim       ) # design.sdf
  g.connect_by_name( testbench,    gl_sim       ) # testbench.sv
  g.connect_by_name( gl_sim,       gen_saif_gl  ) # run.vcd
 
  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g

if __name__ == '__main__':
  g = construct()
  g.plot()
