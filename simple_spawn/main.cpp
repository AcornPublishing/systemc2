//FILE: main.cpp (systemc)
//# vim600:set sw=2 tw=0 fdm=marker:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//See simple_spawn.h for more information
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include <iostream>
using std::cout;
using std::endl;

char* simulation_name = "simple_spawn";
char* simulation_vers = "$Header: /eklectICally/Project/ea/Cvsroot/Book2003/Examples/simple_spawn/main.cpp,v 1.2 2004/03/03 04:53:18 dcblack Exp $";
#ifdef SYSTEMC_V2_1
#include <systemc.h>
#include "simple_spawn.h"

unsigned errors = 0;

int sc_main(int argc, char* argv[]) {
  cout << "INFO: " << simulation_name << " " << simulation_vers << endl;
  cout << "INFO: Elaborating "<< simulation_name << endl;
  //sc_set_time_resolution(1,SC_PS);
  //sc_set_default_time_unit(1,SC_NS);
  simple_spawn simple_spawn_i("simple_spawn_i");
  cout << "INFO: Simulating "<< simulation_name << endl;
  sc_start();
  cout << "INFO: Post-processing "<< simulation_name << endl;
  cout << "INFO: Simulation " << simulation_name
       << " " << (errors?"FAILED":"PASSED")
       << " with " << errors << " errors"
       << endl;
  return errors?1:0;
}
#else
int sc_main(int argc, char* argv[]) {
  cout << "WARNING: This example requires SystemC version 2.1" << endl;
  cout << "INFO: Simulation " << simulation_name << " SKIPPED" << endl;
  return 0;
}
#endif

//Portions COPYRIGHT (C) 2003-2004 Eklectic Ally, Inc.-------------{{{//
// Permission granted for anybody to use this example provided this   //
// acknowledgement of Eklectic Ally, Inc. remains.                    //
//-----------------------------------------------------------------}}}//
//END $Id: main.cpp,v 1.2 2004/03/03 04:53:18 dcblack Exp $
