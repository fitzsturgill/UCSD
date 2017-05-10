function unitArray = populateUnits_responseMat(unitArray)

unitArray = unitArray_forEachUnit(unitArray, @populateUnit_responseMat,1);