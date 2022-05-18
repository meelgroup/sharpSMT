#!/bin/sh

usage () {
cat <<EOF
usage: $0 [<option> ...] <smt2 filename>
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

    -f*|-m*) if [ -z "$flags" ]; then flags=$1; else flags="$flags;$1"; fi;;

    --ninja) ninja=yes;;

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

echo "count $file with $counter bitblasting with $solver"
