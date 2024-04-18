# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2022 replay file
# Internal Version: 2021_09_15-13.57.30 176069
# Run by pfs5290 on Fri Mar 29 15:04:59 2024
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=328.158355712891, 
    height=135.559585571289)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
openMdb(
    pathName='/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model2.cae')
#: A new model database has been created.
#: The model "Model-1" has been created.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
#* MdbError: incompatible release number, expected 2022, got 2017
upgradeMdb(
    "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model2-2017.cae", 
    "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model2.cae", 
    )
#: The model database "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model2_TEMP.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
#: The model database has been saved to "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model2.cae".
#: The model database "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model2-2017.cae" has been converted.
p1 = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
del mdb.models['Model-1'].parts['Part-1']
openMdb(
    pathName='/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model.cae')
#: A new model database has been created.
#: The model "Model-1" has been created.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
#* MdbError: incompatible release number, expected 2022, got 2017
upgradeMdb(
    "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model-2017.cae", 
    "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model.cae", 
    )
#: The model database "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model_TEMP.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
#: The model database has been saved to "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model.cae".
#: The model database "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model-2017.cae" has been converted.
p = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON, optimizationTasks=OFF, 
    geometricRestrictions=OFF, stopConditions=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF)
mdb.Job(name='Job-2', model='Model-1', description='', type=ANALYSIS, 
    atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, 
    memoryUnits=PERCENTAGE, explicitPrecision=SINGLE, 
    nodalOutputPrecision=SINGLE, echoPrint=OFF, modelPrint=OFF, 
    contactPrint=OFF, historyPrint=OFF, userSubroutine='', scratch='', 
    resultsFormat=ODB, parallelizationMethodExplicit=DOMAIN, numDomains=1, 
    activateLoadBalancing=False, numThreadsPerMpiProcess=1, 
    multiprocessingMode=DEFAULT, numCpus=1)
mdb.jobs['Job-1'].submit(consistencyChecking=OFF)
#: The job input file "Job-1.inp" has been submitted for analysis.
#: Job Job-1: Analysis Input File Processor completed successfully.
#: Job Job-1: Abaqus/Explicit Packager completed successfully.
#: Job Job-1: Abaqus/Explicit completed successfully.
#: Job Job-1 completed successfully. 
session.viewports['Viewport: 1'].setValues(displayedObject=None)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    optimizationTasks=ON, geometricRestrictions=ON, stopConditions=ON)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    optimizationTasks=OFF, geometricRestrictions=OFF, stopConditions=OFF)
mdb.jobs['Job-2'].submit(consistencyChecking=OFF)
#: The job input file "Job-2.inp" has been submitted for analysis.
#: Job Job-2: Analysis Input File Processor completed successfully.
#: Job Job-2: Abaqus/Explicit Packager completed successfully.
#: Job Job-2: Abaqus/Explicit completed successfully.
#: Job Job-2 completed successfully. 
o3 = session.openOdb(
    name='/storage/work/pfs5290/classes/me563/flagshyp/Job-2.odb')
#: Model: /storage/work/pfs5290/classes/me563/flagshyp/Job-2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       5
#: Number of Node Sets:          6
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o3)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
mdb.save()
#: The model database has been saved to "/storage/work/pfs5290/classes/me563/flagshyp/job_folder/explicit_100elt_3D/abaqus/model.cae".
