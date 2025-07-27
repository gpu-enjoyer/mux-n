#! /bin/bash

WORK_DIR="$(pwd)"
PROJ_DIR="$(dirname "$0")"

YOSYS_ENV=\
"$FPGA_TOOLS/repos/oss-cad-suite/environment"

NAMES=(mux mux_n)


if [ -f "$YOSYS_ENV" ]; then
    # shellcheck disable=SC1090
    source "$YOSYS_ENV"
    echo "source: $YOSYS_ENV"
else
    echo "error: yosys env file not found: "\
        "$YOSYS_ENV" >&2
    exit 1
fi

cd "$PROJ_DIR" || exit 1

    for N in "${NAMES[@]}";
    do

        echo "generating: $N.svg"

        yosys -q -p "
            read_verilog -sv code/*.sv;
            prep -top $N;
            write_json svg/$N.json"

        npx \
            netlistsvg \
            "svg/$N.json" \
            -o "svg/$N.svg" \

        rm -f "svg/$N.json"

    done

    for f in svg/*.svg;
    do
        awk -v insert="$(<internal/custom_svg.insert)\n" '
            /<svg[^>]*>/ {
            print $0
            print insert
            next
            }
            { print }
        ' "$f" > tmp_svg && mv tmp_svg "$f"
    done


cd "$WORK_DIR" || exit 1

exit 0
