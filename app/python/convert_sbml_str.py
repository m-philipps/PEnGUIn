import libsbml
import tellurium

def convert_local_to_global(doc : libsbml.SBMLDocument) -> libsbml.SBMLDocument:
   """ Convert parameters in SBML file from local to global parameters"""
   props = libsbml.ConversionProperties()
   props.addOption("promoteLocalParameters", True, "Promotes all Local Parameters to Global ones")
   if doc.convert(props) != libsbml.LIBSBML_OPERATION_SUCCESS:
       # conversion failed!
       return None
   return doc

def convert_sbml_str(sbml): 
   doc = libsbml.readSBMLFromString(sbml)
   doc = convert_local_to_global(doc)
   return libsbml.writeSBMLToString(doc)

def convert_to_antimony(sbml_str):
   return tellurium.sbmlToAntimony(sbml_str)

def convert_to_sbml(sbml_str):
   return tellurium.antimonyToSBML(sbml_str)
