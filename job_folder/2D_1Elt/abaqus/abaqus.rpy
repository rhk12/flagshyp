# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2017 replay file
# Internal Version: 2016_09_27-17.54.59 126836
# Run by rhk12 on Mon Feb  4 11:48:19 2019
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=257.439575195312, 
    height=167.255249023438)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
openMdb(
    pathName='/storage/work/r/rhk12/classes/me563/sp19/flagshyp/job_folder/2D_1Elt/abaqus/2DPlaneStrain-v2.cae')
#: The model database "/storage/work/r/rhk12/classes/me563/sp19/flagshyp/job_folder/2D_1Elt/abaqus/2DPlaneStrain-v2.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
p = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].setValues(displayedObject=None)
o1 = session.openOdb(
    name='/storage/work/r/rhk12/classes/me563/sp19/flagshyp/job_folder/2D_1Elt/abaqus/2DPlaneStrain-v2.odb')
session.viewports['Viewport: 1'].setValues(displayedObject=o1)
#: Model: /storage/work/r/rhk12/classes/me563/sp19/flagshyp/job_folder/2D_1Elt/abaqus/2DPlaneStrain-v2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       5
#: Number of Node Sets:          5
#: Number of Steps:              1
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=2.91616, 
    farPlane=5.08384, width=1.60061, height=1.00814, viewOffsetX=0.0307589, 
    viewOffsetY=-0.0226425)
session.viewports['Viewport: 1'].view.fitView()
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    INVARIANT, 'Max. In-Plane Principal'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    COMPONENT, 'LE22'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(INVARIANT, 
    'Magnitude'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(COMPONENT, 'U2'), )
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON, optimizationTasks=OFF, 
    geometricRestrictions=OFF, stopConditions=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='Step-1')
mdb.models['Model-1'].boundaryConditions['BC-3'].setValues(u2=0.5)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF)
mdb.jobs['2DPlaneStrain-v2'].submit(consistencyChecking=OFF)
#: The job input file "2DPlaneStrain-v2.inp" has been submitted for analysis.
#: Job 2DPlaneStrain-v2: Analysis Input File Processor completed successfully.
#: Job 2DPlaneStrain-v2: Abaqus/Standard completed successfully.
#: Job 2DPlaneStrain-v2 completed successfully. 
o3 = session.openOdb(
    name='/storage/work/r/rhk12/classes/me563/sp19/flagshyp/job_folder/2D_1Elt/abaqus/2DPlaneStrain-v2.odb')
#: Model: /storage/work/r/rhk12/classes/me563/sp19/flagshyp/job_folder/2D_1Elt/abaqus/2DPlaneStrain-v2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       5
#: Number of Node Sets:          5
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o3)
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=2.77459, 
    farPlane=5.22541, width=2.28113, height=1.43676, viewOffsetX=0.0167795, 
    viewOffsetY=-0.00171027)
session.viewports['Viewport: 1'].view.fitView()
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(INVARIANT, 
    'Magnitude'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(COMPONENT, 'U2'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    INVARIANT, 'Max. In-Plane Principal'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    COMPONENT, 'LE22'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    COMPONENT, 'LE11'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    COMPONENT, 'LE12'), )
mdb.save()
#: The model database has been saved to "/storage/work/r/rhk12/classes/me563/sp19/flagshyp/job_folder/2D_1Elt/abaqus/2DPlaneStrain-v2.cae".
