//BEGIN Cylinder.cpp
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//See sedan.h for more information
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include "Cylinder.h"

// Constructor
Cylinder::Cylinder(sc_module_name nm)
: sc_module(nm)
{
  cout << "INFO: Constructing instance " << name() << endl;
  SC_THREAD(Cylinder_thread);
}//end Cylinder constructor

void Cylinder::Cylinder_thread(void) {
  cout << "INFO: Ran Cylinder_thread inside instance " << name() << endl;
}//end Cylinder_thread()

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//END $Id: Cylinder.cpp,v 1.4 2004/03/04 21:04:07 dcblack Exp $
