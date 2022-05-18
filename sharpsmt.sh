#!/bin/sh

set -e

usage () {
cat <<EOF
usage: $0 -s <smtsolver> -c <modelcounter> <smt2 filename>
where <option> is one of the following:
  -h, --help        print this message and exit
  -s <solver>       use SMT solver <solver> for bitblasting {stp,boolector}
  -c <counter>      use model counter <counter> for counting
                    {approxmc,sharpsat-td,ganak,addmc}
  -m <smtcounter>   use SMT counter <smtcounter> {cdm,smtapproxmc,smc}
EOF
  exit 0
}

die () {
  echo "*** sharpsmt.sh: $*" 1>&2
  exit 1
}

msg () {
  echo "[sharpsmt.sh] $*"
}

while [ $# -gt 0 ]
do
  opt=$1
  case $opt in
    -h|--help) usage;;

    -s)
      shift
      [ $# -eq 0 ] && die "missing argument to $opt"
      solver=$1
      ;;

    -c)
      shift
      [ $# -eq 0 ] && die "missing argument to $opt"
      counter=$1
      ;;

    -*) die "invalid option '$opt' (try '-h')";;
  esac
  shift
done

file=$opt
cnffilename=${file%.smt2}.cnf

echo "count $file with $counter bitblasting with $solver"

case $solver in
  stp)
    ./smtsolvers/stp/build/stp --disable-simplifications --disable-opt-inc --disable-cbitp --disable-equality --output-CNF ${file}
    mv output_0.cnf ${cnffilename}
    ;;

  boolector)
    ./smtsolvers/boolector/build/bin/boolector -dd ${file} > ${cnffilename}
    ;;

  *) die "invalid smtsolver name '$solver' (try 'sharpsmt.sh -h')";;
esac

case $counter in
  approxmc)
    ./modelcounters/approxmc/build/approxmc ${cnffilename}
    ;;

  sharpsat-td)
    ./modelcounters/sharpsat-td/bin/sharpSAT -decot 1 -decow 100 -tmpdir . -cs 3500 ${cnffilename}
    ;;

  ganak)
    ./modelcounters/ganak/build/ganak ${cnffilename}
    ;;

  addmc)
    ./modelcounters/ADDMC/build/addmc --wf 1 --vl 1 --cf ${cnffilename}
    ;;

  *) die "invalid model counter name '$counter' (try 'sharpsmt.sh -h')";;
esac
