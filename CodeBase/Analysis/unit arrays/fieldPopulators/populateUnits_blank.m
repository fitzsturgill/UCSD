function unitArray = populateUnits_blank(unitArray)

unitArray = unitArray_forEachUnit(unitArray, @populateUnit_blank,1);