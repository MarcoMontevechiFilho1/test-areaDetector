PREFIX="13SIM1:"
DRIVER="cam1:"
HDF="HDF1:"
IMAGE="image1:"
WARP="warp1:"
WARP_PORT="Warp1"
IMAGE_PORT="Image1"
DRIVER_PORT="SIM1"

prepare_hdf() {

    #$1 should point if it gets data from warp or from image
    caput "${PREFIX}${HDF}NDArrayPort" $1
    caput "${PREFIX}${HDF}EnableCallbacks" 1
    caput -S "${PREFIX}${HDF}FilePath" '/tmp'
    caput -S "${PREFIX}${HDF}FileName" 'test_acquire_'${2}
    caput "${PREFIX}${HDF}AutoIncrement" 1
    caput "${PREFIX}${HDF}LazyOpen" 1
    caput -S "${PREFIX}${HDF}FileTemplate" '%s%s_%3.3d.h5'
    caput "${PREFIX}${HDF}NumCapture" 10
    caput -S "${PREFIX}${HDF}FileWriteMode" 'Capture'
    caput "${PREFIX}${HDF}Capture" 1
}

prepare_image() {

    caput "${PREFIX}${HDF}NDArrayPort" $1
    caput "${PREFIX}${IMAGE}EnableCallbacks" 1

}

prepare_warp() {

    caput -S "${PREFIX}${WARP}NDArrayPort" "SIM1"
    caput "${PREFIX}${WARP}EnableCallbacks" 1

}

start_driver() {

    caput "${PREFIX}${DRIVER}Acquire" 1

}

start_all_no_warp() {

    start_driver
    prepare_image $DRIVER_PORT
    prepare_hdf  $DRIVER_PORT "NOWARP"

}

start_all_warp() {

    start_driver
    prepare_warp
    prepare_image $WARP_PORT
    prepare_hdf  $WARP_PORT "WARP"

}

stop_all() {

    caput "${PREFIX}${DRIVER}Acquire" 0
    caput "${PREFIX}${HDF}Capture" 0
    caput "${PREFIX}${HDF}WriteFile" 1

}

start_all_no_warp
sleep 3
stop_all
sleep 10

start_all_warp
sleep 3
stop_all
