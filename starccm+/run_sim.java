// STAR-CCM+ macro: run_sim.java
// Written by STAR-CCM+ 18.02.008
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.vis.*;

public class run_sim extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();
	  
    simulation_0.getSimulationIterator().run();

  }
}
