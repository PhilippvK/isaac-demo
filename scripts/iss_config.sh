#!/bin/bash
# Source this before choosing target-specific MLonMCU configuration.
case "${ISS:-${TARGET:-etiss}}" in
    spike)
        ISS=spike
        case "${SPIKE_RUNTIME:-htif}" in
            htif) TARGET=spike_bm ;;
            pk) TARGET=spike_pk ;;
            *) echo "SPIKE_RUNTIME must be htif or pk" >&2; return 1 ;;
        esac ;;
    spike*) TARGET=${ISS:-$TARGET}; ISS=spike ;;
    etiss*) TARGET=${ISS:-${TARGET:-etiss}}; ISS=etiss ;;
    *) echo "Unsupported ISS: ${ISS:-$TARGET}" >&2; return 1 ;;
esac
export ISS TARGET
XLEN=${XLEN:-32}
if [[ ${ARCH:-rv$XLEN} == rv64* ]]; then XLEN=64; fi
export XLEN
isaac_iss_args() {
    ISAAC_ISS_ARGS=()
    if [[ $ISS == spike ]]; then
        ISAAC_ISS_ARGS+=(-c "$TARGET.legacy=false")
        if [[ -n ${SPIKE_EXE:-} ]]; then ISAAC_ISS_ARGS+=(-c "spike.exe=$SPIKE_EXE"); fi
        if [[ -n ${SPIKE_PK:-} ]]; then ISAAC_ISS_ARGS+=(-c "spike.pk=$SPIKE_PK"); fi
    fi
    if [[ -n ${ISAAC_GNU_INSTALL_DIR:-} ]]; then
        ISAAC_ISS_ARGS+=(-c "riscv_gcc_rv$XLEN.install_dir=$ISAAC_GNU_INSTALL_DIR")
    fi
}

# Use the same backend selection in comparison and retracing.
isaac_retarget_args() {
    isaac_iss_args
    ISAAC_RETARGET_ARGS=("${ISAAC_ISS_ARGS[@]}")
    if [[ $ISS == spike ]]; then
        local manifest=${SPIKE_PLUGIN_MANIFEST:-$WORK/local/spike${SUFFIX}/spike_plugin.json}
        if [[ ! -f $manifest ]]; then
            echo "Missing Spike plugin: $manifest. Run the retargeting step first." >&2
            return 1
        fi
        ISAAC_RETARGET_ARGS+=(-c "$TARGET.plugin_manifest=$manifest")
    else
        ISAAC_RETARGET_ARGS+=(-c "etissvp.script=$ETISS_SCRIPT" -c "etiss.script=$ETISS_SCRIPT" -c "etiss.cpu_arch=$CORE_NAME")
    fi
}
