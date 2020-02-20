# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2017 replay file
# Internal Version: 2016_09_27-17.54.59 126836
# Run by rhk12 on Mon Feb 17 21:22:08 2020
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=239.977066040039, 
    height=151.077087402344)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
openMdb(
    pathName='/storage/work/r/rhk12/classes/me563/flagshyp/job_folder/1elt_3D_incompressible_neohookean/abaqus/1elt_3D_neohookean.cae')
#: The model database "/storage/work/r/rhk12/classes/me563/flagshyp/job_folder/1elt_3D_incompressible_neohookean/abaqus/1elt_3D_neohookean.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
p = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    optimizationTasks=OFF, geometricRestrictions=OFF, stopConditions=OFF)
mdb.jobs['Job-1'].submit(consistencyChecking=OFF)
#: The job input file "Job-1.inp" has been submitted for analysis.
#: Job Job-1: Analysis Input File Processor completed successfully.
#: Job Job-1: Abaqus/Standard completed successfully.
#: Job Job-1 completed successfully. 
o3 = session.openOdb(
    name='/storage/work/r/rhk12/classes/me563/flagshyp/job_folder/1elt_3D_incompressible_neohookean/abaqus/Job-1.odb')
#: Model: /storage/work/r/rhk12/classes/me563/flagshyp/job_folder/1elt_3D_incompressible_neohookean/abaqus/Job-1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       6
#: Number of Node Sets:          6
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o3)
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].view.fitView()
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    INVARIANT, 'Max. Principal'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    COMPONENT, 'LE22'), )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=1 )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    COMPONENT, 'LE11'), )
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0269802, 
    farPlane=0.049562, width=0.0223781, height=0.014037, cameraPosition=(
    0.0329455, 0.0164696, 0.0276064), cameraUpVector=(-0.506386, 0.828158, 
    -0.240265), cameraTarget=(0.00413534, 0.00743663, 0.00413534))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0263632, 
    farPlane=0.0501241, width=0.0218663, height=0.013716, cameraPosition=(
    -0.00216152, 0.027978, 0.0357893), cameraUpVector=(-0.099915, 0.586975, 
    -0.803416), cameraTarget=(0.00410934, 0.00744515, 0.0041414))
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='Step-1')
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.02582, 
    farPlane=0.0476992, width=0.0193161, height=0.0121164, cameraPosition=(
    -0.0110754, -0.00279376, 0.0371301), cameraUpVector=(-0.0279145, 0.985277, 
    -0.168674), cameraTarget=(0.00520979, 0.00458042, 0.00520979))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0250975, 
    farPlane=0.0475183, width=0.0187757, height=0.0117774, cameraPosition=(
    -0.0205672, 0.029623, 0.0126366), cameraUpVector=(0.662473, 0.388949, 
    -0.640194), cameraTarget=(0.0051648, 0.00473406, 0.0050937))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0252744, 
    farPlane=0.0473405, width=0.0189081, height=0.0118604, cameraPosition=(
    -0.0216342, 0.028705, 0.0118521), cameraUpVector=(0.646972, 0.398089, 
    -0.650348), cameraTarget=(0.00517296, 0.00474108, 0.0050997))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0245536, 
    farPlane=0.0481874, width=0.0183689, height=0.0115222, cameraPosition=(
    -0.01802, 0.0242949, 0.0255091), cameraUpVector=(0.517168, 0.614782, 
    -0.595467), cameraTarget=(0.00514529, 0.00477484, 0.00499516))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0257065, 
    farPlane=0.0469071, width=0.0192314, height=0.0120632, cameraPosition=(
    -0.0233489, 0.0273565, 0.00883858), cameraUpVector=(0.737071, 0.47103, 
    -0.48462), cameraTarget=(0.00517677, 0.00475676, 0.00509363))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0247637, 
    farPlane=0.0479867, width=0.0185261, height=0.0116208, cameraPosition=(
    -0.00943092, 0.0245052, 0.0321011), cameraUpVector=(0.261761, 0.607616, 
    -0.749856), cameraTarget=(0.00507001, 0.00477863, 0.00491519))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0248241, 
    farPlane=0.0479547, width=0.0185713, height=0.0116492, cameraPosition=(
    -0.0143918, 0.020148, 0.0318086), cameraUpVector=(0.46211, 0.714009, 
    -0.525971), cameraTarget=(0.00509867, 0.0048038, 0.00491688))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0247491, 
    farPlane=0.0478359, width=0.0185153, height=0.011614, cameraPosition=(
    -0.0179004, 0.0297174, -0.00848247), cameraUpVector=(0.938601, 0.337261, 
    -0.0726889), cameraTarget=(0.00511756, 0.00475227, 0.00513384))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0278188, 
    farPlane=0.0446625, width=0.0208118, height=0.0130545, cameraPosition=(
    0.00709288, 0.0411801, 0.00489974), cameraUpVector=(0.906894, -0.388551, 
    -0.163006), cameraTarget=(0.00491591, 0.00465979, 0.00502587))
session.viewports['Viewport: 1'].view.setProjection(projection=PARALLEL)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0251016, 
    farPlane=0.04741, cameraPosition=(0.00241806, 0.039658, 0.0153268), 
    cameraUpVector=(0.955358, -0.220812, -0.196298), cameraTarget=(0.00496037, 
    0.00467427, 0.0049267))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0265251, 
    farPlane=0.0459668, cameraPosition=(0.00465982, 0.0412396, 0.00559301), 
    cameraUpVector=(0.945189, -0.326326, 0.0113705), cameraTarget=(0.00493999, 
    0.00465989, 0.00501518))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0239822, 
    farPlane=0.0486327, cameraPosition=(-0.0236972, 0.0109147, 0.0264411), 
    cameraUpVector=(0.578391, 0.815601, -0.0160935), cameraTarget=(0.00520549, 
    0.00494381, 0.00481999))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0242842, 
    farPlane=0.0482987, cameraPosition=(0.00106975, 0.0354264, 0.024387), 
    cameraUpVector=(0.928398, -0.0428767, -0.369104), cameraTarget=(0.00501593, 
    0.00475621, 0.00483571))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0238951, 
    farPlane=0.0486969, cameraPosition=(-0.00649603, 0.0367182, 0.0183865), 
    cameraUpVector=(0.677373, 0.166382, -0.716578), cameraTarget=(0.0050772, 
    0.00474575, 0.0048843))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.02334, 
    farPlane=0.0492575, cameraPosition=(-0.0136438, 0.0326265, 0.01938), 
    cameraUpVector=(0.629929, 0.348363, -0.694142), cameraTarget=(0.00513417, 
    0.00477836, 0.00487638))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0260493, 
    farPlane=0.0465418, cameraPosition=(0.00660407, 0.0411157, 0.00176743), 
    cameraUpVector=(0.918779, -0.384214, -0.0906953), cameraTarget=(0.00497431, 
    0.00471134, 0.00501543))
session.viewports['Viewport: 1'].view.setValues(cameraUpVector=(0.917013, 
    -0.385256, -0.103266), cameraTarget=(0.00497431, 0.00471134, 0.00501543))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0259553, 
    farPlane=0.0466357, width=0.0279288, height=0.0175188, cameraPosition=(
    0.00663852, 0.0411142, 0.00176843), cameraTarget=(0.00500876, 0.00470989, 
    0.00501643))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0265047, 
    farPlane=0.0460832, cameraPosition=(0.00507107, 0.0412885, 0.00437475), 
    cameraUpVector=(0.928455, -0.337286, -0.155596), cameraTarget=(0.00502127, 
    0.0047085, 0.00499562))
session.viewports['Viewport: 1'].setValues(
    displayedObject=session.odbs['/storage/work/r/rhk12/classes/me563/flagshyp/job_folder/1elt_3D_incompressible_neohookean/abaqus/Job-1.odb'])
odb = session.odbs['/storage/work/r/rhk12/classes/me563/flagshyp/job_folder/1elt_3D_incompressible_neohookean/abaqus/Job-1.odb']
session.viewports['Viewport: 1'].setValues(displayedObject=odb)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0263956, 
    farPlane=0.0499896, width=0.0218932, height=0.0137329, cameraPosition=(
    0.00655703, 0.045436, 0.0077803), cameraUpVector=(0.919542, -0.391081, 
    -0.0386995), cameraTarget=(0.00410954, 0.00744554, 0.00414078))
session.viewports['Viewport: 1'].view.setProjection(projection=PARALLEL)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.025321, 
    farPlane=0.0510547, cameraPosition=(0.00421564, 0.0456874, 0.00396022), 
    cameraUpVector=(0.941842, -0.335923, -0.0095182), cameraTarget=(0.00411262, 
    0.00744521, 0.0041458))
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=1 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=1 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=1 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=1 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=1 )
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0244482, 
    farPlane=0.0519935, cameraPosition=(0.0282155, 0.0237013, 0.0289425), 
    cameraUpVector=(0.423557, -0.817029, -0.391232), cameraTarget=(0.00407807, 
    0.00747686, 0.00410984))
session.viewports['Viewport: 1'].view.setValues(width=0.032367, 
    height=0.0203027, cameraPosition=(0.0281879, 0.0237483, 0.0289387), 
    cameraTarget=(0.00405045, 0.00752382, 0.004106))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0233512, 
    farPlane=0.0530294, cameraPosition=(0.0187368, -0.0207961, 0.0251679), 
    cameraUpVector=(-0.29002, -0.359459, -0.886948), cameraTarget=(0.00405588, 
    0.0075494, 0.00410817))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0251885, 
    farPlane=0.0512594, cameraPosition=(-0.00709782, -0.00659662, 0.0378214), 
    cameraUpVector=(-0.13895, -0.688094, -0.712194), cameraTarget=(0.00409137, 
    0.00752989, 0.00409079))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0233425, 
    farPlane=0.0530552, cameraPosition=(0.0185458, -0.0252996, 0.0173236), 
    cameraUpVector=(-0.822817, -0.18997, -0.535615), cameraTarget=(0.00407876, 
    0.00753909, 0.00410087))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.0251711, 
    farPlane=0.0512236, cameraPosition=(0.00426381, -0.0306925, 0.00351818), 
    cameraUpVector=(-0.82592, 0.336814, -0.452121), cameraTarget=(0.00409519, 
    0.00754529, 0.00411675))
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    COMPONENT, 'LE33'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='LE', outputPosition=INTEGRATION_POINT, refinement=(
    COMPONENT, 'LE11'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(INVARIANT, 
    'Mises'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(COMPONENT, 
    'S22'), )
session.viewports['Viewport: 1'].view.fitView()
