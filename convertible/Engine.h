#ifndef Engine_H
#define Engine_H
//BEGIN Engine.h
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//See convertible.h for more information
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include <systemc.h>

struct FuelMix;
struct Exhaust;
struct Cylinder;

SC_MODULE(Engine) {
  // Sub-module instances
  FuelMix* fuelmix_i;
  Exhaust* exhaust_i;
  Cylinder* cyl_i1;
  Cylinder* cyl_i2;
  // Constructor
  SC_HAS_PROCESS(Engine);
  Engine(sc_module_name nm);
  // Processes
  void Engine_thread(void);
};

#endif
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//END $Id: Engine.h,v 1.4 2004/04/15 17:38:04 dcblack Exp $
